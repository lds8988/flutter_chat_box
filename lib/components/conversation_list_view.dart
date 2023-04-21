import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tony_chat_box/device/form_factor.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';
import 'package:tony_chat_box/repository/conversation/conversation_info.dart';
import 'package:tony_chat_box/route/route_util.dart';

class ConversationListView extends ConsumerStatefulWidget {
  const ConversationListView(this.emptyTip, {super.key});

  final String emptyTip;

  @override
  ConsumerState<ConversationListView> createState() =>
      _ConversationListViewState();
}

class _ConversationListViewState extends ConsumerState<ConversationListView> {
  @override
  void initState() {
    final conversation = ref.read(conversationListProvider.notifier);
    conversation.initConversationList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final conversationList = ref.watch(conversationListProvider);

    final selectedConversation = ref.watch(selectedConversationProvider);

    bool isPhoneSize =
        MediaQuery.of(this.context).size.width < FormFactor.tablet;

    return conversationList.isEmpty
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  widget.emptyTip,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: conversationList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onSecondaryTapUp: (details) {
                  _showConversationDetail(
                      conversationList[index], details.globalPosition);
                },
                onLongPressStart: (details) {
                  HapticFeedback.vibrate();
                  _showConversationDetail(
                      conversationList[index], details.globalPosition);
                },
                child: ListTile(
                  onTap: () {
                    _tapConversation(conversationList[index]);

                    if (isPhoneSize) {
                      RouteUtil.jumpToChatPage(
                        this.context,
                        conversationId: conversationList[index].uuid,
                      );
                    }
                  },
                  selected: !isPhoneSize &&
                      (selectedConversation.uuid ==
                          conversationList[index].uuid),
                  leading: const Icon(Icons.chat),
                  title: Text(
                    conversationList[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          );
  }

  void _showConversationDetail(
      ConversationInfo conversationInfo, Offset offset) {
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy,
      MediaQuery.of(context).size.width - offset.dx,
      MediaQuery.of(context).size.height - offset.dy,
    );

    showMenu(
      context: context,
      position: position,
      items: [
        PopupMenuItem(
          value: "delete",
          child: Text(AppLocalizations.of(context)!.delete),
        ),
        PopupMenuItem(
          value: "rename",
          child: Text(AppLocalizations.of(context)!.renameConversation),
        ),
      ],
    ).then((value) {
      if (value == "delete") {
        ref
            .read(conversationListProvider.notifier)
            .deleteConversation(conversationInfo);
      } else if (value == "rename") {
        _renameConversation(conversationInfo);
      }
    });
  }

  void _renameConversation(ConversationInfo conversationInfo) {
    final TextEditingController controller = TextEditingController();
    controller.text = conversationInfo.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.renameConversation),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.enterNewConversationNameTip,
                  hintText:
                      AppLocalizations.of(context)!.enterNewConversationNameTip,
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
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                ref.read(conversationListProvider.notifier).updateConversation(
                    conversationInfo.copyWith(name: controller.text));

                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  _tapConversation(ConversationInfo conversationInfo) {
    ref.read(selectedConversationProvider.notifier).update(conversationInfo);
  }
}
