import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../../common/constants.dart';
import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/index.dart';
import '../../../models/video.dart';

class VideoDetailStyle4 extends StatelessWidget with ActionButtonMixin {
  const VideoDetailStyle4({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final product = video.product;
    if (product == null) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor = colorScheme.surface;
    final textColor = backgroundColor.getColorBasedOnBackground;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor.withValues(alpha: 0.85),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (product.imageFeature?.isNotEmpty ?? false)
            SizedBox(
              width: 64,
              height: 64,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: FluxImage(
                  fit: BoxFit.cover,
                  imageUrl: product.imageFeature ?? '',
                ),
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
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                ProductPricing(
                  product: product,
                  hide: false,
                  showOnlyPrice: true,
                  priceTextStyle: textTheme.titleSmall?.copyWith(
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                ProductRating(
                  product: product,
                  enableRating: true,
                  hideEmptyProductListRating: false,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {
                    _showDetail(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(S.of(context).showDetails),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
