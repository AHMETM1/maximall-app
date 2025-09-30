// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'icon_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IconConfig _$IconConfigFromJson(Map<String, dynamic> json) {
  return _IconConfig.fromJson(json);
}

/// @nodoc
mixin _$IconConfig {
  String get icon => throw _privateConstructorUsedError;
  String get fontFamily => throw _privateConstructorUsedError;
  @JsonKey(name: 'color')
  String? get colorString => throw _privateConstructorUsedError;
  double? get size => throw _privateConstructorUsedError;

  /// Serializes this IconConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IconConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IconConfigCopyWith<IconConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IconConfigCopyWith<$Res> {
  factory $IconConfigCopyWith(
          IconConfig value, $Res Function(IconConfig) then) =
      _$IconConfigCopyWithImpl<$Res, IconConfig>;
  @useResult
  $Res call(
      {String icon,
      String fontFamily,
      @JsonKey(name: 'color') String? colorString,
      double? size});
}

/// @nodoc
class _$IconConfigCopyWithImpl<$Res, $Val extends IconConfig>
    implements $IconConfigCopyWith<$Res> {
  _$IconConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IconConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? fontFamily = null,
    Object? colorString = freezed,
    Object? size = freezed,
  }) {
    return _then(_value.copyWith(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      colorString: freezed == colorString
          ? _value.colorString
          : colorString // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IconConfigImplCopyWith<$Res>
    implements $IconConfigCopyWith<$Res> {
  factory _$$IconConfigImplCopyWith(
          _$IconConfigImpl value, $Res Function(_$IconConfigImpl) then) =
      __$$IconConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String icon,
      String fontFamily,
      @JsonKey(name: 'color') String? colorString,
      double? size});
}

/// @nodoc
class __$$IconConfigImplCopyWithImpl<$Res>
    extends _$IconConfigCopyWithImpl<$Res, _$IconConfigImpl>
    implements _$$IconConfigImplCopyWith<$Res> {
  __$$IconConfigImplCopyWithImpl(
      _$IconConfigImpl _value, $Res Function(_$IconConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of IconConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? icon = null,
    Object? fontFamily = null,
    Object? colorString = freezed,
    Object? size = freezed,
  }) {
    return _then(_$IconConfigImpl(
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      fontFamily: null == fontFamily
          ? _value.fontFamily
          : fontFamily // ignore: cast_nullable_to_non_nullable
              as String,
      colorString: freezed == colorString
          ? _value.colorString
          : colorString // ignore: cast_nullable_to_non_nullable
              as String?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IconConfigImpl extends _IconConfig with DiagnosticableTreeMixin {
  const _$IconConfigImpl(
      {required this.icon,
      required this.fontFamily,
      @JsonKey(name: 'color') this.colorString,
      this.size})
      : super._();

  factory _$IconConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$IconConfigImplFromJson(json);

  @override
  final String icon;
  @override
  final String fontFamily;
  @override
  @JsonKey(name: 'color')
  final String? colorString;
  @override
  final double? size;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'IconConfig(icon: $icon, fontFamily: $fontFamily, colorString: $colorString, size: $size)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'IconConfig'))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('fontFamily', fontFamily))
      ..add(DiagnosticsProperty('colorString', colorString))
      ..add(DiagnosticsProperty('size', size));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IconConfigImpl &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.fontFamily, fontFamily) ||
                other.fontFamily == fontFamily) &&
            (identical(other.colorString, colorString) ||
                other.colorString == colorString) &&
            (identical(other.size, size) || other.size == size));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, icon, fontFamily, colorString, size);

  /// Create a copy of IconConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IconConfigImplCopyWith<_$IconConfigImpl> get copyWith =>
      __$$IconConfigImplCopyWithImpl<_$IconConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IconConfigImplToJson(
      this,
    );
  }
}

abstract class _IconConfig extends IconConfig {
  const factory _IconConfig(
      {required final String icon,
      required final String fontFamily,
      @JsonKey(name: 'color') final String? colorString,
      final double? size}) = _$IconConfigImpl;
  const _IconConfig._() : super._();

  factory _IconConfig.fromJson(Map<String, dynamic> json) =
      _$IconConfigImpl.fromJson;

  @override
  String get icon;
  @override
  String get fontFamily;
  @override
  @JsonKey(name: 'color')
  String? get colorString;
  @override
  double? get size;

  /// Create a copy of IconConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IconConfigImplCopyWith<_$IconConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
