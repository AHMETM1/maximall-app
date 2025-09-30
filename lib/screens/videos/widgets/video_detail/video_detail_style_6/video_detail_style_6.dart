import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/inspireui.dart';

import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/index.dart';
import '../../../models/video.dart';

class VideoDetailStyle6 extends StatelessWidget with ActionButtonMixin {
  const VideoDetailStyle6({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final product = video.product;
    if (product == null) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;
    final textTheme = theme.textTheme;
    final backgroundColor = primaryColor.lighten(0.45);
    final textColor = backgroundColor.getColorBasedOnBackground;

    return GestureDetector(
      onTap: () {
        _showDetail(context);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 16,
              children: [
                if (product.imageFeature?.isNotEmpty ?? false)
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                    child: FluxImage(
                      fit: BoxFit.cover,
                      imageUrl: product.imageFeature ?? '',
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProductTitle(
                        product: product,
                        hide: false,
                        maxLines: 2,
                        style: textTheme.titleMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ProductPricing(
                        product: product,
                        hide: false,
                        showOnlyPrice: true,
                        priceTextStyle:
                            textTheme.titleSmall?.copyWith(color: textColor),
                      ),
                      const SizedBox(height: 2),
                      ProductRating(
                        product: product,
                        enableRating: true,
                        hideEmptyProductListRating: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    var product = video.product;
    if (product != null) {
      onTapProduct(context, product: product);
    }
  }
}
