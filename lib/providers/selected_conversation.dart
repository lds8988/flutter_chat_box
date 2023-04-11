import 'package:flutter_chatgpt/repository/conversation/conversation_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_conversation.g.dart';

@riverpod
class SelectedConversation extends _$SelectedConversation {

  @override
  ConversationInfo build() {
    return ConversationInfo(name: "", uuid: "");
  }

  void update(ConversationInfo conversationInfo) {
    state = conversationInfo;
  }

  void clear() {
    state = ConversationInfo(name: "", uuid: "");
  }
}