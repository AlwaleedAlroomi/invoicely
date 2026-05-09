import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/clients/data/client_model.dart';

class ClientService {
  final AppDatabase _db;
  ClientService(this._db);

  static ClientModel fromRow(Client row) {
    return ClientModel(
      isarId: row.id,
      remoteId: row.remoteId,
      name: row.name,
      email: row.email,
      phone: row.phone,
      website: row.website,
      addressLine1: row.addressLine1,
      addressLine2: row.addressLine2,
      city: row.city,
      state: row.state,
      zipCode: row.zipCode,
      country: row.country,
      taxNumber: row.taxNumber,
      currency: row.currency,
      notes: row.notes,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<Result<ClientModel>> addClient(ClientModel client) async {
    try {
      final id = await _db.into(_db.clients).insert(ClientsCompanion(
            remoteId: Value(client.remoteId!),
            name: Value(client.name),
            email: Value(client.email),
            phone: Value(client.phone),
            website: Value(client.website),
            addressLine1: Value(client.addressLine1),
            addressLine2: Value(client.addressLine2),
            city: Value(client.city),
            state: Value(client.state),
            zipCode: Value(client.zipCode),
            country: Value(client.country),
            taxNumber: Value(client.taxNumber),
            currency: Value(client.currency),
            notes: Value(client.notes),
            isActive: Value(client.isActive),
            createdAt: Value(client.createdAt),
            updatedAt: Value(client.updatedAt),
          ));
      client.isarId = id;
      return Success(client);
    } catch (e) {
      return Error(
        AppFailure.database('An error occurred saving client: $e'),
      );
    }
  }

  Future<ClientModel?> getClientByRemoteId(String clientRemoteId) async {
    try {
      final row = await (_db.select(_db.clients)
            ..where((t) => t.remoteId.equals(clientRemoteId)))
          .getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint(
        'Warning: Failed to find client by remote id $clientRemoteId: $e',
      );
      return null;
    }
  }

  Future<ClientModel?> getClientByEmail(String clientEmail) async {
    try {
      final row = await (_db.select(_db.clients)
            ..where((t) => t.email.equals(clientEmail)))
          .getSingleOrNull();
      if (row == null) return null;
      return fromRow(row);
    } catch (e) {
      debugPrint('Warning: Failed to find client by email $clientEmail: $e');
      return null;
    }
  }

  Future<Result<List<ClientModel>>> getAllClients() async {
    try {
      final rows = await _db.select(_db.clients).get();
      return Success(rows.map((r) => fromRow(r)).toList());
    } catch (e) {
      return Error(
        AppFailure(
          'An unexpected error occurred fetching clients: $e',
          type: FailureType.database,
        ),
      );
    }
  }

  Future<Result<ClientModel>> updateClient(ClientModel client) async {
    try {
      await (_db.update(_db.clients)
            ..where((t) => t.remoteId.equals(client.remoteId!)))
          .write(ClientsCompanion(
            name: Value(client.name),
            email: Value(client.email),
            phone: Value(client.phone),
            website: Value(client.website),
            addressLine1: Value(client.addressLine1),
            addressLine2: Value(client.addressLine2),
            city: Value(client.city),
            state: Value(client.state),
            zipCode: Value(client.zipCode),
            country: Value(client.country),
            taxNumber: Value(client.taxNumber),
            currency: Value(client.currency),
            notes: Value(client.notes),
            isActive: Value(client.isActive),
            updatedAt: Value(client.updatedAt),
          ));
      return Success(client);
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
      await (_db.delete(_db.clients)
            ..where((t) => t.remoteId.equals(client.remoteId!)))
          .go();
      return const Success(null);
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
      await (_db.update(_db.clients)
            ..where((t) => t.remoteId.equals(client.remoteId!)))
          .write(const ClientsCompanion(
            isActive: Value(false),
          ));
      return const Success(null);
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
