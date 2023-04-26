import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:tony_chat_box/configs/config.dart';
import 'package:tony_chat_box/configs/config_info.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/providers/msg_list.dart';

import 'code_wrapper.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView(
    this.msgInfo,
    this.showContinueBtn, {
    Key? key,
  }) : super(key: key);

  final MsgInfo msgInfo;
  final bool showContinueBtn;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {

  @override
  Widget build(BuildContext context) {
    var isUser = widget.msgInfo.role == Role.user;

    return Column(
      crossAxisAlignment:
          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isUser && widget.msgInfo.state == MsgState.failed)
              GestureDetector(
                onTap: () {
                  ref.read(msgListProvider.notifier).sendMessage(
                        widget.msgInfo,
                        isRetry: true,
                      );
                },
                child: Container(
                  height: 24,
                  margin: const EdgeInsets.only(right: 5),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.red,
                  ),
                ),
              ),
            FaIcon(isUser ? FontAwesomeIcons.person : FontAwesomeIcons.robot),
            const SizedBox(
              width: 5,
            ),
            Text(isUser
                ? AppLocalizations.of(context)!.roleUser
                : AppLocalizations.of(context)!.roleAssistant),
            if (!isUser && widget.msgInfo.state == MsgState.sending)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: CupertinoActivityIndicator(
                  radius: 8,
                ),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isUser
                  ? SelectableText(
                      widget.msgInfo.text,
                    )
                  : buildReplyContent(),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReplyContent() {

    ConfigInfo configInfo = ref.read(configProvider);

    final config = configInfo.isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);

    Widget replyContent = MarkdownWidget(
      data: widget.msgInfo.text,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      config: config.copy(configs: [
        configInfo.isDark
            ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
            : const PreConfig().copy(wrapper: codeWrapper)
      ]),
    );

    if (widget.showContinueBtn) {
      replyContent = Column(
        children: [
          replyContent,
          const Divider(),
          GestureDetector(
            onTap: () {
              MsgInfo newMessage = MsgInfo(
                conversationId: widget.msgInfo.conversationId,
                roleInt: Role.user.index,
                text: AppLocalizations.of(context)!.continueConversation,
                stateInt: MsgState.sending.index,
              );

              ref.read(msgListProvider.notifier).sendMessage(
                    newMessage,
                  );
            },
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child:
                    Text(AppLocalizations.of(context)!.continueConversation)),
          ),
        ],
      );
    }

    return replyContent;
  }
}
