import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:random_string/random_string.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import '../common/config.dart';
import '../common/constants.dart';
import '../common/tools.dart';
import '../data/boxes.dart';
import '../services/auth_provider_service.dart';
import '../services/index.dart';
import 'entities/cookie_data.dart';
import 'entities/user.dart';

abstract class UserModelDelegate {
  void onLoaded(User? user);

  void onLoggedIn(User user);

  void onLogout(User? user);
}

class UserModel with ChangeNotifier {
  UserModel();

  final Services _service = Services();
  late final _authProviderService = AuthProviderService(
    api: _service.api,
    firebaseService: _service.firebase,
  );

  User? user;
  bool loggedIn = false;
  bool loading = false;
  UserModelDelegate? userDelegate;

  bool get _isFirebaseServerless => ServerConfig().isFirebase;

  /// Check token expired
  bool isTokenExpired() {
    if (user?.expiresAt == null) {
      return false; // If expiresAt is null, token is not expired
    }

    final now = DateTime.now();
    return now.isAfter(user!.expiresAt!);
  }

  /// Hiển thị thông báo token hết hạn và đăng xuất
  Future<void> handleExpiredToken(VoidCallback showNotiticationExpired) async {
    if (isTokenExpired() && loggedIn) {
      await logout();

      showNotiticationExpired();
    }
  }

  Future<String?> submitForgotPassword(
      {String? forgotPwLink, Map<String, dynamic>? data}) async {
    return await _service.api
        .submitForgotPassword(forgotPwLink: forgotPwLink, data: data);
  }

