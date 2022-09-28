import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/pageview/afterlayout.dart';

class VariablePageViewWidget extends StatefulWidget {
  VariablePageViewWidget({Key key, this.pages, this.pageController})
      : super(key: key);
  final List<Widget> pages;
  final PageController pageController;

  @override
  State<StatefulWidget> createState() => _VariablePageViewWidgetState();
}

class _VariablePageViewWidgetState extends State<VariablePageViewWidget> {
  double _height = 0.0;
  final Map<int, double> _heightSet = <int, double>{};

  double _widgetWidth = 0.0;

  double offsetBias = 0.0;
  ScrollPhysics _pagePhysics = NeverScrollableScrollPhysics();

  /// 是否开始点击屏幕
  bool _isBeginTap = false;

  /// 是否点击后第一下是向左边划
  bool _isBeginToLeft = false;

  double targetHeight(int page) {
    double height = _heightSet[page];
    if (height == null || height <= 0) {
      height = 100;
    }
    return height;
  }

  @override
  void initState() {
    _heightSet[0] = ScreenUtil().screenHeight;
    _heightSet[1] = ScreenUtil().screenHeight;
    _heightSet[2] = ScreenUtil().screenHeight;
    _heightSet[3] = ScreenUtil().screenHeight;
    widget.pageController.addListener(() {
      double leftHeight = targetHeight(widget.pageController.page.floor());
      double rightHeight = targetHeight(widget.pageController.page.ceil());
      double progress = widget.pageController.page -
          widget.pageController.page.floorToDouble();

      _height = lerpDouble(leftHeight, rightHeight, progress);
      if (widget.pageController.page == 0) {
        _pagePhysics = NeverScrollableScrollPhysics();
      } else {
        _pagePhysics = ClampingScrollPhysics();
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GestureDetector();
    return Container(
      height: _height,
      child: Listener(
        onPointerDown: (PointerDownEvent event) {
          // debugPrint('${event.position}');
          _isBeginTap = true;
        },
        onPointerMove: (PointerMoveEvent event) {
          if (_isBeginTap && event.delta.dx < 0 && widget.pages.length > 1) {
            _isBeginToLeft = true;
          }
          _isBeginTap = false;

          // debugPrint('${event.delta}');
          if (_isBeginToLeft &&
              event.delta.dx < 0 &&
              widget.pageController.page < 1) {
            _pagePhysics = ClampingScrollPhysics();
            offsetBias += event.delta.dx;
            widget.pageController.jumpTo(-offsetBias);
            setState(() {});
          }
        },
        onPointerUp: (event) {
          if (_widgetWidth > 0 && offsetBias.abs() > _widgetWidth / 3.0) {
            widget.pageController.animateToPage(1,
                duration: Duration(milliseconds: 400), curve: Curves.ease);
          }
          offsetBias = 0.0;
          _isBeginTap = _isBeginToLeft = false;
        },
        child:
            // PageView.builder(
            //   itemBuilder: (BuildContext context, int index) {
            //     // return SingleChildScrollView(
            //     //     // physics: ClampingScrollPhysics(),
            //     //     child: AfterLayout(
            //     //         callback: (RenderAfterLayout l) {
            //     //           // debugPrint('layout size = ${l.size}');
            //     //           if (_widgetWidth == 0) {
            //     //             _widgetWidth = l.size.width;
            //     //           }
            //     //           _height = l.size.height;
            //     //           _heightSet[index] = l.size.height;
            //     //           setState(() {});
            //     //         },
            //     //         child: widget.pages[index]));
            //     return widget.pages[index];
            //   },
            //   controller: widget.pageController,
            //   physics: _pagePhysics,
            // )
            PageView(
          controller: widget.pageController,
          pageSnapping: true,
          physics: _pagePhysics,
          children: widget.pages.asMap().keys.map((index) {
            return SingleChildScrollView(
                // physics: ClampingScrollPhysics(),
                child: AfterLayout(
                    callback: (RenderAfterLayout l) {
                      // debugPrint('layout size = ${l.size}');
                      if (_widgetWidth == 0) {
                        _widgetWidth = l.size.width;
                      }
                      _height = l.size.height;
                      _heightSet[index] = l.size.height;
                      setState(() {});
                    },
                    child: widget.pages[index]));
          }).toList(),
        ),
      ),
    );
  }
}
