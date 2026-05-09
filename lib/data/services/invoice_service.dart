import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/errors/failure.dart';
import 'package:invoicely/core/results/result.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/data/services/client_service.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';

class InvoiceService {
  final AppDatabase _db;
  InvoiceService(this._db);

  Future<String> generateInvoiceNumber() async {
    final count = await _db.select(_db.invoices).get();
    final number = (count.length + 1).toString().padLeft(4, '0');
    return 'INV-$number';
  }

  Future<Result<InvoiceModel>> createInvoice(
    InvoiceModel invoice,
    String clientRemoteId,
  ) async {
    try {
      final id = await _db
          .into(_db.invoices)
          .insert(
            InvoicesCompanion(
              remoteId: Value(invoice.remoteId!),
              clientRemoteId: Value(clientRemoteId),
              invoiceNumber: Value(invoice.invoiceNumber),
              issueDate: Value(invoice.issueDate),
              dueDate: Value(invoice.dueDate),
              taxRate: Value(invoice.taxRate),
              subTotal: Value(invoice.subTotal),
              taxAmount: Value(invoice.taxAmount),
              totalAmount: Value(invoice.totalAmount),
              status: Value(invoice.status),
              items: Value(invoice.items),
              notes: Value(invoice.notes),
              terms: Value(invoice.terms),
              isActive: const Value(true),
              createdAt: Value(invoice.createdAt),
              updatedAt: Value(invoice.updatedAt),
            ),
          );

      for (final item in invoice.items) {
        final product =
            await (_db.select(
                  _db.products,
                )..where((t) => t.id.equals(int.tryParse(item.productId) ?? 0)))
                .getSingleOrNull();

        if (product == null) continue;

        final newStock = product.stockQuantity - item.quantity;
        await (_db.update(
          _db.products,
        )..where((t) => t.id.equals(product.id))).write(
          ProductsCompanion(
            stockQuantity: Value(newStock),
            lastUpdated: Value(DateTime.now()),
          ),
        );
      }

      invoice.isarId = id;
      return Success(invoice);
    } catch (e) {
      return Error(
        AppFailure.database('An unexpected error occurred saving invoice: $e'),
      );
    }
  }

  Future<InvoiceModel?> getInvoiceByRemoteId(String remoteId) async {
    try {
      final row = await (_db.select(
        _db.invoices,
      )..where((t) => t.remoteId.equals(remoteId))).getSingleOrNull();
      if (row == null) return null;
      return _toModel(row);
    } catch (e) {
      debugPrint('Warning: Failed to find invoice by remoteId $remoteId: $e');
      return null;
    }
  }

  Future<List<InvoiceModel>> getInvoiceByClient(String clientRemoteId) async {
    final rows = await (_db.select(
      _db.invoices,
    )..where((t) => t.clientRemoteId.equals(clientRemoteId))).get();
    return Future.wait(rows.map((r) => _toModel(r)));
  }

  Future<List<InvoiceModel>> getInvoiceByProduct(String prodRemoteId) async {
    final all = await _db.select(_db.invoices).get();
    final matching = all.where((inv) {
      return (inv.items ?? []).any((item) => item.productId == prodRemoteId);
    }).toList();
    return Future.wait(matching.map((r) => _toModel(r)));
  }

