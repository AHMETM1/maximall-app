enum ProductCategoryMenuStyle {
  menu,
  tab,
  ;

  bool get isTab => this == tab;

  factory ProductCategoryMenuStyle.fromString(dynamic name) {
    return ProductCategoryMenuStyle.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ProductCategoryMenuStyle.menu,
    );
  }
}
