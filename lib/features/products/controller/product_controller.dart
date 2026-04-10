import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/repository/product_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductListState {
  final bool isLoading;
  final List<ProductModel> products;
  final AppFailure? failure;
  final ProductModel? selectedProduct;

  ProductListState({
    required this.isLoading,
    required this.products,
    this.failure,
    this.selectedProduct,
  });

  ProductListState copyWith({
    bool? isLoading,
    List<ProductModel>? products,
    AppFailure? failure,
    ProductModel? selectedProduct,
  }) {
    return ProductListState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      failure: failure,
      selectedProduct: selectedProduct,
    );
  }
}

class ProductController extends StateNotifier<ProductListState> {
  final ProductRepository _productRepository;
  final Ref ref;
  List<ProductModel> _allProducts = [];
  String _searchQuery = '';
  bool _showActiveOnly = true;

  ProductController(this._productRepository, this.ref)
    : super(ProductListState(isLoading: false, products: [], failure: null)) {
    ref.listen(sortTypeProvider, (_, _) {
      _applyFiltersAndSort();
    });
  }

  Future<void> fetchProducts() async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _productRepository.getProducts();

    switch (result) {
      case Success<List<ProductModel>> fecthed:
        // final activeProducts = fecthed.data
        //     .where((p) => p.isActive != false)
        //     .toList();
        _allProducts = fecthed.data;
        _applyFiltersAndSort();
        break;
      case Error<List<ProductModel>> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          products: state.products.isEmpty ? const [] : state.products,
        );
        break;
    }
  }

  // create/save Product
  Future<void> saveProduct(ProductModel product) async {
    state = state.copyWith(isLoading: true, failure: null);

    final Result<ProductModel> result = product.isarId == null
        ? await _productRepository.createProduct(product)
        : await _productRepository.updateProduct(product);

    switch (result) {
      case Success<ProductModel> _:
        fetchProducts();
        break;
      case Error<ProductModel> e:
        state = state.copyWith(
          isLoading: false,
          products: [...state.products],
          failure: e.failure,
        );
        break;
    }
  }

  Future<void> deleteProduct(ProductModel product) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _productRepository.deleteProduct(product);
    switch (result) {
      case Success<void> _:
        // final updatedList = state.products
        //     .where((p) => p.remoteId != product.remoteId)
        //     .toList();
        // state = state.copyWith(
        //   isLoading: false,
        //   products: updatedList,
        //   failure: null,
        // );
        fetchProducts();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          products: [...state.products],
        );
    }
  }

  Future<void> forceDeleteProduct(ProductModel product) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _productRepository.forceDeleteProduct(product);
    switch (result) {
      case Success<void> _:
        fetchProducts();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          products: [...state.products],
        );
    }
  }

  // Getbyremoteid
  Future<void> getProductByRemoteId(ProductModel product) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _productRepository.getProductByRemoteId(product);
    switch (result) {
      case Success<ProductModel> fetched:
        state = state.copyWith(
          isLoading: false,
          failure: null,
          products: state.products,
          selectedProduct: fetched.data,
        );
        break;
      case Error<ProductModel> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          products: state.products,
        );
    }
  }

  //getbysku
  Future<void> getProductBySku(String sku) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _productRepository.getProductBySku(sku);

    switch (result) {
      case Success<ProductModel> fetched:
        if (fetched.data.isActive) {
          state = state.copyWith(
            isLoading: false,
            failure: null,
            products: state.products,
            selectedProduct: fetched.data,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
            // You can create a custom failure message here
            failure: AppFailure.database("This product is currently inactive."),
            products: state.products,
          );
        }
        break;
      case Error<ProductModel> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          products: state.products,
        );
    }
  }

  void _applyFiltersAndSort() {
    if (_allProducts.isEmpty) {
      state = state.copyWith(products: [], isLoading: false);
    }
    final sortType = ref.read(sortTypeProvider);

    List<ProductModel> filtered;

    if (_showActiveOnly) {
      filtered = _allProducts.where((p) => p.isActive == true).toList();
    } else {
      filtered = List.from(_allProducts); // active + deleted
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();

      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            (product.sku?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    filtered = sortType.sort(filtered);

    state = state.copyWith(isLoading: false, products: filtered, failure: null);
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _applyFiltersAndSort();
    } else {
      fetchProducts();
    }
  }

  void setShowActiveOnly() {
    _showActiveOnly = !_showActiveOnly;
    _applyFiltersAndSort();
  }
}

class ProductSortTypeNotifier extends StateNotifier<SortType> {
  static const _prefsKey = 'product_sort_type';
  final SharedPreferences _prefs;

  ProductSortTypeNotifier(this._prefs)
    : super(SortTypePrefs.fromKey(_prefs.getString(_prefsKey)));

  void setSortType(SortType type) {
    state = type;
    _prefs.setString(_prefsKey, type.key);
  }
}
