import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/message_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_chatgpt/utils/log_util.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'msg_list.g.dart';

@riverpod
class MsgList extends _$MsgList {
  @override
  List<MsgInfo> build() {
    return [];
  }

  Future<List<MsgInfo>> initMsgList(String uuid) async {
    List<MsgInfo> msgList = await ConversationRepository.getInstance()
        .getMessagesByConversationUUid(uuid);

    LogUtil.d(msgList, title: "msg list");

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
      int id =
          await ConversationRepository.getInstance().addMessage(userMsgInfo);
      userMsgInfo = userMsgInfo.copyWith(id: id);
      state = [...state, userMsgInfo];
    } else {

      userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.sending.index);
      await ConversationRepository.getInstance().updateMessage(userMsgInfo);

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

    MessageRepository().postMessage(
      userMsgInfo.conversationId,
      onSuccess: (receivedMsg) async {
        newMsgInfo = newMsgInfo.copyWith(
          text: receivedMsg,
          stateInt: MsgState.received.index,
        );

        int newMsgId =
        await ConversationRepository.getInstance().addMessage(newMsgInfo);

        userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.received.index);
        ConversationRepository.getInstance().updateMessage(userMsgInfo);

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
                text: receivedMsg,
              )
            else
              msgInfo,
        ];
      },
      onError: (error) async {
        LogUtil.e(error, title: "send message error");

        if (error.isEmpty) {
          error = AppLocalizations.of(state as BuildContext)!.sendMsgErrTip;
        }

        SmartDialog.showToast(error);

        state = state.where((msgInfo) => msgInfo.id != null).toList();

        userMsgInfo = userMsgInfo.copyWith(stateInt: MsgState.failed.index);
        ConversationRepository.getInstance().updateMessage(userMsgInfo);

        state = state.map((msgInfo) {
          if (msgInfo.id == userMsgInfo.id) {
            msgInfo = msgInfo.copyWith(stateInt: MsgState.failed.index);
          }

          return msgInfo;
        }).toList();
      },
    );
  }

  Future<void> deleteMsg(int msgId) async {
    await ConversationRepository.getInstance().deleteMessage(msgId);
    state = state.where((msgInfo) => msgInfo.id != msgId).toList();
  }
}
