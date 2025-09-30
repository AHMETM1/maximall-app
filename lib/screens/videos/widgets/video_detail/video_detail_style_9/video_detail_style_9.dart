import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../../common/constants.dart';
import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/index.dart';
import '../../../models/video.dart';

class VideoDetailStyle9 extends StatelessWidget with ActionButtonMixin {
  const VideoDetailStyle9({super.key, required this.video});

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
    final textTheme = theme.textTheme;
    final secondaryColor = theme.colorScheme.secondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: secondaryColor,
            width: 2,
          ),
        ),
      ),
      child: Row(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.imageFeature?.isNotEmpty ?? false)
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -36,
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(color: secondaryColor, width: 2),
                      ),
                      child: FluxImage(
                        fit: BoxFit.cover,
                        imageUrl: product.imageFeature ?? '',
                      ),
                    ),
                  ),
                ],
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
                  style: textTheme.titleMedium?.copyWith(),
                ),
                const SizedBox(height: 5),
                ProductPricing(
                  product: product,
                  hide: false,
                  showOnlyPrice: true,
                  priceTextStyle: textTheme.titleSmall?.copyWith(),
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
                    backgroundColor: secondaryColor,
                    foregroundColor: secondaryColor.getColorBasedOnBackground,
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
