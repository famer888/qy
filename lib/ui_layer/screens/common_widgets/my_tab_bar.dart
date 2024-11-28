import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme.dart';

enum TabBarType {
  /// 下滑线
  line,

  /// 填充色
  fillColor
}

class TabBarWithView extends StatefulWidget {
  const TabBarWithView.line({
    super.key,
    required this.titles,
    required this.views,
    this.tabBarPadding,
    this.tabBarHeight,
    this.isScrollable = true,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.isCenter = false,
    this.initialIndex = 0,
    this.labelPadding,
  })  : type = TabBarType.line,
        tabPadding = null,
        tabBarRightWidget = null;

  const TabBarWithView.fillColor({
    super.key,
    required this.titles,
    required this.views,
    this.tabPadding,
    this.tabBarPadding,
    this.tabBarHeight,
    this.isScrollable = false,
    this.tabBarRightWidget,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.tabController,
    this.isCenter = false,
    this.initialIndex = 0,
    this.labelPadding,
  }) : type = TabBarType.fillColor;

  final TabBarType type;

  final List<String> titles;
  final List<Widget> views;
  final bool isScrollable;
  final EdgeInsetsGeometry? tabBarPadding;
  final EdgeInsetsGeometry? tabPadding;
  final EdgeInsetsGeometry? labelPadding;

  final double? tabBarHeight;
  final Widget? tabBarRightWidget;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final TabController? tabController;
  final bool isCenter;
  final int initialIndex;

  @override
  State<TabBarWithView> createState() => _TabBarWithViewState();
}

class _TabBarWithViewState extends State<TabBarWithView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = widget.tabController ??
      TabController(
        length: widget.views.length,
        vsync: this,
        initialIndex: widget.initialIndex,
      );

  List<Widget> get tabs => widget.titles
      .map((title) => switch (widget.type) {
            TabBarType.fillColor => Tab(
                height: MyTheme.navbarHegiht,
                child: Padding(
                  padding: widget.tabPadding ??
                      EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    title,
                  ),
                ),
              ),
            _ => Tab(
                height: MyTheme.navbarHegiht,
                text: title,
              ),
          })
      .toList();

  late final TabBarTheme tabBarTheme = switch (widget.type) {
    TabBarType.line => MyTabBarTheme.line(
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        tabAlignment: widget.isScrollable ? TabAlignment.start : null,
      ),
    TabBarType.fillColor => MyTabBarTheme.fillColor(
        tabAlignment: widget.isScrollable ? TabAlignment.start : null,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        labelPadding: widget.labelPadding,
      ),
  };

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = Theme(
      data: Theme.of(context).copyWith(tabBarTheme: tabBarTheme),
      child: RepaintBoundary(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false,
          ),
          child: TabBar(
            physics: const BouncingScrollPhysics(),
            isScrollable: widget.isScrollable,
            padding: EdgeInsets.symmetric(vertical: 2.w),
            controller: _tabController,
            labelPadding: widget.labelPadding,
            tabs: tabs,
          ),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: widget.isCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (widget.titles.isNotEmpty)
          Padding(
            padding: widget.tabBarPadding ?? EdgeInsets.zero,
            child: SizedBox(
              height: widget.tabBarHeight ?? MyTheme.navbarHegiht,
              child: Row(
                mainAxisSize:
                    widget.isCenter ? MainAxisSize.min : MainAxisSize.max,
                children: [
                  widget.isCenter
                      ? Flexible(child: bar)
                      : Expanded(
                          child: bar,
                        ),
                  if (widget.tabBarRightWidget case final view?) view,
                ],
              ),
            ),
          ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.views,
          ),
        ),
      ],
    );
  }
}

class MyTabBarTheme extends TabBarTheme {
  const MyTabBarTheme({
    super.indicator,
    super.indicatorColor,
    super.indicatorSize,
    super.dividerColor,
    super.dividerHeight,
    super.labelColor,
    super.labelPadding,
    super.labelStyle,
    super.unselectedLabelColor,
    super.unselectedLabelStyle,
    super.overlayColor,
    super.splashFactory,
    super.mouseCursor,
    super.tabAlignment,
  });
  factory MyTabBarTheme.line({
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    TabAlignment? tabAlignment,
  }) =>
      MyTabBarTheme(
        labelStyle: labelStyle ?? MyTheme.jellyCyan_18,
        labelPadding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        unselectedLabelStyle: unselectedLabelStyle ?? MyTheme.white18,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const LineIndicator(),
        indicatorColor: Colors.transparent,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        tabAlignment: tabAlignment,
        dividerColor: Colors.transparent,
      );

  factory MyTabBarTheme.fillColor({
    TabAlignment? tabAlignment,
    TextStyle? labelStyle,
    TextStyle? unselectedLabelStyle,
    Decoration? indicator,
    EdgeInsetsGeometry? labelPadding,
  }) =>
      MyTabBarTheme(
        labelStyle: labelStyle ?? MyTheme.green85_15,
        labelPadding: labelPadding ??
            (tabAlignment == null
                ? EdgeInsets.zero
                : EdgeInsets.only(right: 16.w)),
        unselectedLabelStyle: unselectedLabelStyle ?? MyTheme.gray232_15,
        overlayColor: WidgetStateProperty.resolveWith<Color>(
          (_) => Colors.transparent,
        ),
        // indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: Colors.transparent,
        indicator: indicator ??
            BoxDecoration(
              color: const Color.fromRGBO(35, 35, 55, 1),
              borderRadius: BorderRadius.circular(30.w),
            ),
        tabAlignment: tabAlignment,
        dividerColor: Colors.transparent,
      );
}

class LineIndicator extends Decoration {
  const LineIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _LinePainter(this, onChanged);
  }
}

class _LinePainter extends BoxPainter {
  _LinePainter(
    this.decoration,
    super.onChanged,
  );

  final LineIndicator decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    final size = configuration.size!;

    final indicatorW = 21.5.w;

    final Rect indicator = Rect.fromLTWH(
      offset.dx + (size.width - indicatorW) / 2,
      size.height - 8,
      indicatorW,
      3.5.w,
    );

    final centerY = indicator.center.dy;
    final startOffset = Offset(indicator.left, centerY);
    final endOffset = Offset(indicator.right, centerY);
    canvas.drawLine(
      startOffset,
      endOffset,
      Paint()
        ..shader = ui.Gradient.linear(
          startOffset,
          endOffset,
          MyTheme.gradient_90_114_colors,
        )
        ..strokeWidth = 4.w
        ..strokeCap = StrokeCap.round,
    );
  }
}
