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
import 'package:tiktoken/tiktoken.dart';

class MessageRepository {
  static final MessageRepository _instance = MessageRepository._internal();

  late Dio _dio;

  factory MessageRepository() {
    return _instance;
  }

  MessageRepository._internal() {
    init();
  }

  int calTokensFromMessages(List<Map<String, dynamic>> messages,
      {String model = "gpt-3.5-turbo-0301"}) {
    final encoding = encodingForModel(model);

    int tokensPerMessage = 0;
    int tokensPerName = 1;

    switch (model) {
      case "gpt-3.5-turbo":
        // gpt-3.5-turbo may change over time. Returning num tokens assuming gpt-3.5-turbo-0301
        return calTokensFromMessages(messages, model: "gpt-3.5-turbo-0301");
      case "gpt-4":
        // gpt-4 may change over time. Returning num tokens assuming gpt-4-0314
        return calTokensFromMessages(messages, model: "gpt-4-0314");
      case "gpt-3.5-turbo-0301":
        tokensPerMessage = 4;
        tokensPerName = -1;
        break;
      case "gpt-4-0314":
        tokensPerMessage = 3;
        tokensPerName = 1;
        break;
      default:
        throw Exception(
            "Unknown model: $model, See https://github.com/openai/openai-python/blob/main/chatml.md for information on how messages are converted to tokens.");
    }

    int numTokens = 0;
    for (Map message in messages) {
      numTokens += tokensPerMessage;
      for (String key in message.keys) {
        String value = message[key];
        numTokens += encoding.encode(value).length;
        if (key == "name") {
          numTokens += tokensPerName;
        }
      }
    }
    numTokens += 3;
    return numTokens;
  }

  void postMessage(
    String conversationId, {
    ValueChanged<String>? onResponse,
    ValueChanged<String>? onError,
    ValueChanged<Map<String, dynamic>>? onSuccess,
  }) async {
    ConfigInfo configInfo = _getConfigInfo();

    String model = configInfo.gptModel;

    List<MsgInfo> messages = await ConversationRepository.getInstance()
        .getSystemMessagesByConversationUuid(conversationId);

    int systemMsgCount = messages.length;

    List<Map<String, String>> openAIMessages = messages
        .map((message) => {
              'role': message.roleStr,
              'content': message.text,
            })
        .toList();

    int totalTokens = calTokensFromMessages(openAIMessages, model: model);

    List<MsgInfo> allMessages = await ConversationRepository.getInstance()
        .getMessagesByConversationUUid(conversationId, order: "DESC");

    // 在不超过 open ai 规定最大 token 总数的情况下尽量多添加消息
    for (int i = 0; i < allMessages.length; i++) {
      Map<String, String> openAIMsg = {
        'role': allMessages[i].roleStr,
        'content': allMessages[i].text,
      };

      int msgTokens = calTokensFromMessages(
        [openAIMsg],
        model: model,
      );

      if (totalTokens + msgTokens <= 3096) {
        totalTokens += msgTokens;

        openAIMessages.insert(systemMsgCount, openAIMsg);
      } else {
        break;
      }
    }

    LogUtil.i("total tokens: $totalTokens");

    _dio.options.baseUrl = configInfo.baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer ${configInfo.key}',
      'Content-Type': 'application/json',
    };

    if (configInfo.ip.isNotEmpty && configInfo.port.isNotEmpty) {
      _dio.httpClientAdapter =
          IOHttpClientAdapter(onHttpClientCreate: (client) {
        client.findProxy = (uri) {
          return "PROXY ${configInfo.ip}:${configInfo.port}";
        };

        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;

        return client;
      });
    }

    try {
      final response = await _dio.post('/v1/chat/completions', data: {
        'model': model,
        'messages': openAIMessages,
        'max_tokens': 4097 - totalTokens, // 4097 是 open ai 规定的最大 token 总数，messages 的 token 总数和 max_tokens 的和不能超过 4097
      });

      if (response.statusCode == 200) {
        if (onSuccess != null) {

          onSuccess(response.data);
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
