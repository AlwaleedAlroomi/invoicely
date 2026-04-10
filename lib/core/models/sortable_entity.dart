abstract interface class SortableEntity {
  String get displayName;
  DateTime get dateCreated;
}

abstract interface class MarketableEntity extends SortableEntity {
  double get price;
  int get quantity;
}
