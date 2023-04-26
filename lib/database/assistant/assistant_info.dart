import 'package:freezed_annotation/freezed_annotation.dart';

part 'assistant_info.freezed.dart';
part 'assistant_info.g.dart';

@freezed
class AssistantInfo with _$AssistantInfo {
  factory AssistantInfo({
    required String id,
    required String title,
    required String desc,
  }) = _AssistantInfo;

  factory AssistantInfo.fromJson(Map<String, dynamic> json) =>
      _$AssistantInfoFromJson(json);
}
