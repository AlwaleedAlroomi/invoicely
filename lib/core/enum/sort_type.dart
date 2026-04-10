enum SortType {
  nameAsc,
  nameDesc,
  priceAsc,
  priceDesc,
  quantityAsc,
  quantityDesc,
  newest,
  oldest,
}

extension SortTypePrefs on SortType {
  String get key => name;

  static SortType fromKey(String? value) {
    return SortType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SortType.newest,
    );
  }
}
