import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/business_expenses/providers/business_expenses_provider.dart';
import 'package:invoicely/features/business_expenses/repository/business_expenses_repository.dart';
import 'package:invoicely/src/home_widget/expense_summary_widget.home_widget.dart';
// import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessExpensesListState {
  final bool isLoading;
  final List<BusinessExpense> businessExpenses;
  final AppFailure? failure;
  final bool hasMore;
  final bool isLoadingMore;
  final int currentPage;
  final BusinessExpense? selectedBusiness;

  BusinessExpensesListState({
    required this.isLoading,
    required this.businessExpenses,
    this.failure,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.currentPage = 0,
    this.selectedBusiness,
  });

  BusinessExpensesListState copyWith({
    bool? isLoading,
    List<BusinessExpense>? businessExpenses,
    AppFailure? failure,
    bool? hasMore,
    bool? isLoadingMore,
    int? currentPage,
    BusinessExpense? selectedBusiness,
  }) {
    return BusinessExpensesListState(
      isLoading: isLoading ?? this.isLoading,
      businessExpenses: businessExpenses ?? this.businessExpenses,
      failure: failure,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      selectedBusiness: selectedBusiness,
    );
  }
}

class BusinessExpensesController
    extends StateNotifier<BusinessExpensesListState> {
  final BusinessExpensesRepository _businessExpensesRepository;
  final Ref ref;
  List<BusinessExpense> _allExpenses = [];
  String _searchQuery = '';
  bool _showActiveOnly = true;
  static const int _pageSize = 20;

  BusinessExpensesController(this._businessExpensesRepository, this.ref)
    : super(
        BusinessExpensesListState(
          isLoading: false,
          businessExpenses: [],
          failure: null,
        ),
      ) {
    ref.listen(sortTypeProvider, (previous, next) {
      if (previous != next) {
        fetchExpenses();
      }
    });
  }

  Future<void> fetchExpenses() async {
    state = state.copyWith(
      isLoading: true,
      failure: null,
      currentPage: 0,
      hasMore: true,
    );
    final sortType = ref.read(sortTypeProvider);
    final result = await _businessExpensesRepository.getAllExpenses(
      0,
      _pageSize,
      sortType,
    );

    switch (result) {
      case Success<List<BusinessExpense>> fetched:
        _allExpenses = fetched.data;
        state = state.copyWith(
          isLoading: false,
          hasMore: fetched.data.length == _pageSize,
          currentPage: 0,
          businessExpenses: fetched.data,
        );
        break;
      case Error<List<BusinessExpense>> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: state.businessExpenses.isEmpty
              ? const []
              : state.businessExpenses,
        );
        break;
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final sortType = ref.read(sortTypeProvider);
    final result = await _businessExpensesRepository.getAllExpenses(
      nextPage,
      _pageSize,
      sortType,
    );

    switch (result) {
      case Success<List<BusinessExpense>> fetched:
        _allExpenses = [..._allExpenses, ...fetched.data];
        state = state.copyWith(
          isLoadingMore: false,
          hasMore: fetched.data.length == _pageSize,
          currentPage: nextPage,
          businessExpenses: [...state.businessExpenses, ...fetched.data],
        );
        break;
      case Error<List<BusinessExpense>> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: state.businessExpenses.isEmpty
              ? const []
              : state.businessExpenses,
        );
        break;
    }
  }

  Future<void> saveExpense(BusinessExpense expense) async {
    state = state.copyWith(isLoading: true, failure: null);

    final Result<BusinessExpense> result = expense.id == 0
        ? await _businessExpensesRepository.insertExpense(expense)
        : await _businessExpensesRepository.updateExpense(expense);

    switch (result) {
      case Success<BusinessExpense> _:
        await updateExpenseWidgetFromDatabase();
        fetchExpenses();
        break;
      case Error<BusinessExpense> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: [...state.businessExpenses],
        );
        break;
    }
  }

  Future<void> archiveExpense(BusinessExpense expense) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _businessExpensesRepository.deleteExpense(expense);
    switch (result) {
      case Success<void> _:
        fetchExpenses();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: [...state.businessExpenses],
        );
        break;
    }
  }

  Future<void> forceDeleteExpense(BusinessExpense expense) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _businessExpensesRepository.forceDeleteExpense(
      expense,
    );
    switch (result) {
      case Success<void> _:
        fetchExpenses();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: [...state.businessExpenses],
        );
        break;
    }
  }

  Future<void> getExpenseByRemoteId(BusinessExpense expense) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _businessExpensesRepository.getExpenseByRemoteId(
      expense,
    );
    switch (result) {
      case Success<BusinessExpense> fetched:
        state = state.copyWith(
          isLoading: false,
          failure: null,
          businessExpenses: state.businessExpenses,
          selectedBusiness: fetched.data,
        );
        break;
      case Error<BusinessExpense> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          businessExpenses: state.businessExpenses,
        );
        break;
    }
  }

  Future<void> updateExpenseWidgetFromDatabase() async {
    final double monthlyTotal = await _businessExpensesRepository
        .getMonthlyExpenseTotal();
    await ExpenseSummaryWidgetSchemaHomeWidget.saveData(
      monthlyTotal: '\$${monthlyTotal.toStringAsFixed(0)}',
    );
    await ExpenseSummaryWidgetSchemaHomeWidget.updateWidget();
  }

  void _applyFiltersAndSort() {
    if (_allExpenses.isEmpty) {
      state = state.copyWith(businessExpenses: [], isLoading: false);
    }
    final sortType = ref.read(sortTypeProvider);

    List<BusinessExpense> filtered;

    if (_showActiveOnly) {
      filtered = _allExpenses.where((e) => e.isActive == true).toList();
    } else {
      filtered = List.from(_allExpenses);
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((expense) {
        return expense.title.toLowerCase().contains(query) ||
            expense.vendorName!.toLowerCase().contains(query) ||
            expense.category!.toLowerCase().contains(query);
      }).toList();
    }
    print(filtered);
    filtered = sortType.sortExpenses(filtered);
    state = state.copyWith(isLoading: false, businessExpenses: filtered);
  }

  void searchExpenses(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _applyFiltersAndSort();
    } else {
      fetchExpenses();
    }
  }

  void setShowActiveOnly() {
    _showActiveOnly = !_showActiveOnly;
    _applyFiltersAndSort();
  }
}

class BusinessExpenseSortTypeNotifier extends StateNotifier<SortType> {
  static const _prefsKey = 'expense_sort_type';
  final SharedPreferences _prefs;

  BusinessExpenseSortTypeNotifier(this._prefs)
    : super(SortTypePrefs.fromKey(_prefs.getString(_prefsKey)));

  void setSortType(SortType type) {
    state = type;
    _prefs.setString(_prefsKey, type.key);
  }
}
