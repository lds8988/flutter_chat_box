import 'package:freezed_annotation/freezed_annotation.dart';

part 'msg_info.freezed.dart';

part 'msg_info.g.dart';

@freezed
class MsgInfo with _$MsgInfo {
  const MsgInfo._();

  Role get role => Role.values[roleInt];

  factory MsgInfo(
      {int? id,
      @JsonKey(name: 'uuid') required String conversationId,
      required String text,
      @JsonKey(name: 'role') required int roleInt}) = _MsgInfo;

  factory MsgInfo.fromJson(Map<String, dynamic> json) =>
      _$MsgInfoFromJson(json);
}

enum Role {
  system,
  user,
  assistant,
}
