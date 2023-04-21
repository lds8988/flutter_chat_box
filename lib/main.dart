import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:tony_chat_box/configs/config.dart';
import 'package:tony_chat_box/route/route.dart';
import 'package:tony_chat_box/utils/sharded_preference/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SPUtil.perInit();

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          ThemeData themeData = ref.watch(
              configProvider.select((configInfo) => configInfo.themeData));

          Locale locale = ref
              .watch(configProvider.select((configInfo) => configInfo.locale));

          return MaterialApp.router(
            theme: themeData,
            routerConfig: gRouter,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            builder: FlutterSmartDialog.init(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    ),
  );
}
