import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tony_chat_box/components/chat/chat_list_view.dart';
import 'package:tony_chat_box/components/conversation/conversation_list_view.dart';
import 'package:tony_chat_box/configs/config.dart';
import 'package:tony_chat_box/configs/config_info.dart';
import 'package:tony_chat_box/database/assistant/assistant_db_provider.dart';
import 'package:tony_chat_box/database/assistant/assistant_info.dart';
import 'package:tony_chat_box/database/conversation/conversation_info.dart';
import 'package:tony_chat_box/database/msg/message_db_provider.dart';
import 'package:tony_chat_box/device/form_factor.dart';
import 'package:tony_chat_box/providers/conversation_list.dart';
import 'package:tony_chat_box/providers/selected_conversation.dart';
import 'package:tony_chat_box/route/route_util.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  PackageInfo? _packageInfo;

  late bool _isPhoneSize;

  late List<AssistantInfo> _assistantInfoList;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _packageInfo = value;
      });
    });

    AssistantDbProvider()
        .getAssistantList()
        .then((value) => _assistantInfoList = value);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConfigInfo configInfo = ref.watch(configProvider);

    _isPhoneSize = MediaQuery.of(context).size.width < FormFactor.tablet;

    return Scaffold(
      key: _scaffoldKey,
      appBar: _isPhoneSize
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
            )
          : null,
      drawer: _isPhoneSize
          ? Drawer(
              backgroundColor: configInfo.themeData.cardColor,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.settings),
                      leading: const Icon(Icons.settings),
                      onTap: () {
                        Navigator.of(context).pop();
                        _showSetting(context);
                      },
                    ),
                    const Spacer(),
                    _buildVersionView(),
                  ],
                ),
              ),
            )
          : null,
      body: _isPhoneSize
          ? Column(
              children: [
                Expanded(
                  child: ConversationListView(
                      AppLocalizations.of(context)!.noConversationTipsPhone),
                ),
                _buildDivider(),
                SafeArea(
                  child: _buildOptionItem(
                    context,
                    AppLocalizations.of(context)!.newConversation,
                    () {
                      _showCreateConversationBottomSheet(context);
                    },
                    icon: Icons.add_box,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Expanded(
                        child: ConversationListView(
                            AppLocalizations.of(context)!.noConversationTips),
                      ),
                      GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedConversationProvider.notifier)
                              .update(ConversationInfo(name: "", uuid: ""));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Icon(Icons.add_box),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.newConversation,
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildBottom(),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: .3,
                  thickness: .3,
                ),
                const Expanded(child: ChatListView()),
              ],
            ),
    );
  }

  void _showCreateConversationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 20,
              ),
              _buildOptionItem(
                context,
                AppLocalizations.of(context)!.createByAsk,
                () {
                  Navigator.of(context).pop();

                  _showCreateConversationByAskDialog(context);
                },
                icon: Icons.add_box,
              ),
              _buildDivider(),
              _buildOptionItem(
                context,
                AppLocalizations.of(context)!.createByPrompt,
                () {
                  Navigator.of(context).pop();
                  _showCreateConversationByPromptDialog();
                },
                icon: Icons.add_box,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreateConversationByPromptDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.createByPrompt,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            content: SizedBox(
              width: 448,
              height: 552,
              child: ListView.separated(
                itemCount: _assistantInfoList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(conversationListProvider.notifier)
                          .createConversation(_assistantInfoList[index].title)
                          .then((conversationInfo) {
                        MessageDbProvider().addSystemMessageByAssistantId(
                          conversationInfo.uuid,
                          _assistantInfoList[index].id,
                        );

                        Navigator.of(context).pop();

                        RouteUtil.jumpToChatPage(
                          context,
                          conversationId: conversationInfo.uuid,
                        );
                      });
                    },
                    child: ListTile(
                      title: Text(_assistantInfoList[index].title),
                      subtitle: Text(_assistantInfoList[index].desc),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
              ),
            ),
            actions: [
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

  void _showCreateConversationByAskDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.createByAsk,
            style: const TextStyle(fontSize: 14),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 12),
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.inputQuestion,
              hintText: AppLocalizations.of(context)!.inputQuestionTips,
              labelStyle: const TextStyle(fontSize: 14),
              hintStyle: const TextStyle(fontSize: 12),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                final message = controller.text;

                if (message.isNotEmpty) {
                  Navigator.of(this.context).pop();

                  RouteUtil.jumpToChatPage(context, msg: message);
                }
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(thickness: .3, height: .3);
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

  SizedBox _buildBottom() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSettingBtn(),
          _buildVersionView(),
        ],
      ),
    );
  }

  Widget _buildVersionView() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Text(
        "${AppLocalizations.of(context)!.version}：${_packageInfo?.version ?? ''}",
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildSettingBtn() {
    return TextButton.icon(
      onPressed: () {
        _showSetting(context);
      },
      label: Text(AppLocalizations.of(context)!.settings),
      icon: const Icon(Icons.settings),
    );
  }

  void _showSetting(BuildContext context) {
    ConfigInfo configInfo = ref.read(configProvider);
    Config config = ref.watch(configProvider.notifier);

    final TextEditingController controllerApiKey =
        TextEditingController(text: configInfo.key);
    FocusNode apiKeyFocusNode = FocusNode();
    apiKeyFocusNode.addListener(() {
      if (!apiKeyFocusNode.hasFocus) {
        config.setKey(controllerApiKey.text);
      }
    });

    final TextEditingController controllerBaseUrl =
        TextEditingController(text: configInfo.baseUrl);
    FocusNode baseUrlFocusNode = FocusNode();
    baseUrlFocusNode.addListener(() {
      if (!baseUrlFocusNode.hasFocus) {
        config.setBaseUrl(controllerBaseUrl.text);
      }
    });

    final TextEditingController controllerIp =
        TextEditingController(text: configInfo.ip);
    FocusNode ipFocusNode = FocusNode();
    ipFocusNode.addListener(() {
      if (!ipFocusNode.hasFocus) {
        config.setIp(controllerIp.text);
      }
    });

    final TextEditingController controllerPort =
        TextEditingController(text: configInfo.port);
    FocusNode portFocusNode = FocusNode();
    portFocusNode.addListener(() {
      if (!portFocusNode.hasFocus) {
        config.setPort(controllerPort.text);
      }
    });

    bool isObscure = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(AppLocalizations.of(context)!.settings),
            content: Consumer(
              builder: (context, ref, widget) {
                ConfigInfo configInfo = ref.watch(configProvider);

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.theme),
                          Switch(
                            value: configInfo.isDark,
                            onChanged: (value) {
                              config.switchTheme();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.language),
                          Switch(
                            value: configInfo.locale.languageCode == 'zh',
                            onChanged: (value) {
                              config.switchLocale();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      TextField(
                        focusNode: baseUrlFocusNode,
                        controller: controllerBaseUrl,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.setBaseUrl,
                          hintText:
                              AppLocalizations.of(context)!.setBaseUrlTips,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                        maxLines: null,
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      TextField(
                        focusNode: apiKeyFocusNode,
                        controller: controllerApiKey,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.enterKey,
                          hintText: AppLocalizations.of(context)!.enterKeyTips,
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: isObscure ? Colors.grey : Colors.blue,
                            ),
                            onPressed: () {
                              setState(() {
                                isObscure = !isObscure;
                              });
                            },
                          ),
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          config.setKey(value);
                        },
                        obscureText: isObscure,
                      ),
                      // const SizedBox(
                      //   height: 28,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(AppLocalizations.of(context)!.useStreamApi),
                      //     Switch(
                      //       value: configInfo.useStream,
                      //       onChanged: (value) {
                      //         config.setUseStream(value);
                      //       },
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 28,
                      ),
                      if (_isPhoneSize)
                        ListTile(
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
                                configInfo.gptModel,
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
                                      ...<String>[
                                        'gpt-3.5-turbo',
                                        'gpt-3.5-turbo-0301',
                                      ].map<Widget>((String value) {
                                        return _buildOptionItem(
                                          context,
                                          value,
                                          () {
                                            config.setGptModel(value);
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }).toList()
                                    ],
                                  );
                                });
                          },
                        ),
                      if (!_isPhoneSize)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.gptModel),
                            DropdownButton<String>(
                              value: configInfo.gptModel,
                              onChanged: (String? newValue) {
                                config.setGptModel(newValue!);
                              },
                              items: <String>[
                                'gpt-3.5-turbo',
                                'gpt-3.5-turbo-0301',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 28,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppLocalizations.of(context)!.isUseProxy),
                          Switch(
                            value: configInfo.userProxy,
                            onChanged: (value) {
                              config.switchProxyMode();
                            },
                          ),
                        ],
                      ),
                      if (configInfo.userProxy)
                        ...buildProxyInputGroup(
                          ipFocusNode,
                          portFocusNode,
                          controllerIp,
                          controllerPort,
                        ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.ok),
              ),
            ],
          );
        });
      },
    );
  }

  List<Widget> buildProxyInputGroup(
    FocusNode ipFocusNode,
    FocusNode portFocusNode,
    TextEditingController controllerIp,
    TextEditingController controllerPort,
  ) {
    return [
      const SizedBox(
        height: 28,
      ),
      TextField(
        focusNode: ipFocusNode,
        controller: controllerIp,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.setIp,
          hintText: AppLocalizations.of(context)!.setIpTip,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        maxLines: null,
      ),
      const SizedBox(
        height: 28,
      ),
      TextField(
        focusNode: portFocusNode,
        controller: controllerPort,
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context)!.setPort,
          hintText: AppLocalizations.of(context)!.setPortTip,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide.none,
          ),
          filled: true,
        ),
        maxLines: null,
      ),
    ];
  }
}
