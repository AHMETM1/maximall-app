// @dart=3.3

@JS()
library;

import 'dart:js_interop';

import 'permission.dart';

@JS('isNotiGranted')
external JSPromise<JSBoolean> isNotiGranted();

@JS('requestNotiPermission')
external JSPromise<JSBoolean> requestNotiPermission();

NotificationPermission getPermission() => WebNotificationPermission();

class WebNotificationPermission extends NotificationPermission {
  @override
  Future<bool> isGranted() async {
    try {
      final value = await isNotiGranted().toDart;
      return value.toDart;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final value = await requestNotiPermission().toDart;
      return value.toDart;
    } catch (e) {
      return false;
    }
  }
}
