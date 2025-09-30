import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../../../common/config.dart';
import '../../../../../common/constants.dart';
import '../../../../../models/app_model.dart';
import '../../../../../services/services.dart';
import '../../../../../widgets/common/star_rating.dart';
import '../../../../../widgets/product/widgets/sale_progress.dart';
import '../../../mixins/detail_product_price_mixin.dart';

class ProductTitleNormalWebWidget extends StatelessWidget {
  final DetailProductPriceStateUI priceData;
  final Widget Function()? builderBuyButton;

  const ProductTitleNormalWebWidget(
    this.priceData,
    this.builderBuyButton,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = priceData.product;
    final backgroundColor = context.read<AppModel>().themeConfig.hexSaleColor;
    final vendorName = product?.vendor ?? '';
    final productName = product?.name ?? '';
    final productAverageRating = product?.averageRating;
    final productRatingCount = product?.ratingCount;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (vendorName.isNotEmpty && kProductDetail.showVendorName)
          Row(
            children: <Widget>[
              Text(
                vendorName,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                productName,
                style:
                    theme.textTheme.headlineSmall!.apply(fontSizeFactor: 0.9),
              ),
            ),
            if (priceData.isSaleOff)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 2,
                ),
                margin: const EdgeInsets.only(left: 4, top: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  S.of(context).sale('${priceData.sale}'),
                  style: theme.textTheme.titleMedium!.copyWith(
                    color: backgroundColor.getColorBasedOnBackground,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (product != null)
          Services().widget.renderDetailPrice(
                context,
                product,
                priceData,
                isShowCountDown: priceData.isShowCountDown,
                countDown: priceData.countDown,
                axisType: Axis.horizontal,
              ),
        Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            if (kAdvanceConfig.enableRating && productAverageRating != null)
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  spacing: 0.0,
                  rating: productAverageRating,
                  size: 17.0,
                  label: productRatingCount != null
                      ? Text(
                          ' ($productRatingCount)',
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: theme.colorScheme.secondary
                                .withValueOpacity(0.8),
                          ),
                        )
                      : null,
                ),
              ),
            const Spacer(),
            if (priceData.dateOnSaleTo != null && priceData.countDown > 0)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SaleProgressBar(
                  product: product,
                  productVariation: priceData.productVariation,
                  width: 160,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        if (builderBuyButton != null) builderBuyButton!(),
      ],
    );
  }
}
