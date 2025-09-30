import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inspireui/utils/colors.dart';

part 'icon_config.freezed.dart';
part 'icon_config.g.dart';

@freezed
class IconConfig with _$IconConfig {
  // Is used for getter. Ref:
  // https://github.com/rrousselGit/freezed?tab=readme-ov-file#adding-getters-and-methods-to-our-models
  const IconConfig._();

  const factory IconConfig({
    required String icon,
    required String fontFamily,
    @JsonKey(name: 'color') String? colorString,
    double? size,
  }) = _IconConfig;

  factory IconConfig.fromJson(Map<String, dynamic> json) =>
      _$IconConfigFromJson(json);

  Color? get color =>
      colorString == null ? null : HexColor.fromJson(colorString);
}
