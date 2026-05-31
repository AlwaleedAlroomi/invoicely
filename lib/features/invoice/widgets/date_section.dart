import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/constants/payment_temrs.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';

class DatesSection extends ConsumerWidget {
  const DatesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(invoiceFormControllerProvider);
    final controller = ref.read(invoiceFormControllerProvider.notifier);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DatePickerField(
              label: 'Issue Date',
              date: state.issueDate,
              onChanged: controller.setIssueDate,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _DatePickerField(
              label: 'Due Date',
              date: state.dueDate,
              onChanged: controller.setDueDate,
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final void Function(DateTime) onChanged;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: AbsorbPointer(
        child: TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 18, color: theme.colorScheme.primary),
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          style: TextStyle(color: theme.colorScheme.onSurface),
          controller: TextEditingController(
            text: '${date.day}/${date.month}/${date.year}',
          ),
        ),
      ),
    );
  }
}

class NotesTermsSection extends ConsumerWidget {
  const NotesTermsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(invoiceFormControllerProvider.notifier);
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            initialValue: state.terms,
            decoration: InputDecoration(
              labelText: 'Payment Terms',
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            dropdownColor: theme.colorScheme.surface,
            items: [
              const DropdownMenuItem(value: null, child: Text('None')),
              ...paymentTermsPresets.map(
                (t) => DropdownMenuItem(value: t, child: Text(t)),
              ),
            ],
            onChanged: (v) => controller.setTerms(v ?? ''),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: state.notes,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes',
              hintText: 'e.g. Thank you for your business',
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              labelStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            style: TextStyle(color: theme.colorScheme.onSurface),
            onChanged: controller.setNotes,
          ),
        ],
      ),
    );
  }
}
