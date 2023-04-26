import 'package:freezed_annotation/freezed_annotation.dart';

part 'prompt_info.freezed.dart';
part 'prompt_info.g.dart';

@freezed
class PromptInfo with _$PromptInfo {
  factory PromptInfo({
    int? id,
    required String content,
    @JsonKey(name: 'assistant_id') required String robotId,
  }) = _PromptInfo;

  factory PromptInfo.fromJson(Map<String, dynamic> json) =>
      _$PromptInfoFromJson(json);

}