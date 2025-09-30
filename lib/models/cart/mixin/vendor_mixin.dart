import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/tools.dart';
import '../../../services/service_config.dart';
import '../../entities/product.dart';
import '../../vendor/vendor_shipping_model.dart';
import '../cart_base.dart';
import 'cart_mixin.dart';

mixin VendorMixin on CartMixin {
  List<VendorShippingMethod> selectedShippingMethods = [];

  void setSelectedMethods(List<VendorShippingMethod> selected) {
    selectedShippingMethods = selected;
  }

  bool isDisableMultiVendorCheckoutValid(
    Map<String, int?> productsInCart,
    Product? Function(String) getProductById,
  ) {
    var isValid = true;
    var storeId;
    if (productsInCart.keys.isNotEmpty) {
      for (var key in productsInCart.keys) {
        var id = Product.cleanProductID(key);
        final product = getProductById(id);
        if (storeId == null) {
          storeId = product?.store?.id;
        } else {
          if (storeId != product?.store?.id) {
            isValid = false;
          }
        }
      }
    }
    return isValid;
  }

  bool isAddingProductFromMultiVendorToCart(Product? product) {
    if (productsInCart.keys.isNotEmpty) {
      for (var key in productsInCart.keys) {
        final id = Product.cleanProductID(key);
        final productInCart = getProductById(id);
        final storeId = productInCart?.store?.id;
        if (storeId != product?.store?.id) {
          return true;
        }
      }
    }
    return false;
  }

  /// Returns a future that resolves with a tuple of a boolean and a string. The
  /// boolean indicates whether the product was able to continue adding to the
  /// cart. The string is an error message if the product was not added.
  Future<(bool, String)> checkMultiVendorDetected(
      BuildContext context, Product product) async {
    if (kVendorConfig.disableMultiVendorCheckout &&
        ServerConfig().isVendorType()) {
      if (isAddingProductFromMultiVendorToCart(product)) {
        if (kVendorConfig.showPopUpIfMultiVendorDetected) {
          final isClearCart = await _multiVendorDetectedPopup(context);

          // If user do not clear cart or just close the popup, and disable
          // multi vendor checkout, return add to cart failed and do nothing,
          // without any error message.
          //
          // If user do not clear cart or just close the popup, but enable multi
          // vendor checkout, return add to cart successed.
          if (!isClearCart && kVendorConfig.disableMultiVendorCheckout) {
            return (false, '');
          }
        } else {
          return (false, S.of(context).youCanOnlyOrderSingleStore);
        }
      }
    }
    return (true, '');
  }

  /// Return true if user clear cart
  Future<bool> _multiVendorDetectedPopup(BuildContext context) async {
    var isClearCart = false;
    if (kVendorConfig.disableMultiVendorCheckout) {
      isClearCart = await context.showFluxDialogText(
        title: S.of(context).multipleSellersDetected,
        body: S
            .of(context)
            .multipleSellersDetectedAndDisableMultiVendorCheckoutContent,
        primaryAction: S.of(context).clearCartAndAddNew,
        secondaryAction: S.of(context).cancel,
        primaryAsDestructiveAction: true,
        directionButton: Axis.vertical,
      );
    } else {
      isClearCart = await context.showFluxDialogText(
        title: S.of(context).multipleSellersDetected,
        body: S
            .of(context)
            .multipleSellersDetectedAndEnableMultiVendorCheckoutContent,
        primaryAction: S.of(context).clearCartAndAddNew,
        secondaryAction: S.of(context).continues,
        primaryAsDestructiveAction: true,
        directionButton: Axis.vertical,
      );
    }

    if (isClearCart) {
      await context.read<CartModel>().clearCart();
      return true;
    }

    return false;
  }

  /// Check vendor-specific minimum order amount for each vendor
  /// Return a tuple of minimum order amount and store name
  (double?, String?) getVendorWiseCartTotal() {
    final vendorWiseCartTotal = <dynamic, double>{};

    for (final key in productsInCart.keys) {
      final productId = Product.cleanProductID(key);
      final product = getProductById(productId);
      final vendorId = product?.store?.id;

      if (vendorId != null) {
        // Calculate product price
        final productPrice = getProductPrice(key);

        // Add to vendor total
        vendorWiseCartTotal[vendorId] =
            (vendorWiseCartTotal[vendorId] ?? 0) + productPrice;
      }
    }

    if (vendorWiseCartTotal.isNotEmpty) {
      for (final entry in vendorWiseCartTotal.entries) {
        final vendorId = entry.key;
        final cartTotal = entry.value;

        // Get the product to access the store
        Store? store;
        for (final key in productsInCart.keys) {
          final productId = Product.cleanProductID(key);
          final product = getProductById(productId);
          if (product?.store?.id == vendorId) {
            store = product?.store;
            break;
          }
        }

        if (store != null &&
            store.minOrderAmount != null &&
            store.minOrderAmount! > 0) {
          if (cartTotal < store.minOrderAmount!) {
            return (store.minOrderAmount!, store.name ?? '');
          }
        }
      }
    }

    return (null, null);
  }
}
