import 'package:invoicely/features/clients/data/client_model.dart';
import 'package:invoicely/features/invoice/data/invoice_item_model.dart';
import 'package:invoicely/features/invoice/data/invoice_model.dart';
import 'package:invoicely/features/products/data/product_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar _isar;

  IsarService._();

  static Isar get instance => _isar;

  static Future<void> initialize() async {
    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance('invoicely_db')!;
      return;
    }

    try {
      final appDocsDir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          ProductModelSchema,
          ClientModelSchema,
          InvoiceModelSchema,
          // InvoiceItemModelSchema,
        ],
        directory: appDocsDir.path,
        name: 'invoicely_db',
        inspector: true,
      );
    } catch (e) {
      print('Isar initialization failed: $e');
      rethrow;
    }
  }
}
