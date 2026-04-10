import 'package:invoicely/core/enum/sort_type.dart';
import 'package:invoicely/core/models/sortable_entity.dart';

import '../../features/products/data/product_model.dart';

extension SortTypeExtension on SortType {
  List<T> sort<T extends SortableEntity>(List<T> list) {
    final items = List<T>.from(list);

    items.sort((a, b) {
      switch (this) {
        case SortType.nameAsc:
          return a.displayName.toLowerCase().compareTo(
            b.displayName.toLowerCase(),
          );
        case SortType.nameDesc:
          return b.displayName.toLowerCase().compareTo(
            a.displayName.toLowerCase(),
          );
        case SortType.newest:
          return b.dateCreated.compareTo(a.dateCreated);
        case SortType.oldest:
          return a.dateCreated.compareTo(b.dateCreated);

        // Specialized sorting
        case SortType.priceAsc:
        case SortType.priceDesc:
        case SortType.quantityAsc:
        case SortType.quantityDesc:
          if (a is MarketableEntity && b is MarketableEntity) {
            if (this == SortType.priceAsc) return a.price.compareTo(b.price);
            if (this == SortType.priceDesc) return b.price.compareTo(a.price);
            if (this == SortType.quantityAsc) {
              return a.quantity.compareTo(b.quantity);
            }
            if (this == SortType.quantityDesc) {
              return b.quantity.compareTo(a.quantity);
            }
          }
          return 0; // Fallback if model doesn
      }
    });

    return items;
  }

  static List<SortType> getOptionsFor(Type modelType) {
    final common = [
      SortType.nameAsc,
      SortType.nameDesc,
      SortType.newest,
      SortType.oldest,
    ];

    if (modelType == ProductModel) {
      return [
        ...common,
        SortType.priceAsc,
        SortType.priceDesc,
        SortType.quantityAsc,
        SortType.quantityDesc,
      ];
    }

    // For Clients or Invoices, just return the common ones
    return common;
  }

  String get label {
    switch (this) {
      case SortType.nameAsc:
        return 'Name (A–Z)';
      case SortType.nameDesc:
        return 'Name (Z–A)';
      case SortType.priceAsc:
        return 'Price (Low → High)';
      case SortType.priceDesc:
        return 'Price (High → Low)';
      case SortType.quantityAsc:
        return 'Quantity (Low → High)';
      case SortType.quantityDesc:
        return 'Quantity (High → Low)';
      case SortType.newest:
        return 'Newest';
      case SortType.oldest:
        return 'Oldest';
    }
  }
}
