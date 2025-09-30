import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flux_interface/flux_interface.dart';

import '../models/entities/social_login_type.dart';
import '../models/index.dart';
import 'base_services.dart';
import 'index.dart';

class AuthProviderService {
  final BaseServices api;
  final BaseFirebaseServices firebaseService;

  AuthProviderService({
    required this.api,
    required this.firebaseService,
  });

  Future<User?>? loginApple({
    Uint8List? authorizationCode,
    Uint8List? identityToken,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    return _loginHandler(
      SocialLoginType.apple,
      authorizationCode: authorizationCode,
      identityToken: identityToken,
      firstName: firstName,
      lastName: lastName,
      email: email,
    );
  }

  Future<User?>? loginFacebook({
    AccessToken? accessToken,
    String? email,
    String? rawNonce,
  }) {
    return _loginHandler(
      SocialLoginType.facebook,
      accessToken: accessToken,
      email: email,
      rawNonce: rawNonce,
    );
  }

  Future<User?>? loginGoogle({
    String? token,
    String? email,
    String? displayName,
    String? picture,
  }) {
    return _loginHandler(
      SocialLoginType.google,
      token: token,
      email: email,
      displayName: displayName,
      picture: picture,
    );
  }

  Future<User?>? _loginHandler(
    SocialLoginType type, {
    String? token,
    AccessToken? accessToken,
    String? email,
    String? displayName,
    Uint8List? authorizationCode,
    Uint8List? identityToken,
    String? rawNonce,
    String? firstName,
    String? lastName,
    String? picture,
  }) async {
    final useFirebaseServerless = ServerConfig().isFirebase;

    User? userResult;
    if (useFirebaseServerless) {
      switch (type) {
        case SocialLoginType.apple:
          await firebaseService.loginFirebaseApple(
            authorizationCode: authorizationCode,
            identityToken: identityToken,
          );
          break;
        case SocialLoginType.facebook:
          await firebaseService.loginFirebaseFacebook(
            token: accessToken,
            rawNonce: rawNonce,
          );
        case SocialLoginType.google:
          await firebaseService.loginFirebaseGoogle(token: token);
          break;
        default:
          return null;
      }
      // Delay 0.5 second to wait for the user to be logged in
      await Future.delayed(const Duration(milliseconds: 500));
      userResult = await api.loginSocial(
        type,
        token: token,
        email: email,
        displayName: displayName,
        firstName: firstName,
        lastName: lastName,
        picture: picture,
      );
    } else {
      switch (type) {
        case SocialLoginType.apple:
          final authorizationCodeText =
              String.fromCharCodes(authorizationCode!);
          final identityTokenText = String.fromCharCodes(identityToken!);

          userResult = await api.loginApple(
            token: ServerConfig().isMStoreApiPluginSupported
                ? authorizationCodeText
                : identityTokenText,
            firstName: firstName,
            lastName: lastName,
          );

          unawaited(firebaseService.loginFirebaseApple(
            authorizationCode: authorizationCode,
            identityToken: identityToken,
          ));
          break;
        case SocialLoginType.facebook:
          userResult = await api.loginFacebook(token: accessToken?.tokenString);

          unawaited(firebaseService.loginFirebaseFacebook(
            token: accessToken,
            rawNonce: rawNonce,
          ));
          break;
        case SocialLoginType.google:
          userResult = await api.loginGoogle(token: token);

          unawaited(firebaseService.loginFirebaseGoogle(token: token));
          break;
        default:
          return null;
      }
    }

    return userResult;
  }
}
