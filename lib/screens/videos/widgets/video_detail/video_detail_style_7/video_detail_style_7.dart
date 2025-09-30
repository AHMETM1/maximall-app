import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/index.dart';
import '../../../models/video.dart';

class VideoDetailStyle7 extends StatelessWidget with ActionButtonMixin {
  const VideoDetailStyle7({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final product = video.product;
    if (product == null) {
      return const SizedBox();
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () {
        _showDetail(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: <Color>[
              const Color(0xFF000000).withValues(alpha: 0.6),
              const Color(0xFF000000).withValues(alpha: 0.3),
              Colors.transparent
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Row(
          spacing: 16,
          children: [
            if (product.imageFeature?.isNotEmpty ?? false)
              SizedBox(
                width: 64,
                height: 64,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
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
                    style: textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  ProductPricing(
                    product: product,
                    hide: false,
                    showOnlyPrice: true,
                    priceTextStyle:
                        textTheme.titleSmall?.copyWith(color: Colors.white),
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
