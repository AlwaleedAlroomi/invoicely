import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/widgets/client_picker.dart';
import 'package:invoicely/features/invoice/widgets/date_section.dart';
import 'package:invoicely/features/invoice/widgets/item_section.dart';
import 'package:invoicely/features/invoice/widgets/total_summary_widget.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

class InvoiceFormScreen extends ConsumerStatefulWidget {
  final InvoiceModel? initialInvoice;
  final ClientModel? preSelectedClient;
  const InvoiceFormScreen({
    super.key,
    this.initialInvoice,
    this.preSelectedClient,
  });

  @override
  ConsumerState<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends ConsumerState<InvoiceFormScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = ref.read(invoiceFormControllerProvider.notifier);
      if (widget.initialInvoice != null) {
        // edit mode
        controller.loadInvoice(widget.initialInvoice!);
      } else {
        // create mode — generate invoice number
        controller.reset();
        await controller.init();
        if (widget.preSelectedClient != null) {
          controller.selectClient(widget.preSelectedClient!);
        }
      }
    });
  }

  Future<void> _onSubmit() async {
    final state = ref.read(invoiceFormControllerProvider);
    final controller = ref.read(invoiceFormControllerProvider.notifier);
    final success = widget.initialInvoice != null
        ? await controller.updateInvoice(
            widget.initialInvoice!,
            state.selectedClient,
          )
        : await controller.createInvoice();

    if (mounted && success) {
      if (state.error == null) {
        final invoice = InvoiceModel(
          invoiceNumber: state.invoiceNumber,
          issueDate: state.issueDate,
          dueDate: state.dueDate,
          taxRate: state.taxRate,
          subTotal: state.subTotal,
          taxAmount: state.taxAmount,
          totalAmount: state.totalAmount,
          items: state.items,
          status: state.status,
          notes: state.notes,
          terms: state.terms,
          createdAt: widget.initialInvoice?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );
        invoice.client.value = state.selectedClient;
        ref.invalidate(allProductsProvider);
        Navigator.of(context).pop(invoice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceFormControllerProvider);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialInvoice != null ? 'Edit Invoice' : 'New Invoice',
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),

            Text(
              'Invoice #${state.invoiceNumber}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),

            // client picker
            const Text('Client', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClientPickerSection(
              selectedClient: state.selectedClient,
              onTap: () => _showClientPicker(context, ref),
            ),
            const SizedBox(height: 20),

            // 2. dates
            const DatesSection(),
            const SizedBox(height: 20),
            // items list
            const ItemsSection(),
            const SizedBox(height: 20),
            // totals summary
            const TotalsSummarySection(),
            const SizedBox(height: 20),
            // notes / terms
            const Text(
              'Notes & Terms',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const NotesTermsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: isKeyboardOpen
              ? MediaQuery.of(context).viewInsets.bottom + 8
              : 16,
        ),
        child: ElevatedButton(
          onPressed: state.isLoading ? null : _onSubmit,
          child: state.isLoading
              ? const CircularProgressIndicator()
              : const Text('Save Invoice'),
        ),
      ),
    );
  }

  void _showClientPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return ClientPickerSheet(scrollController: scrollController);
          },
        );
      },
    );
  }
}
