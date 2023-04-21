import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tony_chat_box/configs/config_info.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_keys.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_util.dart';

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

  void switchProxyMode() {
    state = state.copyWith(userProxy: !state.userProxy);
    _saveToSp();
  }

  void setKey(String key) {
    state = state.copyWith(key: key);
    _saveToSp();
  }

  void setBaseUrl(String baseUrl) {
    state = state.copyWith(baseUrl: baseUrl);
    _saveToSp();
  }

  void setIp(String ip) {
    state = state.copyWith(ip: ip);
    _saveToSp();
  }

  void setPort(String port) {
    state = state.copyWith(port: port);
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
