import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/extensions/color_extension.dart';
import 'package:inspireui/utils/colors.dart';

import '../helper/helper.dart';

/// position : 0
/// radius : 0.0
/// color : ''
/// marginTop : 0.0
/// marginBottom : 0.0
/// marginLeft : 0.0
/// marginRight : 0.0

FloatingActionButtonLocation? stringToFloatingActionButtonLocation(
    String? value) {
  switch (value) {
    case 'centerDocked':
      return FloatingActionButtonLocation.centerDocked;
    case 'startDocked':
      return FloatingActionButtonLocation.startDocked;
    case 'endDocked':
      return FloatingActionButtonLocation.endDocked;
    case 'miniCenterDocked':
      return FloatingActionButtonLocation.miniCenterDocked;
    case 'miniStartDocked':
      return FloatingActionButtonLocation.miniStartDocked;
    case 'miniEndDocked':
      return FloatingActionButtonLocation.miniEndDocked;
    default:
  }
  return null;
}

String? floatingActionButtonLocationToString(
    FloatingActionButtonLocation? value) {
  switch (value) {
    case FloatingActionButtonLocation.centerDocked:
      return 'centerDocked';
    case FloatingActionButtonLocation.startDocked:
      return 'startDocked';
    case FloatingActionButtonLocation.endDocked:
      return 'endDocked';
    case FloatingActionButtonLocation.miniCenterDocked:
      return 'miniCenterDocked';
    case FloatingActionButtonLocation.miniStartDocked:
      return 'miniStartDocked';
    case FloatingActionButtonLocation.miniEndDocked:
      return 'miniEndDocked';
    default:
  }
  return null;
}

enum FloatingType {
  diamond,
  rectangle,
  circle;

  factory FloatingType.fromString(String? value) {
    switch (value) {
      case 'diamond':
        return FloatingType.diamond;
      case 'rectangle':
        // For users who previously used the `rectangle` type, it will be the
        // same as new `circle` type
        return FloatingType.rectangle;
      case 'circle':
      default:
        return FloatingType.circle;
    }
  }
}

class TabBarFloatingConfig {
  int? position;
  FloatingActionButtonLocation? location;
  late FloatingType floatingType;
  HexColor? color;
  double? radius;
  double? elevation; //shadow
  double? width;
  double? height;

  double notchMargin = 4.0;
  bool isCoverMode = false;

  EdgeInsetsDirectional? margin;
  double? sizeIcon;

  TabBarFloatingConfig({
    this.position,
    this.radius,
    this.floatingType = FloatingType.circle,
    this.color,
    this.width,
    this.height,
    this.elevation,
    this.location,
    this.notchMargin = 4.0,
    this.isCoverMode = false,
    this.margin,
    this.sizeIcon,
  });

  TabBarFloatingConfig.fromJson(dynamic json) {
    if (json['color'] != null) {
      color = HexColor(json['color']);
    }
    location = stringToFloatingActionButtonLocation(json['location']);
    position = Helper.formatInt(json['position'], 0);
    floatingType = FloatingType.fromString(json['floatingType']);
    radius = Helper.formatDouble(json['radius']) ?? 50.0;
    width = Helper.formatDouble(json['width']) ?? 50.0;
    height = Helper.formatDouble(json['height']) ?? 50.0;
    elevation = Helper.formatDouble(json['elevation']) ?? 2.0;
    notchMargin = Helper.formatDouble(json['notchMargin']) ?? 4.0;
    isCoverMode = json['isCoverMode'] ?? false;
    margin = const EdgeInsetsDirectionalConverter().fromJson(json['margin']);

    // The Helper.formatDouble function sets the passed values to 0.0
    // if the format is invalid. However, the icon size needs a null
    // value if it is not set or if an invalid value is set.
    // Therefore, use num.tryParse to get the value from JSON and convert it to a double.
    sizeIcon = num.tryParse(json['sizeIcon'].toString())?.toDouble();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['position'] = position;
    map['radius'] = radius;
    map['color'] = color?.valueNum.toRadixString(16);
    map['location'] = floatingActionButtonLocationToString(location);
    map['width'] = width;
    map['height'] = height;
    map['elevation'] = elevation;
    map['floatingType'] = floatingType.name;
    map['notchMargin'] = notchMargin;
    map['isCoverMode'] = isCoverMode;
    map['margin'] = const EdgeInsetsDirectionalConverter().toJson(margin);
    map['sizeIcon'] = sizeIcon;
    return map;
  }
}
