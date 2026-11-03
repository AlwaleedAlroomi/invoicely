import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/data/services/business_expenses_service.dart';
import 'package:invoicely/features/business_expenses/repository/business_expenses_repository.dart';

class BusinessExpensesRepositoryImpl implements BusinessExpensesRepository {
  final BusinessExpensesService _businessExpensesService;
  const BusinessExpensesRepositoryImpl(this._businessExpensesService);

  @override
  Future<Result<void>> deleteExpense(BusinessExpense expense) async {
    final expenseToArchive = await _businessExpensesService
        .getExpenseByRemoteId(expense);
    if (expenseToArchive == null) {
      return Error(
        AppFailure.database(
          'Expense with remoteId ${expense.remoteId} not found in local DB.',
        ),
      );
    }
    return await _businessExpensesService.deleteExpense(expense);
  }

  @override
  Future<Result<void>> forceDeleteExpense(BusinessExpense expense) async {
    try {
      final ExpenseToDelete = await _businessExpensesService
          .getExpenseByRemoteId(expense);
      if (ExpenseToDelete == null) {
        return Error(
          AppFailure.database(
            'Expense with remoteId ${expense.remoteId} not found in local DB.',
          ),
        );
      }
      return await _businessExpensesService.forceDeleteExpense(expense);
    } catch (e) {
      return Error(AppFailure('Unexpected error deleting expense: $e'));
    }
  }

  @override
  Future<Result<List<BusinessExpense>>> getAllExpenses(
    int page,
    int limit,
    SortType sortType,
  ) async {
    return await _businessExpensesService.getExpensesPaginated(
      page,
      limit,
      sortType,
    );
  }

  @override
  Future<double> getTotalExpenses() async {
    return await _businessExpensesService.getTotalExpenses();
  }

  @override
  Future<Result<BusinessExpense>> insertExpense(BusinessExpense expense) async {
    try {
      final result = await _businessExpensesService.insertExpense(expense);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error inserting expense: $e'));
    }
  }

  @override
  Future<Result<BusinessExpense>> updateExpense(BusinessExpense expense) async {
    try {
      final result = await _businessExpensesService.updateExpense(expense);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error updating expense: $e'));
    }
  }

  @override
  Future<Result<BusinessExpense>> getExpenseByRemoteId(
    BusinessExpense expense,
  ) async {
    try {
      final searchedExpense = await _businessExpensesService
          .getExpenseByRemoteId(expense);
      if (searchedExpense == null) {
        return Error(
          AppFailure.database(
            "Expense not found with remote ID: ${expense.remoteId}",
          ),
        );
      }
      return Success(searchedExpense);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching expense: $e'));
    }
  }
}
