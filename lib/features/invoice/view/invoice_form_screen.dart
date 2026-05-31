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
        controller.loadInvoice(widget.initialInvoice!);
      } else {
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
        invoice.client = state.selectedClient;
        ref.invalidate(allProductsProvider);
        Navigator.of(context).pop(invoice);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(invoiceFormControllerProvider);
    final theme = Theme.of(context);
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.initialInvoice != null ? 'Edit Invoice' : 'New Invoice',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, color: theme.colorScheme.onPrimary, size: 28),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Invoice #${state.invoiceNumber}',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.initialInvoice != null ? 'Edit existing invoice' : 'Create new invoice',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.person_outline, title: 'Client'),
            const SizedBox(height: 10),
            ClientPickerSection(
              selectedClient: state.selectedClient,
              onTap: () => _showClientPicker(context, ref),
            ),
            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.calendar_today_outlined, title: 'Dates'),
            const SizedBox(height: 10),
            const DatesSection(),
            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.shopping_cart_outlined, title: 'Items'),
            const SizedBox(height: 10),
            const ItemsSection(),
            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.receipt_long_outlined, title: 'Summary'),
            const SizedBox(height: 10),
            const TotalsSummarySection(),
            const SizedBox(height: 24),

            _SectionHeader(icon: Icons.notes_outlined, title: 'Notes & Terms'),
            const SizedBox(height: 10),
            const NotesTermsSection(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: isKeyboardOpen ? MediaQuery.of(context).viewInsets.bottom + 8 : 16,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.3))),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: state.isLoading ? null : _onSubmit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: state.isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save Invoice', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ),
      ),
    );
  }

  void _showClientPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: theme.colorScheme.onPrimaryContainer),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
