import '../../../models/entities/wishlist_type.dart';

class WishListConfig {
  final WishListType type;

  /// only suppport wishlist type "normal"
  final bool showCartButton;

  WishListConfig({
    this.type = WishListType.normal,
    this.showCartButton = true,
  });

  factory WishListConfig.fromJson(Map json) {
    return WishListConfig(
      type: WishListType.fromString(json['type']),
      showCartButton: bool.tryParse(json['showCartButton'].toString()) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['type'] = type.name;
    data['showCartButton'] = showCartButton;
    return data;
  }
}
