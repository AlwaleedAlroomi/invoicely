import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/data/database/providers.dart';
import 'package:invoicely/data/repositories/business_expenses_repository_impl.dart';
import 'package:invoicely/data/services/business_expenses_service.dart';
import 'package:invoicely/features/business_expenses/controller/business_expenses_controller.dart';
import 'package:invoicely/features/business_expenses/repository/business_expenses_repository.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

final businessExpenseServiceProvider = Provider<BusinessExpensesService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BusinessExpensesService(db);
});

final businessExpenseRepositoryProvider = Provider<BusinessExpensesRepository>((
  ref,
) {
  final service = ref.watch(businessExpenseServiceProvider);
  return BusinessExpensesRepositoryImpl(service);
});

final businessExpenseController =
    StateNotifierProvider<
      BusinessExpensesController,
      BusinessExpensesListState
    >((ref) {
      final repository = ref.watch(businessExpenseRepositoryProvider);
      return BusinessExpensesController(repository, ref);
    });

final isListViewModeProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('is_list_view') ?? true;
});

final sortTypeProvider =
    StateNotifierProvider<BusinessExpenseSortTypeNotifier, SortType>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return BusinessExpenseSortTypeNotifier(prefs);
    });

final allBusinessExpensesProvider = FutureProvider<double>((ref) async {
  ref.watch(businessExpenseController);
  final result = await ref
      .read(businessExpenseRepositoryProvider)
      .getTotalExpenses();
  return result;
});
