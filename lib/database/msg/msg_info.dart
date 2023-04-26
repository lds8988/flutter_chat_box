import 'package:freezed_annotation/freezed_annotation.dart';

part 'msg_info.freezed.dart';
part 'msg_info.g.dart';

@freezed
class MsgInfo with _$MsgInfo {
  const MsgInfo._();

  Role get role => Role.values[roleInt];

  MsgState get state => MsgState.values[stateInt];

  String get roleStr {
    switch (role) {
      case Role.system:
        return "system";
      case Role.user:
        return "user";
      case Role.assistant:
        return "assistant";
    }
  }

  factory MsgInfo({
    int? id,
    @JsonKey(name: 'uuid') required String conversationId,
    required String text,
    @JsonKey(name: 'role') required int roleInt,
    @JsonKey(name: "state")required int stateInt,
    @JsonKey(name: "finish_reason") @Default('null') String finishReason,
  }) = _MsgInfo;

  factory MsgInfo.fromJson(Map<String, dynamic> json) =>
      _$MsgInfoFromJson(json);
}

enum Role {
  system,
  user,
  assistant,
}

enum MsgState {
  sending,
  received,
  failed,
}
