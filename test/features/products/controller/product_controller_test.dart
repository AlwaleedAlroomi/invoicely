import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/products/controller/product_controller.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';
import 'package:invoicely/features/products/repository/product_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockSubscription extends Mock implements ProviderSubscription<SortType> {}

class MockRef extends Mock implements Ref {}

class FakeProviderListenable extends Fake
    implements ProviderListenable<SortType> {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProviderListenable());
    registerFallbackValue(SortType.nameAsc);

    registerFallbackValue((SortType? prev, SortType next) {});
  });

  late ProductController controller;
  late MockProductRepository mockRepo;
  late MockRef mockRef;

  final tProduct = ProductModel(name: 'mock app', unitPrice: 8, sku: 'M1');
  final tProductList = [tProduct];

  setUp(() {
    mockRepo = MockProductRepository();
    mockRef = MockRef();
    final mockSubscription = MockSubscription();

    when(
      () => mockRef.listen<SortType>(
        any(),
        any(),
        fireImmediately: any(
          named: 'fireImmediately',
        ), // Matches the optional param
        onError: any(named: 'onError'),
      ),
    ).thenReturn(mockSubscription);
    when(() => mockRef.read(sortTypeProvider)).thenReturn(SortType.nameAsc);

    controller = ProductController(mockRepo, mockRef);
  });

  group('init state', () {
    test('init state should be empty and not loading', () {
      expect(controller.state.isLoading, false);
      expect(controller.state.products, []);
      expect(controller.state.failure, isNull);
    });
  });

  group('fetch products', () {
    test('emits loading then Success when repo succeeds', () async {
      when(
        () => mockRepo.getProducts(),
      ).thenAnswer((_) async => Success(tProductList));

      final future = controller.fetchProducts();

      await future;

      expect(controller.state.isLoading, false);
      expect(controller.state.products, tProductList);
      verify(() => mockRepo.getProducts()).called(1);
    });

    test('emits failure state when repo return error', () async {
      final failure = AppFailure.database('Error');

      when(
        () => mockRepo.getProducts(),
      ).thenAnswer((_) async => Error(failure));

      await controller.fetchProducts();

      expect(controller.state.isLoading, false);
      expect(controller.state.failure, failure);
    });
  });
}
