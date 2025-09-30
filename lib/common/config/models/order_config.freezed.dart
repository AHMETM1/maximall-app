// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrderConfig _$OrderConfigFromJson(Map<String, dynamic> json) {
  return _OrderConfig.fromJson(json);
}

/// @nodoc
mixin _$OrderConfig {
  int get version => throw _privateConstructorUsedError;
  bool get enableReorder => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderConfigCopyWith<OrderConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderConfigCopyWith<$Res> {
  factory $OrderConfigCopyWith(
          OrderConfig value, $Res Function(OrderConfig) then) =
      _$OrderConfigCopyWithImpl<$Res, OrderConfig>;
  @useResult
  $Res call({int version, bool enableReorder});
}

/// @nodoc
class _$OrderConfigCopyWithImpl<$Res, $Val extends OrderConfig>
    implements $OrderConfigCopyWith<$Res> {
  _$OrderConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? enableReorder = null,
  }) {
    return _then(_value.copyWith(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      enableReorder: null == enableReorder
          ? _value.enableReorder
          : enableReorder // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderConfigImplCopyWith<$Res>
    implements $OrderConfigCopyWith<$Res> {
  factory _$$OrderConfigImplCopyWith(
          _$OrderConfigImpl value, $Res Function(_$OrderConfigImpl) then) =
      __$$OrderConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int version, bool enableReorder});
}

/// @nodoc
class __$$OrderConfigImplCopyWithImpl<$Res>
    extends _$OrderConfigCopyWithImpl<$Res, _$OrderConfigImpl>
    implements _$$OrderConfigImplCopyWith<$Res> {
  __$$OrderConfigImplCopyWithImpl(
      _$OrderConfigImpl _value, $Res Function(_$OrderConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? version = null,
    Object? enableReorder = null,
  }) {
    return _then(_$OrderConfigImpl(
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as int,
      enableReorder: null == enableReorder
          ? _value.enableReorder
          : enableReorder // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderConfigImpl with DiagnosticableTreeMixin implements _OrderConfig {
  const _$OrderConfigImpl({this.version = 1, this.enableReorder = true});

  factory _$OrderConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderConfigImplFromJson(json);

  @override
  @JsonKey()
  final int version;
  @override
  @JsonKey()
  final bool enableReorder;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderConfig(version: $version, enableReorder: $enableReorder)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderConfig'))
      ..add(DiagnosticsProperty('version', version))
      ..add(DiagnosticsProperty('enableReorder', enableReorder));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderConfigImpl &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.enableReorder, enableReorder) ||
                other.enableReorder == enableReorder));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, version, enableReorder);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderConfigImplCopyWith<_$OrderConfigImpl> get copyWith =>
      __$$OrderConfigImplCopyWithImpl<_$OrderConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderConfigImplToJson(
      this,
    );
  }
}

abstract class _OrderConfig implements OrderConfig {
  const factory _OrderConfig({final int version, final bool enableReorder}) =
      _$OrderConfigImpl;

  factory _OrderConfig.fromJson(Map<String, dynamic> json) =
      _$OrderConfigImpl.fromJson;

  @override
  int get version;
  @override
  bool get enableReorder;
  @override
  @JsonKey(ignore: true)
  _$$OrderConfigImplCopyWith<_$OrderConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
