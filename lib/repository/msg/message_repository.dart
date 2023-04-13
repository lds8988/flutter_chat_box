import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/configs/config_info.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_chatgpt/utils/log_util.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_keys.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_util.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class MessageRepository {
  static final MessageRepository _instance = MessageRepository._internal();

  late Dio _dio;

  factory MessageRepository() {
    return _instance;
  }

  MessageRepository._internal() {
    init();
  }

  int countTokens(String text) {
    // 将文本按照 UTF-8 编码进行分割
    List<int> utf8Bytes = text.codeUnits;

    // 遍历 UTF-8 编码的字节序列，判断每个字节是否属于多字节字符的一部分
    int tokens = 0;
    for (int i = 0; i < utf8Bytes.length; i++) {
      if ((utf8Bytes[i] & 0xC0) != 0x80) {
        tokens++; // 每个非多字节字符都算作一个 token
      }
    }

    return tokens;
  }

  void postMessage(
    String conversationId, {
    ValueChanged<String>? onResponse,
    ValueChanged<String>? onError,
    ValueChanged<String>? onSuccess,
  }) async {

    List<MsgInfo> messages = await ConversationRepository.getInstance()
        .getSystemMessagesByConversationUuid(conversationId);

    int totalTokens = 0;

    List<MsgInfo> allMessages = await ConversationRepository.getInstance()
        .getMessagesByConversationUUid(conversationId, order: "DESC");

    messages.add(allMessages[0]);

    for (var message in messages) {
      totalTokens += countTokens(message.text);
    }

    // 在不超过 open ai 规定最大 token 总数的情况下尽量多添加消息
    for (int i = 1; i < allMessages.length - 1; i++) {
      int msgTokens = countTokens(allMessages[i].text);
      if (totalTokens + msgTokens <= 4096) {
        totalTokens += msgTokens;
        if(messages.length > 1) {
          messages.insert(messages.length - 1, allMessages[i]);
        } else {
          messages.add(allMessages[i]);
        }

      } else {
        break;
      }
    }

    LogUtil.i("total tokens: $totalTokens");

    List<Map<String, dynamic>> openAIMessages = messages
        .map((message) => {
              'role': message.roleStr,
              'content': message.text,
            })
        .toList();

    ConfigInfo configInfo = _getConfigInfo();

    _dio.options.baseUrl = configInfo.baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer ${configInfo.key}', // 替换为您的实际 API 密钥
      'Content-Type': 'application/json',
    };

    if(configInfo.ip.isNotEmpty && configInfo.port.isNotEmpty) {
      _dio.httpClientAdapter = IOHttpClientAdapter(onHttpClientCreate: (client) {
        client.findProxy = (uri) {

          LogUtil.d(configInfo, title: "config info");

          return "PROXY ${configInfo.ip}:${configInfo.port}";
        };

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        return client;
      });
    }

    try {
      final response = await _dio.post('/v1/chat/completions', data: {
        'model': configInfo.gptModel,
        'messages': openAIMessages,
        'max_tokens': 2048,
      });

      if (response.statusCode == 200) {
        if (onSuccess != null) {
          String message = response.data['choices'][0]['message']['content'];

          onSuccess(message);
        }
      } else {
        if (onError != null) {
          onError(response.statusMessage ?? "");
        }
      }
    } catch (e) {
      if (onError != null) {
        onError(e.toString());
      }
    }
  }

  void init() {

    _dio = Dio();

    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      maxWidth: 130,
    ));

  }

  ConfigInfo _getConfigInfo() {
    ConfigInfo configInfo = const ConfigInfo();

    var configJson = SPUtil.getInstance().getJson(SpKeys.config);
    if (configJson != null) {
      configInfo = ConfigInfo.fromJson(configJson);
    }
    return configInfo;
  }

  deleteMessage(int messageId) {
    ConversationRepository.getInstance().deleteMessage(messageId);
  }
}
