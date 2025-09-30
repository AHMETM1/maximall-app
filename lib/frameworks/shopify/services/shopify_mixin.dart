import '../../../services/service_config.dart';
import '../index.dart';
import 'shopify_service.dart';

mixin ShopifyMixin on ConfigMixin {
  @override
  void configShopify(appConfig) {
    final client = ShopifyService.getClient(
      accessToken: appConfig['accessToken'],
      domain: appConfig['url'],
      version: ShopifyService.apiVersion,
    );

    final shopifyService = ShopifyService(
      domain: appConfig['url'],
      blogDomain: appConfig['blog'],
      accessToken: appConfig['accessToken'],
      client: client,
    );
    api = shopifyService;
    widget = ShopifyWidget(shopifyService);
  }
}
