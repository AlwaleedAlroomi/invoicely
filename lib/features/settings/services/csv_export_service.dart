import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invoicely/core/enum/invoice_status.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/data/services/client_service.dart';
import 'package:invoicely/data/services/product_service.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';

class ExportService {
  final AppDatabase _db;
  ExportService(this._db);

  Future<List<InvoiceModel>> _getAllInvoicesWithClients() async {
    final rows = await _db.select(_db.invoices).get();
    final models = <InvoiceModel>[];
    for (final row in rows) {
      Client? clientRow;
      try {
        clientRow = await (_db.select(_db.clients)
              ..where((t) => t.remoteId.equals(row.clientRemoteId)))
            .getSingleOrNull();
      } catch (_) {}
      models.add(InvoiceModel(
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
      ));
    }
    return models;
  }

  // ── INVOICES ──────────────────────────────────
  Future<String> exportInvoices({String? directoryPath}) async {
    final invoices = await _getAllInvoicesWithClients();

    final rows = <List<dynamic>>[
      [
        'Invoice Number',
        'Client Name',
        'Client Email',
        'Issue Date',
        'Due Date',
        'Status',
        'Tax Rate (%)',
        'Subtotal',
        'Tax Amount',
        'Total Amount',
        'Terms',
        'Notes',
        'Created At',
      ],
      ...invoices.map(
        (invoice) => [
          invoice.invoiceNumber,
          invoice.client?.name ?? 'Unknown',
          invoice.client?.email ?? '',
          _formatDate(invoice.issueDate),
          _formatDate(invoice.dueDate),
          invoice.status.name,
          invoice.taxRate.toStringAsFixed(2),
          invoice.subTotal.toStringAsFixed(2),
          invoice.taxAmount.toStringAsFixed(2),
          invoice.totalAmount.toStringAsFixed(2),
          invoice.terms ?? '',
          invoice.notes ?? '',
          _formatDate(invoice.createdAt),
        ],
      ),
    ];

    return _saveCsv(rows, 'invoices', directoryPath: directoryPath);
  }

  // ── INVOICE ITEMS ─────────────────────────────
  Future<String> exportInvoiceItems({String? directoryPath}) async {
    final invoices = await _getAllInvoicesWithClients();

    final rows = <List<dynamic>>[
      [
        'Invoice Number',
        'Product Name',
        'Product ID',
        'Unit Price',
        'Quantity',
        'Total',
      ],
      ...invoices.expand(
        (invoice) => invoice.items.map(
          (item) => [
            invoice.invoiceNumber,
            item.productName,
            item.productId,
            item.unitPrice.toStringAsFixed(2),
            item.quantity,
            item.total.toStringAsFixed(2),
          ],
        ),
      ),
    ];

    return _saveCsv(rows, 'invoice_items', directoryPath: directoryPath);
  }

  // ── CLIENTS ───────────────────────────────────
  Future<String> exportClients({String? directoryPath}) async {
    final rows = await _db.select(_db.clients).get();
    final clients = rows.map((r) => ClientService.fromRow(r)).toList();

    final csvRows = <List<dynamic>>[
      [
        'Name',
        'Email',
        'Phone',
        'Website',
        'Address Line 1',
        'Address Line 2',
        'City',
        'State',
        'ZIP Code',
        'Country',
        'Tax Number',
        'Currency',
        'Notes',
        'Active',
        'Created At',
      ],
      ...clients.map(
        (client) => [
          client.name,
          client.email,
          client.phone ?? '',
          client.website ?? '',
          client.addressLine1 ?? '',
          client.addressLine2 ?? '',
          client.city ?? '',
          client.state ?? '',
          client.zipCode ?? '',
          client.country ?? '',
          client.taxNumber ?? '',
          client.currency,
          client.notes ?? '',
          client.isActive ? 'Yes' : 'No',
          _formatDate(client.createdAt),
        ],
      ),
    ];

    return _saveCsv(csvRows, 'clients', directoryPath: directoryPath);
  }

  // ── PRODUCTS ──────────────────────────────────
  Future<String> exportProducts({String? directoryPath}) async {
    final rows = await _db.select(_db.products).get();
    final products = rows.map((r) => ProductService.fromRow(r)).toList();

    final csvRows = <List<dynamic>>[
      [
        'Name',
        'SKU',
        'Description',
        'Unit Price',
        'Stock Quantity',
        'Unit',
        'Active',
        'Created At',
      ],
      ...products.map(
        (product) => [
          product.name,
          product.sku ?? '',
          product.description ?? '',
          product.unitPrice.toStringAsFixed(2),
          product.stockQuantity,
          product.isActive ? 'Yes' : 'No',
          _formatDate(product.createdAt!),
        ],
      ),
    ];

    return _saveCsv(csvRows, 'products', directoryPath: directoryPath);
  }

  // ── EXPORT ALL ────────────────────────────────
  Future<List<String>> exportAll() async {
    final String? selectedDir = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select Folder for All Exports',
    );

    if (selectedDir == null) return ['Export cancelled'];

    return await Future.wait([
      exportInvoices(directoryPath: selectedDir),
      exportInvoiceItems(directoryPath: selectedDir),
      exportClients(directoryPath: selectedDir),
      exportProducts(directoryPath: selectedDir),
    ]);
  }

  // ── HELPERS ───────────────────────────────────
  Future<String> _saveCsv(
    List<List<dynamic>> rows,
    String name, {
    String? directoryPath,
  }) async {
    final csv = Csv().encode(rows);
    final selectedDir =
        directoryPath ??
        await FilePicker.getDirectoryPath(
          dialogTitle: 'Select Folder to Save CSV',
        );

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '$selectedDir/invoicely_${name}_$timestamp.csv';

    try {
      final file = File(filePath);
      await file.writeAsString(csv);
      return filePath;
    } catch (e) {
      return 'Error saving CSV: $e';
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
