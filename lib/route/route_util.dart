import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/route/route.dart';
import 'package:go_router/go_router.dart';

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
