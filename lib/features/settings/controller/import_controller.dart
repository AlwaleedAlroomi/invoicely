import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/settings/services/import_service.dart';

class ImportState {
  final bool isLoading;
  final String? error;
  final ImportResult? result;

  const ImportState({this.isLoading = false, this.error, this.result});

  ImportState copyWith({bool? isLoading, String? error, ImportResult? result}) {
    return ImportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      result: result ?? this.result,
    );
  }
}

class ImportController extends StateNotifier<ImportState> {
  final XlsxImportService _service;

  ImportController(this._service) : super(const ImportState());

  Future<void> importClients() async {
    state = state.copyWith(isLoading: true, error: null, result: null);
    try {
      final result = await _service.importClients();
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> importProducts() async {
    state = state.copyWith(isLoading: true, error: null, result: null);
    try {
      final result = await _service.importProducts();
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
