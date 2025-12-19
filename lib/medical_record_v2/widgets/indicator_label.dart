import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class FieldLabel extends StatelessWidget {
  final String raw;
  final TextStyle? style;

  const FieldLabel(this.raw, {super.key, this.style});

  bool _hasHtml(String s) {
    final x = s.toLowerCase();
    return x.contains('<img') || x.contains('<br') || x.contains('<p');
  }

  @override
  Widget build(BuildContext context) {
    final s = raw.trim();
    if (s.isEmpty) return const SizedBox.shrink();

    if (_hasHtml(s)) {
      return Html(
        data: s,
        style: {
          'body': Style(
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
            fontSize: FontSize((style?.fontSize ?? 14).toDouble()),
            fontWeight: style?.fontWeight,
            color: style?.color,
          ),
          'img': Style(margin: Margins.only(bottom: 6)),
          'p': Style(margin: Margins.zero, padding: HtmlPaddings.zero),
        },
      );
    }

    return Text(
      s,
      style: style ??
          const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
