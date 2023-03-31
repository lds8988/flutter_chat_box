import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt/components/chat_window.dart';
import 'package:flutter_chatgpt/components/conversation_window.dart';
import 'package:flutter_chatgpt/cubit/setting_cubit.dart';
import 'package:flutter_chatgpt/device/form_factor.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  PackageInfo? _packageInfo;

  @override
  void initState() {
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _packageInfo = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool useTabs = MediaQuery.of(context).size.width < FormFactor.tablet;
    return Scaffold(
      key: _scaffoldKey,
      appBar: useTabs
          ? AppBar(
              title: Text(AppLocalizations.of(context)!.appTitle),
            )
          : null,
      drawer: useTabs ? const ConversationWindow() : null,
      body: useTabs
          ? const ChatWindow()
          : Row(
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      const Expanded(child: ConversationWindow()),
                      SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSettingBtn(),
                            _buildVersionView(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: .3,
                  thickness: .3,
                ),
                const Expanded(child: ChatWindow()),
              ],
            ),
    );
  }

  Widget _buildVersionView() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
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
    final TextEditingController controllerApiKey = TextEditingController(
        text: BlocProvider.of<UserSettingCubit>(context).state.key);
    final TextEditingController controllerProxy = TextEditingController(
        text: BlocProvider.of<UserSettingCubit>(context).state.baseUrl);

    bool isObscure = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.settings),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.theme),
                        Switch(
                          value: BlocProvider.of<UserSettingCubit>(context)
                                  .state
                                  .themeData ==
                              darkTheme,
                          onChanged: (value) {
                            BlocProvider.of<UserSettingCubit>(context)
                                .switchTheme();
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
                          value: BlocProvider.of<UserSettingCubit>(context)
                                  .state
                                  .locale
                                  .languageCode ==
                              'zh',
                          onChanged: (value) {
                            BlocProvider.of<UserSettingCubit>(context)
                                .switchLocale();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    TextFormField(
                      controller: controllerProxy,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.setProxyUrl,
                        hintText: AppLocalizations.of(context)!.setProxyUrlTips,
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                      ),
                      autovalidateMode: AutovalidateMode.always,
                      maxLines: null,
                      onChanged: (value) {
                        BlocProvider.of<UserSettingCubit>(context)
                            .setProxyUrl(value);
                      },
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    TextFormField(
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
                      autovalidateMode: AutovalidateMode.always,
                      maxLines: 1,
                      onChanged: (value) {
                        BlocProvider.of<UserSettingCubit>(context)
                            .setKey(value);
                      },
                      obscureText: isObscure,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppLocalizations.of(context)!.useStreamApi),
                        Switch(
                          value: BlocProvider.of<UserSettingCubit>(context)
                              .state
                              .useStream,
                          onChanged: (value) {
                            BlocProvider.of<UserSettingCubit>(context)
                                .setUseStream(value);
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
                        Text(AppLocalizations.of(context)!.gptModel),
                        DropdownButton<String>(
                          value: BlocProvider.of<UserSettingCubit>(context)
                              .state
                              .gptModel,
                          onChanged: (String? newValue) {
                            BlocProvider.of<UserSettingCubit>(context)
                                .setGptModel(newValue!);
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
                  ],
                ),
              ),
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
}
