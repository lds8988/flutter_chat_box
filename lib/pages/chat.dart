import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/components/chat/chat_list_view.dart';
import 'package:flutter_chatgpt/providers/conversation_list.dart';
import 'package:flutter_chatgpt/providers/msg_list.dart';
import 'package:flutter_chatgpt/providers/selected_conversation.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_chatgpt/utils/log_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
