// import 'package:audio_service/audio_service.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

// Enable Audio feature
// import 'package:flux_audio/index.dart';

import '../screens/app_coordinator_shared.dart';
import '../services/index.dart'
    show AudioManager, NotificationService, Services;
import '../services/location_service.dart';
import '../services/review_manager.dart';
import '../services/wallet/wallet_services.dart';
import '../services/wallet/wallet_services_impl.dart';
import 'di_core.dart';

export 'di_core.dart';

class DependencyInjection {
  static Future<void> inject() async {
    /// Check and register the main services if the service has not been registered..
    _registerMainService();

    injector.allowReassignment = true;
    final locationService = LocationService();
    injector.registerSingleton<LocationService>(locationService);

    var notificationService = Services.getNotificationService();
    injector.registerSingleton<NotificationService>(notificationService);

    /// Enable Audio feature
    // if (kBlogDetail['enableAudioSupport'] ?? false) {
    //   injector.registerSingleton<AudioHandler>(await initAudioService());
    // }
    var audioService = Services().getAudioService();
    injector.registerLazySingleton<AudioManager>(() => audioService);

    /// Wallet services
    injector.registerLazySingleton<WalletServices>(WalletServicesImpl.new);

    /// Review Manager
    injector.registerSingleton<ReviewManager>(ReviewManager());

    /// App Coordinator
    injector.registerFactoryParam<AppCoordinatorShared, BuildContext, dynamic>(
        (param1, _) => AppCoordinatorSharedImpl(param1));

    /// Image Picker
    final imagePickerPlatform = ImagePickerPlatform.instance;
    if (imagePickerPlatform is ImagePickerAndroid) {
      imagePickerPlatform.useAndroidPhotoPicker = true;
    }
    final imagePicker = ImagePicker();
    injector.registerLazySingleton<ImagePicker>(() => imagePicker);
  }
}

/// NOTE:
/// This is a list of the main services of the application.
/// In case the flux_firebase package is removed, these services
/// will not be injected into the project. At that time, the services
/// will be injected by their corresponding classes.
void _registerMainService() {
  tryRegisterSingleton<FirebaseAnalyticsService>(
      () => FirebaseAnalyticsService());
  tryRegisterSingleton<FirebaseRemoteServices>(() => FirebaseRemoteServices());
  tryRegisterSingleton<FirebaseCoreService>(() => FirebaseCorePlatform());
  tryRegisterSingleton<BaseFirebaseServices>(() => BaseFirebaseServices());
  tryRegisterSingleton<FirebaseMessagingService>(
      () => FirebaseMessagingService());
}
