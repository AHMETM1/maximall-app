// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderConfigImpl _$$OrderConfigImplFromJson(Map<String, dynamic> json) =>
    _$OrderConfigImpl(
      version: (json['version'] as num?)?.toInt() ?? 1,
      enableReorder: json['enableReorder'] as bool? ?? true,
    );

Map<String, dynamic> _$$OrderConfigImplToJson(_$OrderConfigImpl instance) =>
    <String, dynamic>{
      'version': instance.version,
      'enableReorder': instance.enableReorder,
    };
