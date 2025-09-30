import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../models/index.dart'
    show Product, ProductModel, ProductVariation;

class VariantImageFeature extends StatelessWidget {
  final Product? product;
  static const heroTagPrefix = 'variant_image_feature_hero_tag';

  const VariantImageFeature(this.product);

  @override
  Widget build(BuildContext context) {
    ProductVariation? productVariation;
    productVariation = Provider.of<ProductModel>(context).selectedVariation;
    final imageFeature = productVariation != null
        ? productVariation.imageFeature
        : product!.imageFeature;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return FlexibleSpaceBar(
          background: GestureDetector(
            onTap: () => context.openImageGallery(
              isDialog: false,
              images: product?.images,
              heroTagPrefix: heroTagPrefix,
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: double.parse(kProductDetail.marginTop.toString()),
                  child: Hero(
                    tag: '$heroTagPrefix$imageFeature',
                    child: ImageResize(
                      url: imageFeature,
                      fit: BoxFit.contain,
                      isResize: true,
                      size: kSize.medium,
                      width: constraints.maxWidth,
                      hidePlaceHolder: true,
                      forceWhiteBackground: kProductDetail.forceWhiteBackground,
                    ),
                  ),
                ),
                Positioned(
                  top: double.parse(kProductDetail.marginTop.toString()),
                  child: ImageResize(
                    url: imageFeature,
                    fit: BoxFit.contain,
                    width: constraints.maxWidth,
                    size: kSize.large,
                    hidePlaceHolder: true,
                    forceWhiteBackground: kProductDetail.forceWhiteBackground,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
