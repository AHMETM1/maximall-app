import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../models/entities/fstore_notification_item.dart';
import 'permissions/permission.dart';

abstract class NotificationService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  void setIsInitialized() {
    _isInitialized = true;
  }

  NotificationService() {
    // var initSetting = const InitializationSettings(
    //   android: AndroidInitializationSettings('@drawable/ic_stat_onesignal_default'),
    //   iOS: IOSInitializationSettings(),
    // );
    //
    // flutterLocalNotificationsPlugin.initialize(initSetting,
    //     onSelectNotification: (String? payload) async {
    //   /// Handle payload here
    // });

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  late final NotificationDelegate delegate;

  void init({
    /// OneSignal only
    String? externalUserId,
    required NotificationDelegate notificationDelegate,
  });

  Future<bool> requestPermission() async {
    return NotificationPermission.permission.requestPermission();
  }

  Future<bool> isGranted() async {
    return NotificationPermission.permission.isGranted();
  }

  void disableNotification();

  void enableNotification();

  void setExternalId(String? userId);

  void removeExternalId();
}

mixin NotificationDelegate {
  void onMessage(FStoreNotificationItem notification);

  void onMessageOpenedApp(FStoreNotificationItem notification);
}
