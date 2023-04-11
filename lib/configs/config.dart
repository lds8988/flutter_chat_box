import 'package:flutter_chatgpt/configs/config_info.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_keys.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'config.g.dart';

@riverpod
class Config extends _$Config {
  @override
  ConfigInfo build() {
    var configJson = SPUtil.getInstance().getJson(SpKeys.config);

    return configJson == null
        ? const ConfigInfo()
        : ConfigInfo.fromJson(configJson);
  }

  void switchTheme() {
    state = state.copyWith(isDark: !state.isDark);
    _saveToSp();
  }

  void setKey(String key) {
    state = state.copyWith(key: key);
    _saveToSp();
  }

  void setProxyUrl(String baseUrl) {
    state = state.copyWith(baseUrl: baseUrl);
    _saveToSp();
  }

  void switchLocale() {
    state = state.copyWith(localeStr: state.localeStr == 'en' ? 'zh' : 'en');
    _saveToSp();
  }

  void setUseStream(bool useStream) {
    state = state.copyWith(useStream: useStream);
    _saveToSp();
  }

  void setGptModel(String value) {
    state = state.copyWith(gptModel: value);
    _saveToSp();
  }

  void _saveToSp() {
    SPUtil.getInstance().setJson(SpKeys.config, state.toJson());
  }
}
