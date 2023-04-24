import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tiktoken/tiktoken.dart';
import 'package:tony_chat_box/configs/config_info.dart';
import 'package:tony_chat_box/database/msg/message_db_provider.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/utils/ApiClient.dart';
import 'package:tony_chat_box/utils/log_util.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_keys.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_util.dart';

part 'msg_list.g.dart';

@riverpod
class MsgList extends _$MsgList {
  @override
  List<MsgInfo> build() {
    return [];
  }

  Future<List<MsgInfo>> initMsgList(String uuid) async {
    List<MsgInfo> msgList =
        await MessageDbProvider().getMessagesByConversationUUid(uuid);

    state = msgList.map((msgInfo) {
      if (msgInfo.state == MsgState.sending && msgInfo.role == Role.user) {
        msgInfo = msgInfo.copyWith(stateInt: MsgState.failed.index);
      }

      return msgInfo;
    }).toList();

    return state;
  }

  Future<void> sendMessage(MsgInfo userMsgInfo, {bool isRetry = false}) async {
    if (!isRetry) {
      int id = await MessageDbProvider().addMessage(userMsgInfo);
      userMsgInfo = userMsgInfo.copyWith(id: id);
      state = [...state, userMsgInfo];
    } else {
      userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.sending.index);
      await MessageDbProvider().updateMessage(userMsgInfo);

      state = [
        for (final msgInfo in state)
          if (msgInfo.id == userMsgInfo.id)
            msgInfo.copyWith(stateInt: MsgState.sending.index)
          else
            msgInfo,
      ];
    }

    var newMsgInfo = MsgInfo(
      conversationId: userMsgInfo.conversationId,
      text: "",
      roleInt: Role.assistant.index,
      stateInt: MsgState.sending.index,
    ); //仅仅第一个返回了角色

    state = [...state, newMsgInfo];

    var messageDbProvider = MessageDbProvider();

    postMessage(
      userMsgInfo.conversationId,
      onSuccess: (responseData) async {
        String message = responseData['choices'][0]['message']['content'];
        String finishReason = responseData['choices'][0]['finish_reason'];

        newMsgInfo = newMsgInfo.copyWith(
          text: message,
          stateInt: MsgState.received.index,
          finishReason: finishReason,
        );

        int newMsgId =
            await messageDbProvider.addMessage(newMsgInfo);

        userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.received.index);
        messageDbProvider.updateMessage(userMsgInfo);

        state = [
          for (final msgInfo in state)
            if (msgInfo.id == userMsgInfo.id)
              msgInfo.copyWith(
                stateInt: MsgState.received.index,
              )
            else if (msgInfo.id == null)
              msgInfo.copyWith(
                id: newMsgId,
                stateInt: MsgState.received.index,
                text: message,
                finishReason: finishReason,
              )
            else
              msgInfo,
        ];
      },
      onError: (error) async {
        if (error.isEmpty) {
          error = AppLocalizations.of(state as BuildContext)!.sendMsgErrTip;
        }

        SmartDialog.showToast(error);

        state = state.where((msgInfo) => msgInfo.id != null).toList();

        userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.failed.index);
        messageDbProvider.updateMessage(userMsgInfo);

        state = state.map((msgInfo) {
          if (msgInfo.id == userMsgInfo.id) {
            msgInfo = msgInfo.copyWith(stateInt: MsgState.failed.index);
          }

          return msgInfo;
        }).toList();
      },
    );
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

    var messageDbProvider = MessageDbProvider();

    List<MsgInfo> messages = await messageDbProvider
        .getSystemMessagesByConversationUuid(conversationId);

    int systemMsgCount = messages.length;

    List<Map<String, String>> openAIMessages = messages
        .map((message) => {
              'role': message.roleStr,
              'content': message.text,
            })
        .toList();

    int totalTokens = calTokensFromMessages(openAIMessages, model: model);

    List<MsgInfo> allMessages = await messageDbProvider
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

    var apiClient = ApiClient.getInstance();
    apiClient.setBaseUrl(configInfo.baseUrl);
    apiClient.setHeaders({
      'Authorization': 'Bearer ${configInfo.key}',
      'Content-Type': 'application/json',
    });

    if (configInfo.userProxy) {
      apiClient.setProxy(configInfo.ip, configInfo.port);
    }

    try {
      final response = await apiClient.post('/v1/chat/completions', data: {
        'model': model,
        'messages': openAIMessages,
        'max_tokens': 4097 - totalTokens,
        // 4097 是 open ai 规定的最大 token 总数，messages 的 token 总数和 max_tokens 的和不能超过 4097
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

  ConfigInfo _getConfigInfo() {
    ConfigInfo configInfo = const ConfigInfo();

    var configJson = SPUtil.getInstance().getJson(SpKeys.config);
    if (configJson != null) {
      configInfo = ConfigInfo.fromJson(configJson);
    }
    return configInfo;
  }

  Future<void> deleteMsg(int msgId) async {
    await MessageDbProvider().deleteMessage(msgId);
    state = state.where((msgInfo) => msgInfo.id != msgId).toList();
  }
}
