import 'package:any_syntax_highlighter/any_syntax_highlighter.dart';
import 'package:any_syntax_highlighter/themes/any_syntax_highlighter_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/configs/config.dart';
import 'package:flutter_chatgpt/configs/config_info.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

class CodeHighLighter extends MarkdownElementBuilder {
  BuildContext buildContext;

  CodeHighLighter(this.buildContext);

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return Consumer(
      builder: (context, ref, child) {
        ConfigInfo configInfo = ref.watch(configProvider);

        return AnySyntaxHighlighter(
          // The original code to be highlighted
          element.textContent,
          fontSize: 14,
          isSelectableText: true,
          hasCopyButton: true,
          reservedWordSets: const {
            'java',
            'python',
            'c',
            'cpp',
            'c#',
            'dart',
            'go',
            'javascript',
            'r',
            'swift',
            'bash',
            'ruby',
            'html'
          },
          // Specify padding
          padding: 8,
          theme: const AnySyntaxHighlighterTheme(
            comment: TextStyle(color: Color(0xff5c6370), fontStyle: FontStyle.italic),
            multilineComment: TextStyle(color: Color(0xff5c6370), fontStyle: FontStyle.italic),
            string: TextStyle(color: Color(0xff98c379)),
            keyword: TextStyle(color: Color(0xffc678dd)),
            number: TextStyle(color: Color(0xffd19a66)),
            function: TextStyle(color: Color(0xffe6c07b)),
          ),
        );
      },
    );
  }
}
