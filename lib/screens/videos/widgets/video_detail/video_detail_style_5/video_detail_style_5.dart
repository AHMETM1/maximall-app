import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/inspireui.dart';

import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/index.dart';
import '../../../models/video.dart';

class VideoDetailStyle5 extends StatelessWidget with ActionButtonMixin {
  const VideoDetailStyle5({super.key, required this.video});

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
    final backgroundColor = colorScheme.surface;
    final textColor = backgroundColor.getColorBasedOnBackground;
    final textTheme = theme.textTheme;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    backgroundBuilder: (context, state, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor,
                              primaryColor.lighten(0.25),
                            ],
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                          ),
                        ),
                        child: child,
                      );
                    },
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
