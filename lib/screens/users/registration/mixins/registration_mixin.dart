import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../../common/config.dart';
import '../../../../common/constants.dart';
import '../../../../common/tools/flash.dart';
import '../../../../models/app_model.dart';
import '../../../../models/cart/cart_base.dart';
import '../../../../models/entities/user.dart';
import '../../../../models/point_model.dart';
import '../../../../models/user_model.dart';
import '../../../../modules/vendor_on_boarding/screen_index.dart';
import '../../../../services/services.dart';

mixin RegistrationMixin<T extends StatefulWidget> on State<T> {
  bool isChecked = true;

  Future<void> submitRegister({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? username,
    String? emailAddress,
    String? password,
    bool? isVendor,
  }) async {
    // invalid user info when required info is true
    final isInvalidUserInfo = firstName.isEmptyOrNull ||
        lastName.isEmptyOrNull ||
        emailAddress.isEmptyOrNull ||
        password.isEmptyOrNull;

    // invalid phone number when showPhoneNumberWhenRegister is true
    // and requirePhoneNumberWhenRegister is true
    final isInvalidPhoneNumber = kLoginSetting.showPhoneNumberWhenRegister &&
        kLoginSetting.requirePhoneNumberWhenRegister &&
        phoneNumber.isEmptyOrNull;

    // invalid username when requireUsernameWhenRegister is true
    final isInvalidUsername =
        kLoginSetting.requireUsernameWhenRegister && username.isEmptyOrNull;

    if (isInvalidPhoneNumber || isInvalidUserInfo || isInvalidUsername) {
      _showMessage(S.of(context).pleaseInputFillAllFields);
    } else if (isChecked == false) {
      _showMessage(S.of(context).pleaseAgreeTerms);
    } else {
      if (!emailAddress.validateEmail()) {
        _showMessage(S.of(context).errorEmailFormat);
        return;
      }

      if (password != null && password.length < 8) {
        _showMessage(S.of(context).errorPasswordFormat);
        return;
      }

      await Provider.of<UserModel>(context, listen: false).createUser(
        username: username,
        email: emailAddress,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        success: _welcomeDiaLog,
        fail: _showMessage,
        isVendor: isVendor,
      );
    }
  }

  void _welcomeDiaLog(User user) {
    Provider.of<CartModel>(context, listen: false).setUser(user);
    Provider.of<PointModel>(context, listen: false).getMyPoint(user.cookie);
    final model = Provider.of<UserModel>(context, listen: false);

    /// Show VendorOnBoarding.
    if (kVendorConfig.vendorRegister &&
        Provider.of<AppModel>(context, listen: false).isMultiVendor &&
        user.isVender) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => VendorOnBoarding(
            user: user,
            onFinish: () {
              model.getUser();
              var email = user.email;
              _showMessage(
                '${S.of(ctx).welcome} $email!',
                isError: false,
              );
              var routeFound = false;
              var routeNames = [RouteList.dashboard, RouteList.productDetail];
              Navigator.popUntil(ctx, (route) {
                if (routeNames.any((element) =>
                    route.settings.name?.contains(element) ?? false)) {
                  routeFound = true;
                }
                return routeFound || route.isFirst;
              });

              if (!routeFound) {
                Navigator.of(ctx).pushReplacementNamed(RouteList.dashboard);
              }
            },
          ),
        ),
      );
      return;
    }

    var email = user.email;
    _showMessage(
      '${S.of(context).welcome} $email!',
      isError: false,
    );
    if (Services().widget.isRequiredLogin) {
      Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
      return;
    }
    var routeFound = false;
    var routeNames = [RouteList.dashboard, RouteList.productDetail];
    Navigator.popUntil(context, (route) {
      if (routeNames
          .any((element) => route.settings.name?.contains(element) ?? false)) {
        routeFound = true;
      }
      return routeFound || route.isFirst;
    });

    // if (!routeFound) {
    //   Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
    // }
  }

  void _showMessage(
    String text, {
    bool isError = true,
  }) {
    if (!mounted) {
      return;
    }
    FlashHelper.message(
      context,
      message: text,
      isError: isError,
    );
  }
}
