import 'package:flutter/material.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:isar/isar.dart';

class IsarInvoiceService {
  final Isar _isar;
  IsarInvoiceService([Isar? isar]) : _isar = isar ?? IsarService.instance;

  @override
  Future<String> generateInvoiceNumber() async {
    final count = await _isar.invoiceModels.count();
    final number = (count + 1).toString().padLeft(4, '0');
    return 'INV-$number';
  }

  // create
  Future<Result<InvoiceModel>> createInvoice(
    InvoiceModel invoice,
    ClientModel client,
  ) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.invoiceModels.put(invoice);
        invoice.client.value = client;
        await invoice.client.save();
      });
      return Success(invoice);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error saving invoice: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure.database('An unexpected error occurred saving invoice: $e'),
      );
    }
  }

  // read
  Future<InvoiceModel?> getInvoiceByRemoteId(String remoteId) async {
    try {
      return await _isar.invoiceModels
          .filter()
          .remoteIdEqualTo(remoteId)
          .findFirst();
    } catch (e) {
      debugPrint('Warning: Failed to find product by remoteId $remoteId: $e');
      return null;
    }
  }

  Future<Result<List<InvoiceModel>>> getAllInvoices() async {
    try {
      final invoices = await _isar.invoiceModels.where().findAll();
      return Success(invoices);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error fetching invoices: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred fetching products: $e',
        ),
      );
    }
  }

  Future<List<InvoiceModel>> getInvoicesByClient(int clientIsarId) async {
    try {
      final foundClient = await _isar.clientModels.get(clientIsarId);
      if (foundClient == null) return [];
      return await foundClient.invoices.filter().findAll();
    } catch (e) {
      debugPrint('Warning: Failed to find invoice for this client: $e');
      return [];
    }
  }

  Future<List<InvoiceModel>> getInvoicesByStatus(InvoiceStatus status) async {
    final invoices = await _isar.invoiceModels
        .where()
        .filter()
        .statusEqualTo(status)
        .findAll();
    for (final invoice in invoices) {
      await invoice.client.load();
    }
    return invoices;
  }

  // update
  Future<Result<InvoiceModel>> updateInvoice(
    InvoiceModel original,
    InvoiceModel updated,
  ) async {
    try {
      updated.client.value = original.client.value;
      await _isar.writeTxn(() async {
        await _isar.invoiceModels.put(updated);
      });
      return Success(updated);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar error updating invoice: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred updating invoice: $e',
        ),
      );
    }
  }

  // delete
  Future<Result<void>> deleteInvoice(InvoiceModel invoice) async {
    try {
      await _isar.writeTxn(() async {
        invoice.copyWith(isActive: false);
        await _isar.invoiceModels.put(invoice);
      });
      return Success(null);
    } on IsarError catch (e) {
      return Error(
        AppFailure.database('Isar Error deleting invoice: ${e.message}'),
      );
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred deleting invoice: $e',
        ),
      );
    }
  }
}
