class ShopifyCustomerAccountConfig {
  final bool enabled;
  final String clientId;
  final String shopId;

  const ShopifyCustomerAccountConfig({
    required this.enabled,
    required this.clientId,
    required this.shopId,
  });

  factory ShopifyCustomerAccountConfig.fromJson(Map<dynamic, dynamic> json) {
    return ShopifyCustomerAccountConfig(
      enabled: json['enabled'] ?? false,
      clientId: json['clientId'] ?? '',
      shopId: json['shopId'] ?? '',
    );
  }

  String get authorizationEndpoint =>
      'https://shopify.com/authentication/$shopId/oauth/authorize';

  String get tokenEndpoint =>
      'https://shopify.com/authentication/$shopId/oauth/token';

  String get logoutEndpoint =>
      'https://shopify.com/authentication/$shopId/logout';

  String get redirectUri => 'shop.$shopId.app://callback';

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'clientId': clientId,
      'shopId': shopId,
    };
  }
}
