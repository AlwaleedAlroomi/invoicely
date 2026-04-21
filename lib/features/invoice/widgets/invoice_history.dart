import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/utils/fade_through_route.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/view/invoice_view_screen.dart';

class InvoiceHistorySection extends ConsumerWidget {
  final AsyncValue<List<InvoiceModel>> invoicesAsync;
  final String title;
  final VoidCallback? onSeeAll;

  const InvoiceHistorySection({
    super.key,
    required this.invoicesAsync,
    this.title = 'Invoice History',
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              if (onSeeAll != null)
                TextButton(onPressed: onSeeAll, child: const Text('See all')),
            ],
          ),
          const SizedBox(height: 8),
          invoicesAsync.when(
            data: (invoices) {
              if (invoices.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No invoices yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
              // show max 3 recent, see all shows full list
              final preview = invoices.take(3).toList();
              return Column(
                children: preview
                    .map((invoice) => _InvoiceHistoryTile(invoice: invoice))
                    .toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceHistoryTile extends ConsumerWidget {
  final InvoiceModel invoice;
  const _InvoiceHistoryTile({required this.invoice});

  Color get _statusColor {
    switch (invoice.status) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.of(context).push(
            FadeThroughRoute(page: InvoiceViewScreen(initInvoice: invoice)),
          );
          ref.invalidate(
            clientInvoicesProvider(invoice.client.value!.remoteId!),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // status indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.invoiceNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Due: ${invoice.dueDate.day}/${invoice.dueDate.month}/${invoice.dueDate.year}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${invoice.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      invoice.status.name.toUpperCase(),
                      style: TextStyle(
                        color: _statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
