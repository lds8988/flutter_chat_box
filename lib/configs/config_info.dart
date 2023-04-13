import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/configs/color_schemes.g.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'config_info.freezed.dart';
part 'config_info.g.dart';

@freezed
class ConfigInfo with _$ConfigInfo {
  const ConfigInfo._();

  get themeData => isDark
      ? ThemeData(useMaterial3: true, colorScheme: darkColorScheme)
      : ThemeData(useMaterial3: true, colorScheme: lightColorScheme);

  get locale => Locale(localeStr);

  const factory ConfigInfo({
    @Default(false) bool isDark,
    @Default("en") String localeStr,
    @Default("") String key,
    @Default("https://api.openai.com") String baseUrl,
    @Default(false) bool useStream,
    @Default("gpt-3.5-turbo") String gptModel,
    @Default("") String ip,
    @Default("") String port,
  }) = _ConfigInfo;

  factory ConfigInfo.fromJson(Map<String, dynamic> json) =>
      _$ConfigInfoFromJson(json);
}
