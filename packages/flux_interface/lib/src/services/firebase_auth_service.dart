import 'dart:async';

import 'package:fstore/models/index.dart';

import '../entities/firebase_error_exception.dart';

class FirebaseAuthService {
  void deleteAccount() {}

  Future<void> loginFirebaseApple({authorizationCode, identityToken}) async {}

  Future<void> loginFirebaseFacebook({token, rawNonce}) async {}

  Future<void> loginFirebaseGoogle({token}) async {}

  Future<void> loginFirebaseEmail({email, password}) async {}

  Future<User?>? loginFirebaseCredential({credential}) => null;

  dynamic getFirebaseCredential({verificationId, smsCode}) => null;

  String? getCurrentUserId() => null;

  StreamController<String?>? getFirebaseStream() => null;

  Future<void> verifyPhoneNumber({
    phoneNumber,
    codeAutoRetrievalTimeout,
    codeSent,
    required void Function(String?) verificationCompleted,
    void Function(FirebaseErrorException error)? verificationFailed,
    forceResendingToken,
    Duration? timeout,
  }) async {}

  Future<void> createUserWithEmailAndPassword({email, password}) async {}

  void signOut() {}

  Future<String?>? getIdToken() => null;

  Future<String?>? loginWithEmailAndPassword(String email, String password) =>
      null;

  Future<String?>? getToken() => null;

  Future<void>? sendPasswordResetEmail(String email) => null;

  Future<void>? updatePassword(String password) => null;

  Future<String?> getGuestUser() async => null;
}
