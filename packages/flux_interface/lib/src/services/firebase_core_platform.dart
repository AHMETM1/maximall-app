import '../entities/flux_firebase_option.dart';
import 'firebase_core_service.dart';

class FirebaseCorePlatform extends FirebaseCoreService {
  @override
  Future<dynamic> initializeApp(
      {FluxFirebaseOption? option, String? name}) async {
    // throw UnsupportedError('The firebase is not support for this platform');
  }
}
