import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../common/tools.dart';
import '../../../models/entities/product.dart';
import '../../../models/index.dart' show AppModel;
import '../../../screens/detail/mixins/detail_product_price_mixin.dart';
import '../../../services/index.dart';
import '../../../widgets/common/parallax_image.dart';
import '../config/product_config.dart';
import '../helper/helper.dart';

const _widthPercentForWebLayout = 0.32;

class ProductListDefault extends StatelessWidget {
  final maxWidth;
  final List<Product>? products;
  final int? row;
  final ProductConfig config;
  final Color? background;
  final DetailProductPriceStateUI? priceData;

  const ProductListDefault({
    super.key,
    this.maxWidth,
    this.products,
    this.row = 1,
    required this.config,
    this.background,
    this.priceData,
  });

  String get layout => config.layout ?? Layout.threeColumn;

  List<Widget> renderProducts(
    BuildContext context, {
    required double productCardWidth,
    double? spaceWidth,
    DetailProductPriceStateUI? priceData,
  }) {
    final listProducts = products ?? [];
    final isDesktop = Layout.isDisplayDesktop(context);
    var ratioProductImage =
        Provider.of<AppModel>(context, listen: false).ratioProductImage;

    /// allow override imageRatio when there is single Row
    if (config.rows == 1) {
      ratioProductImage = config.imageRatio;
    }

    if (isDesktop) {
      return [
        if (listProducts.isNotEmpty)
          for (var i = 0; i < 3; i++)
            Expanded(
              child: Services().widget.renderProductCardView(
                    item: listProducts[i],
                    width: productCardWidth,
                    maxWidth: maxWidth,
                    ratioProductImage: ratioProductImage,
                    config: config,
                    useDesktopStyle: true,
                    priceData: priceData,
                  ),
            )
      ];
    }

    return [
      if (spaceWidth != null)
        SizedBox(
          width: spaceWidth,
        ),
      if (listProducts.isNotEmpty)
        for (var i = 0; i < listProducts.length; i++)
          Services().widget.renderProductCardView(
                item: listProducts[i],
                width: productCardWidth,
                maxWidth: maxWidth,
                ratioProductImage: ratioProductImage,
                config: config,
                priceData: priceData,
              )
    ];
  }

  Widget renderHorizontal(BuildContext context,
      {bool enableBackground = false}) {
    final isDesktop = Layout.isDisplayDesktop(context);
    final isCarouselView = config.layout == Layout.carousel;

    final productCardWidth = isDesktop
        ? maxWidth * _widthPercentForWebLayout
        : Layout.buildProductWidth(
            screenWidth: maxWidth,
            layout: layout,
          );

    final padding = !isCarouselView &&
            (enableBackground ||
                config.cardDesign.isSimpleCard ||
                config.cardDesign.isFlat)
        ? 0.0
        : 12.0;
    final horizontalWidth = maxWidth - padding;
    final scrollController =
        isCarouselView ? CarouselController() : ScrollController();
    final listProducts = products is List ? (products as List) : [];

    /// wrap the product for Desktop mode
    if (Layout.isDisplayDesktop(context)) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16,
        ),
        child: FlexSeparated.row(
          separationSize: 24,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: renderProducts(
            context,
            productCardWidth: productCardWidth,
            spaceWidth: enableBackground == false
                ? null
                : (config.spaceWidth ?? productCardWidth),
          ),
        ),
      );
    }

    final backgroundHeight = config.backgroundHeight?.toDouble();
    late final horizontalWidget;

    switch (config.layout) {
      case Layout.carousel:
        final isMobileDisplay = Tools.isPhone(MediaQuery.of(context)) ||
            Tools.isBuilder; //check is in FluxBuilder or not
        final maxHeight = isMobileDisplay ? 350.0 : 610.0; // magic number

        final maxWidthItem = Layout.buildProductWidth(
          screenWidth: horizontalWidth,
          layout: layout,
        );
        horizontalWidget = ConstrainedBox(
          constraints: BoxConstraints(maxHeight: backgroundHeight ?? maxHeight),
          child: CarouselView(
            controller: scrollController is CarouselController
                ? scrollController
                : null,
            enableSplash:
                false, // disable splash effect to active action of child
            padding: EdgeInsets.only(right: padding),
            backgroundColor: Colors.transparent,
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            itemSnapping: config.isSnapping ?? false,
            itemExtent: maxWidthItem,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            children: renderProducts(
              context,
              productCardWidth: productCardWidth,
              spaceWidth: enableBackground == false
                  ? null
                  : config.spaceWidth?.toDouble(),
            )
                .map(
                  (e) => SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: maxWidthItem,
                      ),
                      child: e,
                    ),
                  ),
                )
                .toList(),
          ),
        );
      default:
        horizontalWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 8,
          ),
          physics: config.isSnapping ?? false
              ? CustomScrollPhysic(
                  width: Layout.buildProductWidth(
                      screenWidth: horizontalWidth, layout: layout))
              : const ScrollPhysics(),
          child: FlexSeparated.row(
            separationSize: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: renderProducts(
              context,
              productCardWidth: productCardWidth,
              spaceWidth: enableBackground == false
                  ? null
                  : (config.spaceWidth?.toDouble() ?? productCardWidth),
            ),
          ),
        );
    }

    final body = Container(
      color: background ??
          Theme.of(context)
              .colorScheme
              .surface
              .withValueOpacity(enableBackground ? 0.0 : 1.0),
      padding: EdgeInsetsDirectional.only(start: padding),
      constraints: BoxConstraints(
        minHeight: config.productListItemHeight,
      ),
      child: horizontalWidget,
    );

    return HandleAutoSlide.list(
      enable: config.enableAutoSliding,
      durationAutoSliding: config.durationAutoSliding,
      numberOfItems: listProducts.length,
      controller: scrollController,
      child: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (products == null) return const SizedBox();

    final haveCustomBackground =
        config.backgroundImage != null || config.backgroundColor != null;
    final backgroundHeight = config.backgroundHeight?.toDouble();
    final backgroundWidth = (config.backgroundWidthMode ?? false)
        ? maxWidth
        : config.backgroundWidth?.toDouble();

    var body = renderHorizontal(
      context,
      enableBackground: haveCustomBackground,
    );

    if (haveCustomBackground) {
      body = Stack(
        children: [
          if (config.backgroundColor != null)
            Container(
              height: backgroundHeight ??
                  Layout.buildProductHeight(
                    layout: layout,
                    defaultHeight: maxWidth,
                  ),
              width: backgroundWidth,
              margin: config.marginBGP,
              decoration: BoxDecoration(
                color: config.backgroundColor,
                borderRadius: BorderRadius.circular(config.backgroundRadius),
              ),
            ),
          if (config.backgroundImage != null)
            Container(
              margin: config.marginBGP,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(config.backgroundRadius),
                child: config.enableParallax
                    ? ParallaxImage(
                        image: config.backgroundImage!,
                        fit: ImageTools.boxFit(config.backgroundBoxFit),
                        height: backgroundHeight,
                        ratio: config.parallaxImageRatio,
                        width: backgroundWidth,
                      )
                    : FluxImage(
                        imageUrl: config.backgroundImage!,
                        fit: ImageTools.boxFit(config.backgroundBoxFit),
                        height: backgroundHeight,
                        width: backgroundWidth,
                      ),
              ),
            ),
          Padding(
            padding: config.paddingBGP ?? EdgeInsets.zero,
            child: body,
          ),
        ],
      );
    }

    return BackgroundColorWidget(
      enable: config.enableBackground,
      child: body,
    );
  }
}
