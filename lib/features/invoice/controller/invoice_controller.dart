import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceListState {
  final bool isLoading;
  final List<InvoiceModel> invoices;
  final AppFailure? failure;
  final InvoiceModel? selectedInvoice;

  InvoiceListState({
    required this.isLoading,
    required this.invoices,
    this.failure,
    this.selectedInvoice,
  });

  InvoiceListState copyWith({
    bool? isLoading,
    List<InvoiceModel>? invoices,
    AppFailure? failure,
    InvoiceModel? selectedInvoice,
  }) {
    return InvoiceListState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      failure: failure,
      selectedInvoice: selectedInvoice,
    );
  }
}

class InvoiceController extends StateNotifier<InvoiceListState> {
  final InvoiceRepository _invoiceRepository;
  final Ref ref;
  List<InvoiceModel> _allInvoices = [];
  String _searchQuery = '';
  bool _showActiveOnly = true;

  InvoiceController(this._invoiceRepository, this.ref)
    : super(InvoiceListState(isLoading: false, invoices: [], failure: null)) {
    ref.listen(sortTypeProvider, (_, _) {
      _applyFiltersAndSort();
    });

    Future<void> fetchInvoices() async {
      state = state.copyWith(isLoading: true, failure: null);
      final result = await _invoiceRepository.getAllInvoices();
      switch (result) {
        case Success<List<InvoiceModel>> fetched:
          _allInvoices = fetched.data;
          _applyFiltersAndSort();
          break;
        case Error<List<InvoiceModel>> e:
          state = state.copyWith(
            isLoading: false,
            failure: e.failure,
            invoices: state.invoices.isEmpty ? const [] : state.invoices,
          );
          break;
      }
    }

    Future<void> updateInvoiceStatus(
      InvoiceModel invoice,
      InvoiceStatus status,
    ) async {
      state = state.copyWith(isLoading: true, failure: null);
      final Result<void> result = await _invoiceRepository.updateInvoiceStatus(
        invoice,
        status,
      );
      switch (result) {
        case Success<void> _:
          fetchInvoices();
          break;
        case Error<void> e:
          state = state.copyWith(
            isLoading: false,
            invoices: [...state.invoices],
            failure: e.failure,
          );
          break;
      }
    }

    Future<void> deleteInvoice(InvoiceModel invoice) async {
      state = state.copyWith(isLoading: true, failure: null);
      final result = await _invoiceRepository.deleteInvoice(invoice);
      switch (result) {
        case Success<void> _:
          fetchInvoices();
          break;
        case Error<void> e:
          state = state.copyWith(
            isLoading: false,
            failure: e.failure,
            invoices: [...state.invoices],
          );
      }
    }

    Future<void> getInvoiceByRemoteId(String remoteId) async {
      state = state.copyWith(isLoading: true, failure: null);
      final result = await _invoiceRepository.getInvoiceByRemoteId(remoteId);
      switch (result) {
        case Success<InvoiceModel?> fetched:
          state = state.copyWith(
            isLoading: false,
            failure: null,
            invoices: state.invoices,
            selectedInvoice: fetched.data,
          );
          break;
        case Error<InvoiceModel?> e:
          state = state.copyWith(
            isLoading: false,
            failure: e.failure,
            invoices: state.invoices,
          );
      }
    }

    Future<void> getInvoicesByStatus(InvoiceStatus status) async {
      state = state.copyWith(isLoading: true, failure: null);
      final result = await _invoiceRepository.getInvoicesByStatus(status);
      switch (result) {
        case Success<List<InvoiceModel>> fetched:
          state = state.copyWith(
            isLoading: false,
            failure: null,
            invoices: fetched.data,
          );
          break;
        case Error<List<InvoiceModel>> e:
          state = state.copyWith(
            isLoading: false,
            failure: e.failure,
            invoices: state.invoices,
          );
      }
    }

    Future<void> getInvoicesByClient(int clientIsarId) async {
      state = state.copyWith(isLoading: true, failure: null);
      final result = await _invoiceRepository.getInvoicesByClient(clientIsarId);
      switch (result) {
        case Success<List<InvoiceModel>> fetched:
          state = state.copyWith(
            isLoading: false,
            failure: null,
            invoices: fetched.data,
          );
          break;
        case Error<List<InvoiceModel>> e:
          state = state.copyWith(
            isLoading: false,
            failure: e.failure,
            invoices: state.invoices,
          );
      }
    }
  }
  void _applyFiltersAndSort() {
    if (_allInvoices.isEmpty) {
      state = state.copyWith(invoices: [], isLoading: false);
    }
    final sortType = ref.read(sortTypeProvider);

    List<InvoiceModel> filtered;

    if (_showActiveOnly) {
      filtered = _allInvoices.where((p) => p.isActive == true).toList();
    } else {
      filtered = List.from(_allInvoices); // active + deleted
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      // filtered = filtered.where((invoice) {
      //   return invoice.displayName.toLowerCase().contains(query) ||
      //       (invoice.sku?.toLowerCase().contains(query) ?? false);
      // }).toList();
    }
    filtered = sortType.sort(filtered);

    state = state.copyWith(isLoading: false, invoices: filtered, failure: null);
  }

  void searchInvoices(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _applyFiltersAndSort();
    } else {
      // TODO: fetch invoices
      // fetchInvoices();
    }
  }

  void setShowActiveOnly() {
    _showActiveOnly = !_showActiveOnly;
    _applyFiltersAndSort();
  }
}

class InvoiceSortTypeNotifier extends StateNotifier<SortType> {
  static const _prefsKey = 'invoice_sort_type';
  final SharedPreferences _prefs;

  InvoiceSortTypeNotifier(this._prefs)
    : super(SortTypePrefs.fromKey(_prefs.getString(_prefsKey)));

  void setSortType(SortType type) {
    state = type;
    _prefs.setString(_prefsKey, type.key);
  }
}
