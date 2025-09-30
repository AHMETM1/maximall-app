import 'package:permission_handler/permission_handler.dart';

import 'permission.dart';

NotificationPermission getPermission() => NativeNotificationPermission();

class NativeNotificationPermission extends NotificationPermission {
  @override
  Future<bool> requestPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied || status.isProvisional) {
      final newStatus = await Permission.notification.request();
      return newStatus.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return isGranted();
  }

  @override
  Future<bool> isGranted() async {
    return await Permission.notification.isGranted;
  }
}
