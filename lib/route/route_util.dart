import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tony_chat_box/route/route.dart';

class RouteUtil {
  static jumpToChatPage(
    BuildContext context, {
    String? conversationId,
    String? msg,
  }) {
    if(conversationId != null) {
      return context.push("${Routes.chat}?conversationId=$conversationId");
    } else if(msg != null) {
      return context.push("${Routes.chat}?msg=$msg");
    }
  }
}
