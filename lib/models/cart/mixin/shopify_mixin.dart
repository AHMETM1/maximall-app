import '../../entities/shopify/cart_data_shopify.dart';
import 'cart_mixin.dart';

mixin ShopifyMixin on CartMixin {
  CartDataShopify? _cartDataShopify;

  // ShopifyCustomerAccountService? _customerAccountService;

  Map<dynamic, dynamic> get checkoutCreatedInCart => {};

  CartDataShopify? get cartDataShopify => _cartDataShopify;

  double? getTax() {
    return _cartDataShopify?.cost.totalTaxAmount?.amount;
  }

  void setCartDataShopify(CartDataShopify? cartData) {
    _cartDataShopify = cartData;
  }

  @override
  String getCartId() {
    return cartDataShopify?.id ?? '';
  }
}
