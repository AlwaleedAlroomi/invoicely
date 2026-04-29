import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_product_service.dart';
import 'package:invoicely/data/repositories/product_repository_impl.dart';
import 'package:invoicely/features/products/controller/product_controller.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isarProductServiceProvider = Provider<IsarProductService>((ref) {
  return IsarProductService();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final isarService = ref.watch(isarProductServiceProvider);
  return ProductRepositoryImpl(isarService);
});

final productControllerProvider =
    StateNotifierProvider<ProductController, ProductListState>((ref) {
      final repository = ref.watch(productRepositoryProvider);
      return ProductController(repository, ref);
    });
// move to core folder
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});
// move to core folder
final isListViewModeProvider = StateProvider<bool>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return prefs.getBool('is_list_view') ?? true;
});

final sortTypeProvider =
    StateNotifierProvider<ProductSortTypeNotifier, SortType>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ProductSortTypeNotifier(prefs);
    });

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final result = await ref
      .read(productRepositoryProvider)
      .getAllActiveProducts();
  switch (result) {
    case Success(:final data):
      return data;
    case Error(:final failure):
      throw failure.message;
  }
});
