import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/components/chat/markdown/markdown.dart';
import 'package:flutter_chatgpt/providers/msg_list.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatView extends ConsumerStatefulWidget {
  const ChatView(this.msgInfo, {Key? key}) : super(key: key);

  final MsgInfo msgInfo;

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  late bool _isUser;

  @override
  void initState() {
    _isUser = widget.msgInfo.role == Role.user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          _isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              _isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (_isUser && widget.msgInfo.state == MsgState.failed)
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
                  child: const Icon(Icons.refresh, color: Colors.red,),
                ),
              ),
            FaIcon(_isUser ? FontAwesomeIcons.person : FontAwesomeIcons.robot),
            const SizedBox(
              width: 5,
            ),
            Text(_isUser
                ? AppLocalizations.of(context)!.roleUser
                : AppLocalizations.of(context)!.roleAssistant),
            if(!_isUser && widget.msgInfo.state == MsgState.sending)
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
              child: _isUser
                  ? SelectableText(
                      widget.msgInfo.text,
                    )
                  : Markdown(text: widget.msgInfo.text),
            ),
          ),
        ),
      ],
    );
  }
}
