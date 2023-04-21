import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';
import 'package:tony_chat_box/repository/conversation/conversation_info.dart';
import 'package:tony_chat_box/repository/conversation/conversation_repository.dart';
import 'package:uuid/uuid.dart';

part 'conversation_list.g.dart';

@riverpod
class ConversationList extends _$ConversationList {
  @override
  List<ConversationInfo> build() {
    return [];
  }

  Future<void> initConversationList() async {
    var conversationList =
        await ConversationRepository.getInstance().getConversations();
    state = conversationList;
  }

  Future<void> add(ConversationInfo conversationInfo) async {
    await ConversationRepository.getInstance()
        .addConversation(conversationInfo);
    state = [...state, conversationInfo];
  }

  Future<ConversationInfo> createConversation(String name) async {
    var uuid = const Uuid().v4();

    var conversationInfo = ConversationInfo(
      name: name,
      uuid: uuid,
    );

    add(conversationInfo);

    ref.read(selectedConversationProvider.notifier).update(conversationInfo);

    return conversationInfo;
  }

  Future<void> updateConversation(ConversationInfo conversationInfo) async {
    await ConversationRepository.getInstance()
        .updateConversation(conversationInfo);

    state = [
      for (final item in state)
        if (item.uuid == conversationInfo.uuid)
          item.copyWith(name: conversationInfo.name)
        else
          item
    ];
  }

  Future<void> deleteConversation(ConversationInfo conversationInfo) async {
    ConversationInfo selectedConversationInfo =
        ref.read(selectedConversationProvider);

    if (selectedConversationInfo.uuid == conversationInfo.uuid) {
      ref.read(selectedConversationProvider.notifier).clear();
    }

    await ConversationRepository.getInstance()
        .deleteConversation(conversationInfo.uuid);
    state = [
      for (final item in state)
        if (item.uuid != conversationInfo.uuid) item
    ];
  }
}
