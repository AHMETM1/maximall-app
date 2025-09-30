import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/cart/cart_base.dart';
import '../../../models/entities/product.dart';
import '../../../models/product_model.dart';
import '../../../models/product_variant_model.dart';
import '../../../models/user_model.dart';
import '../../../services/service_config.dart';
import '../../../services/services.dart';
import '../../../widgets/product/widgets/heart_button.dart';
import '../../cart/cart_screen.dart';
import '../../chat/vendor_chat.dart';
import '../product_detail_screen.dart';
import '../widgets/product_brand.dart';
import '../widgets/product_common_info.dart';
import '../widgets/product_description.dart';
import '../widgets/product_detail_categories.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_gallery_slider_widget.dart';
import '../widgets/product_short_description.dart';
import '../widgets/product_size_guide.dart';
import '../widgets/product_tag.dart';
import '../widgets/product_title/product_title_widget.dart';
import '../widgets/recent_product.dart';
import '../widgets/related_product.dart';
import '../widgets/related_product_from_same_store.dart';

class ProductDetailGallerySliderLayout extends StatefulWidget {
  final Product product;
  final bool isProductInfoLoading;

  const ProductDetailGallerySliderLayout({
    required this.product,
    required this.isProductInfoLoading,
  });

  @override
  State<ProductDetailGallerySliderLayout> createState() =>
      _ProductDetailGallerySliderLayoutState();
}

class _ProductDetailGallerySliderLayoutState
    extends State<ProductDetailGallerySliderLayout>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _selectIndexNotifier = ValueNotifier(0);
  int get totalCart => Provider.of<CartModel>(context).totalCartQuantity;

  late Product product;

  Map<String, String> mapAttribute = HashMap();
  late AnimationController _hideController;
  var top = 0.0;

  @override
  void initState() {
    super.initState();
    product = widget.product;
    _hideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(ProductDetailGallerySliderLayout oldWidget) {
    if (oldWidget.product.type != widget.product.type) {
      setState(() {
        product = widget.product;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _hideController.dispose();
    _selectIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const fixSizeHeight = 0.6;
    final size = MediaQuery.of(context).size;
    final height = size.height;
    var hasProductInfo = true;
    final userModel = Provider.of<UserModel>(context, listen: false);
    var heightProductImage = kIsWeb ? 0 : height * fixSizeHeight;
    var ratioHeight = 1 -
        (heightProductImage +
                kProductDetail.marginTop +
                (size.width - 60 * (2 - fixSizeHeight)) / 4) /
            height;
    var startDraggable = ratioHeight < 0.03 ? 0.03 : ratioHeight;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        bottom: false,
        top: kProductDetail.safeArea,
        child: ChangeNotifierProvider(
          create: (_) => ProductModel(),
          child: Consumer<ProductVariantModel>(
            builder: (context, model, child) {
              return Column(
                children: [
                  Expanded(
                    child: Scaffold(
                      appBar: AppBar(
                        leading: Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .primaryColorLight
                                .withValueOpacity(0.7),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                context
                                    .read<ProductModel>()
                                    .clearProductVariations();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: _shoppingCartIcon(),
                          ),
                          if (hasProductInfo)
                            HeartButton(
                              product: product,
                              size: 20.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .primaryColorLight
                                  .withValueOpacity(0.7),
                              child: IconButton(
                                icon: const Icon(Icons.more_vert, size: 19),
                                color: Theme.of(context).primaryColor,
                                onPressed: () => ProductDetailScreen.showMenu(
                                  context,
                                  widget.product,
                                  isLoading: !hasProductInfo,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      resizeToAvoidBottomInset: false,
                      floatingActionButton: (!ServerConfig().isVendorType() ||
                              !kConfigChat.enableVendorChat)
                          ? null
                          : VendorChat(
                              user: userModel.user,
                              store: product.store,
                              product: product,
                            ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      body: Stack(
                        children: <Widget>[
                          kIsWeb
                              ? const SizedBox()
                              : SizedBox(
                                  height: heightProductImage.toDouble(),
                                  child: ProductGallerrySliderWidget(
                                    product: product,
                                    onChange: (index) {
                                      _selectIndexNotifier.value = index;
                                    },
                                  ),
                                ),
                          DraggableScrollableSheet(
                            initialChildSize: startDraggable,
                            minChildSize: startDraggable,
                            builder: (context, scrollController) => Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValueOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: CustomScrollView(
                                controller: scrollController,
                                slivers: <Widget>[
                                  SliverList(
                                    delegate: SliverChildListDelegate(
                                      <Widget>[
                                        const SizedBox(height: 2),
                                        if (kIsWeb)
                                          ValueListenableBuilder<int>(
                                              valueListenable:
                                                  _selectIndexNotifier,
                                              builder: (context, index, child) {
                                                return ProductGallery(
                                                  product: widget.product,
                                                  selectIndex: index,
                                                );
                                              }),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 4.0,
                                            left: 15,
                                            right: 15,
                                          ),
                                          child: widget.product.isGroupedProduct
                                              ? const SizedBox()
                                              : ProductTitle(product),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (Services().widget.enableShoppingCart(
                                      product.copyWith(isRestricted: false)))
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: AnimatedSize(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: ProductCommonInfo(
                                            product: widget.product,
                                            wrapSliver: false,
                                            isProductInfoLoading:
                                                widget.isProductInfoLoading,
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (!Services().widget.enableShoppingCart(
                                          product.copyWith(
                                              isRestricted: false)) &&
                                      product.shortDescription != null &&
                                      product.shortDescription!.isNotEmpty)
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: ProductShortDescription(product),
                                      ),
                                    ),
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        // horizontal: 15.0,
                                        vertical: 8.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                            ),
                                            child: Column(
                                              children: [
                                                Services()
                                                    .widget
                                                    .renderVendorInfo(product),
                                                Services()
                                                    .renderTiredPriceTable(
                                                        product),
                                                Services()
                                                    .renderCustomInformationTable(
                                                        product),
                                                ProductBrand(
                                                    product: widget.product),
                                                ProductDescription(product),
                                                if (widget
                                                        .isProductInfoLoading ==
                                                    false)
                                                  ProductSizeGuide(
                                                      widget.product),
                                                if (kProductDetail
                                                    .showProductCategories)
                                                  ProductDetailCategories(
                                                      product),
                                                if (kProductDetail
                                                    .showProductTags)
                                                  ProductTag(product),
                                                if (widget
                                                        .isProductInfoLoading ==
                                                    false)
                                                  Services()
                                                      .widget
                                                      .productReviewWidget(
                                                          product),
                                              ],
                                            ),
                                          ),
                                          if (kProductDetail
                                                  .showRelatedProductFromSameStore &&
                                              product.store?.id != null)
                                            RelatedProductFromSameStore(
                                                product),
                                          if (kProductDetail
                                                  .showRelatedProduct &&
                                              widget.isProductInfoLoading ==
                                                  false)
                                            RelatedProduct(product),
                                          if (kProductDetail.showRecentProduct)
                                            RecentProducts(
                                                excludeProduct: product),
                                          const SizedBox(height: 50),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _shoppingCartIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart,
            size: 22,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: const CartScreen(isModal: true),
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(9),
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                totalCart.toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
