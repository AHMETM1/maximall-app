import 'package:firebase_core/firebase_core.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:inspireui/inspireui.dart';

extension FluxFirebaseOptionExtension on FluxFirebaseOption {
  FirebaseOptions? toFirebaseOptions() {
    if (isValid) {
      return FirebaseOptions(
        apiKey: apiKey!,
        appId: appId!,
        projectId: projectId!,
        messagingSenderId: messagingSenderId!,
        storageBucket: storageBucket,
        databaseURL: databaseURL,
        authDomain: authDomain,
        measurementId: measurementId,
        iosClientId: iosClientId,
        iosBundleId: iosBundleId,
        androidClientId: androidClientId,
      );
    }

    return null;
  }
}

extension SupabaseConfigOptionExtension on FirebaseOptions {
  FluxFirebaseOption toFluxFirebaseOption() {
    return FluxFirebaseOption(
      apiKey: apiKey,
      appId: appId,
      projectId: projectId,
      messagingSenderId: messagingSenderId,
      storageBucket: storageBucket,
      databaseURL: databaseURL,
      authDomain: authDomain,
      measurementId: measurementId,
      iosClientId: iosClientId,
      iosBundleId: iosBundleId,
      androidClientId: androidClientId,
    );
  }
}

extension FirebaseFactoryExt on Firebase {
  static Future<FirebaseApp> initializeApp({
    String? name,
    FirebaseOptions? options,
    String? demoProjectId,
  }) async {
    try {
      // If app name is provided, try to get existing instance
      if (name?.isNotEmpty ?? false) {
        try {
          // Check if app with the given name already exists
          final isExistApp = Firebase.apps.any((app) => app.name == name);

          // If app exists, return it
          if (isExistApp) {
            return Firebase.app(name!);
          }
        } catch (e) {
          // Log error for debugging
          printLog('[Firebase] Failed to get existing app: $name. Error: $e');
          // Continue with new initialization flow
        }
      }

      // Try to initialize with full options first
      try {
        return await Firebase.initializeApp(
          name: name,
          options: options,
          demoProjectId: demoProjectId,
        );
      } catch (e) {
        printLog(
            '[Firebase] Failed to initialize with full options. Error: $e');

        // If demoProjectId is provided, try fallback to demo mode
        if (demoProjectId != null) {
          try {
            return await Firebase.initializeApp(
              name: name,
              options: options?.copyWith(projectId: demoProjectId) ??
                  FirebaseOptions(
                    apiKey: 'demo-api-key',
                    appId: 'demo-app-id',
                    messagingSenderId: 'demo-sender-id',
                    projectId: demoProjectId,
                  ),
            );
          } catch (e) {
            printLog('[Firebase] Failed to initialize in demo mode. Error: $e');
            rethrow;
          }
        } else if (name?.isNotEmpty ?? false) {
          return await Firebase.initializeApp(options: options);
        }

        // If no demoProjectId available, rethrow original error
        rethrow;
      }
    } catch (e) {
      printLog('[Firebase] Fatal error during initialization: $e');
      rethrow;
    }
  }
}
