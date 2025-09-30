import '../../../modules/dynamic_layout/helper/helper.dart';

class PointsOfflineStoreConfig {
  final bool enabled;
  final double usePointRateForOnePoint;
  final double addPointRateForOnePoint;
  final String cardName;

  const PointsOfflineStoreConfig(
      {this.enabled = false,
      this.usePointRateForOnePoint = 1.0,
      this.addPointRateForOnePoint = 100.0,
      this.cardName = 'FluxStore Card'});

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'usePointRateForOnePoint': usePointRateForOnePoint,
      'addPointRateForOnePoint': addPointRateForOnePoint,
      'cardName': cardName
    };
  }

  factory PointsOfflineStoreConfig.fromJson(Map map) {
    return PointsOfflineStoreConfig(
      enabled: (map['enabled'] as bool?) ?? false,
      usePointRateForOnePoint:
          Helper.formatDouble(map['usePointRateForOnePoint']) ?? 1.0,
      addPointRateForOnePoint:
          Helper.formatDouble(map['addPointRateForOnePoint']) ?? 100,
      cardName: map['cardName'] ?? '-',
    );
  }
}
