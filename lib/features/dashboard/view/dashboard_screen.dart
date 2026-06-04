import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/services/permission_helper.dart';
import 'package:invoicely/core/utils/currency_utils.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';
import 'package:invoicely/features/clients/view/client_form_screen.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/view/invoice_form_screen.dart';
import 'package:invoicely/features/invoice/view/invoice_view_screen.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/view/product_form_screen.dart';
import 'package:invoicely/features/settings/data/default_settings.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardScreen();
}

class _DashboardScreen extends ConsumerState<DashboardScreen> {
  bool permissionsRequested = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (permissionsRequested) return;
    permissionsRequested = true;

    // Small delay to ensure the widget is fully mounted
    await Future.delayed(const Duration(milliseconds: 500));

    final granted = await PermissionHelper().requestNotificationPermissions();

    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please allow notifications to use this app.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else if (granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notifications enabled!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(allInvoicesProvider);
    final clientsAsync = ref.watch(allClientsProvider);
    final productsAsync = ref.watch(allProductsProvider);
    final defaultCurrency = DefaultSettings.getCurrency(
      ref.read(sharedPreferencesProvider),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       NotificationService().showBasicNotification(
        //         title: 'test basic',
        //         body: 'test body basic notificaiton',
        //       );
        //     },
        //     icon: Icon(Icons.add),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryRow(
              context,
              invoicesAsync,
              clientsAsync,
              productsAsync,
              defaultCurrency,
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Invoices',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildRecentInvoices(context, ref, invoicesAsync),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildQuickActions(context, ref),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(allInvoicesProvider);
    ref.invalidate(allClientsProvider);
    ref.invalidate(allProductsProvider);
  }

  Widget _buildSummaryRow(
    BuildContext context,
    AsyncValue<List<InvoiceModel>> invoicesAsync,
    AsyncValue<List<ClientModel>> clientsAsync,
    AsyncValue<List<ProductModel>> productsAsync,
    String defaultCurrency,
  ) {
    final isLoading =
        invoicesAsync.isLoading ||
        clientsAsync.isLoading ||
        productsAsync.isLoading;
    if (isLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final invoices = invoicesAsync.valueOrNull ?? [];
    final clients = clientsAsync.valueOrNull ?? [];
    final products = productsAsync.valueOrNull ?? [];

    final totalRevenue = invoices
        .where((i) => i.status == InvoiceStatus.paid)
        .fold<double>(0, (sum, i) => sum + i.totalAmount);
    final pendingCount = invoices
        .where(
          (i) =>
              i.status == InvoiceStatus.draft || i.status == InvoiceStatus.sent,
        )
        .length;
    final activeClients = clients.where((c) => c.isActive).length;
    final lowStock = products.where((p) => p.stockQuantity < 5).length;

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Revenue',
            value: formatAmount(totalRevenue, defaultCurrency, decimals: 0),
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            icon: Icons.pending_actions_rounded,
            label: 'Pending',
            value: '$pendingCount',
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            icon: Icons.people_rounded,
            label: 'Clients',
            value: '$activeClients',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _SummaryCard(
            icon: Icons.inventory_rounded,
            label: 'Low Stock',
            value: '$lowStock',
            color: lowStock > 0 ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentInvoices(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<InvoiceModel>> invoicesAsync,
  ) {
    final invoices = invoicesAsync.valueOrNull;
    if (invoices == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final recent = invoices.where((i) => i.isActive).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (recent.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 48,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 8),
                Text(
                  'No invoices yet',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
      children: recent
          .take(5)
          .map((inv) => _buildInvoiceTile(context, ref, inv))
          .toList(),
    );
  }

  Widget _buildInvoiceTile(
    BuildContext context,
    WidgetRef ref,
    InvoiceModel invoice,
  ) {
    Color statusColor;
    switch (invoice.status) {
      case InvoiceStatus.paid:
        statusColor = Colors.green;
      case InvoiceStatus.overdue:
        statusColor = Colors.red;
      case InvoiceStatus.draft:
        statusColor = Colors.grey;
      case InvoiceStatus.cancelled:
        statusColor = Colors.orange;
      case InvoiceStatus.sent:
        statusColor = Colors.blue;
    }
    final client = invoice.client;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () async {
          await Navigator.of(context).push(
            FadeThroughRoute(page: InvoiceViewScreen(initInvoice: invoice)),
          );
        },
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          invoice.invoiceNumber,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          client?.name ?? 'Unknown',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              formatAmount(invoice.totalAmount, invoice.client?.currency),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              invoice.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.receipt_long_rounded,
            label: 'New Invoice',
            color: Colors.indigo,
            onTap: () async {
              await Navigator.of(
                context,
              ).push(FadeThroughRoute(page: const InvoiceFormScreen()));
              ref.invalidate(allInvoicesProvider);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.person_add_rounded,
            label: 'New Client',
            color: Colors.teal,
            onTap: () async {
              await Navigator.of(
                context,
              ).push(FadeThroughRoute(page: const ClientFormScreen()));
              ref.invalidate(allClientsProvider);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _ActionButton(
            icon: Icons.inventory_2_rounded,
            label: 'New Product',
            color: Colors.amber,
            onTap: () async {
              await Navigator.of(
                context,
              ).push(FadeThroughRoute(page: const ProductFormPage()));
              ref.invalidate(allProductsProvider);
            },
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
