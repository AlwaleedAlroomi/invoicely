import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';
import 'package:invoicely/features/products/data/product_model.dart';

class InvoiceFormState {
  final ClientModel? selectedClient;
  final List<InvoiceItemModel> items;
  final double taxRate;
  final DateTime issueDate;
  final DateTime dueDate;
  final InvoiceStatus status;
  final String? notes;
  final String? terms;
  final String invoiceNumber;
  final bool isLoading;
  final String? error;

  // calculated
  double get subTotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => subTotal * (taxRate / 100);
  double get totalAmount => subTotal + taxAmount;

  // validation
  bool get isValid =>
      selectedClient != null && items.isNotEmpty && invoiceNumber.isNotEmpty;

  const InvoiceFormState({
    this.selectedClient,
    this.items = const [],
    this.taxRate = 0.0,
    required this.issueDate,
    required this.dueDate,
    this.status = InvoiceStatus.draft,
    this.notes,
    this.terms,
    this.invoiceNumber = '',
    this.isLoading = false,
    this.error,
  });

  InvoiceFormState copyWith({
    ClientModel? selectedClient,
    List<InvoiceItemModel>? items,
    double? taxRate,
    DateTime? issueDate,
    DateTime? dueDate,
    InvoiceStatus? status,
    String? notes,
    String? terms,
    String? invoiceNumber,
    bool? isLoading,
    String? error,
  }) {
    return InvoiceFormState(
      selectedClient: selectedClient ?? this.selectedClient,
      items: items ?? this.items,
      taxRate: taxRate ?? this.taxRate,
      issueDate: issueDate ?? this.issueDate,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      terms: terms ?? this.terms,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class InvoiceFormController extends StateNotifier<InvoiceFormState> {
  final InvoiceRepository _repo;
  InvoiceFormController(this._repo)
    : super(
        InvoiceFormState(
          issueDate: DateTime.now(),
          dueDate: DateTime.now().add(const Duration(days: 30)),
        ),
      );

  // ── INIT ──────────────────────────────────────────

  Future<void> init() async {
    final result = await _repo.generateInvoiceNumber();
    switch (result) {
      case Success(:final data):
        state = state.copyWith(invoiceNumber: data);
      case Error(:final failure):
        state = state.copyWith(error: failure.message);
    }
  }

  // for edit mode — load existing invoice into state
  void loadInvoice(InvoiceModel invoice) {
    state = InvoiceFormState(
      selectedClient: invoice.client.value,
      items: invoice.items,
      taxRate: invoice.taxRate,
      issueDate: invoice.issueDate,
      dueDate: invoice.dueDate,
      status: invoice.status,
      notes: invoice.notes,
      terms: invoice.terms,
      invoiceNumber: invoice.invoiceNumber,
    );
  }

  // ── CLIENT ────────────────────────────────────────

  void selectClient(ClientModel client) {
    state = state.copyWith(selectedClient: client);
  }

  void clearClient() {
    state = state.copyWith(selectedClient: null);
  }

  // ── ITEMS ─────────────────────────────────────────

  void addItem(ProductModel product, int quantity) {
    // check if item already exists — update quantity instead
    final existingIndex = state.items.indexWhere(
      (i) => i.productId == product.isarId.toString(),
    );

    if (existingIndex != -1) {
      updateItemQuantity(existingIndex, quantity);
      return;
    }

    final newItem = InvoiceItemModel.create(
      productId: product.isarId.toString(),
      productName: product.name,
      unitPrice: product.unitPrice,
      quantity: quantity,
      total: product.unitPrice * quantity,
    );

    state = state.copyWith(items: [...state.items, newItem]);
  }

  void removeItem(int index) {
    final updated = List<InvoiceItemModel>.from(state.items)..removeAt(index);
    state = state.copyWith(items: updated);
  }

  void updateItemQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeItem(index);
      return;
    }

    final updated = List<InvoiceItemModel>.from(state.items);
    final item = updated[index];

    updated[index] = InvoiceItemModel.create(
      productId: item.productId,
      productName: item.productName,
      unitPrice: item.unitPrice,
      quantity: quantity,
      total: item.unitPrice * quantity,
    );

    state = state.copyWith(items: updated);
  }

  void clearItems() {
    state = state.copyWith(items: []);
  }

  // ── FIELDS ────────────────────────────────────────

  void setTaxRate(double rate) {
    state = state.copyWith(taxRate: rate);
  }

  void setIssueDate(DateTime date) {
    final days = state.terms != null ? _extractDays(state.terms!) : null;
    final newDueDate = days != null
        ? date.add(Duration(days: days))
        : state.dueDate;

    state = state.copyWith(issueDate: date, dueDate: newDueDate);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes.isEmpty ? null : notes);
  }

  void setTerms(String? terms) {
    if (terms == null || terms.isEmpty) {
      state = state.copyWith(terms: null);
      return;
    }

    // auto-calculate due date based on term
    final days = _extractDays(terms);
    final newDueDate = days != null
        ? state.issueDate.add(Duration(days: days))
        : state.dueDate; // keep existing if term has no extractable days

    state = state.copyWith(terms: terms, dueDate: newDueDate);
  }

  int? _extractDays(String terms) {
    switch (terms) {
      case 'Due on receipt':
        return 0;
      case 'Net 7':
        return 7;
      case 'Net 15':
        return 15;
      case 'Net 30':
        return 30;
      case 'Net 45':
        return 45;
      case 'Net 60':
        return 60;
      case '100% upfront':
        return 0;
      default:
        return null;
    }
  }

  void setStatus(InvoiceStatus status) {
    state = state.copyWith(status: status);
  }

  // ── FINALIZE ──────────────────────────────────────

  Future<bool> createInvoice() async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please fill all required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

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
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _repo.createInvoice(invoice, state.selectedClient!);

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false);
        return true;
      case Error(:final failure):
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
    }
  }

  Future<bool> updateInvoice(InvoiceModel original) async {
    if (!state.isValid) {
      state = state.copyWith(error: 'Please fill all required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    final updated = original.copyWith(
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
    );

    final result = await _repo.updateInvoice(original, updated);

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false);
        return true;
      case Error(:final failure):
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
    }
  }

  // ── RESET ─────────────────────────────────────────

  void reset() {
    state = InvoiceFormState(
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      notes: '',
    );
  }
}
