import 'package:flutter/material.dart';

import '../../models/index.dart' show Product;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../screens/detail/mixins/detail_product_price_mixin.dart';
import '../../services/services.dart';
import '../web_layout/widgets/mouse_hover_transition.dart';
import 'action_button_mixin.dart';
import 'index.dart' show HeartButton, ProductImage, ProductOnSale, ProductTitle;

class ProductSimpleLayoutWeb extends StatelessWidget with ActionButtonMixin {
  final Product item;
  final double? width;
  final double? maxWidth;
  final offset;
  final ProductConfig config;
  final DetailProductPriceStateUI? priceData;

  const ProductSimpleLayoutWeb({
    required this.item,
    this.width,
    this.maxWidth,
    this.offset,
    this.priceData,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    final isShowPrice = config.hidePrice == false;
    final theme = Theme.of(context);

    final widthItem = width ?? 30;
    final heighItem = (widthItem / 0.8) - 105;
    Widget productImage = Stack(
      children: [
        ProductImage(
          width: widthItem,
          product: item,
          config: config,
          ratioProductImage: heighItem / widthItem,
          offset: offset,
          onTapProduct: () =>
              onTapProduct(context, product: item, config: config),
        ),
        if (config.showHeart && !item.isEmptyProduct())
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: config.hMargin / 2,
            top: config.hMargin / 2,
            child: SizedBox(
              width: 50,
              height: 50,
              child: HeartButton(
                product: item,
                size: 20,
              ),
            ),
          ),
        Positioned.directional(
          start: 8,
          top: 8,
          textDirection: Directionality.of(context),
          child: ProductOnSale(
            product: item,
            config: ProductConfig.empty()..hMargin = 0,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
          ),
        ),
        ...Services().renderProductBadges(context, item),
      ],
    );
    // TODO(tri): fix price data 01
    Widget productInfo = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductTitle(
          product: item,
          hide: config.hideTitle,
          maxLines: config.titleLine,
          textCenter: false,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        if (isShowPrice)
          Services().widget.renderDetailPrice(
                context,
                item,
                priceData,
                axisType: Axis.vertical,
              ),
      ],
    );

    var padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16);

    if (!Layout.isDisplayDesktop(context)) {
      padding = padding / 1.5;
    }

    return MouseHoverTransition(
      duration: const Duration(milliseconds: 100),
      scale: 0.03,
      child: GestureDetector(
        onTap: () => onTapProduct(context, product: item, config: config),
        behavior: HitTestBehavior.opaque,
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth ?? width!),
          margin: EdgeInsets.symmetric(
            horizontal: config.hMargin,
            vertical: config.vMargin,
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(config.borderRadius ?? 16),
            border: Border.all(
              color: theme.disabledColor,
              width: 0.5,
            ),
          ),
          width: width!,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              productImage,
              Padding(
                padding: padding,
                child: productInfo,
              ),
              // Center(
              //   child: Container(
              //     color: Colors.yellow,
              //     height: 120,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
