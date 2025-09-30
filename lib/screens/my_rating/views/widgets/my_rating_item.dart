import 'package:flutter/material.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../models/entities/product.dart';
import '../../../../models/entities/review.dart';
import '../../../../modules/product_reviews/views/widgets/review_item.dart';
import '../../../../services/services.dart';
import '../../../../widgets/product/action_button_mixin.dart';
import 'product_simple_item.dart';

class MyRatingItem extends StatelessWidget {
  final Review review;

  const MyRatingItem({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          ReviewItem(
            name: review.displayName,
            date: review.createdAt.timeAgo(),
            rating: review.rating ?? 0,
            content: review.displayContent,
            images: review.images,
            showRatingStar: kAdvanceConfig.enableRating,
            verified: review.verified,
          ),
          const SizedBox(height: 12),
          _ProductSimpleItemNetwork(
            productId: review.productId.toString(),
            productName: review.productName,
          ),
        ],
      ),
    );
  }
}

class _ProductSimpleItemNetwork extends StatefulWidget {
  const _ProductSimpleItemNetwork({
    required this.productId,
    required this.productName,
  });

  final String productId;

  final String productName;

  @override
  State<_ProductSimpleItemNetwork> createState() =>
      _ProductSimpleItemNetworkState();
}

class _ProductSimpleItemNetworkState extends State<_ProductSimpleItemNetwork>
    with ActionButtonMixin {
  late final Future<Product?> productFuture;

  @override
  void initState() {
    super.initState();
    productFuture = Services().api.getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product?>(
      future: productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ProductSimpleItem(
            name: widget.productName,
          );
        }

        if (snapshot.data == null || snapshot.hasError) {
          return ProductSimpleItem(
            imageUrl: kDefaultImage,
            name: snapshot.data?.name ?? '',
          );
        }

        final product = snapshot.data;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: product != null
              ? () => onTapProduct(
                    context,
                    product: product,
                  )
              : null,
          child: ProductSimpleItem(
            imageUrl: product?.imageFeature ?? kDefaultImage,
            name: snapshot.data?.name ?? '',
          ),
        );
      },
    );
  }
}

class MyRatingItemSkeleton extends StatelessWidget {
  const MyRatingItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12,
      ),
      color: Theme.of(context).cardColor,
      child: const Column(
        children: [
          ReviewItemSkeleton(),
          SizedBox(height: 12),
          ProductSimpleItemSkeleton(),
        ],
      ),
    );
  }
}
