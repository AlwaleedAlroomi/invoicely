import 'package:invoicely/core/models/sortable_entity.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'product_model.g.dart';

const uuid = Uuid();

@collection
class ProductModel implements MarketableEntity {
  Id? isarId = Isar.autoIncrement;
  @Index(unique: true)
  String? remoteId;
  String name;
  String? description;
  double unitPrice;
  String? imagePath;
  int stockQuantity;
  @Index(unique: true, replace: false)
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
  }) : remoteId = remoteId ?? uuid.v4(),
       lastUpdated = lastUpdated ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now();

  ProductModel copyWith({
    Id? isarId,
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
      isarId: isarId ?? this.isarId,
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
  // TODO: implement dateCreated
  DateTime get dateCreated => createdAt!;

  @override
  // TODO: implement displayName
  String get displayName => name;

  @override
  // TODO: implement price
  double get price => unitPrice;

  @override
  // TODO: implement quantity
  int get quantity => stockQuantity;
}
