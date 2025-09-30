import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flux_interface/flux_interface.dart';

class FirebaseMessagingServiceImpl extends FirebaseMessagingService {
  @override
  void onBackgroundMessage(Future<void> Function(dynamic message) handler) {
    FirebaseMessaging.onBackgroundMessage(handler);
  }
}
