import 'package:flux_interface/flux_interface.dart'
    if (dart.library.io) 'firebase_core/firebase_core_native.dart'
    if (dart.library.js) 'firebase_core/firebase_core_web.dart';

class FirebaseCorePlatformImpl extends FirebaseCorePlatform {}
