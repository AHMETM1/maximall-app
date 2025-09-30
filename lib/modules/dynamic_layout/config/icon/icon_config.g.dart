// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IconConfigImpl _$$IconConfigImplFromJson(Map<String, dynamic> json) =>
    _$IconConfigImpl(
      icon: json['icon'] as String,
      fontFamily: json['fontFamily'] as String,
      colorString: json['color'] as String?,
      size: (json['size'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$IconConfigImplToJson(_$IconConfigImpl instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'fontFamily': instance.fontFamily,
      'color': instance.colorString,
      'size': instance.size,
    };
