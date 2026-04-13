import 'package:flutter/foundation.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:isar/isar.dart';

class IsarClientService {
  final Isar _isar;

  IsarClientService([Isar? isar]) : _isar = isar ?? IsarService.instance;

  Future<Result<ClientModel>> addClient(ClientModel client) async {
    // print('from isar');
    try {
      await _isar.writeTxn(() async {
        await _isar.clientModels.put(client);
      });
      return Success(client);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error saving client: ${e.message}'),
      );
    }
  }

  Future<ClientModel?> getClientByRemoteId(String clientRemoteId) async {
    try {
      return await _isar.clientModels
          .filter()
          .remoteIdEqualTo(clientRemoteId)
          .findFirst();
    } catch (e) {
      debugPrint(
        'Warning: Failed to find client by remote id $clientRemoteId: $e',
      );
      return null;
    }
  }

  Future<ClientModel?> getClientByEmail(String clientEmail) async {
    try {
      return await _isar.clientModels
          .filter()
          .emailEqualTo(clientEmail)
          .findFirst();
    } catch (e) {
      debugPrint('Warning: Failed to find client by email $clientEmail: $e');
      return null;
    }
  }

  Future<Result<List<ClientModel>>> getAllClients() async {
    try {
      final clients = await _isar.clientModels.where().findAll();
      return Success(clients);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error fetching clients: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching client: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<ClientModel>> updateClient(ClientModel client) async {
    try {
      final updatedClient = await _isar.writeTxn(() async {
        await _isar.clientModels.put(client);
      });
      return Success(updatedClient);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error updating client: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred updating client: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> deleteClient(ClientModel client) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.clientModels.delete(client.isarId!);
      });
      return Success(null);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database("Isar error deleting client: ${e.message}"),
      );
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred while deleting client: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<void>> archiveClient(ClientModel client) async {
    try {
      await _isar.writeTxn(() async {
        client.isActive = false;
        await _isar.clientModels.put(client);
      });
      return Success(null);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error archiving client: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure(
          "An unexpected error occurred while archiving client: $e",
          type: FailureType.database,
        ),
      );
    }
  }
}
