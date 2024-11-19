import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationText extends StatelessWidget {
  const LocalizationText(
    this.data, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.namedArgs,
  });

  final String data;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Map<String, String>? namedArgs;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.tr(context: context, namedArgs: namedArgs),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
