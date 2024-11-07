import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    super.key,
    this.isExpanded = false,
    required this.style,
    this.moreStyle,
    this.onExpand,
    this.trimLines = 2,
  });

  final String text;
  final TextStyle style;
  final TextStyle? moreStyle;

  final bool isExpanded;
  final VoidCallback? onExpand;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  late bool _isExpanded = widget.isExpanded;

  void _onTapMore() {
    widget.onExpand?.call();
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  void didUpdateWidget(covariant ExpandableText oldWidget) {
    _isExpanded = widget.isExpanded;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    final contentSpan = TextSpan(
      text: widget.text,
      style: widget.style,
    );

    final moreSpan = TextSpan(
      text: 'mhzk'.tr(context: context),
      style: widget.moreStyle ?? widget.style.copyWith(color: Colors.white60),
      recognizer: TapGestureRecognizer()..onTap = _onTapMore,
    );

    const delimiter = '...          ';

    final delimiterSpan = TextSpan(
      text: delimiter,
      style: widget.style,
      recognizer: TapGestureRecognizer()..onTap = _onTapMore,
    );

    final textPainter = TextPainter(
      textDirection: textDirection,
      maxLines: widget.trimLines,
      ellipsis: delimiter,
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        TextSpan? textSpan;

        if (!_isExpanded) {
          const downArrowSize = 20.0;
          final minWidth = constraints.minWidth;
          final maxWidth = constraints.maxWidth;

          textPainter.text = moreSpan;
          textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
          final moreSpanSize = Size(
              downArrowSize + textPainter.size.width, textPainter.size.height);

          textPainter.text = delimiterSpan;
          textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
          final delimiterSpanSize = textPainter.size;

          textPainter.text = contentSpan;
          textPainter.layout(minWidth: minWidth, maxWidth: maxWidth);
          final contentSpanSize = textPainter.size;

          late final int endIndex;

          if (moreSpanSize.width < maxWidth) {
            final readMoreSize = moreSpanSize.width + delimiterSpanSize.width;
            final pos = textPainter.getPositionForOffset(Offset(
              textDirection == TextDirection.rtl
                  ? readMoreSize
                  : contentSpanSize.width - readMoreSize,
              contentSpanSize.height,
            ));
            endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
          } else {
            var pos = textPainter.getPositionForOffset(
              contentSpanSize.bottomLeft(Offset.zero),
            );
            endIndex = pos.offset;
          }

          if (textPainter.didExceedMaxLines) {
            textSpan = TextSpan(
              text: widget.text.substring(0, endIndex),
              style: widget.style,
              children: [
                delimiterSpan,
                moreSpan,
                const WidgetSpan(
                  child: Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: downArrowSize,
                    color: Colors.white60,
                  ),
                )
              ],
              recognizer: TapGestureRecognizer()..onTap = _onTapMore,
            );
          }
        }

        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan ?? contentSpan,
        );
      },
    );
    return result;
  }
}
