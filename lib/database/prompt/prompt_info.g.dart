// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PromptInfo _$$_PromptInfoFromJson(Map<String, dynamic> json) =>
    _$_PromptInfo(
      id: json['id'] as int?,
      content: json['content'] as String,
      robotId: json['assistant_id'] as String,
    );

Map<String, dynamic> _$$_PromptInfoToJson(_$_PromptInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'assistant_id': instance.robotId,
    };
