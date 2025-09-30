import 'platform_permission.dart'
    if (dart.library.io) 'native_permission.dart'
    if (dart.library.js) 'web_permission.dart';

abstract class NotificationPermission {
  Future<bool> requestPermission();
  Future<bool> isGranted();

  static NotificationPermission get permission => getPermission();
}
