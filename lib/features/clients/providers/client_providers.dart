import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_client_service.dart';
import 'package:invoicely/data/repositories/client_repository_impl.dart';
import 'package:invoicely/features/clients/controller/client_controller.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/repository/client_repository.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

final isarClientServiceProvider = Provider<IsarClientService>((ref) {
  return IsarClientService();
});

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final isarService = ref.watch(isarClientServiceProvider);
  return ClientRepositoryImpl(isarService);
});

final clientControllerProvider =
    StateNotifierProvider<ClientController, ClientListState>((ref) {
      final repository = ref.watch(clientRepositoryProvider);
      return ClientController(repository, ref);
    });

final clientSortTypeProvider =
    StateNotifierProvider<ClientSortTypeNotifier, SortType>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ClientSortTypeNotifier(prefs);
    });

final allClientsProvider = FutureProvider<List<ClientModel>>((ref) async {
  final result = await ref.read(clientRepositoryProvider).getAllClients();
  switch (result) {
    case Success(:final data):
      return data;
    case Error(:final failure):
      throw failure.message;
  }
});
