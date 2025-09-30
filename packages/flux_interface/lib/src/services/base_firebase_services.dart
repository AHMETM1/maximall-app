import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:fstore/models/entities/product.dart';
import 'package:fstore/models/entities/user.dart';

import '../entities/firebase_error_exception.dart';
import '../entities/flux_firebase_option.dart';
import 'firebase_analytics_service.dart';

class BaseFirebaseServices {
  /// check if the Firebase is enable or not
  bool get isEnabled => false;

  FirebaseAnalyticsService? get firebaseAnalytics => null;

  Future<void> init({FluxFirebaseOption? option, String? name}) async {}

  dynamic getCloudMessaging() {}

  String? getCurrentUserId() => null;

  /// Login Firebase with social account
  Future<void> loginFirebaseApple({authorizationCode, identityToken}) async {}

  Future<void> loginFirebaseFacebook({token, rawNonce}) async {}

  Future<void> loginFirebaseGoogle({token}) async {}

  Future<void> loginFirebaseEmail({email, password}) async {}

  dynamic loginFirebaseCredential({credential}) {}

  dynamic getFirebaseCredential({verificationId, smsCode}) {}

  /// save user to firebase
  void saveUserToFirestore({User? user}) {}

  /// verify SMS login
  dynamic getFirebaseStream() {}

  Future<void> verifyPhoneNumber({
    phoneNumber,
    codeAutoRetrievalTimeout,
    codeSent,
    required void Function(String?) verificationCompleted,
    void Function(FirebaseErrorException error)? verificationFailed,
    forceResendingToken,
    Duration? timeout,
  }) async {}

  /// render Chat Screen
  Widget renderChatScreen({
    User? senderUser,
    String? receiverEmail,
    String? receiverName,
    Product? product,
  }) =>
      const SizedBox();

  /// load firebase remote config
  Future<bool> loadRemoteConfig() async => false;

  String getRemoteConfigString(String key) => '';

  Future<List<String>> getRemoteKeys() async => [];

  /// register new user with email and password
  Future<void> createUserWithEmailAndPassword({email, password}) async {}

  Future<void> signOut() async {}

  Future<String?> getMessagingToken() async => '';

  List<NavigatorObserver> getMNavigatorObservers() =>
      const <NavigatorObserver>[];

  void deleteAccount() {}

  Future<String?>? getIdToken() => null;
}
