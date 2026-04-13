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
    int clientIsarId,
  ) async {
    try {
      final invoices = await _invoiceService.getInvoicesByClient(clientIsarId);
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
  Future<Result<InvoiceModel>> updateInvoice(InvoiceModel invoice) async {
    try {
      final result = await _invoiceService.updateInvoice(invoice);
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
    InvoiceStatus status,
  ) async {
    try {
      final foundInvoice = await _invoiceService.getInvoiceByRemoteId(
        invoice.remoteId!,
      );
      if (foundInvoice == null) {
        return Error(AppFailure.database('Invoice not found'));
      }
      final updated = invoice.copyWith(status: status);
      return await _invoiceService.updateInvoice(updated);
    } catch (e) {
      return Error(AppFailure('Unexpected error updating invoice status: $e'));
    }
  }
}
