import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/products/data/product_model.dart';

abstract class ProductRepository {
  // Create, read, update, delete
  Future<Result<ProductModel>> createProduct(ProductModel product);
  Future<Result<ProductModel>> updateProduct(ProductModel product);
  Future<Result<List<ProductModel>>> getProducts();
  Future<Result<void>> deleteProduct(ProductModel product);
  Future<Result<void>> forceDeleteProduct(ProductModel product);
  Future<Result<ProductModel>> getProductByRemoteId(ProductModel product);
  Future<Result<ProductModel>> getProductBySku(String sku);
}
