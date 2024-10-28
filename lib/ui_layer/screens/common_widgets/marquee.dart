import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({
    super.key,
    this.pauseDuration = const Duration(milliseconds: 100),
    this.scrollSpeed = 60.0,
    required this.children,
  });

  final Duration pauseDuration;
  final double scrollSpeed; //每秒滚动距离
  final List<Widget> children;

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  final _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.doWhile(_scroll);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final blankSpace = SizedBox(width: constraints.maxWidth, height: 0);
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: [
                blankSpace,
                for (final child in widget.children) ...[
                  child,
                  blankSpace,
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _scroll() async {
    if (!_controller.hasClients) return false;

    await Future.delayed(widget.pauseDuration);

    _controller.jumpTo(0);
    final maxScrollExtent = _controller.position.maxScrollExtent;
    await _controller.animateTo(
      maxScrollExtent,
      duration: Duration(
        seconds: (maxScrollExtent / widget.scrollSpeed).floor(),
      ),
      curve: Curves.linear,
    );

    return true;
  }
}
