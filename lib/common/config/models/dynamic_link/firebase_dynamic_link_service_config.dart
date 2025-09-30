import 'dynamic_link_service_config.dart';

class FirebaseDynamicLinkServiceConfig extends DynamicLinkServiceConfig {
  final bool isEnabled;
  final bool shortDynamicLinkEnable;
  final String uriPrefix;
  final String link;
  final String androidPackageName;
  final int androidAppMinimumVersion;
  final String iOSBundleId;
  final String iOSAppMinimumVersion;
  final String iOSAppStoreId;

  FirebaseDynamicLinkServiceConfig({
    required this.isEnabled,
    required this.shortDynamicLinkEnable,
    required this.uriPrefix,
    required this.link,
    required this.androidPackageName,
    required this.androidAppMinimumVersion,
    required this.iOSBundleId,
    required this.iOSAppMinimumVersion,
    required this.iOSAppStoreId,
  });

  @override
  bool get allowShareLink => isEnabled;

  factory FirebaseDynamicLinkServiceConfig.fromJson(Map<String, dynamic> json) {
    return FirebaseDynamicLinkServiceConfig(
      isEnabled: bool.tryParse(json['isEnabled'].toString()) ?? false,
      shortDynamicLinkEnable:
          bool.tryParse(json['shortDynamicLinkEnable'].toString()) ?? false,
      uriPrefix: json['uriPrefix'] ?? '',
      link: json['link'] ?? '',
      androidPackageName: json['androidPackageName'] ?? '',
      androidAppMinimumVersion:
          int.tryParse(json['androidAppMinimumVersion'].toString()) ?? 0,
      iOSBundleId: json['iOSBundleId'] ?? '',
      iOSAppMinimumVersion: json['iOSAppMinimumVersion'] ?? '',
      iOSAppStoreId: json['iOSAppStoreId'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isEnabled': isEnabled,
      'shortDynamicLinkEnable': shortDynamicLinkEnable,
      'uriPrefix': uriPrefix,
      'link': link,
      'androidPackageName': androidPackageName,
      'androidAppMinimumVersion': androidAppMinimumVersion,
      'iOSBundleId': iOSBundleId,
      'iOSAppMinimumVersion': iOSAppMinimumVersion,
      'iOSAppStoreId': iOSAppStoreId,
    };
  }

  FirebaseDynamicLinkServiceConfig copyWith({
    bool? isEnabled,
    bool? shortDynamicLinkEnable,
    String? uriPrefix,
    String? link,
    String? androidPackageName,
    int? androidAppMinimumVersion,
    String? iOSBundleId,
    String? iOSAppMinimumVersion,
    String? iOSAppStoreId,
  }) {
    return FirebaseDynamicLinkServiceConfig(
      isEnabled: isEnabled ?? this.isEnabled,
      shortDynamicLinkEnable:
          shortDynamicLinkEnable ?? this.shortDynamicLinkEnable,
      uriPrefix: uriPrefix ?? this.uriPrefix,
      link: link ?? this.link,
      androidPackageName: androidPackageName ?? this.androidPackageName,
      androidAppMinimumVersion:
          androidAppMinimumVersion ?? this.androidAppMinimumVersion,
      iOSBundleId: iOSBundleId ?? this.iOSBundleId,
      iOSAppMinimumVersion: iOSAppMinimumVersion ?? this.iOSAppMinimumVersion,
      iOSAppStoreId: iOSAppStoreId ?? this.iOSAppStoreId,
    );
  }
}
