import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  ApiClient._internal() {
    _dio = Dio();

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      maxWidth: 130,
    ));
  }

  factory ApiClient.getInstance() => _instance ??= ApiClient._internal();

  static ApiClient? _instance;

  late Dio _dio;

  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void setHeaders(Map<String, dynamic> headers) {
    _dio.options.headers = headers;
  }

  void setProxy(String ip, String port) {
    _dio.httpClientAdapter = IOHttpClientAdapter(onHttpClientCreate: (client) {
      client.findProxy = (uri) {
        return "PROXY $ip:$port";
      };

      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      return client;
    });
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) {
    return _dio.post(path, queryParameters: queryParameters, data: data);
  }
}
