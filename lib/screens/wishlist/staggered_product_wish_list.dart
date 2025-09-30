import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/index.dart';
import '../../widgets/product/action_button_mixin.dart';

const _kDuration = Duration(milliseconds: 200);

class StaggeredProductWishList extends StatefulWidget {
  const StaggeredProductWishList({super.key});

  @override
  State<StaggeredProductWishList> createState() =>
      _StaggeredProductWishListState();
}

class _StaggeredProductWishListState extends State<StaggeredProductWishList>
    with ActionButtonMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProductWishListModel>(
      builder: (context, model, child) {
        final products = model.products;
        return GridView.custom(
          cacheExtent: 500,
          padding: const EdgeInsets.all(4),
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 3,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.same,
            pattern: const [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              // //
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              //
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              //
              QuiltedGridTile(1, 1),
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              //
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              //
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: products.length,
            (context, index) {
              final product = products[index];
              final selectMode = model.isSelecting;
              return GestureDetector(
                onTap: selectMode
                    ? () => model.toggleSelectProduct(product)
                    : () => onTapProduct(context, product: product),
                child: _StaggeredItem(
                  isSelecting: model.isSelected(product),
                  selectMode: selectMode,
                  product: product,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StaggeredItem extends StatelessWidget {
  const _StaggeredItem({
    required this.isSelecting,
    required this.selectMode,
    required this.product,
  });

  final bool isSelecting;
  final bool selectMode;
  final Product product;

  EdgeInsets get _paddingItem =>
      selectMode ? const EdgeInsets.all(10) : EdgeInsets.zero;

  BorderRadius get _borderRadiusItem =>
      selectMode ? BorderRadius.circular(10) : BorderRadius.zero;

  double get _scaleValue => isSelecting ? 1 : 0;

  double get _opacityValue => isSelecting ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedPadding(
          padding: _paddingItem,
          duration: _kDuration,
          child: AnimatedContainer(
            duration: _kDuration,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: _borderRadiusItem,
            ),
            child: FluxImage(
              fit: BoxFit.cover,
              imageUrl: product.imageFeature ?? kDefaultImage,
            ),
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          bottom: 0,
          end: 0,
          child: AnimatedOpacity(
            duration: _kDuration,
            opacity: _opacityValue,
            child: TweenAnimationBuilder(
              duration: _kDuration,
              tween: Tween<double>(begin: 0, end: _scaleValue),
              builder: (context, double scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onPrimary,
                      width: 1.5,
                    ),
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
