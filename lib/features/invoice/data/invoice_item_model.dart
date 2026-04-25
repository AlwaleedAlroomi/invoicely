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

  String getIndex(int index) {
    switch (index) {
      case 0:
        return productId;
      case 1:
        return productName;
      case 2:
        return unitPrice.toString();
      case 3:
        return quantity.toString();
      case 4:
        return total.toString();
    }
    return '';
  }
}
