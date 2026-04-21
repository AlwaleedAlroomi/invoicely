import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';

abstract class InvoiceRepository {
  // create
  Future<Result<InvoiceModel>> createInvoice(
    InvoiceModel invoice,
    ClientModel client,
  );
  Future<Result<String>> generateInvoiceNumber();
  // read
  Future<Result<InvoiceModel?>> getInvoiceByRemoteId(String remoteId);
  Future<Result<List<InvoiceModel>>> getAllInvoices();
  Future<Result<List<InvoiceModel>>> getInvoicesByClient(String clientRemoteId);
  Future<Result<List<InvoiceModel>>> getInvoicesByStatus(InvoiceStatus status);
  // update
  Future<Result<InvoiceModel>> updateInvoice(
    InvoiceModel invoice,
    InvoiceModel updated,
  );
  Future<Result<void>> updateInvoiceStatus(
    InvoiceModel invoice,
    InvoiceStatus status,
  );
  // delete
  Future<Result<void>> deleteInvoice(InvoiceModel invoice);
}
