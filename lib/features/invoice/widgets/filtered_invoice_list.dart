import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/widgets/invoice_history.dart';

class FilteredInvoiceListScreen extends ConsumerWidget {
  final String title;
  final ProviderListenable<AsyncValue<List<InvoiceModel>>> provider;

  const FilteredInvoiceListScreen({
    super.key,
    required this.title,
    required this.provider,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(provider);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: invoicesAsync.when(
        data: (invoices) => invoices.isEmpty
            ? const Center(child: Text('No invoices found'))
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  return InvoiceHistoryTile(invoice: invoices[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
