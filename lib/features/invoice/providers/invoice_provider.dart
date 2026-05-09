import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/providers.dart';
import 'package:invoicely/data/repositories/invoice_repository_impl.dart';
import 'package:invoicely/data/services/invoice_service.dart';
import 'package:invoicely/features/invoice/controller/invoice_controller.dart';
import 'package:invoicely/features/invoice/controller/invoice_form_controller.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return InvoiceService(db);
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final service = ref.watch(invoiceServiceProvider);
  return InvoiceRepositoryImpl(service);
});

final invoiceControllerProvider =
    StateNotifierProvider<InvoiceController, InvoiceListState>((ref) {
      final repository = ref.watch(invoiceRepositoryProvider);
      return InvoiceController(repository, ref);
    });

final invoiceSortTypeProvider =
    StateNotifierProvider<InvoiceSortTypeNotifier, SortType>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return InvoiceSortTypeNotifier(prefs);
    });

final invoiceFormControllerProvider =
    StateNotifierProvider<InvoiceFormController, InvoiceFormState>((ref) {
      final repository = ref.watch(invoiceRepositoryProvider);
      return InvoiceFormController(repository, ref);
    });

final clientInvoicesProvider =
    FutureProvider.family<List<InvoiceModel>, String>((
      ref,
      clientRemoteId,
    ) async {
      final result = await ref
          .read(invoiceRepositoryProvider)
          .getInvoicesByClient(clientRemoteId);
      switch (result) {
        case Success(:final data):
          return data;
        case Error(:final failure):
          throw failure.message;
      }
    });

final allInvoicesProvider = FutureProvider<List<InvoiceModel>>((ref) async {
  ref.watch(invoiceControllerProvider);
  final result = await ref.read(invoiceRepositoryProvider).getAllInvoices();
  switch (result) {
    case Success(:final data):
      return data;
    case Error(:final failure):
      throw failure.message;
  }
});

final productInvoicesProvider =
    FutureProvider.family<List<InvoiceModel>, String>((
      ref,
      prodRemoteId,
    ) async {
      final result = await ref
          .read(invoiceRepositoryProvider)
          .getInvoicesByProduct(prodRemoteId);
      switch (result) {
        case Success(:final data):
          return data;
        case Error(:final failure):
          throw failure.message;
      }
    });
