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
    );

Map<String, dynamic> _$$_MsgInfoToJson(_$_MsgInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.conversationId,
      'text': instance.text,
      'role': instance.roleInt,
    };
