import 'package:flutter/material.dart';
import 'package:flutter_markdown_selectionarea/flutter_markdown_selectionarea.dart';
import 'package:tony_chat_box/components/chat/markdown/code_hightlighter.dart';

class Markdown extends StatelessWidget {
  final String text;

  const Markdown({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: MarkdownBody(
        data: text,
        builders: {
          'code': CodeHighLighter(context),
        },
      ),
    );
  }
}
