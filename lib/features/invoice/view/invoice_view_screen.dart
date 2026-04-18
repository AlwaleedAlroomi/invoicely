import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/constants/countries.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/view/invoice_form_screen.dart';

class InvoiceViewScreen extends ConsumerStatefulWidget {
  final InvoiceModel initInvoice;
  const InvoiceViewScreen({super.key, required this.initInvoice});

  @override
  ConsumerState<InvoiceViewScreen> createState() => _InvoiceViewScreenState();
}

class _InvoiceViewScreenState extends ConsumerState<InvoiceViewScreen> {
  late InvoiceModel invoice;

  @override
  void initState() {
    super.initState();
    invoice = widget.initInvoice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(invoice: invoice),
            const SizedBox(height: 16),
            _ClientSection(invoice: invoice),
            const SizedBox(height: 16),
            _ItemsSection(invoice: invoice),
            const SizedBox(height: 16),
            _TotalsSection(invoice: invoice),
            if (invoice.notes != null || invoice.terms != null) ...[
              const SizedBox(height: 16),
              _NotesTermsSection(invoice: invoice),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _BottomActions(
        invoice: invoice,
        onStatusChanged: (updated) {
          setState(() => invoice = updated);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(invoice.invoiceNumber),
      actions: [
        PopupMenuButton(
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(Icons.copy_outlined),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) async {
            switch (value) {
              case 'edit':
                final updatedInvoice = await Navigator.of(context)
                    .push<InvoiceModel>(
                      // replace with your route
                      MaterialPageRoute(
                        builder: (_) =>
                            InvoiceFormScreen(initialInvoice: invoice),
                      ),
                    );
                if (updatedInvoice != null) {
                  setState(() => invoice = updatedInvoice);
                }
                break;
              case 'duplicate':
                // handle duplicate
                break;
              case 'delete':
                await ref
                    .read(invoiceRepositoryProvider)
                    .deleteInvoice(invoice);
                if (!context.mounted) return;
                Navigator.pop(context);
                break;
            }
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// HEADER — invoice number + status + dates
// ─────────────────────────────────────────

class _HeaderSection extends StatelessWidget {
  final InvoiceModel invoice;
  const _HeaderSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoice.invoiceNumber,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _StatusBadge(status: invoice.status),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Issue Date',
                    date: invoice.issueDate,
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                Expanded(
                  child: _DateTile(
                    label: 'Due Date',
                    date: invoice.dueDate,
                    icon: Icons.event_outlined,
                    isOverdue:
                        invoice.status != InvoiceStatus.paid &&
                        invoice.dueDate.isBefore(DateTime.now()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final InvoiceStatus status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case InvoiceStatus.draft:
        return Colors.grey;
      case InvoiceStatus.sent:
        return Colors.blue;
      case InvoiceStatus.paid:
        return Colors.green;
      case InvoiceStatus.overdue:
        return Colors.red;
      case InvoiceStatus.cancelled:
        return Colors.orange;
    }
  }

  String get _label {
    switch (status) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.sent:
        return 'Sent';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.overdue:
        return 'Overdue';
      case InvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.4)),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime date;
  final IconData icon;
  final bool isOverdue;

  const _DateTile({
    required this.label,
    required this.date,
    required this.icon,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: isOverdue ? Colors.red : Colors.grey),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isOverdue ? Colors.red : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// CLIENT
// ─────────────────────────────────────────

class _ClientSection extends StatelessWidget {
  final InvoiceModel invoice;
  const _ClientSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final client = invoice.client.value;

    return _SectionCard(
      title: 'Bill To',
      icon: Icons.person_outline,
      child: client == null
          ? const Text('No client', style: TextStyle(color: Colors.grey))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(client.email, style: const TextStyle(color: Colors.grey)),
                if (client.phone != null) Text(client.phone!),
                if (client.addressLine1 != null) ...[
                  const SizedBox(height: 4),
                  Text(client.addressLine1!),
                  if (client.addressLine2 != null) Text(client.addressLine2!),
                  Text(
                    [
                      client.city,
                      client.state,
                      client.zipCode,
                    ].whereType<String>().join(', '),
                  ),
                  if (client.country != null)
                    Text('${getFlagEmoji(client.country!)}  ${client.country}'),
                ],
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────
// ITEMS
// ─────────────────────────────────────────

class _ItemsSection extends StatelessWidget {
  final InvoiceModel invoice;
  const _ItemsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Items',
      icon: Icons.list_alt_outlined,
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Item',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Qty',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Price',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Total',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const Divider(),
          ...invoice.items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      item.productName,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${item.quantity}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${item.unitPrice.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '\$${item.total.toStringAsFixed(2)}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// TOTALS
// ─────────────────────────────────────────

class _TotalsSection extends StatelessWidget {
  final InvoiceModel invoice;
  const _TotalsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Summary',
      icon: Icons.calculate_outlined,
      child: Column(
        children: [
          _TotalRow(label: 'Subtotal', value: invoice.subTotal),
          _TotalRow(
            label: 'Tax (${invoice.taxRate.toStringAsFixed(0)}%)',
            value: invoice.taxAmount,
          ),
          const Divider(),
          _TotalRow(
            label: 'Total',
            value: invoice.totalAmount,
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final double fontSize;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('\$${value.toStringAsFixed(2)}', style: style),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// NOTES + TERMS
// ─────────────────────────────────────────

class _NotesTermsSection extends StatelessWidget {
  final InvoiceModel invoice;
  const _NotesTermsSection({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Notes & Terms',
      icon: Icons.notes_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (invoice.notes != null) ...[
            const Text(
              'Notes',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(invoice.notes!),
          ],
          if (invoice.notes != null && invoice.terms != null)
            const SizedBox(height: 12),
          if (invoice.terms != null) ...[
            const Text(
              'Terms',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(invoice.terms!),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// BOTTOM ACTIONS
// ─────────────────────────────────────────

class _BottomActions extends ConsumerWidget {
  final InvoiceModel invoice;
  final void Function(InvoiceModel updated) onStatusChanged;

  const _BottomActions({required this.invoice, required this.onStatusChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showStatusSheet(context, ref),
                icon: const Icon(Icons.swap_horiz_outlined),
                label: const Text('Status'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  // PDF generation — next feature
                },
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Download PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Change Status',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...InvoiceStatus.values.map(
              (status) => ListTile(
                title: Text(status.name),
                leading: Radio<InvoiceStatus>(
                  value: status,
                  groupValue: invoice.status,
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(invoiceRepositoryProvider)
                        .updateInvoiceStatus(invoice, value);
                    // update local state via callback
                    onStatusChanged(invoice.copyWith(status: value));
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// SHARED SECTION CARD
// ─────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
