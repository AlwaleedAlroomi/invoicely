import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_invoice_service.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/invoice/repository/invoice_repository.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  final IsarInvoiceService _invoiceService;
  const InvoiceRepositoryImpl(this._invoiceService);

  @override
  Future<Result<String>> generateInvoiceNumber() async {
    try {
      final number = await _invoiceService.generateInvoiceNumber();
      return Success(number);
    } catch (e) {
      return Error(AppFailure(e.toString()));
    }
  }

  @override
  Future<Result<InvoiceModel>> createInvoice(
    InvoiceModel invoice,
    ClientModel client,
  ) async {
    try {
      final result = await _invoiceService.createInvoice(invoice, client);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error creating invoice: $e'));
    }
  }

  @override
  Future<Result<void>> deleteInvoice(InvoiceModel invoice) async {
    final invoiceToDelete = await _invoiceService.getInvoiceByRemoteId(
      invoice.remoteId!,
    );
    if (invoiceToDelete == null) {
      return Error(
        AppFailure.database(
          'Product with remoteId ${invoice.remoteId} not found in local DB.',
        ),
      );
    }
    return await _invoiceService.deleteInvoice(invoice);
  }

  @override
  Future<Result<List<InvoiceModel>>> getAllInvoices() async {
    return await _invoiceService.getAllInvoices();
  }

  @override
  Future<Result<InvoiceModel?>> getInvoiceByRemoteId(String remoteId) async {
    try {
      final invoice = await _invoiceService.getInvoiceByRemoteId(remoteId);
      if (invoice == null) {
        return Error(
          AppFailure.database("invoice not found with remote ID: $remoteId"),
        );
      }
      return Success(invoice);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching invoice: $e'));
    }
  }

  @override
  Future<Result<List<InvoiceModel>>> getInvoicesByClient(
    String clientRemoteId,
  ) async {
    try {
      final invoices = await _invoiceService.getInvoiceByClient(clientRemoteId);
      if (invoices.isEmpty) {
        return Success([]);
      }
      return Success(invoices);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching invoices: $e'));
    }
  }

  @override
  Future<Result<List<InvoiceModel>>> getInvoicesByProduct(
    String prodRemoteId,
  ) async {
    try {
      final invoices = await _invoiceService.getInvoiceByProduct(prodRemoteId);
      if (invoices.isEmpty) {
        return Success([]);
      }
      return Success(invoices);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching invoices: $e'));
    }
  }

  @override
  Future<Result<List<InvoiceModel>>> getInvoicesByStatus(
    InvoiceStatus status,
  ) async {
    try {
      final invoices = await _invoiceService.getInvoicesByStatus(status);
      if (invoices.isEmpty) {
        return Success([]);
      }
      return Success(invoices);
    } catch (e) {
      return Error(AppFailure('Unexpected error fetching invoices: $e'));
    }
  }

  @override
  Future<Result<InvoiceModel>> updateInvoice(
    InvoiceModel original,
    InvoiceModel updated,
  ) async {
    try {
      final result = await _invoiceService.updateInvoice(original, updated);
      switch (result) {
        case Success():
          return Success(result.data);
        case Error<void> e:
          return Error(e.failure);
      }
    } catch (e) {
      return Error(AppFailure('Unexpected error updating invoice: $e'));
    }
  }

  @override
  Future<Result<void>> updateInvoiceStatus(
    InvoiceModel invoice,
    InvoiceStatus newStatus,
  ) async {
    try {
      final foundInvoice = await _invoiceService.getInvoiceByRemoteId(
        invoice.remoteId!,
      );
      if (foundInvoice == null) {
        return Error(AppFailure.database('Invoice not found'));
      }
      final updated = invoice.copyWith(status: newStatus);
      return await _invoiceService.updateInvoice(invoice, updated);
    } catch (e) {
      return Error(AppFailure('Unexpected error updating invoice status: $e'));
    }
  }
}
