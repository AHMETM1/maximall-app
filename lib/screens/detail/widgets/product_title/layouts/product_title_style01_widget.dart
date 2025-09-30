import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/extensions.dart';
import 'package:provider/provider.dart';

import '../../../../../common/config.dart';
import '../../../../../models/app_model.dart';
import '../../../../../widgets/product/widgets/title.dart';
import '../../../mixins/detail_product_price_mixin.dart';

class ProductTitleStyle01Widget extends StatelessWidget {
  const ProductTitleStyle01Widget(this.priceData, {super.key});

  final DetailProductPriceStateUI priceData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = priceData.product;
    final backgroundColor = context.read<AppModel>().themeConfig.hexSaleColor;
    final vendorName = product?.vendor ?? '';
    final productAverageRating = product?.averageRating;

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
            if (product != null)
              Expanded(
                child: ProductTitle(
                  resizeByMaxLines: false,
                  hide: false,
                  product: product,
                  style:
                      theme.textTheme.headlineSmall!.apply(fontSizeFactor: 0.9),
                  strutStyle: const StrutStyle(forceStrutHeight: false),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
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
                if (kProductDetail.showRating &&
                    productAverageRating != null &&
                    productAverageRating > 0)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star_rate_rounded,
                        color: Colors.yellow,
                      ),
                      Text(
                        '($productAverageRating)',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
