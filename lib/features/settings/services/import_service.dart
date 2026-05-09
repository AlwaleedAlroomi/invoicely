import 'dart:io';
import 'package:drift/drift.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:invoicely/data/database/database.dart';
import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/products/data/product_model.dart';

class ImportResult {
  final int added;
  final int skipped;
  final int failed;
  final List<String> errors;

  const ImportResult({
    this.added = 0,
    this.skipped = 0,
    this.failed = 0,
    this.errors = const [],
  });

  String get summary => '$added added · $skipped skipped · $failed failed';
}

class XlsxImportService {
  final AppDatabase _db;
  XlsxImportService(this._db);

  // ── PICK FILE ─────────────────────────────────
  Future<String?> pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      dialogTitle: 'Select Excel file to import',
    );
    return result?.files.single.path;
  }

  // ── IMPORT CLIENTS ────────────────────────────
  Future<ImportResult> importClients() async {
    final path = await pickFile();
    if (path == null) return const ImportResult();

    int added = 0;
    int skipped = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final bytes = File(path).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel['Clients'];

      final rows = sheet.rows.skip(1).toList();

      for (int i = 0; i < rows.length; i++) {
        try {
          final row = rows[i];

          if (row.isEmpty || _cellValue(row, 0).isEmpty) {
            skipped++;
            continue;
          }

          final name = _cellValue(row, 0);
          final email = _cellValue(row, 1);

          final existing = await (_db.select(
            _db.clients,
          )..where((t) => t.email.equals(email))).getSingleOrNull();

          if (existing != null) {
            skipped++;
            continue;
          }

          final client = ClientModel(
            name: name,
            email: email,
            phone: _cellValueOrNull(row, 2),
            website: _cellValueOrNull(row, 3),
            addressLine1: _cellValueOrNull(row, 4),
            addressLine2: _cellValueOrNull(row, 5),
            city: _cellValueOrNull(row, 6),
            state: _cellValueOrNull(row, 7),
            zipCode: _cellValueOrNull(row, 8),
            country: _cellValueOrNull(row, 9),
            taxNumber: _cellValueOrNull(row, 10),
            currency: _cellValue(row, 11).isEmpty ? 'USD' : _cellValue(row, 11),
            notes: _cellValueOrNull(row, 12),
            isActive: _cellBool(row, 13),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          await _db
              .into(_db.clients)
              .insert(
                ClientsCompanion(
                  remoteId: Value(client.remoteId!),
                  name: Value(client.name),
                  email: Value(client.email),
                  phone: Value(client.phone),
                  website: Value(client.website),
                  addressLine1: Value(client.addressLine1),
                  addressLine2: Value(client.addressLine2),
                  city: Value(client.city),
                  state: Value(client.state),
                  zipCode: Value(client.zipCode),
                  country: Value(client.country),
                  taxNumber: Value(client.taxNumber),
                  currency: Value(client.currency),
                  notes: Value(client.notes),
                  isActive: Value(client.isActive),
                  createdAt: Value(client.createdAt),
                  updatedAt: Value(client.updatedAt),
                ),
              );

          added++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 2}: $e');
        }
      }
    } catch (e) {
      errors.add('Failed to read file: $e');
    }

    return ImportResult(
      added: added,
      skipped: skipped,
      failed: failed,
      errors: errors,
    );
  }

  // ── IMPORT PRODUCTS ───────────────────────────
  Future<ImportResult> importProducts() async {
    final path = await pickFile();
    if (path == null) return const ImportResult();

    int added = 0;
    int skipped = 0;
    int failed = 0;
    final errors = <String>[];

    try {
      final bytes = File(path).readAsBytesSync();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel['Products'];

      final rows = sheet.rows.skip(1).toList();

      for (int i = 0; i < rows.length; i++) {
        try {
          final row = rows[i];

          if (row.isEmpty || _cellValue(row, 0).isEmpty) {
            skipped++;
            continue;
          }

          final name = _cellValue(row, 0);
          final sku = _cellValueOrNull(row, 1);

          if (sku != null) {
            final existing = await (_db.select(
              _db.products,
            )..where((t) => t.sku.equals(sku))).getSingleOrNull();

            if (existing != null) {
              skipped++;
              continue;
            }
          }

          final product = ProductModel(
            name: name,
            sku: sku,
            description: _cellValueOrNull(row, 2),
            unitPrice: double.tryParse(_cellValue(row, 3)) ?? 0.0,
            stockQuantity: int.tryParse(_cellValue(row, 4)) ?? 0,
            isActive: _cellBool(row, 5),
            createdAt: DateTime.now(),
            lastUpdated: DateTime.now(),
          );

          await _db
              .into(_db.products)
              .insert(
                ProductsCompanion(
                  remoteId: Value(product.remoteId!),
                  name: Value(product.name),
                  description: Value(product.description),
                  unitPrice: Value(product.unitPrice),
                  imagePath: const Value(null),
                  stockQuantity: Value(product.stockQuantity),
                  sku: Value(product.sku),
                  isActive: Value(product.isActive),
                  createdAt: Value(product.createdAt),
                  lastUpdated: Value(product.lastUpdated),
                ),
              );

          added++;
        } catch (e) {
          failed++;
          errors.add('Row ${i + 2}: $e');
        }
      }
    } catch (e) {
      errors.add('Failed to read file: $e');
    }

    return ImportResult(
      added: added,
      skipped: skipped,
      failed: failed,
      errors: errors,
    );
  }

  // ── HELPERS ───────────────────────────────────
  String _cellValue(List<Data?> row, int index) {
    if (index >= row.length) return '';
    final cell = row[index];
    if (cell == null) return '';
    return cell.value?.toString().trim() ?? '';
  }

  String? _cellValueOrNull(List<Data?> row, int index) {
    final value = _cellValue(row, index);
    return value.isEmpty ? null : value;
  }

  bool _cellBool(List<Data?> row, int index) {
    final value = _cellValue(row, index).toLowerCase();
    switch (value) {
      case 'yes':
      case 'true':
      case '1':
        return true;
      case 'no':
      case 'false':
      case '0':
        return false;
      default:
        return true;
    }
  }
}
