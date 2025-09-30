import 'package:flux_interface/flux_interface.dart';

import '../../common/extensions/firebase.dart';

class FirebaseCorePlatform extends FirebaseCoreService {
  @override
  Future<dynamic> initializeApp({FluxFirebaseOption? option, String? name}) {
    final firebaseOption = option?.toFirebaseOptions();
    return FirebaseFactoryExt.initializeApp(
      options: firebaseOption,
      name: name,
    );
  }
}
