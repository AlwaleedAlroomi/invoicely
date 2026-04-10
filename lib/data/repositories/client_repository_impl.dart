import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_client_service.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/repository/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  final IsarClientService _clientService;

  const ClientRepositoryImpl(this._clientService);

  @override
  Future<Result<ClientModel>> addClient(ClientModel client) async {
    try {
      final result = await _clientService.addClient(client);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error while adding client: $e'));
    }
  }

  @override
  Future<Result<void>> archiveClient(ClientModel client) async {
    final clientToArchive = await _clientService.getClientByRemoteId(
      client.remoteId!,
    );
    if (clientToArchive == null) {
      return Error(
        AppFailure.database(
          'Client with remote id ${client.remoteId} not found in local DB.',
        ),
      );
    }
    return await _clientService.archiveClient(client);
  }

  @override
  Future<Result<void>> deleteClient(ClientModel client) async {
    try {
      final clientToDelete = await _clientService.getClientByRemoteId(
        client.remoteId!,
      );
      if (clientToDelete == null) {
        return Error(
          AppFailure.database(
            'Client with remote id ${client.remoteId} not found in local DB.',
          ),
        );
      }
      return await _clientService.deleteClient(client);
    } catch (e) {
      return Error(AppFailure('Unexpected error deleting client: $e'));
    }
  }

  @override
  Future<Result<List<ClientModel>>> getAllClients() async {
    return await _clientService.getAllClients();
  }

  @override
  Future<Result<ClientModel?>> getClientByEmail(String email) async {
    try {
      final client = await _clientService.getClientByEmail(email);
      if (client == null) {
        return Error(AppFailure.database('Client not found with email $email'));
      }
      return Success(client);
    } catch (e) {
      return Error(
        AppFailure('Unexpected error fetching client with emai: $e'),
      );
    }
  }

  @override
  Future<Result<ClientModel?>> getClientByRemoteId(String remoteId) async {
    try {
      final client = await _clientService.getClientByRemoteId(remoteId);
      if (client == null) {
        return Error(
          AppFailure.database('Client not found with remote Id $remoteId'),
        );
      }
      return Success(client);
    } catch (e) {
      return Error(
        AppFailure('Unexpected error fetching client with remote Id: $e'),
      );
    }
  }

  @override
  Future<Result<ClientModel>> updateClient(ClientModel client) async {
    try {
      final updatedClient = await _clientService.updateClient(client);
      switch (updatedClient) {
        case Success():
          return Success(updatedClient.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error updating client: $e'));
    }
  }
}
