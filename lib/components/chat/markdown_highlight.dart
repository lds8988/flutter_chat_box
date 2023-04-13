import 'package:flutter/material.dart';
import 'package:flutter_chatgpt/configs/config.dart';
import 'package:flutter_chatgpt/configs/config_info.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;

class CodeElementBuilder extends MarkdownElementBuilder {
  BuildContext buildContext;
  CodeElementBuilder(this.buildContext);
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {

    var language = 'javascript';

    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      language = lg.substring(9);
    }
    return SizedBox(
      width:
          MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
      child: Consumer(builder: (context, ref, child) {

        ConfigInfo configInfo = ref.watch(configProvider);

        return HighlightView(
          // The original code to be highlighted
          element.textContent,

          // Specify language
          // It is recommended to give it a value for performance
          language: language,

          // Specify highlight theme
          // All available themes are listed in `themes` folder
          theme: configInfo.isDark ? atomOneDarkTheme : atomOneLightTheme,

          // Specify padding
          padding: const EdgeInsets.all(8),

          // Specify text style
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        );
      },),
    );
  }
}
