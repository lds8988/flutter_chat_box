// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'msg_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MsgInfo _$$_MsgInfoFromJson(Map<String, dynamic> json) => _$_MsgInfo(
      id: json['id'] as int?,
      conversationId: json['uuid'] as String,
      text: json['text'] as String,
      roleInt: json['role'] as int,
      stateInt: json['state'] as int,
      finishReason: json['finish_reason'] as String? ?? 'null',
    );

Map<String, dynamic> _$$_MsgInfoToJson(_$_MsgInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.conversationId,
      'text': instance.text,
      'role': instance.roleInt,
      'state': instance.stateInt,
      'finish_reason': instance.finishReason,
    };
