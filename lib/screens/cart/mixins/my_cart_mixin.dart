import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/extensions/extensions.dart';
import '../../../common/tools/biometrics_tools.dart';
import '../../../common/tools/flash.dart';
import '../../../common/tools/navigate_tools.dart';
import '../../../common/tools/price_tools.dart';
import '../../../menu/maintab_delegate.dart';
import '../../../models/index.dart';
import '../../../modules/analytics/analytics.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/service_config.dart';
import '../../../services/services.dart';
import '../../../widgets/product/cart_item/cart_item.dart';
import '../../../widgets/product/cart_item/cart_item_state_ui.dart';
import '../../../widgets/product/product_bottom_sheet.dart';
import '../../../widgets/vendor/store_item.dart';
import '../../checkout/checkout_screen.dart';

mixin MyCartMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  String errMsg = '';

  bool? get isModal;

  CartModel get cartModel => Provider.of<CartModel>(context, listen: false);

  void _loginWithResult(BuildContext context) async {
    await NavigateTools.navigateToLogin(
      context,
    );

    final user = Provider.of<UserModel>(context, listen: false).user;
    if (user != null && user.name != null) {
      Tools.showSnackBar(ScaffoldMessenger.of(context),
          '${S.of(context).welcome} ${user.name} !');
      setState(() {});
    }
  }

  Future<void> clearCartPopup(BuildContext context) async {
    final confirmed = await context.showFluxDialogText(
      title: S.of(context).notice,
      body: S.of(context).confirmClearTheCart,
      primaryAction: S.of(context).clear,
      secondaryAction: S.of(context).keep,
      primaryAsDestructiveAction: true,
      directionButton: Axis.vertical,
    );
    if (confirmed) {
      await cartModel.clearCart();
    }
  }

  void onCheckout(CartModel model) {
    var isLoggedIn = Provider.of<UserModel>(context, listen: false).loggedIn;
    final appModel = Provider.of<AppModel>(context, listen: false);
    final currencyRate = appModel.currencyRate;
    final currency = appModel.currency;

    var message;

    if (isLoading) return;

    // Check global minimum cart value
    if (kCartDetail['minAllowTotalCartValue'] != null) {
      if (kCartDetail['minAllowTotalCartValue'].toString().isNotEmpty) {
        var totalValue = model.getSubTotal() ?? 0;
        var minValue = PriceTools.getCurrencyFormatted(
            kCartDetail['minAllowTotalCartValue'], currencyRate,
            currency: currency);
        if (totalValue < kCartDetail['minAllowTotalCartValue'] &&
            model.totalCartQuantity > 0) {
          message = '${S.of(context).totalCartValue} $minValue';
        }
      }
    }

    // Check multi vendor
    if (kVendorConfig.disableMultiVendorCheckout &&
        ServerConfig().isVendorType() &&
        message == null) {
      if (!model.isDisableMultiVendorCheckoutValid(
          model.productsInCart, model.getProductById)) {
        message = S.of(context).youCanOnlyOrderSingleStore;
      }
    }

    // Check vendor-specific minimum order amounts
    if (message == null && ServerConfig().isVendorType()) {
      var (minOrderAmount, storeName) = model.getVendorWiseCartTotal();
      final minValue = PriceTools.getCurrencyFormatted(
          minOrderAmount, currencyRate,
          currency: currency);
      if (minValue != null && storeName != null) {
        message = S.of(context).minOrderAmount(storeName, minValue);
      }
    }

    if (message != null) {
      FlashHelper.errorMessage(context, message: message);
      return;
    }

    if (model.totalCartQuantity == 0) {
      if (isModal == true) {
        try {
          ExpandingBottomSheet.of(context)!.close();
        } catch (e) {
          Navigator.of(context).pushNamed(RouteList.dashboard);
        }
      } else {
        final modalRoute = ModalRoute.of(context);
        if (modalRoute?.canPop ?? false) {
          Navigator.of(context).pop();
        }

        MainTabControlDelegate.getInstance().changeToDefaultTab();
      }
    } else if (isLoggedIn || kPaymentConfig.guestCheckout) {
      doCheckout();
    } else {
      _loginWithResult(context);
    }
  }

  Future<void> doCheckout() async {
    if (BiometricsTools.instance.isCheckoutSupported) {
      var didAuth = await BiometricsTools.instance.localAuth(context);
      if (!didAuth) {
        return;
      }
    }
    showLoading();

    await Services().widget.doCheckout(
      context,
      success: () async {
        hideLoading('');

        if (ServerConfig().isHaravan) {
          return FluxNavigate.pushNamed(
            RouteList.checkoutWithWebview,
            context: context,
            forceRootNavigator: true,
          ).then((value) => NavigateTools.redirect(context, value));
        }

        var manualClosed = await FluxNavigate.pushNamed(
          RouteList.checkout,
          arguments: CheckoutArgument(isModal: isModal),
          forceRootNavigator: true,
          context: context,
        );

        if (true == manualClosed) {
          if (isModal == true) {
            try {
              ExpandingBottomSheet.of(context)!.close();
            } catch (e) {
              if (ModalRoute.of(context)?.canPop ?? false) {
                Navigator.of(context).pop();
              } else {
                await Navigator.of(context).pushNamed(RouteList.dashboard);
              }
            }
          } else if (ModalRoute.of(context)?.canPop ?? false) {
            Navigator.of(context).pop();
          }
        }
      },
      error: (message) async {
        if (message ==
            Exception('Token expired. Please logout then login again')
                .toString()) {
          setState(() {
            isLoading = false;
          });
          //logout
          final userModel = Provider.of<UserModel>(context, listen: false);
          await userModel.logout();
          await Services().firebase.signOut();

          _loginWithResult(context);
        } else {
          hideLoading(message);
          Future.delayed(const Duration(seconds: 3), () {
            setState(() => errMsg = '');
          });
        }
      },
      loading: (isLoading) {
        setState(() {
          this.isLoading = isLoading;
        });
      },
    );
  }

  void showLoading() {
    setState(() {
      isLoading = true;
      errMsg = '';
    });
  }

  void hideLoading(error) {
    setState(() {
      isLoading = false;
      errMsg = error;
    });
  }

  void onPressedClose(String layoutType, bool? isBuyNow) {
    if (isBuyNow!) {
      Navigator.of(context).pop();
      return;
    }

    if (Navigator.of(context).canPop() &&
        ['simpleType', 'flatStyle'].contains(layoutType) == false) {
      Navigator.of(context).pop();
    } else {
      ExpandingBottomSheet.of(context, isNullOk: true)?.close();
    }
  }

  List<Widget> createShoppingCartRows(
    CartModel model,
    BuildContext context,
    bool enabledTextBoxQuantity, {
    CartStyle? cartStyle,
  }) {
    if (!model.isWalletCart()) {
      model.productsInCart.forEach((key, _) async {
        // Is variant product
        var productId = Product.cleanProductID(key);
        var isVariation = model.cartItemMetaDataInCart[key]?.variation != null;
        if (isVariation) {
          var productVariation = model.getProductVariationById(key);
          var updatedProduct = await Services()
              .api
              .getVariationProduct(productId, productVariation?.id);
          model.updateProductVariant(key, updatedProduct);
        } else {
          // Try to load product instead of listing because the cart cannot add
          // listing products
          var updatedProduct =
              await Services().api.overrideGetProduct(productId);
          model.updateProduct(productId, updatedProduct);
        }
        model.updateStateCheckoutButton();
      });
    }

    var productList = {};
    var groupedItems = groupCartItems(model);
    var productListWidget = <Widget>[];
    if (groupedItems.length > 1) {
      productListWidget = groupedItems.map((GroupedStoreItems item) {
        return Column(
          children: [
            StoreCartItem(store: item.store),
            ...item.itemKeys.map((key) => renderCartItemByKey(context, key,
                model, productList, true, enabledTextBoxQuantity, cartStyle)),
            const SizedBox(height: 10.0),
            Container(color: kGrey200, height: 10),
            const SizedBox(height: 10.0),
          ],
        );
      }).toList();
    } else {
      productListWidget = model.productsInCart.keys.map(
        (key) {
          return renderCartItemByKey(
            context,
            key,
            model,
            productList,
            false,
            enabledTextBoxQuantity,
            cartStyle,
          );
        },
      ).toList();
    }

    Analytics.triggerViewCart(productList, context);

    return productListWidget;
  }

  Widget renderCartItemByKey(
    BuildContext context,
    String key,
    CartModel model,
    Map productList,
    bool multiStore,
    bool enabledTextBoxQuantity,
    CartStyle? cartStyle,
  ) {
    var productId = Product.cleanProductID(key);
    var product = model.getProductById(productId);

    if (product != null) {
      productList[key] = {
        'id': key,
        'product': product,
        'quantity': model.productsInCart[key]
      };

      return ShoppingCartRow(
        enabledTextBoxQuantity: enabledTextBoxQuantity,
        enableBottomDivider: !multiStore,
        enableTopDivider: multiStore,
        cartStyle: cartStyle ?? kCartDetail['style'].toString().toCartStyle(),
        showStoreName: !multiStore,
        product: product,
        cartItemMetaData: model.cartItemMetaDataInCart[key]
            ?.copyWith(variation: model.getProductVariationById(key)),
        quantity: model.productsInCart[key],
        onRemove: () {
          Analytics.triggerRemoveProductFromCart(product, context);
          model.removeItemFromCart(key);
        },
        onChangeQuantity: (val) {
          var message = model.updateQuantity(product, key, val);
          if (message.isNotEmpty) {
            final snackBar = SnackBar(
              content: Text(message),
              duration: Duration(
                  milliseconds: kAdvanceConfig.timeShowToastMessage ?? 1000),
            );
            Future.delayed(
              const Duration(milliseconds: 300),
              () => ScaffoldMessenger.of(context).showSnackBar(snackBar),
            );

            return false;
          }
          return true;
        },
      );
    }
    return const SizedBox();
  }

  List<GroupedStoreItems> groupCartItems(CartModel model) {
    var groupedItems = <GroupedStoreItems>[];
    for (var key in model.productsInCart.keys) {
      var productId = Product.cleanProductID(key);
      var product = model.getProductById(productId);
      if (product?.store?.id != null) {
        var groupedItem = groupedItems
            .firstWhereOrNull((item) => item.store?.id == product?.store?.id);
        if (groupedItem != null) {
          groupedItem.itemKeys.add(key);
        } else {
          groupedItems
              .add(GroupedStoreItems(store: product?.store, itemKeys: [key]));
        }
      }
    }
    return groupedItems;
  }
}

class GroupedStoreItems {
  const GroupedStoreItems({this.store, required this.itemKeys});
  final Store? store;
  final List<String> itemKeys;
}
