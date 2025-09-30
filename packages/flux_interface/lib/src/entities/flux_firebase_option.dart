import 'package:fstore/common/constants.dart';

class FluxFirebaseOption {
  final String? apiKey;
  final String? appId;
  final String? projectId;
  final String? messagingSenderId;
  final String? storageBucket;
  final String? databaseURL;
  final String? authDomain;
  final String? measurementId;
  final String? iosClientId;
  final String? iosBundleId;
  final String? androidClientId;
  const FluxFirebaseOption({
    this.apiKey,
    this.appId,
    this.projectId,
    this.messagingSenderId,
    this.storageBucket,
    this.databaseURL,
    this.authDomain,
    this.measurementId,
    this.iosClientId,
    this.iosBundleId,
    this.androidClientId,
  });

  bool get isValid =>
      apiKey.isNotNullAndNotEmpty &&
      appId.isNotNullAndNotEmpty &&
      projectId.isNotNullAndNotEmpty &&
      messagingSenderId.isNotNullAndNotEmpty;

  Map<String, dynamic> toJson() {
    final result = <String, dynamic>{};

    result.addAll({'apiKey': apiKey});
    result.addAll({'appId': appId});
    result.addAll({'projectId': projectId});
    result.addAll({'messagingSenderId': messagingSenderId});

    if (storageBucket != null) {
      result.addAll({'storageBucket': storageBucket});
    }
    if (databaseURL != null) {
      result.addAll({'databaseURL': databaseURL});
    }
    if (authDomain != null) {
      result.addAll({'authDomain': authDomain});
    }
    if (measurementId != null) {
      result.addAll({'measurementId': measurementId});
    }
    if (iosClientId != null) {
      result.addAll({'iosClientId': iosClientId});
    }
    if (iosBundleId != null) {
      result.addAll({'iosBundleId': iosBundleId});
    }
    if (androidClientId != null) {
      result.addAll({'androidClientId': androidClientId});
    }

    return result;
  }

  factory FluxFirebaseOption.fromJson(Map<String, dynamic> json) {
    return FluxFirebaseOption(
      apiKey: json['apiKey'] ?? '',
      appId: json['appId'] ?? '',
      projectId: json['projectId'] ?? '',
      messagingSenderId: json['messagingSenderId'],
      storageBucket: json['storageBucket'],
      databaseURL: json['databaseURL'],
      authDomain: json['authDomain'],
      measurementId: json['measurementId'],
      iosClientId: json['iosClientId'],
      iosBundleId: json['iosBundleId'],
      androidClientId: json['androidClientId'],
    );
  }

  FluxFirebaseOption copyWith({
    String? apiKey,
    String? appId,
    String? projectId,
    String? messagingSenderId,
    String? storageBucket,
    String? databaseURL,
    String? authDomain,
    String? measurementId,
    String? iosClientId,
    String? iosBundleId,
    String? androidClientId,
  }) {
    return FluxFirebaseOption(
      apiKey: apiKey ?? this.apiKey,
      appId: appId ?? this.appId,
      projectId: projectId ?? this.projectId,
      messagingSenderId: messagingSenderId ?? this.messagingSenderId,
      storageBucket: storageBucket ?? this.storageBucket,
      databaseURL: databaseURL ?? this.databaseURL,
      authDomain: authDomain ?? this.authDomain,
      measurementId: measurementId ?? this.measurementId,
      iosClientId: iosClientId ?? this.iosClientId,
      iosBundleId: iosBundleId ?? this.iosBundleId,
      androidClientId: androidClientId ?? this.androidClientId,
    );
  }
}
