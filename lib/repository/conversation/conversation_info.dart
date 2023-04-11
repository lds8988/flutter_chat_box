import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_info.freezed.dart';

part 'conversation_info.g.dart';

@freezed
class ConversationInfo with _$ConversationInfo {
  factory ConversationInfo({
    required String name,
    required String uuid,
  }) = _ConversationInfo;

  factory ConversationInfo.fromJson(Map<String, dynamic> json) =>
      _$ConversationInfoFromJson(json);
}
