import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/bloc/conversation_bloc.dart';
import 'package:flutter_chatgpt/bloc/message_bloc.dart';
import 'package:flutter_chatgpt/cubit/setting_cubit.dart';
import 'package:flutter_chatgpt/repository/conversation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConversationWindow extends StatefulWidget {
  const ConversationWindow({super.key});

  @override
  State<ConversationWindow> createState() => _ConversationWindowState();
}

class _ConversationWindowState extends State<ConversationWindow> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context)
        .add(const LoadConversationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: BlocProvider.of<UserSettingCubit>(context)
                .state
                .themeData
                .cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              state.runtimeType == ConversationInitial ||
                      state.conversations.isEmpty
                  ? Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.noConversationTips,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              _tapConversation(index);
                            },
                            selected: state.currentConversationUuid ==
                                state.conversations[index].uuid,
                            leading: const Icon(Icons.chat),
                            title: Text(state.conversations[index].name),
                            trailing: Builder(builder: (context) {
                              return IconButton(
                                  onPressed: () {
                                    //显示一个overlay操作
                                    _showConversationDetail(context, index);
                                  },
                                  icon: const Icon(Icons.more_horiz));
                            }),
                          );
                        },
                      ),
                    ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: const BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(width: .3, color: Colors.grey),
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    _showNewConversationDialog(context);
                  },
                  label: Text(AppLocalizations.of(context)!.newConversation),
                  icon: const Icon(Icons.add_box),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConversationDetail(BuildContext context, int index) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu(
      context: context,
      position: position,
      items: [
        const PopupMenuItem(
          value: "delete",
          child: Text("Delete"),
        ),
        const PopupMenuItem(
          value: "rename",
          child: Text("ReName"),
        ),
      ],
    ).then((value) {
      if (value == "delete") {
        BlocProvider.of<ConversationBloc>(context).add(DeleteConversationEvent(
            context.read<ConversationBloc>().state.conversations[index]));
      } else if (value == "rename") {
        _renameConversation(context, index);
        BlocProvider.of<ConversationBloc>(context).add(UpdateConversationEvent(
            context.read<ConversationBloc>().state.conversations[index]));
      }
    });
  }

  void _showNewConversationDialog(BuildContext context) {
    context.read<ConversationBloc>().add(const ChooseConversationEvent(""));
    context
        .read<MessageBloc>()
        .add(const LoadAllMessagesEvent("new conversation"));
  }

  void _renameConversation(BuildContext context, int index) {
    var outerContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        controller.text = outerContext
            .read<ConversationBloc>()
            .state
            .conversations[index]
            .name;
        return AlertDialog(
          title: const Text("Rename Conversation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Enter the new name',
                  hintText: 'Enter the new name',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                autovalidateMode: AutovalidateMode.always,
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:  Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<ConversationBloc>(outerContext).add(
                  UpdateConversationEvent(
                    Conversation(
                      name: controller.text,
                      description: "",
                      uuid: outerContext
                          .read<ConversationBloc>()
                          .state
                          .conversations[index]
                          .uuid,
                    ),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  _tapConversation(int index) {
    String conversationUUid =
        context.read<ConversationBloc>().state.conversations[index].uuid;
    context
        .read<ConversationBloc>()
        .add(ChooseConversationEvent(conversationUUid));
    context.read<MessageBloc>().add(LoadAllMessagesEvent(conversationUUid));
  }
}
