import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tony_chat_box/components/chat/chat_list_view.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/providers/msg_list.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({
    super.key,
    this.conversationId,
    this.msg,
  });

  final String? conversationId;
  final String? msg;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    if (widget.conversationId != null) {
      ref.read(msgListProvider.notifier).initMsgList(widget.conversationId!);
    } else if (widget.msg != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(conversationListProvider.notifier)
            .createConversation(widget.msg!)
            .then((conversationInfo) {
          MsgInfo newMessage = MsgInfo(
            conversationId: conversationInfo.uuid,
            roleInt: Role.user.index,
            text: widget.msg!,
            stateInt: MsgState.sending.index,
          );

          ref.read(msgListProvider.notifier).sendMessage(newMessage);
        });
      });
    }

    super.initState();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (MediaQuery.of(context).viewInsets.bottom > 0 &&
        _scrollController.position.pixels !=
            _scrollController.position.maxScrollExtent) {

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(selectedConversationProvider).name),
      ),
      body: ChatListView(
        scrollController: _scrollController,
      ),
    );
  }
}
