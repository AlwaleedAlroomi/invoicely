import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invoicely/data/local/isar_service.dart';
import 'package:isar/isar.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/products/data/product_model.dart';

class XlsxExportService {
  final Isar _isar = IsarService.instance;

  // ── INVOICES ──────────────────────────────────
  Future<String> exportInvoices({String? directoryPath}) async {
    final invoices = await _isar.invoiceModels.where().findAll();
    for (final invoice in invoices) {
      await invoice.client.load();
    }

    final excel = Excel.createExcel();
    final sheet = excel['Invoices'];
    excel.delete('Sheet1'); // remove default sheet

    // header
    _addHeaderRow(sheet, [
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
    ]);

    // data
    for (final invoice in invoices) {
      sheet.appendRow([
        TextCellValue(invoice.invoiceNumber),
        TextCellValue(invoice.client.value?.name ?? 'Unknown'),
        TextCellValue(invoice.client.value?.email ?? ''),
        TextCellValue(_formatDate(invoice.issueDate)),
        TextCellValue(_formatDate(invoice.dueDate)),
        TextCellValue(invoice.status.name),
        DoubleCellValue(invoice.taxRate),
        DoubleCellValue(invoice.subTotal),
        DoubleCellValue(invoice.taxAmount),
        DoubleCellValue(invoice.totalAmount),
        TextCellValue(invoice.terms ?? ''),
        TextCellValue(invoice.notes ?? ''),
        TextCellValue(_formatDate(invoice.createdAt)),
      ]);
    }

    return _saveExcel(excel, 'invoices', directoryPath: directoryPath);
  }

  // ── INVOICE ITEMS ─────────────────────────────
  Future<String> exportInvoiceItems({String? directoryPath}) async {
    final invoices = await _isar.invoiceModels.where().findAll();

    final excel = Excel.createExcel();
    final sheet = excel['Invoice Items'];
    excel.delete('Sheet1');

    _addHeaderRow(sheet, [
      'Invoice Number',
      'Product Name',
      'Product ID',
      'Unit Price',
      'Quantity',
      'Total',
    ]);

    for (final invoice in invoices) {
      for (final item in invoice.items) {
        sheet.appendRow([
          TextCellValue(invoice.invoiceNumber),
          TextCellValue(item.productName),
          TextCellValue(item.productId),
          DoubleCellValue(item.unitPrice),
          IntCellValue(item.quantity),
          DoubleCellValue(item.total),
        ]);
      }
    }

    return _saveExcel(excel, 'invoice_items', directoryPath: directoryPath);
  }

  // ── CLIENTS ───────────────────────────────────
  Future<String> exportClients({String? directoryPath}) async {
    final clients = await _isar.clientModels.where().findAll();

    final excel = Excel.createExcel();
    final sheet = excel['Clients'];
    excel.delete('Sheet1');

    _addHeaderRow(sheet, [
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
    ]);

    for (final client in clients) {
      sheet.appendRow([
        TextCellValue(client.name),
        TextCellValue(client.email),
        TextCellValue(client.phone ?? ''),
        TextCellValue(client.website ?? ''),
        TextCellValue(client.addressLine1 ?? ''),
        TextCellValue(client.addressLine2 ?? ''),
        TextCellValue(client.city ?? ''),
        TextCellValue(client.state ?? ''),
        TextCellValue(client.zipCode ?? ''),
        TextCellValue(client.country ?? ''),
        TextCellValue(client.taxNumber ?? ''),
        TextCellValue(client.currency),
        TextCellValue(client.notes ?? ''),
        TextCellValue(client.isActive ? 'Yes' : 'No'),
        TextCellValue(_formatDate(client.createdAt)),
      ]);
    }

    return _saveExcel(excel, 'clients', directoryPath: directoryPath);
  }

  // ── PRODUCTS ──────────────────────────────────
  Future<String> exportProducts({String? directoryPath}) async {
    final products = await _isar.productModels.where().findAll();

    final excel = Excel.createExcel();
    final sheet = excel['Products'];
    excel.delete('Sheet1');

    _addHeaderRow(sheet, [
      'Name',
      'SKU',
      'Description',
      'Unit Price',
      'Stock Quantity',
      'Active',
      'Created At',
    ]);

    for (final product in products) {
      sheet.appendRow([
        TextCellValue(product.name),
        TextCellValue(product.sku ?? ''),
        TextCellValue(product.description ?? ''),
        DoubleCellValue(product.unitPrice),
        IntCellValue(product.stockQuantity),
        TextCellValue(product.isActive ? 'Yes' : 'No'),
        TextCellValue(_formatDate(product.createdAt!)),
      ]);
    }

    return _saveExcel(excel, 'products', directoryPath: directoryPath);
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
  void _addHeaderRow(Sheet sheet, List<String> headers) {
    final headerStyle = CellStyle(
      bold: true,
      backgroundColorHex: ExcelColor.fromHexString('#4F46E5'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
    );

    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());

    // apply style to header row
    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0),
      );
      cell.cellStyle = headerStyle;
    }
  }

  Future<String> _saveExcel(
    Excel excel,
    String name, {
    String? directoryPath,
  }) async {
    final selectedDir =
        directoryPath ??
        await FilePicker.getDirectoryPath(
          dialogTitle: 'Select Folder to Save File',
        );

    if (selectedDir == null) return 'Export cancelled';

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filePath = '$selectedDir/invoicely_${name}_$timestamp.xlsx';

    try {
      final bytes = excel.save();
      if (bytes == null) return 'Error: failed to generate file';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      return 'Error saving file: $e';
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
