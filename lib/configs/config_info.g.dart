// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConfigInfo _$$_ConfigInfoFromJson(Map<String, dynamic> json) =>
    _$_ConfigInfo(
      isDark: json['isDark'] as bool? ?? false,
      localeStr: json['localeStr'] as String? ?? "en",
      key: json['key'] as String? ?? "",
      baseUrl: json['baseUrl'] as String? ?? "https://api.openai.com",
      useStream: json['useStream'] as bool? ?? false,
      gptModel: json['gptModel'] as String? ?? "gpt-3.5-turbo",
      ip: json['ip'] as String? ?? "",
      port: json['port'] as String? ?? "",
    );

Map<String, dynamic> _$$_ConfigInfoToJson(_$_ConfigInfo instance) =>
    <String, dynamic>{
      'isDark': instance.isDark,
      'localeStr': instance.localeStr,
      'key': instance.key,
      'baseUrl': instance.baseUrl,
      'useStream': instance.useStream,
      'gptModel': instance.gptModel,
      'ip': instance.ip,
      'port': instance.port,
    };
