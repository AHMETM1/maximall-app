import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/icons/constants.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/entities/wishlist_type.dart';
import '../../models/index.dart' show ProductWishListModel;
import '../../modules/dynamic_layout/config/product_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/services.dart';
import '../../widgets/common/flux_alert.dart';
import '../../widgets/product/action_button_mixin.dart';
import '../../widgets/web_layout/web_layout.dart';
import '../../widgets/web_layout/widgets/path_header_widget.dart';
import '../common/app_bar_mixin.dart';
import 'empty_wishlist.dart';
import 'empty_wishlist_web.dart';
import 'staggered_product_wish_list.dart';
import 'wishlist_item_widget.dart';

class ProductWishListScreen extends StatefulWidget {
  const ProductWishListScreen();

  @override
  State<StatefulWidget> createState() => _WishListState();
}

class _WishListState extends State<ProductWishListScreen>
    with AppBarMixin, ActionButtonMixin {
  final ScrollController _scrollController = ScrollController();

  WishListType get wishListType => kWishListConfig.type;

  ProductWishListModel get model => context.read<ProductWishListModel>();

  Widget renderWishListWidget() {
    switch (wishListType) {
      case WishListType.staggered:
        return const StaggeredProductWishList();
      case WishListType.normal:
        return ListView.builder(
          controller: _scrollController,
          itemCount: model.products.length,
          itemBuilder: (context, index) {
            final product = model.products[index];
            return WishlistItem(
              product: product,
              onRemove: () {
                model.toggleWishlist(product);
              },
            );
          },
        );
    }
  }

  @override
  void initState() {
    super.initState();
    screenScrollController = _scrollController;
  }

  @override
  void deactivate() {
    printLog('[ProductWishListScreen] deactivate');
    super.deactivate();
  }

  Future<bool> onRemoveSelectedItems() async {
    final confirmed = await context.showFluxDialogConfirm(
      title: S.of(context).removeWishlist,
      body: S.of(context).removeWishlistContent(model.selectedProducts.length),
      primaryAsDestructiveAction: true,
      useAppNavigator: true,
    );
    if (confirmed) {
      model.removeSelectedProducts();
      return true;
    }

    return false;
  }

  void onPopScreen() {
    final length = model.selectedProducts.length;
    context.showFluxDialog(FluxAlert.text(
      title: S.of(context).youAreSelecting(length),
      body: S.of(context).removeWishlistContent(length),
      primaryAction: S.of(context).remove,
      secondaryAction: S.of(context).continueToSelectItem,
      tertiaryAction: S.of(context).back,
      onPrimaryPressed: () {
        if (mounted) {
          model.removeSelectedProducts();
          Navigator.of(context).pop();
        }
      },
      onTertiaryPressed: () {
        if (mounted) {
          model.stopSelecting();
          Navigator.of(context).pop();
        }
      },
      primaryAsDestructiveAction: true,
      directionButton: Axis.vertical,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Layout.isDisplayDesktop(context);

    return Consumer<ProductWishListModel>(
      builder: (context, model, child) {
        final isSelecting = model.isSelecting;
        final canPop = model.selectedProducts.isEmpty;
        final products = model.products;
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              return;
            }
            onPopScreen();
          },
          child: renderScaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            routeName: RouteList.wishlist,
            secondAppBar: isDesktop
                ? null
                : AppBar(
                    iconTheme: IconThemeData(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    elevation: 0.5,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: Text(
                      S.of(context).myWishList,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    actions: [
                      if (wishListType.isStaggered && products.isNotEmpty)
                        Builder(builder: (_) {
                          if (isSelecting) {
                            return CupertinoButton(
                              onPressed: model.stopSelecting,
                              child: Text(S.of(context).cancel),
                            );
                          }
                          return CupertinoButton(
                            onPressed: model.startSelecting,
                            child: Text(S.of(context).select),
                          );
                        }),
                    ],
                  ),
            child: Builder(
              builder: (context) {
                if (isDesktop) {
                  final configProductList = context.mathSizeLayoutProductList();
                  var crossAxisCount = configProductList.$1;
                  var widthContent = configProductList.$2 + 16;

                  return LayoutBuilder(builder: (_, constraints) {
                    final paddingHorizontal =
                        constraints.maxWidth > kLimitWidthScreen
                            ? ((constraints.maxWidth - kLimitWidthScreen) / 2)
                            : 0.0;

                    return SliverWebLayout(
                      slivers: [
                        SliverToBoxAdapter(
                          child: LayoutLimitWidthScreen(
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  S.of(context).myWishList,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (products.isEmpty)
                          SliverFillRemaining(
                            child: EmptyWishlistWeb(
                              onShowHome: () =>
                                  NavigateTools.navigateToDefaultTab(context),
                            ),
                          )
                        else
                          SliverPadding(
                            padding: EdgeInsets.symmetric(
                              horizontal: paddingHorizontal,
                              vertical: 16.0,
                            ),
                            sliver: SliverGrid(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: 0.8,
                                crossAxisSpacing: 12.0,
                                mainAxisSpacing: 24.0,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                addAutomaticKeepAlives: false,
                                childCount: products.length,
                                (BuildContext context, int i) {
                                  return Services()
                                      .widget
                                      .renderProductCardView(
                                        item: products[i],
                                        width: widthContent,
                                        ratioProductImage: 1.0,
                                        useDesktopStyle: isDesktop,
                                        config: ProductConfig.empty()
                                          ..cardDesign = isDesktop
                                              ? CardDesign.simpleForWeb
                                              : CardDesign.card
                                          ..imageRatio = 1.0
                                          ..showHeart = true
                                          ..useCircularRadius = false
                                          ..borderRadius = 16,
                                      );
                                },
                              ),
                            ),
                          ),
                      ],
                      pathHeaders: [
                        PathHeaderItem(title: S.of(context).myWishList),
                      ],
                    );
                  });
                }
                if (products.isEmpty) {
                  return EmptyWishlist(
                    onShowHome: () =>
                        NavigateTools.navigateToDefaultTab(context),
                    onSearchForItem: () => NavigateTools.navigateToRootTab(
                      context,
                      RouteList.search,
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: SizedBox(
                        height: 48,
                        child: Builder(builder: (context) {
                          if (model.isSelecting) {
                            final canRemove = model.selectedProducts.isNotEmpty;
                            return Row(
                              children: [
                                canRemove
                                    ? Text(
                                        context.transCountItem(
                                            model.selectedProducts.length),
                                      )
                                    : Text(S.of(context).selectItem),
                                const Spacer(),
                                TextButton.icon(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                  ),
                                  icon: const Icon(CupertinoIcons.delete),
                                  onPressed:
                                      canRemove ? onRemoveSelectedItems : null,
                                  label: Text(
                                    S.of(context).remove,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.transCountProduct(products.length),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }),
                      ),
                    ),
                    const Divider(height: 1, color: kGrey200),
                    const SizedBox(height: 14.0),
                    Expanded(
                      child: renderWishListWidget(),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
