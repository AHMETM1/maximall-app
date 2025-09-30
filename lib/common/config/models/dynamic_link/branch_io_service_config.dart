import 'package:inspireui/inspireui.dart';

import 'dynamic_link_service_config.dart';

/// [BranchIOConfig] is only used for FluxBuilder's Auto build feature.
class BranchIOServiceConfig extends DynamicLinkServiceConfig {
  final bool testMode;
  final String? keyLive;
  final String? keyTest;
  final String? liveLinkDomain;
  final String? liveAlternateLinkDomain;
  final String? testLinkDomain;
  final String? testAlternateLinkDomain;

  BranchIOServiceConfig({
    this.testMode = true,
    this.keyLive,
    this.keyTest,
    this.liveLinkDomain,
    this.liveAlternateLinkDomain,
    this.testLinkDomain,
    this.testAlternateLinkDomain,
  });

  bool get useTestKey => testMode;

  @override
  bool get allowShareLink => isValidate;

  bool get isValidate {
    if (testMode) {
      return [
            keyTest,
            testLinkDomain,
            testAlternateLinkDomain,
          ].any((e) => e.isEmptyOrNull) ==
          false;
    }

    return [
          keyLive,
          liveLinkDomain,
          liveAlternateLinkDomain,
        ].any((e) => e.isEmptyOrNull) ==
        false;
  }

  bool isSupportedLink(String url) {
    return [
      testLinkDomain,
      testAlternateLinkDomain,
      liveLinkDomain,
      liveAlternateLinkDomain
    ].any((e) => url.contains(e ?? ''));
  }

  factory BranchIOServiceConfig.fromJson(Map<String, dynamic> json) {
    return BranchIOServiceConfig(
      // To adapt with the old config `liveMode`, we will use the the new config
      // `testMode` instead if set
      testMode: json['testMode'] ?? !(json['liveMode'] ?? false),
      keyLive: json['keyLive'],
      keyTest: json['keyTest'],
      liveLinkDomain: json['liveLinkDomain'],
      liveAlternateLinkDomain: json['liveAlternateLinkDomain'],
      testLinkDomain: json['testLinkDomain'],
      testAlternateLinkDomain: json['testAlternateLinkDomain'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'testMode': testMode,
      'keyLive': keyLive,
      'keyTest': keyTest,
      'liveLinkDomain': liveLinkDomain,
      'liveAlternateLinkDomain': liveAlternateLinkDomain,
      'testLinkDomain': testLinkDomain,
      'testAlternateLinkDomain': testAlternateLinkDomain,
    };
  }

  BranchIOServiceConfig copyWith({
    bool? testMode,
    String? keyLive,
    String? keyTest,
    String? liveLinkDomain,
    String? liveAlternateLinkDomain,
    String? testLinkDomain,
    String? testAlternateLinkDomain,
  }) {
    return BranchIOServiceConfig(
      testMode: testMode ?? this.testMode,
      keyLive: keyLive ?? this.keyLive,
      keyTest: keyTest ?? this.keyTest,
      liveLinkDomain: liveLinkDomain ?? this.liveLinkDomain,
      liveAlternateLinkDomain:
          liveAlternateLinkDomain ?? this.liveAlternateLinkDomain,
      testLinkDomain: testLinkDomain ?? this.testLinkDomain,
      testAlternateLinkDomain:
          testAlternateLinkDomain ?? this.testAlternateLinkDomain,
    );
  }
}
