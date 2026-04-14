import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/data/local/isar_invoice_service.dart';
import 'package:invoicely/data/repositories/invoice_repository_impl.dart';
import 'package:invoicely/features/invoice/controller/invoice_controller.dart';
import 'package:invoicely/features/invoice/controller/invoice_form_controller.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';
import 'package:invoicely/features/products/providers/product_providers.dart';

final isarInvoiceServiceProvider = Provider<IsarInvoiceService>((ref) {
  return IsarInvoiceService();
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  final isarService = ref.watch(isarInvoiceServiceProvider);
  return InvoiceRepositoryImpl(isarService);
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
      return InvoiceFormController(repository);
    });
