import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tony_chat_box/components/conversation/edit_conversation_dialog.dart';
import 'package:tony_chat_box/database/conversation/conversation_info.dart';
import 'package:tony_chat_box/device/form_factor.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';
import 'package:tony_chat_box/route/route_util.dart';

class ConversationListView extends ConsumerStatefulWidget {
  const ConversationListView(this.emptyTip, {super.key});

  final String emptyTip;

  @override
  ConsumerState<ConversationListView> createState() =>
      _ConversationListViewState();
}

class _ConversationListViewState extends ConsumerState<ConversationListView> {
  late bool _isPhoneSize;

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

    _isPhoneSize = MediaQuery.of(this.context).size.width < FormFactor.tablet;

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

                    if (_isPhoneSize) {
                      RouteUtil.jumpToChatPage(
                        this.context,
                        conversationId: conversationList[index].uuid,
                      );
                    }
                  },
                  selected: !_isPhoneSize &&
                      (selectedConversation.uuid ==
                          conversationList[index].uuid),
                  title: Text(
                    conversationList[index].name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    conversationList[index].model,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
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
          value: "edit",
          child: Text(AppLocalizations.of(context)!.edit),
        ),
      ],
    ).then((value) {
      switch (value) {
        case 'delete':
          ref
              .read(conversationListProvider.notifier)
              .deleteConversation(conversationInfo);
          break;
        case 'edit':
          _editConversation(conversationInfo);
          break;
      }
    });
  }

  void _editConversation(ConversationInfo conversationInfo) {


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editConversation),
          content: EditConversationDialog(conversationInfo),
          actions: [
            TextButton(
              onPressed: () {

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
