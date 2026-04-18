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

    return Row(
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
            suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // terms preset picker
        DropdownButtonFormField<String>(
          initialValue: state.terms,
          decoration: InputDecoration(
            labelText: 'Payment Terms',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onChanged: controller.setNotes,
        ),
      ],
    );
  }
}
