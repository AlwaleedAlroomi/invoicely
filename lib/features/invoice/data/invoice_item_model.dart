import 'package:isar/isar.dart';
part 'invoice_item_model.g.dart';

@Embedded()
class InvoiceItemModel {
  late String productId;
  late String productName;
  late double unitPrice;
  late int quantity;
  late double total;

  InvoiceItemModel();

  InvoiceItemModel.create({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.total,
  });
}
