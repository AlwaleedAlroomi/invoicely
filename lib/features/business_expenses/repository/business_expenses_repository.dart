import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';

abstract class BusinessExpensesRepository {
  Future<Result<BusinessExpense>> getAllExpenses();
  Future<Result<BusinessExpense>> insertExpense(BusinessExpense expense);
  Future<Result<BusinessExpense>> updateExpense(BusinessExpense expense);
  Future<Result<void>> deleteExpense(BusinessExpense expense);
  Future<Result<void>> forceDeleteExpense(BusinessExpense expense);
  Future<double> getTotalExpenses();
}
