import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../models/index.dart';
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../routes/flux_navigate.dart';
import '../../widgets/common/place_picker.dart';
import '../config.dart';
import '../constants.dart';
import '../tools/navigate_tools.dart';

extension AppBarItemConfigExt on AppBarItemConfig {
  FutureOr<T?> onHandleItem<T>(BuildContext context,
      [Map<String, dynamic>? config]) {
    switch (action) {
      case 'home':
        NavigateTools.navigateHome(context);
        break;
      case 'menu':
        NavigateTools.onTapOpenDrawerMenu(context);
        break;
      case 'search':
        FluxNavigate.pushNamed(RouteList.homeSearch,
            arguments: BackDropArguments(config: config), context: context);
        break;
      case 'cart':
        FluxNavigate.pushNamed(RouteList.cart, context: context);
        break;
      case 'location':
        return _onTapAddress(context);
      case 'wishlist':
        FluxNavigate.pushNamed(RouteList.wishlist, context: context);
        break;
      case 'notification':
        FluxNavigate.pushNamed(RouteList.notify, context: context);
        break;
      case 'product':
      case 'category':
      case 'url':
      case 'launch_url':
      case 'blog':
      case 'blog_category':
        if (actionLink?.isNotEmpty ?? false) {
          NavigateTools.onTapNavigateOptions(config: {
            action: actionLink,
          }, context: context);
        }
        break;
      default:
    }

    return null;
  }

  Future<T?> _onTapAddress<T>(BuildContext context) async {
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => isDesktop
            ? const PlatformError()
            : PlacePicker(
                kIsWeb
                    ? kGoogleApiKey.web
                    : isIos
                        ? kGoogleApiKey.ios
                        : kGoogleApiKey.android,
              ),
      ),
    ) as LocationResult?;

    if (result != null) {
      // Get existing address from cart model
      final cartModel = Provider.of<CartModel>(context, listen: false);
      final existingAddress = await cartModel.getAddress();

      // Create new address preserving user info
      final address = Address(
        firstName: existingAddress?.firstName,
        lastName: existingAddress?.lastName,
        email: existingAddress?.email,
        phoneNumber: existingAddress?.phoneNumber,
      );

      // Update location info
      address.country = result.country;
      address.street = result.street;
      address.state = result.state;
      address.city = result.city;
      address.zipCode = result.zip;
      address.latitude = result.latLng?.latitude.toString();
      address.longitude = result.latLng?.longitude.toString();
      address.mapUrl =
          'https://maps.google.com/maps?q=${result.latLng?.latitude},${result.latLng?.longitude}&output=embed';

      return address as T;
    }

    return null;
  }
}
