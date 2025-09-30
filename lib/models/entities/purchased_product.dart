import 'lite_order.dart';
import 'product.dart';

class PurchasedProduct {
  final Product data;
  final LiteOrder order;

  PurchasedProduct({
    required this.data,
    required this.order,
  });

  factory PurchasedProduct.fromJson(Map<String, dynamic> json) {
    return PurchasedProduct(
      data: Product.fromJson(json['product_data']),
      order: LiteOrder.fromJson(json['order']),
    );
  }

  String get id => data.id;

  String get orderId => order.id;
}
