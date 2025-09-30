import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/index.dart' show Product;
import '../../services/services.dart';
import '../../widgets/product/action_button_mixin.dart';
import '../../widgets/product/dialog_add_to_cart.dart';
import '../../widgets/product/widgets/pricing.dart';

class WishlistItem extends StatelessWidget with ActionButtonMixin {
  const WishlistItem({required this.product, this.onRemove});

  final Product product;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(children: [
          InkWell(
            onTap: () => onTapProduct(context, product: product),
            child: Row(
              key: ValueKey(product.id),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: onRemove,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 16.0),
                    child: _ProductCard(product: product),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          const Divider(color: kGrey200, height: 1),
          const SizedBox(height: 10.0),
        ]);
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: FluxImage(
            imageUrl: (product.imageFeature?.isNotEmpty ?? false)
                ? product.imageFeature!
                : kDefaultImage,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 7),
              ProductPricing(
                product: product,
                hide: false,
                priceTextStyle: const TextStyle(
                    fontWeight: FontWeight.normal, fontSize: 14),
              ),
              const SizedBox(height: 10),
              if (kWishListConfig.showCartButton &&
                  Services().widget.enableShoppingCart(product))
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    final files = product.files ?? [];
                    if ((product.isPurchased) &&
                        (product.isDownloadable ?? false) &&
                        files.isNotEmpty &&
                        (files.first?.isNotEmpty ?? false)) {
                      Tools.launchURL(files.first,
                          mode: LaunchMode.externalApplication);
                      return;
                    }
                    DialogAddToCart.show(context, product: product);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      ((product.isPurchased && product.isDownloadable!)
                              ? S.of(context).download
                              : S.of(context).addToCart)
                          .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
