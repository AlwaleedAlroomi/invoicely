import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/clients/data/client_model.dart';

abstract class ClientRepository {
  Future<Result<ClientModel>> addClient(ClientModel client);

  Future<Result<ClientModel?>> getClientByRemoteId(String remoteId);
  Future<Result<ClientModel?>> getClientByEmail(String email);
  Future<Result<List<ClientModel>>> getAllClients();

  Future<Result<ClientModel>> updateClient(ClientModel client);
  Future<Result<void>> deleteClient(ClientModel client);
  Future<Result<void>> archiveClient(ClientModel client);
}
