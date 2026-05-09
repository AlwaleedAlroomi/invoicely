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

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'unitPrice': unitPrice,
        'quantity': quantity,
        'total': total,
      };

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      InvoiceItemModel.create(
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: json['quantity'] as int,
        total: (json['total'] as num).toDouble(),
      );
}
