import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/inspireui.dart';

import '../../../../common/constants.dart';
import '../../../../models/entities/purchased_product.dart';
import '../../../../widgets/common/paging_list.dart';
import '../../../../widgets/product/action_button_mixin.dart';
import '../../model/list_purchased_product_model.dart';
import '../widgets/product_simple_item.dart';

class ListPurchaseProduct extends StatefulWidget {
  const ListPurchaseProduct({super.key});

  @override
  State<ListPurchaseProduct> createState() => _ListPurchaseProductState();
}

class _ListPurchaseProductState extends State<ListPurchaseProduct> {
  @override
  Widget build(BuildContext context) {
    return PagingList<ListPurchasedProductModel, PurchasedProduct>(
      itemBuilder: (context, item, index) {
        return _ProductItem(item: item);
      },
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      loadingWidget: const _ProductItemSkeleton(),
      lengthLoadingWidget: 4,
    );
  }
}

class _ProductItem extends StatelessWidget with ActionButtonMixin {
  const _ProductItem({
    required this.item,
  });

  final PurchasedProduct item;

  void _onTapRate(BuildContext context, PurchasedProduct purchaseProduct) {
    Navigator.of(context).pushNamed(
      RouteList.createReview,
      arguments: purchaseProduct.data.toLiteProduct(purchaseProduct.orderId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = item.data;
    final order = item.order;

    return Container(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTapProduct(
                context,
                product: product,
              ),
              child: ProductSimpleItem(
                imageUrl: product.imageFeature ?? kDefaultImage,
                name: product.displayName,
              ),
            ),
            Column(
              children: [
                const Divider(),
                Row(
                  children: [
                    Text(
                      '${S.of(context).orderNo}: ${order.number}',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 14.0,
                          ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _onTapRate(context, item),
                        child: Text(S.of(context).rate),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ProductItemSkeleton extends StatelessWidget {
  const _ProductItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(bottom: 8),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ProductSimpleItemSkeleton(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Divider(),
                Row(
                  children: [
                    Skeleton(
                      height: 20,
                      width: 80,
                    ),
                    Spacer(),
                    Expanded(
                      child: Skeleton(
                        height: 32,
                        width: 80,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
