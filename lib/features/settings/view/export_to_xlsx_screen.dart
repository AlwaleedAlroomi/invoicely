import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/settings/providers/settings_providers.dart';

class ExportToXlsxScreen extends ConsumerWidget {
  const ExportToXlsxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exportXlsxControllerProvider);

    ref.listen(exportXlsxControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
      if (!next.isLoading &&
          next.exportedPaths.isNotEmpty &&
          next.error == null) {
        _showSuccessDialog(context, next.exportedPaths);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Export Data'), centerTitle: true),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Exporting data...'),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // info banner
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Files will be saved as Excel (.xlsx) format to your selected folder.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // export all button
                _ExportCard(
                  icon: Icons.file_download_outlined,
                  title: 'Export Everything',
                  subtitle: 'Export all invoices, clients and products at once',
                  color: Theme.of(context).colorScheme.primary,
                  onTap: () => ref
                      .read(exportXlsxControllerProvider.notifier)
                      .exportAll(),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),

                // individual exports
                _ExportCard(
                  icon: Icons.receipt_long_outlined,
                  title: 'Export Invoices',
                  subtitle: 'Invoice number, client, dates, totals, status',
                  color: Colors.blue,
                  onTap: () => ref
                      .read(exportXlsxControllerProvider.notifier)
                      .exportInvoices(),
                ),
                const SizedBox(height: 12),

                _ExportCard(
                  icon: Icons.list_alt_outlined,
                  title: 'Export Invoice Items',
                  subtitle: 'All line items across all invoices',
                  color: Colors.indigo,
                  onTap: () => ref
                      .read(exportXlsxControllerProvider.notifier)
                      .exportInvoiceItems(),
                ),
                const SizedBox(height: 12),

                _ExportCard(
                  icon: Icons.people_outline,
                  title: 'Export Clients',
                  subtitle: 'Client details, addresses, contact info',
                  color: Colors.green,
                  onTap: () => ref
                      .read(exportXlsxControllerProvider.notifier)
                      .exportClients(),
                ),
                const SizedBox(height: 12),

                _ExportCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Export Products',
                  subtitle: 'Product catalog with prices and stock',
                  color: Colors.orange,
                  onTap: () => ref
                      .read(exportXlsxControllerProvider.notifier)
                      .exportProducts(),
                ),
              ],
            ),
    );
  }

  void _showSuccessDialog(BuildContext context, List<String> paths) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 8),
            Text('Export Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Files saved to:'),
            const SizedBox(height: 8),
            ...paths.map((path) {
              // show only folder/filename
              final parts = path.split('/');
              final display = parts.reversed
                  .take(2)
                  .toList()
                  .reversed
                  .join('/');
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.insert_drive_file_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        display,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ExportCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.file_download_outlined, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
