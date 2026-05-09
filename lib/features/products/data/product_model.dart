import 'package:invoicely/core/models/sortable_entity.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ProductModel implements MarketableEntity {
  int? isarId;
  String? remoteId;
  String name;
  String? description;
  double unitPrice;
  String? imagePath;
  int stockQuantity;
  final String? sku;
  bool isActive;
  DateTime? lastUpdated;
  DateTime? createdAt;

  ProductModel({
    this.isarId,
    String? remoteId,
    required this.name,
    this.description,
    required this.unitPrice,
    this.imagePath,
    this.stockQuantity = 0,
    this.sku,
    this.isActive = true,
    DateTime? lastUpdated,
    DateTime? createdAt,
  })  : remoteId = remoteId ?? uuid.v4(),
        lastUpdated = lastUpdated ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  ProductModel copyWith({
    String? remoteId,
    String? name,
    String? description,
    double? unitPrice,
    String? imagePath,
    int? stockQuantity,
    String? sku,
    bool? isActive,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) {
    return ProductModel(
      isarId: isarId,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      description: description ?? this.description,
      unitPrice: unitPrice ?? this.unitPrice,
      imagePath: imagePath ?? this.imagePath,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  DateTime get dateCreated => createdAt!;

  @override
  String get displayName => name;

  @override
  double get price => unitPrice;

  @override
  int get quantity => stockQuantity;
}
