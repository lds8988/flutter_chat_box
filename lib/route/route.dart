import 'package:flutter/widgets.dart';
import 'package:flutter_chatgpt/pages/home.dart';
import 'package:flutter_chatgpt/pages/chat.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static const String home = '/';
  static const String chat = '/chat';
}

final GoRouter gRouter = GoRouter(
  initialLocation: Routes.home,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.home,
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
    ),
    GoRoute(
      path: Routes.chat,
      builder: (BuildContext context, GoRouterState state) {

        String? conversationId = state.queryParams["conversationId"];

        String? msg = state.queryParams["msg"];

        if(conversationId != null) {
          return ChatPage(conversationId: conversationId);
        } else if(msg != null) {
          return ChatPage(msg: msg);
        }else {
          return const Text("conversationId or msg is null");
        }

      },
    ),
  ],
  observers: [FlutterSmartDialog.observer]
);
