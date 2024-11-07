import 'package:flutter/material.dart';
import '../../../domain/model/tip_model.dart';
import '../../utils/common_utils.dart';
import '../theme.dart';

class MyMarqueeTipsWidget extends StatelessWidget {
  const MyMarqueeTipsWidget({super.key, required this.tips});
  final List<TipModel> tips;
  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) return const SizedBox.shrink();

    return MarqueeWidget(
      children: [
        for (final tip in tips)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              CommonUtils.openRoute(context, tip.toJson());
            },
            child: Text(
              tip.title ?? '',
              style: MyTheme.white14,
            ),
          ),
      ],
    );
  }
}

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
  final _controller = _ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.doWhile(_scroll);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            child: Row(children: [
              blankSpace,
              for (final child in widget.children) ...[
                child,
                blankSpace,
              ],
            ]),
          ),
        );
      },
    );
  }

  Future<bool> _scroll() async {
    await Future.delayed(widget.pauseDuration);

    if (!_controller.hasClients) return false;

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

class _ScrollController extends ScrollController {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    return _ScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialScrollOffset,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}

class _ScrollPositionWithSingleContext extends ScrollPositionWithSingleContext {
  _ScrollPositionWithSingleContext({
    required super.physics,
    required super.context,
    double? initialPixels = 0.0,
    super.keepScrollOffset,
    super.oldPosition,
    super.debugLabel,
  });

  @override
  Future<void> animateTo(
    double to, {
    required Duration duration,
    required Curve curve,
  }) {
    if (_nearEqual(to, pixels, physics.toleranceFor(this).distance)) {
      // Skip the animation, go straight to the position as we are already close.
      jumpTo(to);
      return Future<void>.value();
    }

    final DrivenScrollActivity activity = _DrivenScrollActivity(
      this,
      from: pixels,
      to: to,
      duration: duration,
      curve: curve,
      vsync: context.vsync,
    );
    beginActivity(activity);
    return activity.done;
  }
}

class _DrivenScrollActivity extends DrivenScrollActivity {
  _DrivenScrollActivity(
    super.delegate, {
    required super.from,
    required super.to,
    required super.duration,
    required super.curve,
    required super.vsync,
  });

  @override
  bool get shouldIgnorePointer => false;
}

bool _nearEqual(double? a, double? b, double epsilon) {
  assert(epsilon >= 0.0);
  if (a == null || b == null) {
    return a == b;
  }
  return (a > (b - epsilon)) && (a < (b + epsilon)) || a == b;
}
