import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:fstore/common/config.dart';
import 'package:fstore/common/constants.dart';
import 'package:fstore/common/tools.dart';
import 'package:fstore/models/entities/product.dart';
import 'package:fstore/models/entities/user.dart';
import 'package:fstore/services/index.dart';

import '../firebase_service_factory.dart';
import '../realtime_chat/realtime_chat.dart';

class FirebaseServices extends BaseFirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._internal();

  factory FirebaseServices() => _instance;

  FirebaseServices._internal();

  bool _isEnabled = false;

  FirebaseApp? _app;

  FirebaseApp get app => _app ?? Firebase.app();

  @override
  bool get isEnabled => _isEnabled;

  @override
  Future<void> init({FluxFirebaseOption? option, String? name}) async {
    var startTime = DateTime.now();
    await _app?.delete();
    _app = await FirebaseServiceFactory.create<FirebaseCoreService>()
        ?.initializeApp(
      option: option,
      name: name,
    );
    _isEnabled = kAdvanceConfig.enableFirebase;

    /// Not require Play Services
    /// https://firebase.google.com/docs/android/android-play-services
    _authService = FirebaseServiceFactory.createAuthService(app);

    if (kFirebaseAnalyticsConfig['enableFirebaseAnalytics'] == true) {
      _firebaseAnalytics = FirebaseServiceFactory.createAnalyticsService(app)!
        ..init(
          adStorageConsentGranted:
              kFirebaseAnalyticsConfig['adStorageConsentGranted'],
          analyticsStorageConsentGranted:
              kFirebaseAnalyticsConfig['analyticsStorageConsentGranted'],
          adPersonalizationSignalsConsentGranted: kFirebaseAnalyticsConfig[
              'adPersonalizationSignalsConsentGranted'],
          adUserDataConsentGranted:
              kFirebaseAnalyticsConfig['adUserDataConsentGranted'],
          functionalityStorageConsentGranted:
              kFirebaseAnalyticsConfig['functionalityStorageConsentGranted'],
          personalizationStorageConsentGranted:
              kFirebaseAnalyticsConfig['personalizationStorageConsentGranted'],
          securityStorageConsentGranted:
              kFirebaseAnalyticsConfig['securityStorageConsentGranted'],
        );
    } else {
      _firebaseAnalytics = FirebaseAnalyticsService()..init();
    }

    if (!kIsWeb) {
      _remoteConfigService = FirebaseServiceFactory.createRemoteServices(app);
    }

    /// Require Play Services
    const message = '[FirebaseServices] Init successfully';
    if (GmsCheck().isGmsAvailable) {
      _messaging = FirebaseMessaging.instance;
      printLog(message, startTime);
    } else {
      printLog('$message (without Google Play Services)', startTime);
    }
  }

  /// Firebase Cloud Firestore
  FirebaseFirestore get firestore => FirebaseFirestore.instanceFor(app: app);

  FirebaseAuth get firebaseAuth => FirebaseAuth.instanceFor(app: app);

  // ignore: deprecated_member_use
  FirebaseDynamicLinks get firebaseDynamicLinks =>
      // ignore: deprecated_member_use
      FirebaseDynamicLinks.instanceFor(app: app);

  /// Firebase Messaging
  FirebaseMessaging? _messaging;

  FirebaseMessaging? get messaging => _messaging;

  /// Firebase Auth
  FirebaseAuthService? _authService;

  FirebaseAuthService? get auth => _authService;

  /// Firebase Remote Config
  FirebaseRemoteServices? _remoteConfigService;

  FirebaseRemoteServices? get remoteConfig => _remoteConfigService;

  /// Firebase Analytics
  FirebaseAnalyticsService? _firebaseAnalytics;

  @override
  FirebaseAnalyticsService? get firebaseAnalytics => _firebaseAnalytics;

  @override
  void deleteAccount() {
    _messaging?.deleteToken();
    _authService?.deleteAccount();
  }

  @override
  Future<void> loginFirebaseApple({authorizationCode, identityToken}) async {
    if (FirebaseServices().isEnabled) {
      await _authService?.loginFirebaseApple(
          authorizationCode: authorizationCode, identityToken: identityToken);
    }
  }

  @override
  Future<void> loginFirebaseFacebook({token, rawNonce}) async {
    if (FirebaseServices().isEnabled) {
      await _authService?.loginFirebaseFacebook(
          token: token, rawNonce: rawNonce);
    }
  }

  @override
  Future<void> loginFirebaseGoogle({token}) async {
    if (FirebaseServices().isEnabled) {
      await _authService?.loginFirebaseGoogle(token: token);
    }
  }

  @override
  Future<void> loginFirebaseEmail({email, password}) async {
    if (FirebaseServices().isEnabled) {
      await _authService?.loginFirebaseEmail(email: email, password: password);
    }
  }

  @override
  Future<User?>? loginFirebaseCredential({credential}) {
    return _authService!.loginFirebaseCredential(credential: credential);
  }

  @override
  void saveUserToFirestore({User? user}) async {
    final token = await messaging?.getToken();
    printLog('token: $token');
    final docPath = (user?.email?.isNotEmpty ?? false) ? user?.email : user?.id;
    await firestore.collection('users').doc(docPath).set(
      {'deviceToken': token, 'isOnline': true},
      SetOptions(merge: true),
    );
    if (GmsCheck().isGmsAvailable) {
      try {
        await Services()
            .api
            .updateUserInfo({'deviceToken': token}, user!.cookie);
      } catch (err, trace) {
        printError(err, trace);
      }
    }
  }

  @override
  dynamic getFirebaseCredential({verificationId, smsCode}) {
    return _authService?.getFirebaseCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  StreamController<String?>? getFirebaseStream() {
    return _authService!.getFirebaseStream();
  }

  @override
  Future<void> verifyPhoneNumber({
    phoneNumber,
    codeAutoRetrievalTimeout,
    codeSent,
    required void Function(String?) verificationCompleted,
    void Function(FirebaseErrorException error)? verificationFailed,
    forceResendingToken,
    Duration? timeout,
  }) async {
    await _authService!.verifyPhoneNumber(
      phoneNumber: phoneNumber!,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      codeSent: codeSent,
      timeout: timeout ?? const Duration(seconds: 120),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      forceResendingToken: forceResendingToken,
    );
  }

  @override
  Widget renderChatScreen({
    User? senderUser,
    String? receiverEmail,
    String? receiverName,
    Product? product,
  }) {
    final isMvApp =
        ServerConfig().isVendorType() || ServerConfig().isVendorManagerType();

    final email = senderUser?.email;
    if (senderUser == null || email == null) {
      return const ChatAuth();
    }

    /// MV: Customer to Vendor.
    if (isMvApp &&
        email != receiverEmail &&
        receiverEmail != null &&
        receiverName != null) {
      var initMessage;
      if (product != null) {
        initMessage = product.name ?? '';
        initMessage += '\n';
        initMessage += product.permalink ?? '';
      }
      return RealtimeChat(
        type: RealtimeChatType.customerToVendor,
        vendorName: receiverName,
        vendorEmail: receiverEmail,
        userEmail: email,
        initMessage: initMessage,
      );
    }

    /// MV: Vendor to self or Vendor to Customer.
    final isVendorChatToSelf = email == receiverEmail;
    if (isMvApp &&
        senderUser.isVender &&
        (isVendorChatToSelf || email != receiverEmail)) {
      return RealtimeChat(
        userEmail: email,
        type: RealtimeChatType.vendorToCustomers,
      );
    }

    /// Admin to Customers.
    if (!isMvApp && email == kConfigChat.realtimeChatConfig.adminEmail) {
      return RealtimeChat(
        userEmail: email,
        type: RealtimeChatType.adminToCustomers,
      );
    }

    /// Customer to Admin. Use as default if it is not MV app.
    if (!isMvApp ||
        receiverEmail == kConfigChat.realtimeChatConfig.adminEmail) {
      return RealtimeChat(
        userEmail: email,
        type: RealtimeChatType.customerToAdmin,
      );
    }

    /// Default: User to Users.
    return RealtimeChat(
      userEmail: email,
      type: RealtimeChatType.userToUsers,
    );
  }

  @override
  Future<void> createUserWithEmailAndPassword({email, password}) async {
    if (isEnabled) {
      await _authService?.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  @override
  String? getCurrentUserId() {
    return _authService?.getCurrentUserId();
  }

  @override
  Future<String?> getMessagingToken() async {
    return await messaging?.getToken();
  }

  @override
  Future<bool> loadRemoteConfig() {
    return _remoteConfigService?.loadRemoteConfig() ?? Future.value(false);
  }

  @override
  Future<List<String>> getRemoteKeys() async {
    return await _remoteConfigService?.getKeys() ?? [];
  }

  @override
  String getRemoteConfigString(String key) {
    return _remoteConfigService?.getString(key) ?? '';
  }

  @override
  Future<void> signOut() async {
    if (isEnabled) {
      _authService?.signOut();
    }
  }

  @override
  List<NavigatorObserver> getMNavigatorObservers() {
    return firebaseAnalytics?.getMNavigatorObservers() ?? <NavigatorObserver>[];
  }

  @override
  Future<String?>? getIdToken() {
    return _authService?.getIdToken();
  }
}
