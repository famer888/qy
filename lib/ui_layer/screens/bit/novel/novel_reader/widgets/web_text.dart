import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

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
  double? height;

  void onElementCreated(Object element) {
    element as web.HTMLDivElement;
    element.style.height = '100%';
    element.style.width = '100%';

    element.innerHTML =
        '''<div style="font-size: ${widget.fontSize}px; color: white; white-space: pre-line;">${widget.text}</div>''';

    final observer = web.ResizeObserver((
      JSArray<web.ResizeObserverEntry> entries,
      web.ResizeObserver observer,
    ) {
      if (element.isConnected) {
        observer.disconnect();

        setState(() {
          height = element.firstElementChild?.scrollHeight.toDouble();
        });
      }
    }.toJS);

    observer.observe(element);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0,
      child: Stack(
        fit: StackFit.expand,
        children: [
          HtmlElementView.fromTagName(
            key: ValueKey(widget.fontSize),
            tagName: 'div',
            onElementCreated: onElementCreated,
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}
