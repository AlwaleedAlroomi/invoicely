import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/theme/app_colors.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/invoice/controller/invoice_controller.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/view/invoice_form_screen.dart';
import 'package:invoicely/features/invoice/view/invoice_view_screen.dart';

class InvoiceListScreen extends ConsumerStatefulWidget {
  const InvoiceListScreen({super.key});

  @override
  ConsumerState<InvoiceListScreen> createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends ConsumerState<InvoiceListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(invoiceControllerProvider.notifier).fetchInvoices();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(invoiceControllerProvider.notifier).fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceControllerProvider);
    final sortType = ref.watch(invoiceSortTypeProvider);
    final sortOptions = SortTypeExtension.getOptionsFor(InvoiceModel);
    ref.listen(invoiceControllerProvider, (previous, next) {
      if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.failure!.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Invoices",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              tooltip: "Refresh",
              onPressed: () =>
                  ref.read(invoiceControllerProvider.notifier).fetchInvoices(),
              icon: Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: 'View Deleted',
              onPressed: () {
                ref
                    .read(invoiceControllerProvider.notifier)
                    .setShowActiveOnly();
              },
              icon: Icon(Icons.delete_sweep_outlined),
            ),
            PopupMenuButton<SortType>(
              icon: const Icon(Icons.sort_rounded),
              tooltip: 'Sort Clients',
              initialValue: sortType,
              onSelected: (type) {
                ref.read(invoiceSortTypeProvider.notifier).setSortType(type);
              },
              itemBuilder: (context) => sortOptions.map((type) {
                return PopupMenuItem(
                  value: type,
                  child: Text(
                    type.label,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? AppColors.subtitleText
                          : AppColors.darkSubtitleText,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by invoice/client name or total amount',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref
                      .read(invoiceControllerProvider.notifier)
                      .searchInvoices(value);
                },
              ),
            ),
            buildStatusFilterBar(ref),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: _buildBody(context, ref, state),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
              FadeThroughRoute(page: InvoiceFormScreen(initialInvoice: null)),
            );
            ref.read(invoiceControllerProvider.notifier).fetchInvoices();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    InvoiceListState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.invoices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const Text(
              "No invoices yet",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await Navigator.of(
                  context,
                ).push(FadeThroughRoute(page: InvoiceFormScreen()));
                if (mounted) {
                  ref.read(invoiceControllerProvider.notifier).fetchInvoices();
                }
              },
              child: const Text("Add your first invoice to get started"),
            ),
          ],
        ),
      );
    }
    return _buildListView(state.invoices);
  }

  Widget _buildListView(List<InvoiceModel> invoices) {
    final state = ref.watch(invoiceControllerProvider);
    return ListView.builder(
      controller: _scrollController,
      itemCount: invoices.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == invoices.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return TweenAnimationBuilder(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 300)),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _buildInvoiceCard(context, invoices[index]),
        );
      },
    );
  }

  Widget _buildInvoiceCard(BuildContext context, InvoiceModel invoice) {
    final client = invoice.client.value;

    // 2. Define status colors (You can move this to your InvoiceStatus enum later)
    Color statusColor;
    switch (invoice.status) {
      case InvoiceStatus.paid:
        statusColor = Colors.green;
        break;
      case InvoiceStatus.overdue:
        statusColor = Colors.red;
        break;
      case InvoiceStatus.draft:
        statusColor = Colors.grey;
        break;
      case InvoiceStatus.cancelled:
        statusColor = Colors.orange;
      case InvoiceStatus.sent:
        statusColor = Colors.blue;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.of(context).push(
            FadeThroughRoute(page: InvoiceViewScreen(initInvoice: invoice)),
          );
          ref.read(invoiceControllerProvider.notifier).fetchInvoices();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            invoice.invoiceNumber,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          _StatusBadge(
                            status: invoice.status,
                            color: statusColor,
                          ),
                        ],
                      ),
                      const Divider(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  client?.name ?? 'Unknown Client',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Due: ${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        invoice.dueDate.isBefore(
                                              DateTime.now(),
                                            ) &&
                                            invoice.status != InvoiceStatus.paid
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '\$${invoice.totalAmount.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildStatusFilterBar(WidgetRef ref) {
    final state = ref.watch(invoiceControllerProvider);
    final notifier = ref.read(invoiceControllerProvider.notifier);

    Color getStatusColor(InvoiceStatus status) {
      switch (status) {
        case InvoiceStatus.paid:
          return Colors.green;
        case InvoiceStatus.overdue:
          return Colors.red;
        case InvoiceStatus.draft:
          return Colors.grey;
        case InvoiceStatus.cancelled:
          return Colors.orange;
        case InvoiceStatus.sent:
          return Colors.blue;
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: const Text("All"),
            selected: state.selectedStatus == null,
            onSelected: (value) {
              notifier.setStatusFilter(null);
            },
          ),
          const SizedBox(width: 8),
          ...InvoiceStatus.values.map((status) {
            final isSelected = state.selectedStatus == status;
            final color = getStatusColor(status);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(status.name.toUpperCase()),
                selected: isSelected,
                onSelected: (value) {
                  notifier.setStatusFilter(status);
                },
                selectedColor: color.withValues(alpha: 0.2),
                side: BorderSide(
                  color: isSelected ? color : Colors.grey[300]!,
                  width: isSelected ? 1.5 : 1,
                ),
                labelStyle: TextStyle(
                  color: isSelected ? color : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final InvoiceStatus status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
