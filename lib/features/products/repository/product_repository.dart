import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/products/data/product_model.dart';

abstract class ProductRepository {
  // Create, read, update, delete
  Future<Result<ProductModel>> createProduct(ProductModel product);
  Future<Result<ProductModel>> updateProduct(ProductModel product);
  Future<Result<List<ProductModel>>> getProductsPaginated(
    int page,
    int limit,
    SortType sortType,
  );
  Future<Result<List<ProductModel>>> getAllActiveProducts();
  Future<Result<void>> deleteProduct(ProductModel product);
  Future<Result<void>> forceDeleteProduct(ProductModel product);
  Future<Result<ProductModel>> getProductByRemoteId(ProductModel product);
  Future<Result<ProductModel>> getProductBySku(String sku);
}
