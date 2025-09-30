import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth_platform_interface/flutter_facebook_auth_platform_interface.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:fstore/models/entities/user.dart' as entities;

import '../firebase_service.dart';
import 'entities/firebase_exception.dart';
import 'extensions/firebase_user_extention.dart';

class FirebaseAuthServiceImpl extends FirebaseAuthService {
  static FirebaseAuth _auth = FirebaseServices().firebaseAuth;

  static final FirebaseAuthServiceImpl _instance =
      FirebaseAuthServiceImpl._internal();

  FirebaseAuthServiceImpl._internal();

  factory FirebaseAuthServiceImpl() => _instance;

  void setApp({FirebaseApp? app}) {
    _auth = app != null
        ? FirebaseAuth.instanceFor(app: app)
        : FirebaseAuth.instance;
    _auth.initializeRecaptchaConfig();
  }

  @override
  void deleteAccount() {
    try {
      _auth.currentUser?.delete();
    } catch (e, t) {
      log('error: $e');
      log('tracer: $t');
      rethrow;
    }
  }

  @override
  Future<void> loginFirebaseApple({authorizationCode, identityToken}) async {
    final AuthCredential credential = OAuthProvider('apple.com').credential(
      accessToken: String.fromCharCodes(authorizationCode),
      idToken: String.fromCharCodes(identityToken),
    );
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> loginFirebaseFacebook({token, rawNonce}) async {
    if (token is! AccessToken) {
      return;
    }

    OAuthCredential? credential;

    if (Platform.isIOS) {
      switch (token.type) {
        case AccessTokenType.classic:
          final accessToken = token as ClassicToken;
          credential = FacebookAuthProvider.credential(
            accessToken.authenticationToken!,
          );
          break;
        case AccessTokenType.limited:
          final accessToken = token as LimitedToken;
          credential = OAuthCredential(
            providerId: 'facebook.com',
            signInMethod: 'oauth',
            idToken: accessToken.tokenString,
            rawNonce: rawNonce,
          );
          break;
      }
    } else {
      credential = FacebookAuthProvider.credential(
        token.tokenString,
      );
    }

    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> loginFirebaseGoogle({token}) async {
    AuthCredential credential =
        GoogleAuthProvider.credential(accessToken: token);
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> loginFirebaseEmail({email, password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (err) {
      /// In case this user was registered on web
      /// so Firebase user was not created.
      /// TODO: Update solution if user enable this option
      /// https://stackoverflow.com/a/77744190/19622959
      if (err is FirebaseAuthException && err.code == 'user-not-found') {
        /// Create Firebase user automatically.
        /// createUserWithEmailAndPassword will auto sign in after success.
        /// No need to call signInWithEmailAndPassword again.
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      /// Ignore other cases.
    }
  }

  @override
  Future<entities.User?>? loginFirebaseCredential({credential}) async {
    try {
      return (await _auth.signInWithCredential(credential)).user?.toEntityApp();
    } on FirebaseAuthException catch (err) {
      throw err.toEntityApp();
    }
  }

  @override
  PhoneAuthCredential getFirebaseCredential({verificationId, smsCode}) {
    try {
      return PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
    } on FirebaseAuthException catch (err) {
      throw err.toEntityApp();
    }
  }

  @override
  StreamController<String?> getFirebaseStream() {
    return StreamController<String?>.broadcast();
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
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber!,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        codeSent: codeSent,
        timeout: timeout ?? const Duration(seconds: 120),
        verificationCompleted: (phoneAuthCredential) {
          verificationCompleted(phoneAuthCredential.smsCode);
        },
        verificationFailed: (error) =>
            verificationFailed?.call(error.toEntityApp()),
        forceResendingToken: forceResendingToken);
  }

  @override
  Future<void> createUserWithEmailAndPassword({email, password}) async {
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }

    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  void signOut() {
    _auth.signOut();
  }

  @override
  Future<String?>? getIdToken() {
    return _auth.currentUser?.getIdToken();
  }

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  @override
  Future<String?>? loginWithEmailAndPassword(
      String email, String password) async {
    final user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user?.uid;
  }

  @override
  Future<String?>? getToken() async {
    return _auth.currentUser?.getIdToken();
  }

  @override
  Future<void>? sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void>? updatePassword(String password) async {
    try {
      await _auth.currentUser?.updatePassword(password);
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw e.toEntityApp();
      }

      rethrow;
    }
  }

  @override
  Future<String?> getGuestUser() async {
    final user = await _auth.signInAnonymously();
    return user.user?.uid;
  }
}
