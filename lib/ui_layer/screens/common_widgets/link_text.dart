import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

/// Easy to use text widget, which converts inlined urls into clickable links.
/// Allows custom styling.
class LinkText extends StatefulWidget {
  final String text;

  /// Style of the non-url part of supplied text.
  final TextStyle? textStyle;

  /// Style of the url part of supplied text.
  final TextStyle? linkStyle;

  /// Determines how the text is aligned.
  final TextAlign textAlign;

  /// If true, this will cut off all visible params after '?'.
  /// This is only for improved readability. When executing the url
  /// the link with all params will stay the same.
  final bool shouldTrimParams;

  /// Overrides default behavior when tapping on links.
  /// Provides the url that was tapped.
  final void Function(String url)? onLinkTap;

  /// Creates a [LinkText] widget, used for inlined urls.
  const LinkText(
    this.text, {
    super.key,
    this.textStyle,
    this.linkStyle,
    this.textAlign = TextAlign.start,
    this.shouldTrimParams = false,
    this.onLinkTap,
  });

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  final _gestureRecognizers = <TapGestureRecognizer>[];
  final _regex = RegExp(
      r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
  final _shortenedRegex = RegExp(r'(.*)\?');

  @override
  void dispose() {
    for (final recognizer in _gestureRecognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  void _launchUrl(String url) async {
    if (widget.onLinkTap != null) {
      widget.onLinkTap!(url);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.textStyle ?? MyTheme.gray102_14;
    final linkStyle = widget.linkStyle ??
        TextStyle(
            color: const Color.fromRGBO(25, 103, 210, 1), fontSize: 14.sp);

    final links = _regex.allMatches(widget.text);
    final textParts = widget.text.split(_regex);
    final textSpans = <InlineSpan>[];

    int i = 0;
    for (final part in textParts) {
      textSpans.add(TextSpan(text: part, style: textStyle));

      if (i < links.length) {
        final link = links.elementAt(i).group(0) ?? '';
        String? shortenedLink;

        final recognizer = TapGestureRecognizer()
          ..onTap = () => _launchUrl(link);

        if (widget.shouldTrimParams) {
          shortenedLink = _shortenedRegex.firstMatch(link)?.group(1);
        }

        _gestureRecognizers.add(recognizer);
        textSpans.add(
          TextSpan(
            text: shortenedLink ?? link,
            style: linkStyle,
            recognizer: recognizer,
          ),
        );

        i++;
      }
    }

    return RichText(
      text: TextSpan(children: textSpans),
      textAlign: widget.textAlign,
      strutStyle:
          const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5),
    );
  }
}
