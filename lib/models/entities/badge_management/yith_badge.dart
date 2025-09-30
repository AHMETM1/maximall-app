import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:inspireui/utils/colors.dart';

import 'extensions/map_extension.dart';
import 'yith_badge_size.dart';

enum YITHBadgeType { text, image, css, advanced }

extension YITHBadgeTypeX on YITHBadgeType {
  static YITHBadgeType? initFrom(String? value) {
    return YITHBadgeType.values
        .firstWhereOrNull((YITHBadgeType e) => e.name == value);
  }
}

enum YITHBadgePosition { top, middle, bottom }

extension YITHBadgePositionX on YITHBadgePosition {
  static YITHBadgePosition? initFrom(String? value) {
    return YITHBadgePosition.values
        .firstWhereOrNull((YITHBadgePosition e) => e.name == value);
  }
}

enum YITHBadgeAlignment { left, center, right }

extension YITHBadgeAlignmentX on YITHBadgeAlignment {
  static YITHBadgeAlignment? initFrom(String? value) {
    return YITHBadgeAlignment.values
        .firstWhereOrNull((YITHBadgeAlignment e) => e.name == value);
  }
}

enum YITHBadgeAdvancedDisplay { amount, percentage }

extension YITHBadgeAdvancedDisplayX on YITHBadgeAdvancedDisplay {
  static YITHBadgeAdvancedDisplay? initFrom(String? value) {
    return YITHBadgeAdvancedDisplay.values
        .firstWhereOrNull((YITHBadgeAdvancedDisplay e) => e.name == value);
  }
}

class YITHBadge {
  const YITHBadge(
      {this.type,
      this.text,
      this.backgroundColor,
      this.textColor,
      this.size,
      this.padding,
      this.margin,
      this.borderRadius,
      this.opacity,
      this.position,
      this.alignment,
      this.imageUrl,
      this.css,
      this.advanced,
      this.advancedDisplay});

  final YITHBadgeType? type;
  final String? text;
  final Color? backgroundColor;
  final Color? textColor;
  final YITHBadgeSize? size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double? opacity;
  final YITHBadgePosition? position;
  final YITHBadgeAlignment? alignment;
  final String? imageUrl;
  final String? css;
  final String? advanced;
  final YITHBadgeAdvancedDisplay? advancedDisplay;

  factory YITHBadge.fromJson(Map<String?, dynamic> json) => YITHBadge(
        text: json['text'],
        backgroundColor: (json['background_color']?.isNotEmpty ?? false)
            ? HexColor(json['background_color'])
            : null,
        textColor: (json['text_color']?.isNotEmpty ?? false)
            ? HexColor(json['text_color'])
            : null,
        type: YITHBadgeTypeX.initFrom(json['type']),
        size: json['size'] != null && json['size']['dimensions'] != null
            ? YITHBadgeSize.fromJson(json['size'])
            : null,
        padding:
            json['padding'] != null && json['padding']['dimensions'] != null
                ? (json['padding']['dimensions'] as Map).toPadding()
                : null,
        margin: json['margin'] != null && json['margin']['dimensions'] != null
            ? (json['margin']['dimensions'] as Map).toPadding()
            : null,
        borderRadius: json['border_radius'] != null &&
                json['border_radius']['dimensions'] != null
            ? (json['border_radius']['dimensions'] as Map).toBorderRadius()
            : null,
        opacity: double.tryParse(json['opacity'].toString()) != null
            ? double.parse(json['opacity'].toString()) / 100
            : 1.0,
        position: YITHBadgePositionX.initFrom(json['position']),
        alignment: YITHBadgeAlignmentX.initFrom(json['alignment']),
        imageUrl: json['image_url'],
        css: json['css'],
        advanced: json['advanced'],
        advancedDisplay:
            YITHBadgeAdvancedDisplayX.initFrom(json['advanced_display']),
      );
}
