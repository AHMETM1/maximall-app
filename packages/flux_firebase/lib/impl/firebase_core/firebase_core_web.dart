// @dart=3.3
import 'dart:js_interop';

import 'package:firebase_core/firebase_core.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:fstore/common/constants.dart';

import '../../common/extensions/firebase.dart';

@JS()
extension type FirebaseConfig(JSObject _) {
  external JSString get apiKey;
  external JSString get appId;
  external JSString get messagingSenderId;
  external JSString get projectId;
  external JSString get authDomain;
  external JSString get databaseURL;
  external JSString get storageBucket;
  external JSString get measurementId;
}

@JS('firebaseConfig')
external FirebaseConfig get firebaseConfig;

class FirebaseCorePlatform extends FirebaseCoreService {
  @override
  Future<dynamic> initializeApp(
      {FluxFirebaseOption? option, String? name}) async {
    try {
      final options = option?.toFirebaseOptions() ??
          FirebaseOptions(
            apiKey: firebaseConfig.apiKey.toDart,
            appId: firebaseConfig.appId.toDart,
            messagingSenderId: firebaseConfig.messagingSenderId.toDart,
            projectId: firebaseConfig.projectId.toDart,
            authDomain: firebaseConfig.authDomain.toDart,
            databaseURL: firebaseConfig.databaseURL.toDart,
            storageBucket: firebaseConfig.storageBucket.toDart,
            measurementId: firebaseConfig.measurementId.toDart,
          );
      await FirebaseFactoryExt.initializeApp(
        options: options,
        name: name,
      );
    } catch (e) {
      printError(e);
    }
  }
}