  /// Login by apple, This function only test on iPhone
  Future<void> loginApple({Function? success, Function? fail, context}) async {
    try {
      final result = await apple.TheAppleSignIn.performRequests([
        const apple.AppleIdRequest(
            requestedScopes: [apple.Scope.email, apple.Scope.fullName])
      ]);

      switch (result.status) {
        case apple.AuthorizationStatus.authorized:
          {
            user = await _authProviderService.loginApple(
              authorizationCode: result.credential!.authorizationCode!,
              identityToken: result.credential!.identityToken!,
              firstName: result.credential?.fullName?.givenName,
              lastName: result.credential?.fullName?.familyName,
              email: result.credential?.email,
            );

            await _saveUser(user);
            success!(user);

            notifyListeners();
          }
          break;

        case apple.AuthorizationStatus.error:
          fail!(S.of(context).errorMsg(result.error!));
          break;
        case apple.AuthorizationStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
      }
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Firebase phone
  Future<void> loginFirebaseSMS(
      {String? phoneNumber,
      required Function success,
      Function? fail,
      required BuildContext context}) async {
    try {
      user = await _service.api.loginSMS(token: phoneNumber);
      await _saveUser(user);
      success(user);

      notifyListeners();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  /// Login by Facebook
  Future<void> loginFB({Function? success, Function? fail, context}) async {
    try {
      // https://github.com/firebase/flutterfire/issues/12713#issuecomment-2120086471
      // https://github.com/darwin-morocho/flutter-facebook-auth/issues/428
      final rawNonce = StringTools.generateNonce();
      final nonce = StringTools.sha256ofString(rawNonce);

      final result = await FacebookAuth.instance.login(nonce: nonce);
      switch (result.status) {
        case LoginStatus.success:
          final accessToken = result.accessToken;
          user = await _authProviderService.loginFacebook(
            accessToken: accessToken,
            rawNonce: rawNonce,
            email: accessToken is LimitedToken ? accessToken.userEmail : null,
          );

          await _saveUser(user);
          success!(user);
          break;
        case LoginStatus.cancelled:
          fail!(S.of(context).loginCanceled);
          break;
        default:
          fail!(result.message);
          break;
      }
      notifyListeners();
    } catch (err) {
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> loginGoogle({Function? success, Function? fail, context}) async {
    try {
      var googleSignIn = GoogleSignIn(scopes: ['email']);

      /// Need to disconnect or cannot login with another account.
      try {
        await googleSignIn.disconnect();
      } catch (_) {
        // ignore.
      }

      var res = await googleSignIn.signIn();

      if (res == null) {
        fail!(S.of(context).loginCanceled);
      } else {
        var auth = await res.authentication;
        user = await _authProviderService.loginGoogle(
          token: auth.accessToken,
          email: res.email,
          displayName: res.displayName,
          picture: res.photoUrl,
        );
        await _saveUser(user);
        success!(user);
        notifyListeners();
      }
    } catch (err, trace) {
      printError(err, trace);
      fail!(S.of(context).loginErrorServiceProvider(err.toString()));
    }
  }

  Future<void> loginWithCookie(
    String cookie, {
    Function? success,
    Function? fail,
    context,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.api.getUserInfo(cookie);

      if (user == null) {
        final cookies = cookie.convertToCookies();
        final hasInfoUser = cookies.any((element) =>
            ['pro_loyalty_api_session', 'customer_sig']
                .contains(element.name) &&
            element.value.isNotEmpty);

        if (hasInfoUser) {
          printLog('[loginWithUserWebAccess]:[ROUTE:] recheck cookie');
          await Future.delayed(const Duration(seconds: 2));
          user = await _service.api.getUserInfo(cookie);
        }

        if (user == null) {
          if (hasInfoUser) {
            throw Exception(ErrorKeyConstant.registerUnableToSyncAccount.name);
          }

          throw Exception(ErrorKeyConstant.registerInvalid.name);
        }
      }

      user!.cookie = cookie;

      await _saveUser(user);
      success?.call(user!);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail?.call(err.toString());
      notifyListeners();
    }
  }

  Future<void> _saveUser(User? user) async {
    try {
      if (Services().firebase.isEnabled && ServerConfig().isVendorType()) {
        Services().firebase.saveUserToFirestore(user: user);
      }

      // save to Preference
      final hasUser = user != null;
      UserBox().isLoggedIn = hasUser;
      loggedIn = hasUser;

      // save the user Info as local storage
      UserBox().userInfo = user;
      this.user = user;
      userDelegate?.onLoaded(user);

      //reload Home screen to show product price based on role
      if ((kAdvanceConfig.enableWooCommerceWholesalePrices ||
              kAdvanceConfig.b2bKingConfig.enabled) &&
          ServerConfig().isWooPluginSupported) {
        eventBus.fire(const EventLoadedAppConfig());
      }
    } catch (err) {
      printLog(err);
    }
  }

  Future<void> getUser() async {
    try {
      final localUser = UserBox().userInfo;
      if (localUser != null) {
        final userInfo = await _service.api.getUserInfo(localUser.cookie);

        if (userInfo != null) {
          userInfo.isSocial = localUser.isSocial;
          user = userInfo;
        } else {
          user = null;
        }

        await setUser(user, acceptNull: true);
      } else {
        if (kPaymentConfig.guestCheckout &&
            ServerConfig().isNeedToGenerateTokenForGuestCheckout) {
          userDelegate?.onLoaded(User()..cookie = _getGenerateCookie());
        } else {
          userDelegate?.onLoaded(null);
        }
        notifyListeners();
      }
    } catch (err) {
      printLog(err);
    }
  }

  void setLoading(bool isLoading) {
    loading = isLoading;
    notifyListeners();
  }

  Future<void> setUser(User? user, {bool acceptNull = false}) async {
    if (user != null || acceptNull) {
      this.user = user;
      await _saveUser(user);
      if (ServerConfig().isHaravan && ['null', null].contains(user?.id)) {
        UserBox().isLoggedIn = false;
        loggedIn = false;
        user?.id = null;
      }

      notifyListeners();
    }
  }

  Future<void> createUser({
    String? username,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    bool? isVendor,
    bool? isDelivery,
    bool? isOwner,
    required Function success,
    Function? fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      final isValidAccount =
          (email?.isEmail ?? false) && (password?.isNotEmpty ?? false);

      Future<void> loginAccountFirebase() async => Services()
          .firebase
          .createUserWithEmailAndPassword(email: email, password: password);

      if (_isFirebaseServerless && isValidAccount) {
        await loginAccountFirebase();
        // Delay 1 second to wait for the user to be logged in
        await Future.delayed(const Duration(milliseconds: 500));
      }

      user = await _service.api.createUser(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        isVendor: isVendor ?? false,
        isDelivery: isDelivery ?? false,
        isOwner: isOwner ?? false,
      );

      if (_isFirebaseServerless == false) {
        unawaited(loginAccountFirebase());
      }

      await _saveUser(user);
      success(user);

      loading = false;
      notifyListeners();
    } catch (err, trace) {
      fail!(err.toString());
      printError(err, trace);
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    loggedIn = false;
    try {
      unawaited(Services().firebase.signOut());
      unawaited(FacebookAuth.instance.logOut());
    } catch (err) {
      printLog(err);
    }

    userDelegate?.onLogout(user);
    unawaited(_service.api.logout(user?.cookie));
    user = null;

    if (kPaymentConfig.guestCheckout &&
        ServerConfig().isNeedToGenerateTokenForGuestCheckout) {
      userDelegate?.onLoaded(User()..cookie = _getGenerateCookie());
    }

    UserBox().cleanUpForLogout();
    notifyListeners();

    //reload Home screen to show correct product price without basing on role
    if ((kAdvanceConfig.enableWooCommerceWholesalePrices ||
            kAdvanceConfig.b2bKingConfig.enabled) &&
        ServerConfig().isWooPluginSupported) {
      eventBus.fire(const EventLoadedAppConfig());
    }
  }

  Future<void> login({
    required String username,
    required String password,
    required Function(User user) success,
    required Function(String message) fail,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.api.login(
        username: username,
        password: password,
      );

      if (user == null) {
        throw 'Something went wrong!!!';
      }

      if (_isFirebaseServerless == false) {
        final userEmail =
            (user?.email?.isNotEmpty ?? false) ? user?.email : username;

        unawaited(
          Services().firebase.loginFirebaseEmail(
                email: userEmail,
                password: password,
              ),
        );
      }
      await _saveUser(user);
      success(user!);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
      notifyListeners();
    }
  }

  Future<void> loginWithCustomerAccountShopify({
    required Function(User user) success,
    required Function(String message) fail,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      notifyListeners();
      user = await _service.api.loginWithCustomerAccount();

      if (user == null) {
        throw 'Something went wrong!!!';
      }
      await _saveUser(user);
      success(user!);
      loading = false;
      notifyListeners();
    } catch (err) {
      loading = false;
      fail(err.toString());
      notifyListeners();
    }
  }

  /// Use for generate fake cookie for guest check out
  String _getGenerateCookie() {
    var cookie = UserBox().userCookie;
    cookie ??= 'OCSESSID=${randomNumeric(30)}; PHPSESSID=${randomNumeric(30)}';
    UserBox().userCookie = cookie;
    return cookie;
  }
}
