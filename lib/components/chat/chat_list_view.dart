import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tony_chat_box/components/chat/chat_view.dart';
import 'package:tony_chat_box/database/assistant/assistant_db_provider.dart';
import 'package:tony_chat_box/database/assistant/assistant_info.dart';
import 'package:tony_chat_box/database/msg/message_db_provider.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/providers/msg_list.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';
import 'package:tony_chat_box/utils/log_util.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key, this.scrollController});

  final ScrollController? scrollController;

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  late ScrollController _scrollController;

  double _scrollStartPixel = 0.0;

  List<AssistantInfo> _assistantInfoList = [];

  bool _isReverse = true;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ScrollController();

    AssistantDbProvider()
        .getAssistantList()
        .then((value) => setState(() => _assistantInfoList = value));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedConversationProvider, (previous, next) {
      _scrollToNewMessage();
    });

    var msgList = ref.watch(msgListProvider);

    if (_isReverse) {
      msgList = msgList.reversed.toList();
    }

    final selectedConversation = ref.watch(selectedConversationProvider);

    return Column(
      children: [
        Expanded(
          child: selectedConversation.uuid.isEmpty
              ? _buildEmptyView()
              : Scrollbar(
                  controller: _scrollController,
                  child: NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollMetricsNotification &&
                          notification.depth == 0) {

                        var metrics = notification.metrics;

                        if (metrics.maxScrollExtent == 0) {
                          if (_isReverse) {
                            LogUtil.d('is do------>yes');
                            setState(() {
                              _isReverse = false;
                            });
                          }
                        } else {
                          if (!_isReverse) {
                            LogUtil.d('is do------>yes');
                            setState(() {
                              _isReverse = true;
                            });
                          }
                        }
                      }

                      if (notification is ScrollStartNotification) {
                        if (notification.depth == 0) {
                          _scrollStartPixel = notification.metrics.pixels;
                        }
                      } else if (notification is ScrollUpdateNotification) {
                        if ((notification.metrics.pixels - _scrollStartPixel)
                                .abs() >
                            0.1 * notification.metrics.viewportDimension) {
                          _focusNode.unfocus();
                        }
                      }
                      return false;
                    },
                    child: ListView.builder(
                      reverse: _isReverse,
                      padding: const EdgeInsets.all(16),
                      controller: _scrollController,
                      itemCount: msgList.length,
                      itemBuilder: (context, index) {
                        MsgInfo msgInfo = msgList[index];

                        return ChatView(
                          msgInfo,
                          index == msgList.length - 1 &&
                              msgInfo.finishReason == 'length',
                        );
                      },
                    ),
                  ),
                ),
        ),
        SafeArea(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 100),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.grey.shade300,
                  width: .3,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: _handleKeyEvent,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.inputQuestion,
                        hintText:
                            AppLocalizations.of(context)!.inputQuestionTips,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 48,
                    width: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        _sendMessage();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        padding: EdgeInsets.zero,
                      ),
                      child: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _sendMessage() async {
    final message = _controller.text;

    _controller.text = "";
    if (message.isNotEmpty) {
      var conversationUuid = ref.read(selectedConversationProvider).uuid;
      if (conversationUuid.isEmpty) {
        // new conversation
        var conversationInfo = await ref
            .read(conversationListProvider.notifier)
            .createConversation(message);

        conversationUuid = conversationInfo.uuid;
      }

      MsgInfo newMessage = MsgInfo(
        conversationId: conversationUuid,
        roleInt: Role.user.index,
        text: message,
        stateInt: MsgState.sending.index,
      );

      await ref.read(msgListProvider.notifier).sendMessage(newMessage);
      _scrollToNewMessage();
    }
  }

  void _handleKeyEvent(RawKeyEvent value) {
    if ((value.isKeyPressed(LogicalKeyboardKey.enter) &&
            value.isControlPressed) ||
        (value.isKeyPressed(LogicalKeyboardKey.enter) && value.isMetaPressed)) {
      _sendMessage();
    }
  }

  void _scrollToNewMessage() {
    if (_scrollController.hasClients) {
      _scrollController
          .animateTo(
            0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease,
          );
    }
  }

  Widget _buildEmptyView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: _assistantInfoList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var conversationInfo = await ref
                .read(conversationListProvider.notifier)
                .createConversation(_assistantInfoList[index].title);

            MessageDbProvider().addSystemMessageByAssistantId(
              conversationInfo.uuid,
              _assistantInfoList[index].id,
            );
          },
          child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    _assistantInfoList[index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _assistantInfoList[index].desc,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
