/// Service
import 'package:flux_interface/flux_interface.dart';

import 'impl/firebase_analytics_service_impl.dart';
import 'impl/firebase_auth/firebase_auth_service_impl.dart';
import 'impl/firebase_cloud_function_service_impl.dart';
import 'impl/firebase_remote_service_impl.dart';
import 'index.dart';

class FirebaseServiceFactory {
  static T? create<T>({Map<String, dynamic> args = const {}}) {
    switch (T) {
      case const (FirebaseAuthService):
        final app = args['firebaseApp'];

        if (app == null || app is FirebaseApp) {
          final firebaseAuthService = FirebaseAuthServiceImpl()
            ..setApp(app: app);

          return firebaseAuthService as T;
        }
        return null;
      case const (FirebaseAnalyticsService):
        final app = args['firebaseApp'];

        if (app == null || app is FirebaseApp) {
          return FirebaseAnalyticsServiceImpl(app: app) as T;
        }
        return null;
      case const (FirebaseRemoteServices):
        final app = args['firebaseApp'];

        if (app == null || app is FirebaseApp) {
          return FirebaseRemoteServicesImpl(app: app) as T;
        }
        return null;
      case const (FirebaseCloudFunctionService):
        final app = args['firebaseApp'];
        if (app == null || app is FirebaseApp) {
          return FirebaseCloudFunctionServiceImpl(app: app) as T;
        }
        return null;
      case const (FirebaseCoreService):
        return FirebaseCorePlatformImpl() as T;
      default:
        return null;
    }
  }

  static FirebaseRemoteServices? createRemoteServices(FirebaseApp app) =>
      create<FirebaseRemoteServices>(
        args: {'firebaseApp': app},
      );

  static FirebaseAnalyticsService? createAnalyticsService(FirebaseApp app) =>
      create<FirebaseAnalyticsService>(
        args: {'firebaseApp': app},
      );

  static FirebaseAuthService? createAuthService(FirebaseApp app) =>
      create<FirebaseAuthService>(
        args: {'firebaseApp': app},
      );

  static FirebaseCloudFunctionService? createCloudFunctionService(
          FirebaseApp app) =>
      create<FirebaseCloudFunctionService>(
        args: {'firebaseApp': app},
      );
}
