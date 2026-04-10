import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/extensions/sort_type_extension.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/clients/providers/client_providers.dart';
import 'package:invoicely/features/clients/repository/client_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientListState {
  final bool isLoading;
  final List<ClientModel> clients;
  final AppFailure? failure;
  final ClientModel? selectedClient;

  ClientListState({
    required this.isLoading,
    required this.clients,
    this.failure,
    this.selectedClient,
  });

  ClientListState copyWith({
    bool? isLoading,
    List<ClientModel>? clients,
    AppFailure? failure,
    ClientModel? selectedClient,
  }) {
    return ClientListState(
      isLoading: isLoading ?? this.isLoading,
      clients: clients ?? this.clients,
      failure: failure,
      selectedClient: selectedClient,
    );
  }
}

class ClientController extends StateNotifier<ClientListState> {
  final ClientRepository _clientRepository;
  final Ref ref;
  List<ClientModel> _allClients = [];
  String _searchQuery = '';
  bool _showActiveOnly = true;

  ClientController(this._clientRepository, this.ref)
    : super(ClientListState(isLoading: false, clients: [], failure: null)) {
    ref.listen(clientSortTypeProvider, (_, _) {
      _applyFiltersAndSort();
    });
  }

  Future<void> getAllClients() async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _clientRepository.getAllClients();
    switch (result) {
      case Success<List<ClientModel>> fetched:
        _allClients = fetched.data;
        final activeClients = fetched.data
            .where((c) => c.isActive == true)
            .toList();
        state = state.copyWith(
          isLoading: false,
          failure: null,
          clients: activeClients,
        );
        break;
      case Error<List<ClientModel>> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: state.clients.isEmpty ? const [] : state.clients,
        );
        break;
    }
  }

  Future<void> saveClient(ClientModel client) async {
    state = state.copyWith(isLoading: true, failure: null);
    final Result<ClientModel> result = client.isarId == null
        ? await _clientRepository.addClient(client)
        : await _clientRepository.updateClient(client);

    switch (result) {
      case Success<ClientModel> _:
        getAllClients();
        break;
      case Error<ClientModel> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: [...state.clients],
        );
        break;
    }
  }

  Future<void> archiveClient(ClientModel client) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _clientRepository.archiveClient(client);
    switch (result) {
      case Success<void> _:
        getAllClients();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: [...state.clients],
        );
        break;
    }
  }

  Future<void> deleteClient(ClientModel client) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _clientRepository.deleteClient(client);
    switch (result) {
      case Success<void> _:
        getAllClients();
        break;
      case Error<void> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: [...state.clients],
        );
        break;
    }
  }

  Future<void> getClientByRemoteId(ClientModel client) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _clientRepository.getClientByRemoteId(
      client.remoteId!,
    );
    switch (result) {
      case Success<ClientModel?> fetched:
        state = state.copyWith(
          isLoading: false,
          failure: null,
          clients: state.clients,
          selectedClient: fetched.data,
        );
        break;
      case Error<ClientModel?> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: state.clients,
        );
        break;
    }
  }

  Future<void> getClientByEmail(ClientModel client) async {
    state = state.copyWith(isLoading: true, failure: null);
    final result = await _clientRepository.getClientByEmail(client.email);
    switch (result) {
      case Success<ClientModel?> fetched:
        state = state.copyWith(
          isLoading: false,
          failure: null,
          clients: state.clients,
          selectedClient: fetched.data,
        );
        break;
      case Error<ClientModel?> e:
        state = state.copyWith(
          isLoading: false,
          failure: e.failure,
          clients: state.clients,
        );
        break;
    }
  }

  void _applyFiltersAndSort() {
    if (_allClients.isEmpty) {
      state = state.copyWith(clients: [], isLoading: false);
    }
    final sortType = ref.read(clientSortTypeProvider);

    List<ClientModel> filtered;

    if (_showActiveOnly) {
      filtered = _allClients.where((p) => p.isActive == true).toList();
    } else {
      filtered = List.from(_allClients); // active + deleted
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((client) {
        return client.name.toLowerCase().contains(query) ||
            client.email.toLowerCase().contains(query) ||
            (client.phone?.toLowerCase().contains(query) ?? false) ||
            (client.website?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    filtered = sortType.sort(filtered);
    state = state.copyWith(isLoading: false, clients: filtered, failure: null);
  }

  void searchClients(String query) {
    _searchQuery = query;
    if (_searchQuery.isNotEmpty) {
      _applyFiltersAndSort();
    } else {
      getAllClients();
    }
  }

  void setShowActiveOnly() {
    _showActiveOnly = !_showActiveOnly;
    _applyFiltersAndSort();
  }
}

class ClientSortTypeNotifier extends StateNotifier<SortType> {
  static const _prefsKey = 'client_sort_type';
  final SharedPreferences _prefs;

  ClientSortTypeNotifier(this._prefs)
    : super(SortTypePrefs.fromKey(_prefs.getString(_prefsKey)));

  void setSortType(SortType type) {
    state = type;
    _prefs.setString(_prefsKey, type.key);
  }
}
