import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/components/chat_view.dart';
import 'package:flutter_chatgpt/providers/conversation_list.dart';
import 'package:flutter_chatgpt/providers/msg_list.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
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

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
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
          );

          ref.read(msgListProvider.notifier).sendMessage(newMessage);
        });
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: const ChatView(),
    );
  }
}
