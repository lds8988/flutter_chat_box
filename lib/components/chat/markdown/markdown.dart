import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/components/chat/markdown/code_hightlighter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Markdown extends StatelessWidget {
  final String text;

  const Markdown({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      selectable: true,
      builders: {
        'code': CodeHighLighter(context),
      },
    );
  }
}
