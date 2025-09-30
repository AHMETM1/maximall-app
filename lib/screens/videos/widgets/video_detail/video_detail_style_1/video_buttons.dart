import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

import '../../../../../common/config.dart';
import '../../../../../common/extensions/extensions.dart';
import '../../../../../models/index.dart';
import '../../../../../modules/dynamic_layout/config/product_config.dart';
import '../../../../../modules/dynamic_layout/index.dart';
import '../../../../../widgets/product/action_button_mixin.dart';
import '../../../../../widgets/product/dialog_add_to_cart.dart';
import '../../../models/video.dart';

const double kIconSize = 30.0;

class VideoButtons extends StatelessWidget with ActionButtonMixin {
  const VideoButtons({
    super.key,
    required this.video,
    this.config,
  });

  final Video video;
  final ProductConfig? config;

  @override
  Widget build(BuildContext context) {
    final product = video.product;
    final inStock = product?.inStock ?? false;
    final allowBackorder = product?.backordersAllowed ?? false;
    final isExternal = product?.type == 'external';
    final enableBuyNow = inStock || allowBackorder || isExternal;
    final enableBottomSheet = config?.enableBottomAddToCart ?? true
        ? true
        : !(product?.canBeAddedToCartFromList() ?? false);
    final productUrl = product?.permalink ?? '';

    return Container(
      padding: const EdgeInsetsDirectional.only(
        end: 2,
        start: 20,
        top: 10,
        bottom: 10,
      ),
      child: Column(
        children: [
          if (product != null &&
              enableBuyNow &&
              kProductCard.openInWebview == false) ...[
            VideoButton(
              icon: const Icon(
                CupertinoIcons.cart_fill_badge_plus,
                size: kIconSize,
                color: Colors.white,
              ),
              label: S.of(context).buyNow,
              onTap: () => _buyNow(context, enableBottomSheet, product),
            ),
            const SizedBox(height: 15),
          ],
          if (dynamicLinkConfig.allowShareLink &&
              kProductCard.openInWebview == false &&
              productUrl.isNotNullAndNotEmpty) ...[
            VideoButton(
              icon: const Icon(
                Icons.share_sharp,
                size: kIconSize,
                color: Colors.white,
              ),
              label: S.of(context).share,
              onTap: () => _share(context, productUrl),
            ),
            const SizedBox(height: 15),
          ],
          if (product != null)
            VideoButton(
              icon: const Icon(
                CupertinoIcons.info,
                size: kIconSize - 2,
                color: Colors.white,
              ),
              label: S.of(context).showDetails,
              onTap: () => _showDetail(context, product),
            ),
        ],
      ),
    );
  }

  void _showDetail(BuildContext context, Product product) {
    onTapProduct(context, product: product);
  }

  void _share(BuildContext context, String url) {
    context.shareLink(url);
  }

  void _buyNow(BuildContext context, bool enableBottomSheet, Product product) {
    if (enableBottomSheet) {
      DialogAddToCart.show(context, product: product, quantity: 1);
    } else {
      onTapProduct(
        context,
        product: product,
      );
    }
  }
}

class VideoButton extends StatelessWidget {
  const VideoButton({super.key, required this.icon, this.label, this.onTap});

  final Widget icon;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          top: 5,
          bottom: 5,
        ),
        child: Column(
          children: [
            icon,
            if (label != null) const SizedBox(height: 3),
            if (label != null)
              Text(
                label ?? '',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
