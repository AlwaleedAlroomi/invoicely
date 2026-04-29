import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/providers/invoice_provider.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceListState {
  final bool isLoading;
  final List<InvoiceModel> invoices;
  final AppFailure? failure;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;
  final InvoiceModel? selectedInvoice;
  final InvoiceStatus? selectedStatus;

  InvoiceListState({
    required this.isLoading,
    required this.invoices,
    this.failure,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.selectedInvoice,
    this.selectedStatus,
  });

  InvoiceListState copyWith({
    bool? isLoading,
    List<InvoiceModel>? invoices,
    AppFailure? failure,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    InvoiceModel? selectedInvoice,
    Object? selectedStatus = _sentinel,
  }) {
    return InvoiceListState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      failure: failure,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      selectedInvoice: selectedInvoice,
      selectedStatus: selectedStatus == _sentinel
          ? this.selectedStatus
          : (selectedStatus as InvoiceStatus?),
    );
  }
}

const _sentinel = Object();

class InvoiceController extends StateNotifier<InvoiceListState> {
  final InvoiceRepository _invoiceRepository;
  final Ref ref;
  List<InvoiceModel> _allInvoices = [];
  String _searchQuery = '';
  InvoiceStatus? _filterStatus;
  bool _showActiveOnly = true;
  static const int _pagesize = 20;

  InvoiceController(this._invoiceRepository, this.ref)
    : super(InvoiceListState(isLoading: false, invoices: [], failure: null)) {
    ref.listen(invoiceSortTypeProvider, (previous, next) {
      if (previous != next) {
        fetchInvoices();
      }
    });
  }

  Future<void> fetchInvoices() async {
    state = state.copyWith(
      isLoading: true,
      failure: null,
      currentPage: 0,
      hasMore: true,
    );
    final sortType = ref.read(invoiceSortTypeProvider);
    final result = await _invoiceRepository.getInvoicesPaginated(
      0,
      _pagesize,
      sortType,
    );
    switch (result) {
      case Success<List<InvoiceModel>> fetched:
        _allInvoices = fetched.data;
        state = state.copyWith(
          isLoading: false,
          hasMore: fetched.data.length == _pagesize,
          currentPage: 0,
          invoices: fetched.data,
        );
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

  Future<void> fetchMore() async {
    if (!state.hasMore || state.isLoadingMore) return;
    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final sortType = ref.read(invoiceSortTypeProvider);
    final result = await _invoiceRepository.getInvoicesPaginated(
      nextPage,
      _pagesize,
      sortType,
    );

    switch (result) {
      case Success<List<InvoiceModel>> fetched:
        _allInvoices = [..._allInvoices, ...fetched.data];
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: fetched.data.length == _pagesize,
          currentPage: nextPage,
        );
      case Error<List<InvoiceModel>> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          invoices: state.invoices.isEmpty ? const [] : state.invoices,
        );
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

  Future<void> getInvoicesByClient(String clientRemoteId) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _invoiceRepository.getInvoicesByClient(clientRemoteId);
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

  void setStatusFilter(InvoiceStatus? status) {
    _filterStatus = status;
    state = state.copyWith(selectedStatus: status);
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    if (_allInvoices.isEmpty) {
      state = state.copyWith(invoices: [], isLoading: false);
    }
    final sortType = ref.read(invoiceSortTypeProvider);

    List<InvoiceModel> filtered;

    if (_showActiveOnly) {
      filtered = _allInvoices
          .where((invoice) => invoice.isActive == true)
          .toList();
    } else {
      filtered = List.from(_allInvoices); // active + deleted
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      filtered = filtered.where((invoice) {
        return invoice.displayName.toLowerCase().contains(query) ||
            invoice.client.value!.name.toLowerCase().contains(query) ||
            invoice.totalAmount.toString().contains(query);
      }).toList();
    }
    if (_filterStatus != null) {
      filtered = filtered
          .where((invoice) => invoice.status == _filterStatus)
          .toList();
    }
    filtered = sortType.sort(filtered);

    state = state.copyWith(isLoading: false, invoices: filtered, failure: null);
  }

  void searchInvoices(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _applyFiltersAndSort();
    } else {
      fetchInvoices();
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
