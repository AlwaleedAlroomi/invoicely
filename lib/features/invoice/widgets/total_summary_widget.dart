import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';

class TotalsSummarySection extends ConsumerWidget {
  const TotalsSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceFormControllerProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          // tax rate input
          Row(
            children: [
              const Text('Tax Rate (%)', style: TextStyle(color: Colors.grey)),
              const Spacer(),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: state.taxRate.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixText: '%',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (v) {
                    final rate = double.tryParse(v) ?? 0;
                    ref
                        .read(invoiceFormControllerProvider.notifier)
                        .setTaxRate(rate);
                  },
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${state.subTotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Tax (${state.taxRate.toStringAsFixed(0)}%)',
            value: '\$${state.taxAmount.toStringAsFixed(2)}',
          ),
          const Divider(height: 16),
          _SummaryRow(
            label: 'Total',
            value: '\$${state.totalAmount.toStringAsFixed(2)}',
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final double fontSize;

  const _SummaryRow({
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
