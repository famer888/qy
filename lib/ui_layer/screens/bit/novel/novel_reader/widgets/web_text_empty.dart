import 'package:flutter/material.dart';

class WebText extends StatefulWidget {
  const WebText(
      {super.key,
      required this.text,
      required this.fontSize,
      required this.onTap});
  final String text;
  final int fontSize;
  final VoidCallback onTap;

  @override
  State<WebText> createState() => _WebTextState();
}

class _WebTextState extends State<WebText> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
