import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'dart:js_interop';

class WebText extends StatefulWidget {
  const WebText({super.key, required this.text, required this.fontSize});
  final String text;
  final int fontSize;
  @override
  State<WebText> createState() => _WebTextState();
}

class _WebTextState extends State<WebText> {
  double? height;

  void onElementCreated(Object element) {
    element as web.HTMLDivElement;

    element.style.height = '100%';
    element.style.color = 'white';
    element.style.fontSize = '${widget.fontSize}px';
    element.textContent = widget.text;

    final observer = web.ResizeObserver((
      JSArray<web.ResizeObserverEntry> entries,
      web.ResizeObserver observer,
    ) {
      if (element.isConnected) {
        observer.disconnect();
        height = element.scrollHeight.toDouble();
        setState(() {});
      }
    }.toJS);

    observer.observe(element);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0,
      child: HtmlElementView.fromTagName(
        key: ValueKey(widget.fontSize),
        tagName: 'div',
        onElementCreated: onElementCreated,
      ),
    );
  }
}
