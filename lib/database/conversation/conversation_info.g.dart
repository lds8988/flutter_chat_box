// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ConversationInfo _$$_ConversationInfoFromJson(Map<String, dynamic> json) =>
    _$_ConversationInfo(
      name: json['name'] as String,
      uuid: json['uuid'] as String,
      model: json['model'] as String? ?? 'gpt-3.5-turbo',
    );

Map<String, dynamic> _$$_ConversationInfoToJson(_$_ConversationInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uuid': instance.uuid,
      'model': instance.model,
    };
