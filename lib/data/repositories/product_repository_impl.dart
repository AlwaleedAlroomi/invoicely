import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_product_service.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final IsarProductService _productService;

  const ProductRepositoryImpl(this._productService);

  @override
  Future<Result<void>> deleteProduct(ProductModel product) async {
    final productToDelete = await _productService.getProductByRemoteId(product);
    if (productToDelete == null || productToDelete.isarId == null) {
      return Error(
        AppFailure.database(
          'Product with remoteId ${product.remoteId} not found in local DB.',
        ),
      );
    }
    return await _productService.deleteProduct(product);
  }

  @override
  Future<Result<ProductModel>> getProductByRemoteId(
    ProductModel product,
  ) async {
    // TODO: implement getProductByRemoteId
    try {
      final searchedProduct = await _productService.getProductByRemoteId(
        product,
      );
      if (searchedProduct == null) {
        return Error(
          AppFailure.database(
            "Product not found with remote ID: ${product.remoteId}",
          ),
        );
      }
      return Success(searchedProduct);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching product: $e'));
    }
  }

  @override
  Future<Result<List<ProductModel>>> getProducts() async {
    // TODO: implement getProducts
    return await _productService.getProducts();
  }

  @override
  Future<Result<ProductModel>> createProduct(ProductModel product) async {
    // TODO: implement saveProduct
    try {
      final result = await _productService.createProduct(product);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error creating product: $e'));
    }
  }

  @override
  Future<Result<ProductModel>> updateProduct(ProductModel product) async {
    try {
      final result = await _productService.updateProduct(product);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error updating product: $e'));
    }
  }

  @override
  Future<Result<ProductModel>> getProductBySku(String sku) async {
    // TODO: implement getProductBySku
    try {
      final product = await _productService.getProductBySku(sku);
      if (product == null) {
        return Error(AppFailure.database('Product not found with SKU: $sku'));
      }
      return Success(product);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching product by SKU: $e'));
    }
  }

  @override
  Future<Result<void>> forceDeleteProduct(ProductModel product) async {
    try {
      final productToDelete = await _productService.getProductByRemoteId(
        product,
      );
      if (productToDelete == null || productToDelete.isarId == null) {
        return Error(
          AppFailure.database(
            'Product with remoteId ${product.remoteId} not found in local DB.',
          ),
        );
      }
      return await _productService.forceDeleteProduct(product);
    } catch (e) {
      return Error(AppFailure('Unexpected error deleting product: $e'));
    }
  }
}
