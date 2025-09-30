import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

enum DeliveryStatus {
  pending,
  delivered,
  unknown,
}

extension DeliveryStatusExtension on DeliveryStatus {
  Color displayColor(context) {
    switch (this) {
      case DeliveryStatus.pending:
        return Theme.of(context).primaryColor;
      default:
        return Theme.of(context).splashColor;
    }
  }

  String getTranslation(context) {
    switch (this) {
      case DeliveryStatus.delivered:
        return S.of(context).delivered;
      default:
        return S.of(context).pending;
    }
  }
}
