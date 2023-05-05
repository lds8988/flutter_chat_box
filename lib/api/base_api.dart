import 'package:dio/dio.dart';
import 'package:tony_chat_box/configs/config_info.dart';
import 'package:tony_chat_box/utils/api_client.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_keys.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_util.dart';

enum RequestType { get, post }

abstract class BaseApi {
  BaseApi() {
    _configInfo = _getConfigInfo();
    _apiClient.setHeaders({
      'Authorization': 'Bearer ${_configInfo.key}',
    });
    if (_configInfo.userProxy) {
      _apiClient.setProxy(_configInfo.ip, _configInfo.port);
    }
  }

  late ConfigInfo _configInfo;

  final ApiClient _apiClient = ApiClient.getInstance();

  final Map<String, dynamic> _params = <String, dynamic>{};

  get params => _params;

  ConfigInfo _getConfigInfo() {
    ConfigInfo configInfo = const ConfigInfo();

    var configJson = SPUtil.getInstance().getJson(SpKeys.config);
    if (configJson != null) {
      configInfo = ConfigInfo.fromJson(configJson);
    }
    return configInfo;
  }

  String getPath();

  RequestType getMethod() {
    return RequestType.post;
  }

  Future<Response> send() {
    String path;

    if (getPath().startsWith('http')) {
      path = getPath();
    } else {
      path = _configInfo.baseUrl + getPath();
    }

    Future<Response> response;

    if (getMethod() == RequestType.get) {
      response = _apiClient.get(path, queryParameters: _params);
    } else {
      response = _apiClient.post(path, data: _params);
    }

    return response;
  }
}
