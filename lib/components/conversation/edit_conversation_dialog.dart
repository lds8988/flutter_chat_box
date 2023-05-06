import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tony_chat_box/api/get_models_api.dart';
import 'package:tony_chat_box/database/conversation/conversation_info.dart';
import 'package:tony_chat_box/database/msg/message_db_provider.dart';
import 'package:tony_chat_box/database/msg/msg_info.dart';
import 'package:tony_chat_box/device/form_factor.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_keys.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_util.dart';

class EditConversationDialog extends ConsumerStatefulWidget {
  const EditConversationDialog(this.conversationInfo, {Key? key})
      : super(key: key);

  final ConversationInfo conversationInfo;

  @override
  ConsumerState<EditConversationDialog> createState() =>
      _EditConversationDialogState();
}

class _EditConversationDialogState
    extends ConsumerState<EditConversationDialog> {
  late ConversationInfo _conversationInfo;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  List<dynamic> _modelInfoList = [];
  List<MsgInfo> _promptList = [];

  @override
  void initState() {
    _conversationInfo = widget.conversationInfo;

    _controller.text = _conversationInfo.name;

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        ref.read(conversationListProvider.notifier).updateConversation(
              _conversationInfo.copyWith(name: _controller.text),
            );
      }
    });

    String? modelListStr = SPUtil.getInstance().get(SpKeys.modelList);
    if (modelListStr != null) {
      setState(() {
        _modelInfoList = jsonDecode(modelListStr);
      });
    }
    getModelList();

    MessageDbProvider messageDbProvider = MessageDbProvider();
    messageDbProvider
        .getSystemMessagesByConversationUuid(_conversationInfo.uuid)
        .then((value) => setState(() {
              _promptList = value;
            }));

    super.initState();
  }

  void getModelList() {
    String? lastGetModelListTime =
        SPUtil.getInstance().get(SpKeys.lastGetModelListTime);

    if (lastGetModelListTime != null) {
      DateTime lastGetModelListDateTime = DateTime.parse(lastGetModelListTime);
      if (DateTime.now().difference(lastGetModelListDateTime).inDays < 1) {
        return;
      }
    }

    GetModelsApi getModelsApi = GetModelsApi();
    getModelsApi.send().then((value) {
      setState(() {
        _modelInfoList = value.data['data'].where((element) {
          return (element['id'] as String).contains('gpt');
        }).toList();

        SPUtil.getInstance().setJson(SpKeys.modelList, _modelInfoList);
        SPUtil.getInstance().setString(
            SpKeys.lastGetModelListTime, DateTime.now().toIso8601String());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var isPhoneSize =
        MediaQuery.of(this.context).size.width < FormFactor.tablet;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 200),
          child: TextField(
            focusNode: _nameFocusNode,
            controller: _controller,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.conversationName,
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
            maxLines: null,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        _buildSelectModelRow(isPhoneSize),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Prompts:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add_circle_outline_rounded,
              ),
              onPressed: () {
                _showEditPromptDialog();
              },
            ),
          ],
        ),
        ..._buildPrompts(),
      ],
    );
  }

  Widget _buildSelectModelRow(bool isPhoneSize) {
    if (isPhoneSize) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          AppLocalizations.of(context)!.gptModel,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _conversationInfo.model,
              style: const TextStyle(fontSize: 10),
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 28,
                    ),
                    ..._modelInfoList.map<Widget>((dynamic value) {
                      String model = value['id'];

                      return _buildOptionItem(
                        context,
                        model,
                        () {
                          setState(() {
                            _conversationInfo = _conversationInfo.copyWith(
                              model: model,
                            );

                            ref
                                .read(conversationListProvider.notifier)
                                .updateConversation(
                                  _conversationInfo,
                                );
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList()
                  ],
                );
              });
        },
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocalizations.of(context)!.gptModel),
          const SizedBox(
            width: 10,
          ),
          DropdownButton<String>(
            value: _conversationInfo.model,
            onChanged: (String? newValue) {
              setState(() {
                _conversationInfo = _conversationInfo.copyWith(
                  model: newValue!,
                );

                ref.read(conversationListProvider.notifier).updateConversation(
                      _conversationInfo,
                    );
              });
            },
            items:
                _modelInfoList.map<DropdownMenuItem<String>>((dynamic value) {
              String model = value['id'];

              return DropdownMenuItem<String>(
                value: model,
                child: Text(model),
              );
            }).toList(),
          ),
        ],
      );
    }
  }

  List<Widget> _buildPrompts() {
    List<Widget> prompts = [];

    for (MsgInfo msgInfo in _promptList) {
      prompts.add(
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            msgInfo.text.trim(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditPromptDialog(msgInfo: msgInfo);
            },
          ),
        ),
      );
    }

    return prompts;
  }

  void _showEditPromptDialog({MsgInfo? msgInfo}) {
    TextEditingController promptController =
        TextEditingController(text: msgInfo?.text);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${AppLocalizations.of(context)!.edit} prompt'),
            content: TextField(
              controller: promptController,
              decoration: InputDecoration(
                labelText: 'prompt',
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
              maxLines: null,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (promptController.text.trim().isEmpty) {
                    SmartDialog.showToast(
                      AppLocalizations.of(context)!.promptEmptyTip,
                    );

                    return;
                  }

                  setState(() {
                    if (msgInfo != null) {
                      MsgInfo newMsgInfo =
                          msgInfo.copyWith(text: promptController.text);

                      MessageDbProvider().updateMessage(
                        newMsgInfo,
                      );

                      for (int i = 0; i < _promptList.length; i++) {
                        MsgInfo msgInfo = _promptList[i];
                        if (msgInfo.id == newMsgInfo.id) {
                          _promptList[i] = newMsgInfo;
                          break;
                        }
                      }
                    } else {
                      setState(() {
                        MsgInfo newMsgInfo = MsgInfo(
                          text: promptController.text,
                          conversationId: _conversationInfo.uuid,
                          roleInt: Role.system.index,
                          stateInt: MsgState.received.index,
                        );

                        MessageDbProvider().addMessage(
                          newMsgInfo,
                        );

                        _promptList.add(newMsgInfo);
                      });
                    }
                  });

                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        });
  }

  Widget _buildOptionItem(
    BuildContext context,
    String title,
    GestureTapCallback onTap, {
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) Icon(icon),
            if (icon != null)
              const SizedBox(
                width: 8,
              ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
