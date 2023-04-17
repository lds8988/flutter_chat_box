import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt/components/chat/chat_view.dart';
import 'package:flutter_chatgpt/providers/conversation_list.dart';
import 'package:flutter_chatgpt/providers/msg_list.dart';
import 'package:flutter_chatgpt/providers/selected_conversation.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_info.dart';
import 'package:flutter_chatgpt/repository/conversation/conversation_repository.dart';
import 'package:flutter_chatgpt/repository/msg/msg_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key});

  @override
  ConsumerState<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState extends ConsumerState<ChatListView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedConversationProvider, (previous, next) {
      final msg = ref.read(msgListProvider.notifier);
      msg.initMsgList(next.uuid).then((value) {
        if (value.isNotEmpty) {
          _scrollToNewMessage();
        }
      });
    });

    ref.listen(msgListProvider, (previous, next) {
      if (next.isNotEmpty) {
        _scrollToNewMessage();
      }
    });

    final msgList = ref.watch(msgListProvider);

    final selectedConversation = ref.watch(selectedConversationProvider);

    return Column(
      children: [
        Expanded(
          child: selectedConversation.uuid.isEmpty
              ? _buildEmptyView()
              : Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
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
        Container(
          constraints: const BoxConstraints(maxHeight: 100),
          padding: const EdgeInsets.all(16),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: _handleKeyEvent,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.inputQuestion,
                      hintText: AppLocalizations.of(context)!.inputQuestionTips,
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
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent),
      );
    }
  }

  Widget _buildEmptyView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: sceneList.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () async {
            var conversationInfo = await ref
                .read(conversationListProvider.notifier)
                .createConversation(sceneList[index]["title"] as String);

            ConversationRepository.getInstance().addSystemMessage(
              conversationInfo.uuid,
              sceneList[index]["description"] as String,
            );
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: sceneList[index]["color"] as Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  '${sceneList[index]["title"]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    '${sceneList[index]["description"]}',
                    maxLines: 10,
                    style: const TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

var sceneList = [
  {
    "title": "前端开发",
    "color": Colors.blue[300],
    "description": "需要你扮演技术精湛的前端开发工程师，解决前端问题"
  },
  {
    "title": "后端开发",
    "color": Colors.green[300],
    "description": "需要你扮演技术精湛的后端开发工程师，解决后端问题"
  },
  {
    "title": "小红书标题",
    "color": Colors.purple[300],
    "description": '''
      💃 10S自测适合裙子or裤子 (结果)\n
      ✂️ 旧衣改造穿出新花样 (事件)\n
      👗 穿搭博主 vs 现实中穿搭 (对比)\n
      🔢 4种体型女生穿搭技巧！ (解决方案)\n
      🎨 最显白颜色穿搭 (结果)\n
      🙋 当代女生买裙子难处 (细分人群+共鸣)\n
      👠 双开门衣柜装鞋情况 (数字+结果)\n
      👗 微胖穿搭建议 (细分人群+数字)\n
      🧦 万能袜子搭配公式 (解决方案+结果)\n
      请基于上述小红书标题和括号里的编写逻辑，针对用户输入生成10个新的小红书标题，标题中应当使用恰当的emoji表情
      '''
  },
  {
    "title": "Prompt 编写导师",
    "color": Colors.orange[300],
    "description": "需要你扮演Prompt 编写导师，我写一段话，你帮我写Prompt"
  },
  {
    "title": "小程序开发",
    "color": Colors.red[300],
    "description": "需要你扮演小程序开发工程师，解决小程序研发疑难杂症"
  },
  {
    "title": "运维工程师",
    "color": Colors.blueGrey[300],
    "description": "需要你扮演运维工程师，需要维护系统的稳定性"
  },
];
