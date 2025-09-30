enum WishListType {
  normal,
  staggered;

  factory WishListType.fromString(String? type) {
    try {
      return WishListType.values.byName('$type');
    } catch (e) {
      return WishListType.normal;
    }
  }

  bool get isStaggered => this == WishListType.staggered;

  bool get isNormal => this == WishListType.normal;
}
