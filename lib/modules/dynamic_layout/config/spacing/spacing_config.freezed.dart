// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacing_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpacingConfig _$SpacingConfigFromJson(Map<String, dynamic> json) {
  return _SpacingConfig.fromJson(json);
}

/// @nodoc
mixin _$SpacingConfig {
  @JsonKey(name: 'margin')
  EdgeConfig? get marginConfig => throw _privateConstructorUsedError;
  @JsonKey(name: 'padding')
  EdgeConfig? get paddingConfig => throw _privateConstructorUsedError;

  /// Serializes this SpacingConfig to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpacingConfigCopyWith<SpacingConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacingConfigCopyWith<$Res> {
  factory $SpacingConfigCopyWith(
          SpacingConfig value, $Res Function(SpacingConfig) then) =
      _$SpacingConfigCopyWithImpl<$Res, SpacingConfig>;
  @useResult
  $Res call(
      {@JsonKey(name: 'margin') EdgeConfig? marginConfig,
      @JsonKey(name: 'padding') EdgeConfig? paddingConfig});

  $EdgeConfigCopyWith<$Res>? get marginConfig;
  $EdgeConfigCopyWith<$Res>? get paddingConfig;
}

/// @nodoc
class _$SpacingConfigCopyWithImpl<$Res, $Val extends SpacingConfig>
    implements $SpacingConfigCopyWith<$Res> {
  _$SpacingConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marginConfig = freezed,
    Object? paddingConfig = freezed,
  }) {
    return _then(_value.copyWith(
      marginConfig: freezed == marginConfig
          ? _value.marginConfig
          : marginConfig // ignore: cast_nullable_to_non_nullable
              as EdgeConfig?,
      paddingConfig: freezed == paddingConfig
          ? _value.paddingConfig
          : paddingConfig // ignore: cast_nullable_to_non_nullable
              as EdgeConfig?,
    ) as $Val);
  }

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EdgeConfigCopyWith<$Res>? get marginConfig {
    if (_value.marginConfig == null) {
      return null;
    }

    return $EdgeConfigCopyWith<$Res>(_value.marginConfig!, (value) {
      return _then(_value.copyWith(marginConfig: value) as $Val);
    });
  }

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EdgeConfigCopyWith<$Res>? get paddingConfig {
    if (_value.paddingConfig == null) {
      return null;
    }

    return $EdgeConfigCopyWith<$Res>(_value.paddingConfig!, (value) {
      return _then(_value.copyWith(paddingConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpacingConfigImplCopyWith<$Res>
    implements $SpacingConfigCopyWith<$Res> {
  factory _$$SpacingConfigImplCopyWith(
          _$SpacingConfigImpl value, $Res Function(_$SpacingConfigImpl) then) =
      __$$SpacingConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'margin') EdgeConfig? marginConfig,
      @JsonKey(name: 'padding') EdgeConfig? paddingConfig});

  @override
  $EdgeConfigCopyWith<$Res>? get marginConfig;
  @override
  $EdgeConfigCopyWith<$Res>? get paddingConfig;
}

/// @nodoc
class __$$SpacingConfigImplCopyWithImpl<$Res>
    extends _$SpacingConfigCopyWithImpl<$Res, _$SpacingConfigImpl>
    implements _$$SpacingConfigImplCopyWith<$Res> {
  __$$SpacingConfigImplCopyWithImpl(
      _$SpacingConfigImpl _value, $Res Function(_$SpacingConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? marginConfig = freezed,
    Object? paddingConfig = freezed,
  }) {
    return _then(_$SpacingConfigImpl(
      marginConfig: freezed == marginConfig
          ? _value.marginConfig
          : marginConfig // ignore: cast_nullable_to_non_nullable
              as EdgeConfig?,
      paddingConfig: freezed == paddingConfig
          ? _value.paddingConfig
          : paddingConfig // ignore: cast_nullable_to_non_nullable
              as EdgeConfig?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpacingConfigImpl
    with DiagnosticableTreeMixin
    implements _SpacingConfig {
  const _$SpacingConfigImpl(
      {@JsonKey(name: 'margin') this.marginConfig,
      @JsonKey(name: 'padding') this.paddingConfig});

  factory _$SpacingConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpacingConfigImplFromJson(json);

  @override
  @JsonKey(name: 'margin')
  final EdgeConfig? marginConfig;
  @override
  @JsonKey(name: 'padding')
  final EdgeConfig? paddingConfig;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SpacingConfig(marginConfig: $marginConfig, paddingConfig: $paddingConfig)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SpacingConfig'))
      ..add(DiagnosticsProperty('marginConfig', marginConfig))
      ..add(DiagnosticsProperty('paddingConfig', paddingConfig));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacingConfigImpl &&
            (identical(other.marginConfig, marginConfig) ||
                other.marginConfig == marginConfig) &&
            (identical(other.paddingConfig, paddingConfig) ||
                other.paddingConfig == paddingConfig));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, marginConfig, paddingConfig);

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacingConfigImplCopyWith<_$SpacingConfigImpl> get copyWith =>
      __$$SpacingConfigImplCopyWithImpl<_$SpacingConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpacingConfigImplToJson(
      this,
    );
  }
}

abstract class _SpacingConfig implements SpacingConfig {
  const factory _SpacingConfig(
          {@JsonKey(name: 'margin') final EdgeConfig? marginConfig,
          @JsonKey(name: 'padding') final EdgeConfig? paddingConfig}) =
      _$SpacingConfigImpl;

  factory _SpacingConfig.fromJson(Map<String, dynamic> json) =
      _$SpacingConfigImpl.fromJson;

  @override
  @JsonKey(name: 'margin')
  EdgeConfig? get marginConfig;
  @override
  @JsonKey(name: 'padding')
  EdgeConfig? get paddingConfig;

  /// Create a copy of SpacingConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpacingConfigImplCopyWith<_$SpacingConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
