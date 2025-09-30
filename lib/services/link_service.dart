import 'dart:async';

import '../app.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../models/entities/index.dart';
import '../routes/flux_navigate.dart';
import '../screens/index.dart';
import 'base_services.dart';
import 'service_config.dart';
import 'services.dart';

class LinkService {
  final BaseServices _serviceApi;

  LinkService(this._serviceApi);

  Future<String?> generateProductCategoryUrl(dynamic productCategoryId) async {
    final cate =
        await _serviceApi.getProductCategoryById(categoryId: productCategoryId);
    var url;
    if (cate != null) {
      if (ServerConfig().isShopify) {
        url = cate.onlineStoreUrl;
      } else {
        url = '${ServerConfig().url}/product-category/${cate.slug}';
      }
    }
    return url;
  }

  Future<String?> generateProductTagUrl(dynamic productTagId) async {
    final tag = await _serviceApi.getTagById(tagId: productTagId.toString());
    var url;
    if (tag != null) {
      url = '${ServerConfig().url}/product-tag/${tag.slug}';
    }
    return url;
  }

  Future<String?> generateProductBrandUrl(dynamic brandCategoryId) async {
    final brand = await _serviceApi.getBrandById(brandCategoryId);
    var url;
    if (brand != null) {
      url = '${ServerConfig().url}/brand/${brand.slug ?? ''}';
    }
    return url;
  }

  Future<void> handleWebLink(Uri uri) async {
    final context = App.fluxStoreNavigatorKey.currentContext!;
    context.navigator.popUntil((route) => route.isFirst);
    LoadingHelper.show();

    try {
      var initUri = uri;

      // If the link has query parameters, it will be parsed
      final queryParameters = initUri.queryParameters;

      if (queryParameters.containsKey('screen') ||
          queryParameters.containsKey('tab_number')) {
        return NavigateTools.onTapNavigateOptions(
          config: queryParameters,
          context: context,
        );
      }

      // _showLoading(context);

      final url = initUri.toString();
      final path = initUri.path;

      /// PRODUCT CASE
      if (path.contains('/product/') ||
          path.contains('/shop/') ||
          path.contains('/products/')) {
        /// Note: the deepLink URL will look like: https://mstore.io/product/stitch-detail-tunic-dress/
        final product = await Services().api.getProductByPermalink(path);
        if (product != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.productDetail,
            arguments: product,
            context: context,
          ));
        }

        /// PRODUCT CATEGORY CASE
      } else if (path.contains('/product-category/') ||
          path.contains('/collections/')) {
        final category =
            await Services().api.getProductCategoryByPermalink(path);
        if (category != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.backdrop,
            context: context,
            arguments: BackDropArguments(
              cateId: category.id,
              cateName: category.name,
            ),
          ));
        }

        /// PRODUCT TAGS CASE
      } else if (path.contains('/product-tag/')) {
        final slug = Uri.tryParse(path)?.pathSegments.last;

        if (slug == null) throw '';

        final tag = await Services().api.getTagBySlug(slug);
        if (tag != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.backdrop,
            arguments: BackDropArguments(
              tag: tag.id.toString(),
            ),
            context: context,
          ));
        }

        /// VENDOR CASE
      } else if (path.contains('/store/')) {
        final vendor = await Services().api.getStoreByPermalink(path);
        if (vendor != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.storeDetail,
            context: context,
            arguments: StoreDetailArgument(store: vendor),
          ));
        }
      } else if (path.contains('/brand/')) {
        final slug = Uri.tryParse(path)?.pathSegments.last;

        if (slug == null) throw '';

        final brand = await Services().api.getBrandBySlug(slug);
        if (brand != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.backdrop,
            context: context,
            arguments: BackDropArguments(
              brandId: brand.id,
              brandName: brand.name,
              brandImg: brand.image,
            ),
          ));
        }
      } else if (path.contains('/listing/')) {
        final listing = await _serviceApi.getBlogByPermalink(path);
        if (listing != null) {
          final product = await _serviceApi.getProduct(listing.id);
          if (product != null) {
            unawaited(FluxNavigate.pushNamed(
              RouteList.productDetail,
              context: context,
              arguments: product,
            ));
          }
        }
      } else {
        var blog = await Services().api.getBlogByPermalink(url);
        if (blog != null) {
          unawaited(FluxNavigate.pushNamed(
            RouteList.detailBlog,
            context: context,
            arguments: BlogDetailArguments(blog: blog),
          ));
        }
      }
    } catch (err) {
      // _showErrorMessage(context);
    } finally {
      LoadingHelper.hide();
    }
  }

//
// static void _showLoading(context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(S.of(context).loadingLink),
//       duration: const Duration(seconds: 3),
//       action: SnackBarAction(
//         label: 'DISMISS',
//         onPressed: () {
//           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         },
//       ),
//     ),
//   );
// }
//
// static void _showErrorMessage(context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(S.of(context).canNotLoadThisLink),
//       duration: const Duration(seconds: 2),
//       action: SnackBarAction(
//         label: 'DISMISS',
//         onPressed: () {
//           ScaffoldMessenger.of(context).hideCurrentSnackBar();
//         },
//       ),
//     ),
//   );
// }
}
