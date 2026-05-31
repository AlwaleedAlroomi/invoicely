import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/utils/currency_utils.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';

class TotalsSummarySection extends ConsumerWidget {
  const TotalsSummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceFormControllerProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text('Tax Rate (%)', style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              const Spacer(),
              SizedBox(
                width: 90,
                child: TextFormField(
                  initialValue: state.taxRate.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '0',
                    suffixText: '%',
                    isDense: true,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  style: TextStyle(color: theme.colorScheme.onSurface),
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
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Subtotal',
            value: formatAmount(state.subTotal, state.currency),
            theme: theme,
          ),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Tax (${state.taxRate.toStringAsFixed(0)}%)',
            value: formatAmount(state.taxAmount, state.currency),
            theme: theme,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Total',
            value: formatAmount(state.totalAmount, state.currency),
            isBold: true,
            fontSize: 16,
            theme: theme,
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
  final ThemeData theme;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.theme,
    this.isBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontSize: fontSize,
      color: isBold ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
