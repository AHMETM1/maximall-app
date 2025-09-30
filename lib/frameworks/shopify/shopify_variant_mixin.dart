import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/index.dart'
    show Product, ProductAttribute, ProductModel, ProductVariation;
import '../../services/index.dart';
import '../../widgets/product/product_variant/product_variant_widget.dart';
import '../product_variant_mixin.dart';

const _defaultTitle = 'Title';

mixin ShopifyVariantMixin on ProductVariantMixin {
  @override
  Future<void> getProductVariations({
    BuildContext? context,
    Product? product,
    void Function({
      Product? productInfo,
      List<ProductVariation>? variations,
      Map<String?, String?> mapAttribute,
      ProductVariation? variation,
    })? onLoad,
  }) async {
    if (product!.attributes!.isEmpty) {
      return;
    }

    Map<String?, String?> mapAttribute = HashMap();
    List<ProductVariation>? variations = <ProductVariation>[];
    Product? productInfo;

    variations = await Services().api.getProductVariations(product);

    if (variations!.isEmpty) {
      for (var attr in product.attributes!) {
        mapAttribute.update(attr.name, (value) => attr.options![0],
            ifAbsent: () => attr.options![0]);
      }
    } else {
      for (var variant in variations) {
        if (variant.price == product.price) {
          for (var attribute in variant.attributes) {
            for (var attr in product.attributes!) {
              mapAttribute.update(attr.name, (value) => attr.options![0],
                  ifAbsent: () => attr.options![0]);
            }
            mapAttribute.update(attribute.name, (value) => attribute.option,
                ifAbsent: () => attribute.option);
          }
          break;
        }
        if (mapAttribute.isEmpty) {
          for (var attribute in product.attributes!) {
            mapAttribute.update(attribute.name, (value) => value, ifAbsent: () {
              return attribute.options![0]['value'];
            });
          }
        }
      }
    }

    final productVariation = updateVariation(variations, mapAttribute);
    context?.read<ProductModel>().changeProductVariations(variations);
    if (productVariation != null) {
      context?.read<ProductModel>().changeSelectedVariation(productVariation);
    }

    onLoad!(
      productInfo: productInfo,
      variations: variations,
      mapAttribute: mapAttribute,
      variation: productVariation,
    );

    return;
  }

  bool couldBePurchased(
    List<ProductVariation>? variations,
    ProductVariation? productVariation,
    Product product,
    Map<String?, String?>? mapAttribute,
  ) {
    return true;
  }

  @override
  List<Widget> getBuyButtonWidget({
    required BuildContext context,
    ProductVariation? productVariation,
    required Product product,
    Map<String?, String?>? mapAttribute,
    required int maxQuantity,
    required int quantity,
    required Function({bool buyNow, bool inStock}) addToCart,
    required Function(int quantity) onChangeQuantity,
    List<ProductVariation>? variations,
    required bool isInAppPurchaseChecking,
    bool showQuantity = true,
    Widget Function(bool Function(int) onChanged, int maxQuantity)?
        builderQuantitySelection,
  }) {
    final isAvailable =
        productVariation != null ? productVariation.id != null : true;

    return makeBuyButtonWidget(
      context: context,
      productVariation: productVariation,
      product: product,
      mapAttribute: mapAttribute,
      maxQuantity: maxQuantity,
      quantity: quantity,
      addToCart: addToCart,
      onChangeQuantity: onChangeQuantity,
      isAvailable: isAvailable,
      isInAppPurchaseChecking: isInAppPurchaseChecking,
      showQuantity: showQuantity,
      builderQuantitySelection: builderQuantitySelection,
    );
  }

  @override
  List<Widget> getProductAttributeWidget(
    String lang,
    Product product,
    Map<String?, String?>? mapAttribute,
    Function onSelectProductVariant,
    List<ProductVariation> variations,
  ) {
    var listWidget = <Widget>[];

    try {
      final checkProductAttribute =
          product.attributes != null && product.attributes!.isNotEmpty;
      if (checkProductAttribute) {
        for (var attr in product.attributes!) {
          if (attr.name != null &&
              attr.name!.isNotEmpty &&
              attr.name != _defaultTitle) {
            var options = List<String>.from(attr.options!);

            var selectedValue = mapAttribute![attr.name!] ?? '';

            listWidget.add(
              BasicSelection(
                options: options,
                title: (kProductVariantLanguage[lang] != null &&
                        kProductVariantLanguage[lang]
                                [attr.name!.toLowerCase()] !=
                            null)
                    ? kProductVariantLanguage[lang][attr.name!.toLowerCase()]
                    : attr.name!.toLowerCase(),
                type: kProductVariantLayout[attr.name!.toLowerCase()] ?? 'box',
                value: selectedValue,
                productId: product.id,
                onChanged: (val) => onSelectProductVariant(
                  attr: attr,
                  val: val,
                  mapAttribute: mapAttribute,
                  variations: product.variations,
                ),
              ),
            );
          }
        }
      }
      return listWidget;
    } catch (e, trace) {
      printError(e, trace);
      return [];
    }
  }

  @override
  List<Widget> getProductTitleWidget(
      BuildContext context, productVariation, product) {
    final isAvailable =
        productVariation != null ? productVariation.id != null : true;

    return makeProductTitleWidget(
        context, productVariation, product, isAvailable);
  }

  @override
  void onSelectProductVariant({
    required ProductAttribute attr,
    String? val,
    required List<ProductVariation> variations,
    required Map<String?, String?> mapAttribute,
    required Function onFinish,
  }) {
    try {
      mapAttribute.update(attr.name, (value) => val.toString(),
          ifAbsent: () => val.toString());

      if (!isValidProductVariation(variations, mapAttribute)) {
        /// Reset other choices
        mapAttribute.clear();
        mapAttribute[attr.name] = val.toString();
      }

      final productVariation = updateVariation(variations, mapAttribute);

      onFinish(mapAttribute, productVariation);
    } catch (e, trace) {
      printError(e, trace);
    }
  }

  bool isValidProductVariation(
      List<ProductVariation> variations, Map<String?, String?> mapAttribute) {
    for (var variation in variations) {
      if (variation.hasSameAttributes(mapAttribute)) {
        /// Hide out of stock variation
        if ((kAdvanceConfig.hideOutOfStock) && !variation.inStock!) {
          return false;
        }
        return true;
      }
    }
    return false;
  }
}
