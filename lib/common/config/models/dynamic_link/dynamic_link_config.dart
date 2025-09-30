import 'package:collection/collection.dart';

import 'dynamic_link_service_config.dart';
import 'dynamic_link_type.dart';

class DynamicLinkConfig {
  /// Set type to [DynamicLinkType.none] to disable dynamic link
  final DynamicLinkType type;
  final Map<DynamicLinkType, DynamicLinkServiceConfig> serviceConfigs;

  DynamicLinkConfig({
    required this.type,
    required this.serviceConfigs,
  });

  bool get allowShareLink {
    if (type.isFirebase) {
      // Adapt with the old Firebase Dynamic Link config
      // TODO(tgloc): Remove this when all the user has migrated to the branchIO
      final firebase = serviceConfigs.entries
          .firstWhereOrNull((e) => e.key.isFirebase)
          ?.value;

      return firebase?.allowShareLink ?? false;
    }

    return type.isNone == false && serviceConfigs.isNotEmpty;
  }

  factory DynamicLinkConfig.fromJson(Map<String, dynamic> json) {
    var mainType = DynamicLinkType.none;

    final configs = json['serviceConfigs'];
    final serviceConfigs = configs is Map && configs.isNotEmpty ? configs : {};

    var dynamicLinkServiceConfigs =
        <DynamicLinkType, DynamicLinkServiceConfig>{};

    if (serviceConfigs.isNotEmpty) {
      // For FluxStore > 4.3.0
      mainType = DynamicLinkType.fromString(json['type']);

      for (var e in serviceConfigs.entries) {
        final type = DynamicLinkType.fromString(e.key);
        if (type.isNone) {
          continue;
        }
        dynamicLinkServiceConfigs[type] = DynamicLinkServiceConfig.fromJson(
          e.key,
          e.value,
        );
      }
    } else {
      // Adapt with the old Firebase Dynamic Link config
      // TODO(tgloc): Remove this when all the user has migrated to the branchIO

      if (json['type']?.toString().isNotEmpty ?? false) {
        // For FluxStore >= 4.2.0 and <= 4.3.0, which have `dynamicLinkConfig`
        // and `branchIO` in `dynamicLinkConfig`
        mainType = DynamicLinkType.fromString(json['type']);
      } else {
        // For FluxStore < 4.2.0, which do not have `dynamicLinkConfig`
        mainType = DynamicLinkType.firebase;
      }

      final branchIO = Map<String, dynamic>.from(json['branchIO'] ?? {});
      final firebase =
          Map<String, dynamic>.from(json['firebaseDynamicLinkConfig'] ?? {});

      if (branchIO.isNotEmpty) {
        dynamicLinkServiceConfigs[DynamicLinkType.branchIO] =
            DynamicLinkServiceConfig.fromJson('branchIO', branchIO);
      }

      if (firebase.isNotEmpty) {
        dynamicLinkServiceConfigs[DynamicLinkType.firebase] =
            DynamicLinkServiceConfig.fromJson('firebase', firebase);
      }
    }

    if (mainType.isSelfHosted) {
      dynamicLinkServiceConfigs[mainType] =
          SelfHostedDynamicLinkServiceConfig();
    }

    return DynamicLinkConfig(
      type: mainType,
      serviceConfigs: dynamicLinkServiceConfigs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'serviceConfigs': serviceConfigs
          .map((key, value) => MapEntry(key.name, value.toJson())),
    };
  }

  DynamicLinkConfig copyWith({
    DynamicLinkType? type,
    Map<DynamicLinkType, DynamicLinkServiceConfig>? serviceConfigs,
  }) {
    return DynamicLinkConfig(
      type: type ?? this.type,
      serviceConfigs: serviceConfigs ?? this.serviceConfigs,
    );
  }
}