  Future<Result<List<InvoiceModel>>> getAllInvoices() async {
    try {
      final rows = await _db.select(_db.invoices).get();
      final models = await Future.wait(rows.map((r) => _toModel(r)));
      return Success(models);
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred fetching invoices: $e',
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
      var query = _db.select(_db.invoices);
      switch (sortType) {
        case SortType.nameAsc:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.invoiceNumber)])
            ..limit(limit, offset: page * limit);
        case SortType.nameDesc:
          query = query
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.invoiceNumber,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.newest:
          query = query
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit, offset: page * limit);
        case SortType.oldest:
          query = query
            ..orderBy([(t) => OrderingTerm(expression: t.createdAt)])
            ..limit(limit, offset: page * limit);
        default:
          query = query
            ..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ])
            ..limit(limit, offset: page * limit);
      }
      final rows = await query.get();
      final models = await Future.wait(rows.map((r) => _toModel(r)));
      return Success(models);
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred fetching invoices: $e',
        ),
      );
    }
  }

  Future<List<InvoiceModel>> getInvoicesByStatus(InvoiceStatus status) async {
    final all = await _db.select(_db.invoices).get();
    final matching = all.where((r) => r.status == status).toList();
    return Future.wait(matching.map((r) => _toModel(r)));
  }

  Future<Result<InvoiceModel>> updateInvoice(
    InvoiceModel original,
    InvoiceModel updated,
  ) async {
    try {
      await (_db.update(
        _db.invoices,
      )..where((t) => t.remoteId.equals(updated.remoteId!))).write(
        InvoicesCompanion(
          invoiceNumber: Value(updated.invoiceNumber),
          issueDate: Value(updated.issueDate),
          dueDate: Value(updated.dueDate),
          taxRate: Value(updated.taxRate),
          subTotal: Value(updated.subTotal),
          taxAmount: Value(updated.taxAmount),
          totalAmount: Value(updated.totalAmount),
          status: Value(updated.status),
          items: Value(updated.items),
          notes: Value(updated.notes),
          terms: Value(updated.terms),
          updatedAt: Value(updated.updatedAt),
        ),
      );

      for (final item in updated.items) {
        final product =
            await (_db.select(
                  _db.products,
                )..where((t) => t.id.equals(int.tryParse(item.productId) ?? 0)))
                .getSingleOrNull();
        if (product == null) continue;

        final originalItem = original.items.firstWhere(
          (i) => i.productId == item.productId,
          orElse: () => InvoiceItemModel.create(
            productId: item.productId,
            productName: item.productName,
            unitPrice: item.unitPrice,
            quantity: 0,
            total: 0,
          ),
        );

        final delta = item.quantity - originalItem.quantity;
        final newStock = product.stockQuantity - delta;
        await (_db.update(
          _db.products,
        )..where((t) => t.id.equals(product.id))).write(
          ProductsCompanion(
            stockQuantity: Value(newStock),
            lastUpdated: Value(DateTime.now()),
          ),
        );
      }

      for (final originalItem in original.items) {
        final stillExists = updated.items.any(
          (i) => i.productId == originalItem.productId,
        );
        if (!stillExists) {
          final product =
              await (_db.select(_db.products)..where(
                    (t) =>
                        t.id.equals(int.tryParse(originalItem.productId) ?? 0),
                  ))
                  .getSingleOrNull();
          if (product == null) continue;
          final newStock = product.stockQuantity + originalItem.quantity;
          await (_db.update(
            _db.products,
          )..where((t) => t.id.equals(product.id))).write(
            ProductsCompanion(
              stockQuantity: Value(newStock),
              lastUpdated: Value(DateTime.now()),
            ),
          );
        }
      }

      return Success(updated);
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred updating invoice: $e',
        ),
      );
    }
  }

  Future<Result<void>> deleteInvoice(InvoiceModel invoice) async {
    try {
      await (_db.update(_db.invoices)
            ..where((t) => t.remoteId.equals(invoice.remoteId!)))
          .write(const InvoicesCompanion(isActive: Value(false)));
      return const Success(null);
    } catch (e) {
      return Error(
        AppFailure.database(
          'An unexpected error occurred deleting invoice: $e',
        ),
      );
    }
  }

  Future<InvoiceModel> _toModel(Invoice row) async {
    Client? clientRow;
    try {
      clientRow = await (_db.select(
        _db.clients,
      )..where((t) => t.remoteId.equals(row.clientRemoteId))).getSingleOrNull();
    } catch (_) {}

    return InvoiceModel(
      isarId: row.id,
      remoteId: row.remoteId,
      client: clientRow != null ? ClientService.fromRow(clientRow) : null,
      invoiceNumber: row.invoiceNumber,
      issueDate: row.issueDate,
      dueDate: row.dueDate,
      taxRate: row.taxRate,
      subTotal: row.subTotal,
      taxAmount: row.taxAmount,
      totalAmount: row.totalAmount,
      items: row.items ?? [],
      status: row.status ?? InvoiceStatus.draft,
      notes: row.notes,
      terms: row.terms,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isActive: row.isActive,
    );
  }
}
