import 'package:flutter/material.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/products/data/product_model.dart';
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

        // update stock quantity for each item
        for (final item in invoice.items) {
          final product = await _isar.productModels
              .filter()
              .isarIdEqualTo(int.tryParse(item.productId))
              .findFirst();

          if (product == null) continue;

          product.stockQuantity = product.stockQuantity - item.quantity;
          await _isar.productModels.put(product);
        }
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

  Future<List<InvoiceModel>> getInvoiceByClient(String clientRemoteId) async {
    final invoices = await _isar.invoiceModels
        .where()
        .filter()
        .client((q) => q.remoteIdEqualTo(clientRemoteId))
        .findAll();
    for (final invoice in invoices) {
      await invoice.client.load();
    }
    return invoices;
  }

  Future<List<InvoiceModel>> getInvoiceByProduct(String prodRemoteId) async {
    final invoices = await _isar.invoiceModels
        .where()
        .filter()
        .itemsElement((q) => q.productIdEqualTo(prodRemoteId))
        .findAll();
    for (final invoice in invoices) {
      await invoice.client.load();
    }
    return invoices;
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

  Future<Result<List<InvoiceModel>>> getInvoicesPaginated(
    int page,
    int limit,
    SortType sortType,
  ) async {
    try {
      final List<InvoiceModel> invoices;
      switch (sortType) {
        case SortType.nameAsc:
          invoices = await _isar.invoiceModels
              .where()
              .sortByDisplayName()
              .offset(page * limit)
              .limit(limit)
              .findAll();
          break;
        case SortType.nameDesc:
          invoices = await _isar.invoiceModels
              .where()
              .sortByDisplayNameDesc()
              .offset(page * limit)
              .limit(limit)
              .findAll();
          break;
        case SortType.newest:
          invoices = await _isar.invoiceModels
              .where()
              .sortByCreatedAtDesc()
              .offset(page * limit)
              .limit(limit)
              .findAll();
          break;
        case SortType.oldest:
          invoices = await _isar.invoiceModels
              .where()
              .sortByCreatedAt()
              .offset(page * limit)
              .limit(limit)
              .findAll();
          break;
        default:
          // fallback — newest first
          invoices = await _isar.invoiceModels
              .where()
              .sortByCreatedAtDesc()
              .offset(page * limit)
              .limit(limit)
              .findAll();
          break;
      }
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
      // updated.client.value = original.client.value;
      await _isar.writeTxn(() async {
        await _isar.invoiceModels.put(updated);
        await updated.client.save();

        // update items with delta calc
        for (final item in updated.items) {
          final product = await _isar.productModels
              .filter()
              .isarIdEqualTo(int.parse(item.productId))
              .findFirst();

          if (product == null) continue;
          final originalItem = original.items.firstWhere(
            (i) => i.productId == item.productId,
            orElse: () => InvoiceItemModel.create(
              productId: item.productId,
              productName: item.productName,
              unitPrice: item.unitPrice,
              quantity: 0, // was not in original
              total: 0,
            ),
          );

          // positive delta = deduct more, negative = return stock
          final delta = item.quantity - originalItem.quantity;
          product.stockQuantity = product.stockQuantity - delta;
          await _isar.productModels.put(product);
        }

        // handle removed items from the list — return their stock
        for (final originalItem in original.items) {
          final stillExists = updated.items.any(
            (i) => i.productId == originalItem.productId,
          );

          if (!stillExists) {
            final product = await _isar.productModels
                .filter()
                .isarIdEqualTo(int.parse(originalItem.productId))
                .findFirst();

            if (product == null) continue;
            product.stockQuantity =
                product.stockQuantity + originalItem.quantity;
            await _isar.productModels.put(product);
          }
        }
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
