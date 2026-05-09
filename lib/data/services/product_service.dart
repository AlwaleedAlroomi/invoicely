import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/products/data/product_model.dart';

class ProductService {
  final AppDatabase _db;
  ProductService(this._db);

  static ProductModel fromRow(Product row) {
    return ProductModel(
      isarId: row.id,
      remoteId: row.remoteId,
      name: row.name,
      description: row.description,
      unitPrice: row.unitPrice,
      imagePath: row.imagePath,
      stockQuantity: row.stockQuantity,
      sku: row.sku,
      isActive: row.isActive,
      lastUpdated: row.lastUpdated,
      createdAt: row.createdAt,
    );
  }

  Future<Result<List<ProductModel>>> getProductsPaginated(
    int page,
    int limit,
    SortType sortType,
  ) async {
    try {
      var query = _db.select(_db.products);
      switch (sortType) {
        case SortType.nameAsc:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.name)])
            ..limit(limit, offset: page * limit);
        case SortType.nameDesc:
          query = query
            ..orderBy([
              (t) => OrderingTerm(expression: t.name, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.newest:
          query = query
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.oldest:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
            ..limit(limit, offset: page * limit);
        case SortType.priceAsc:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.unitPrice)])
            ..limit(limit, offset: page * limit);
        case SortType.priceDesc:
          query = query
            ..orderBy([
              (t) =>
                  OrderingTerm(expression: t.unitPrice, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.quantityAsc:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.stockQuantity)])
            ..limit(limit, offset: page * limit);
        case SortType.quantityDesc:
          query = query
            ..orderBy([
              (t) => OrderingTerm(
                  expression: t.stockQuantity, mode: OrderingMode.desc),
            ])
            ..limit(limit, offset: page * limit);
      }
      final rows = await query.get();
      return Success(rows.map((r) => fromRow(r)).toList());
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
      final id = await _db.into(_db.products).insert(ProductsCompanion(
            remoteId: Value(product.remoteId!),
            name: Value(product.name),
            description: Value(product.description),
            unitPrice: Value(product.unitPrice),
            imagePath: Value(product.imagePath),
            stockQuantity: Value(product.stockQuantity),
            sku: Value(product.sku),
            isActive: Value(product.isActive),
            createdAt: Value(product.createdAt),
            lastUpdated: Value(product.lastUpdated),
          ));
      product.isarId = id;
      return Success(product);
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred saving product: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<ProductModel>> updateProduct(ProductModel product) async {
    try {
      final updatedProduct = product.copyWith(lastUpdated: DateTime.now());
      await (_db.update(_db.products)
            ..where((t) => t.remoteId.equals(product.remoteId!)))
          .write(ProductsCompanion(
            name: Value(updatedProduct.name),
            description: Value(updatedProduct.description),
            unitPrice: Value(updatedProduct.unitPrice),
            imagePath: Value(updatedProduct.imagePath),
            stockQuantity: Value(updatedProduct.stockQuantity),
            sku: Value(updatedProduct.sku),
            isActive: Value(updatedProduct.isActive),
            lastUpdated: Value(updatedProduct.lastUpdated),
          ));
      return Success(updatedProduct);
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
      await (_db.update(_db.products)
            ..where((t) => t.remoteId.equals(product.remoteId!)))
          .write(const ProductsCompanion(
            isActive: Value(false),
          ));
      return const Success(null);
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
      await (_db.delete(_db.products)
            ..where((t) => t.remoteId.equals(product.remoteId!)))
          .go();
      return const Success(null);
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
      final row = await (_db.select(_db.products)
            ..where((t) => t.remoteId.equals(product.remoteId!)))
          .getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint(
        'Warning: Failed to find product by remoteId ${product.remoteId}: $e',
      );
      return null;
    }
  }

  Future<ProductModel?> getProductBySku(String sku) async {
    try {
      final row = await (_db.select(_db.products)
            ..where((t) => t.sku.equals(sku)))
          .getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint("Warning: Failed to find product by SKU $sku: $e");
      return null;
    }
  }

  Future<Result<List<ProductModel>>> getAllActiveProducts() async {
    try {
      final rows = await (_db.select(_db.products)
            ..where((t) => t.isActive.equals(true)))
          .get();
      return Success(rows.map((r) => fromRow(r)).toList());
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching products: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<ProductModel?> getProductById(int id) async {
    try {
      final row = await (_db.select(_db.products)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint('Warning: Failed to find product by id $id: $e');
      return null;
    }
  }
}
