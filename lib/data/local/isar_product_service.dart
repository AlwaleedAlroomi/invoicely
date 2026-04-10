import 'package:flutter/foundation.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:isar/isar.dart';

class IsarProductService {
  // Isar get _isar => IsarService.instance;
  final Isar _isar;

  IsarProductService([Isar? isar]) : _isar = isar ?? IsarService.instance;

  Future<Result<List<ProductModel>>> getProducts() async {
    try {
      final products = await _isar.productModels.where().findAll();
      return Success(products);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error fetching products: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching products: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<ProductModel>> createProduct(ProductModel product) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.productModels.put(product);
      });
      return Success(product);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error saving products: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred saving products: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<ProductModel>> updateProduct(ProductModel product) async {
    try {
      final updatedProduct = product.copyWith(lastUpdated: DateTime.now());
      await _isar.writeTxn(() async {
        await _isar.productModels.put(updatedProduct);
      });
      return Success(updatedProduct);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error updating product: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred updating product: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> deleteProduct(ProductModel product) async {
    try {
      await _isar.writeTxn(() async {
        product.isActive = false;
        await _isar.productModels.put(product);
      });
      return Success(null);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error deleting product: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred deleting product: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> forceDeleteProduct(ProductModel product) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.productModels.delete(product.isarId!);
      });
      return Success(null);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error deleting product: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred deleting product: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<ProductModel?> getProductByRemoteId(ProductModel product) async {
    try {
      return await _isar.productModels
          .filter()
          .remoteIdEqualTo(product.remoteId)
          .findFirst();
    } catch (e) {
      debugPrint(
        'Warning: Failed to find product by remoteId ${product.remoteId}: $e',
      );
      return null;
    }
  }

  Future<ProductModel?> getProductBySku(String sku) async {
    try {
      return await _isar.productModels
          .filter()
          .skuEqualTo(sku, caseSensitive: false)
          .findFirst();
    } catch (e) {
      debugPrint("Warning: Failed to find product by SKU $sku: $e");
      return null;
    }
  }
}
