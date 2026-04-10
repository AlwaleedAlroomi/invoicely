import 'package:flutter_test/flutter_test.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_product_service.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;
  late IsarProductService service;
  setUp(() async {
    await Isar.initializeIsarCore(download: true);
    isar = await Isar.open([ProductModelSchema], directory: '.');

    service = IsarProductService(isar);
    await isar.writeTxn(() => isar.productModels.clear());
  });

  tearDown(() async {
    if (isar.isOpen) {
      await isar.close(deleteFromDisk: true);
    }
  });

  group("createProduct", () {
    test('should successfully save a product and return Success', () async {
      final product = ProductModel(name: 'test Product 1', unitPrice: 10);
      final result = await service.createProduct(product);
      expect(result.isSuccess, true);
      expect((result as Success).data.isarId, isA<int>());
    });

    test('should successfully get products and return Success', () async {
      final product = ProductModel(name: 'test Product 1', unitPrice: 10);
      await service.createProduct(product);
      final result = await service.getProducts();
      expect(result.isSuccess, true);
    });

    test('should successfully update a product and return Success', () async {
      final product = ProductModel(
        name: 'test Product 1',
        unitPrice: 10,
        sku: 'UPD-001',
      );
      final oldProduct = await service.createProduct(product);
      final newProduct = product.copyWith(
        name: 'updated test product',
        unitPrice: 15,
      );
      final result = await service.updateProduct(newProduct);
      final lastUpdated = (result as Success).data.lastUpdated;
      expect(result.isSuccess, true);
      expect(
        lastUpdated.isAfter((oldProduct as Success).data.lastUpdated),
        true,
      );
    });

    test(
      'should successfully soft delete product and return Success',
      () async {
        final product = ProductModel(name: 'test Product 1', unitPrice: 10);
        await service.createProduct(product);
        final result = await service.deleteProduct(product);
        expect(result.isSuccess, true);
        expect((result as Success).data.isActive, false);
      },
    );

    test(
      'should successfully delete product and return Success with 0 count',
      () async {
        final product = ProductModel(name: 'test Product 1', unitPrice: 10);
        await service.createProduct(product);
        await service.forceDeleteProduct(product);
        final count = await isar.productModels.count();
        expect(count, 0);
      },
    );

    test('should successfully get a product and return ProductModel', () async {
      final product = ProductModel(
        name: 'test Product 1',
        unitPrice: 10,
        sku: 'SER-001',
      );
      await service.createProduct(product);

      final result = await service.getProductBySku('ser-001');
      expect(result, isNotNull);
    });

    test('closing DB manually and return a Failure', () async {
      final product = ProductModel(
        name: 'test Product 1',
        unitPrice: 10,
        sku: 'SER-001',
      );
      await service.createProduct(product);
      await isar.close();
      final result = await service.getProducts();
      expect(result.isError, true);
    });
  });
}
