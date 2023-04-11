import 'package:dart_openai/openai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chatgpt/configs/config_info.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_keys.dart';
import 'package:flutter_chatgpt/utils/sharded_preference/sp_util.dart';

class MessageRepository {
  static final MessageRepository _instance = MessageRepository._internal();

  factory MessageRepository() {
    return _instance;
  }

  MessageRepository._internal() {
    init();
  }

  void postMessage(
    MsgInfo message, {
    ValueChanged<MsgInfo>? onResponse,
    ValueChanged<MsgInfo>? onError,
    ValueChanged<MsgInfo>? onSuccess,
  }) async {
    List<MsgInfo> messages = await ConversationRepository.getInstance()
        .getMessagesByConversationUUid(message.conversationId);
    _getResponseFromGpt(
      messages,
      onResponse: onResponse,
      errorCallback: onError,
      onSuccess: onSuccess,
    );
  }

  void init() {
    ConfigInfo configInfo = _getConfigInfo();

    OpenAI.apiKey = configInfo.key;
    OpenAI.baseUrl = configInfo.baseUrl;
  }

  void _getResponseFromGpt(
    List<MsgInfo> messages, {
    ValueChanged<MsgInfo>? onResponse,
    ValueChanged<MsgInfo>? errorCallback,
    ValueChanged<MsgInfo>? onSuccess,
  }) async {
    List<OpenAIChatCompletionChoiceMessageModel> openAIMessages = messages
        .map((message) => OpenAIChatCompletionChoiceMessageModel(
              content: message.text,
              role: message.role == Role.user
                  ? OpenAIChatMessageRole.user
                  : OpenAIChatMessageRole.assistant,
            ))
        .toList();
    var message = MsgInfo(
        conversationId: messages.first.conversationId,
        text: "",
        roleInt: Role.assistant.index); //仅仅第一个返回了角色

    ConfigInfo configInfo = _getConfigInfo();

    if (configInfo.useStream) {
      Stream<OpenAIStreamChatCompletionModel> chatStream = OpenAI.instance.chat
          .createStream(model: configInfo.gptModel, messages: openAIMessages);
      chatStream.listen(
        (chatStreamEvent) {
          if (chatStreamEvent.choices.first.delta.content != null) {
            if (onResponse != null) {
              onResponse(message.copyWith(
                  text: chatStreamEvent.choices.first.delta.content!));
            }
          }
        },
        onError: (error) {
          if (errorCallback != null) {
            errorCallback(message.copyWith(text: error.message));
          }
        },
        onDone: () {
          if (onSuccess != null) {
            onSuccess(message);
          }
        },
      );
    } else {
      try {
        var response = await OpenAI.instance.chat.create(
          model: configInfo.gptModel,
          messages: openAIMessages,
        );
        if (onSuccess != null) {
          onSuccess(
              message.copyWith(text: response.choices.first.message.content));
        }
      } catch (e) {
        if (errorCallback != null) {
          errorCallback(message.copyWith(text: e.toString()));
        }
      }
    }
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
