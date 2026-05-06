import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/features/settings/services/csv_export_service.dart';

class ExportState {
  final bool isLoading;
  final String? error;
  final List<String> exportedPaths;

  const ExportState({
    this.isLoading = false,
    this.error,
    this.exportedPaths = const [],
  });

  ExportState copyWith({
    bool? isLoading,
    String? error,
    List<String>? exportedPaths,
  }) {
    return ExportState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      exportedPaths: exportedPaths ?? this.exportedPaths,
    );
  }
}

class ExportCsvController extends StateNotifier<ExportState> {
  final ExportService _service;

  ExportCsvController(this._service) : super(const ExportState());

  Future<void> exportInvoices() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final path = await _service.exportInvoices();
      state = state.copyWith(isLoading: false, exportedPaths: [path]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> exportClients() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final path = await _service.exportClients();
      state = state.copyWith(isLoading: false, exportedPaths: [path]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> exportProducts() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final path = await _service.exportProducts();
      state = state.copyWith(isLoading: false, exportedPaths: [path]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> exportInvoiceItems() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final path = await _service.exportInvoiceItems();
      state = state.copyWith(isLoading: false, exportedPaths: [path]);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> exportAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final paths = await _service.exportAll();
      state = state.copyWith(isLoading: false, exportedPaths: paths);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
