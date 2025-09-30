import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:inspireui/inspireui.dart';

/// Implemennt Firebase Remote Config
///
class FirebaseRemoteServicesImpl extends FirebaseRemoteServices {
  late final FirebaseRemoteConfig _firebaseRemoteConfig;

  FirebaseRemoteServicesImpl({FirebaseApp? app}) {
    _firebaseRemoteConfig = app != null
        ? FirebaseRemoteConfig.instanceFor(app: app)
        : FirebaseRemoteConfig.instance;
  }

  @override
  String getString(String key) {
    return _firebaseRemoteConfig.getString(key);
  }

  @override
  Future<bool> loadRemoteConfig() async {
    try {
      await _firebaseRemoteConfig.fetch();
      await _firebaseRemoteConfig.activate();
      return true;
    } catch (e) {
      printLog('Unable to fetch remote config. Default value will be used. $e');
    }

    return false;
  }

  @override
  Future<List<String>> getKeys() async {
    return _firebaseRemoteConfig.getAll().keys.toList();
  }
}
