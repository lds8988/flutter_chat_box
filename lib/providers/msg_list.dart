import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/message_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_chatgpt/utils/log.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'msg_list.g.dart';

@riverpod
class MsgList extends _$MsgList {
  @override
  List<MsgInfo> build() {
    return [];
  }

  Future<void> initMsgList(String uuid) async {
    state = await ConversationRepository.getInstance()
        .getMessagesByConversationUUid(uuid);
  }

  Future<void> sendMessage(MsgInfo msgInfo) async {
    await ConversationRepository.getInstance().addMessage(msgInfo);
    state = [...state, msgInfo];

    MessageRepository().postMessage(
      msgInfo,
      onSuccess: (msgInfo) async {
        await ConversationRepository.getInstance().addMessage(msgInfo);

        state = [...state, msgInfo];
      },
    );
  }

}
