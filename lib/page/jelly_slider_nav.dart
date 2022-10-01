import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class JellySliderNav extends StatefulWidget {
  JellySliderNav(
      {Key key,
      this.titles,
      this.pages,
      this.defaultStyle,
      this.selectStyle,
      this.isCenter = false,
      this.inedxFunc})
      : super(key: key);
  List<String> titles;
  List<Widget> pages;
  TextStyle defaultStyle;
  TextStyle selectStyle;
  bool isCenter;
  Function(int) inedxFunc;

  @override
  State<JellySliderNav> createState() => _JellySliderNavState();
}

class _JellySliderNavState extends State<JellySliderNav>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;
  TextStyle _defaultStyle;
  TextStyle _selectStyle;

  Widget _dealTabs() {
    return Theme(
        data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent),
        child: TabBar(
          onTap: (index) {
            _isOnTab = true;
            _onTabPageChange(index, isOnTab: true);
          },
          indicatorColor: Colors.transparent,
          labelPadding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0.5)),
          isScrollable: true,
          physics: BouncingScrollPhysics(),
          tabs: widget.titles
              .asMap()
              .keys
              .map((x) => Tab(
                    child: Row(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(13)),
                              child: Container(
                                width: ScreenUtil().setWidth(60),
                                height: ScreenUtil().setWidth(26),
                                decoration: BoxDecoration(
                                    color: _selectIndex == x
                                        ? Color(0xFF232337)
                                        : Colors.transparent),
                                child: Center(
                                  child: Text(
                                    widget.titles[x],
                                    style: _selectIndex == x
                                        ? _selectStyle
                                        : _defaultStyle,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ));
  }

  void _onTabPageChange(index, {bool isOnTab = false}) {
    if (_selectIndex == index) {
      _isOnTab = false;
      return;
    }
    _selectIndex = index;
    if (!isOnTab) {
      _tabController.animateTo(_selectIndex);
      setState(() {});
      if (widget.inedxFunc != null) widget.inedxFunc(_selectIndex);
    } else {
      _pageController.animateToPage(_selectIndex,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      //等待滑动解锁
      Future.delayed(Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
        if (widget.inedxFunc != null) widget.inedxFunc(_selectIndex);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.defaultStyle == null || widget.selectStyle == null) {
      _defaultStyle = TextStyle(
          color: Color(0xff999999),
          fontSize: ScreenUtil().setSp(13),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
      _selectStyle = TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(13),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
    } else {
      _defaultStyle = widget.defaultStyle;
      _selectStyle = widget.selectStyle;
    }
    _tabController = TabController(length: widget.titles.length, vsync: this);
    _pageController = PageController();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.titles.length == 0
        ? Container()
        : Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                height: GQStyle.navbarHegiht,
                width: double.infinity,
                child:
                    widget.isCenter ? Center(child: _dealTabs()) : _dealTabs(),
              ),
              Expanded(
                  child: PageView(
                onPageChanged: (index) {
                  if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
                },
                controller: _pageController,
                children: widget.pages,
              ))
            ],
          );
  }

// 用 NestedScrollView 实现的方法
  // @override
  // Widget build(BuildContext context) {
  //   return widget.titles.length == 0
  //       ? Container()
  //       : NestedScrollView(
  //           headerSliverBuilder: (context, res) {
  //             return [
  //               SliverPersistentHeader(
  //                   pinned: true,
  //                   delegate: CustomHeaderDelegate(
  //                     Container(
  //                       color: GQStyle.bgColor,
  //                       child: widget.isCenter
  //                           ? Center(child: _dealTabs())
  //                           : _dealTabs(),
  //                     ),
  //                     minHeight: GQStyle.navbarHegiht,
  //                     maxHeight: GQStyle.navbarHegiht,
  //                   ))
  //             ];
  //           },
  //           body: PageView(
  //             onPageChanged: (index) {
  //               if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
  //             },
  //             controller: _pageController,
  //             children: widget.pages,
  //           ));
  // }
}

class JellySliderBar extends StatefulWidget {
  JellySliderBar(
      {Key key,
      this.titles,
      this.pages,
      this.defaultStyle,
      this.selectStyle,
      this.isCenter = false,
      this.inedxFunc,
      this.labelPadding = 12.5,
      this.pageController})
      : super(key: key);
  List<String> titles;
  List<Widget> pages;
  TextStyle defaultStyle;
  TextStyle selectStyle;
  bool isCenter;
  Function(int) inedxFunc;
  PageController pageController;
  double labelPadding;

  @override
  State<JellySliderBar> createState() => _JellySliderBarState();
}

class _JellySliderBarState extends State<JellySliderBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;

  TextStyle _defaultStyle;
  TextStyle _selectStyle;

  Widget _dealTabs() {
    return Theme(
        data: ThemeData(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent),
        child: TabBar(
          onTap: (index) {
            _isOnTab = true;
            _onTabPageChange(index, isOnTab: true);
          },
          indicatorColor: Colors.transparent,
          labelPadding:
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0.5)),
          isScrollable: true,
          physics: BouncingScrollPhysics(),
          tabs: widget.titles
              .asMap()
              .keys
              .map((x) => Tab(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenUtil().setWidth(13)),
                      child: Container(
                        width: ScreenUtil().setWidth(60),
                        height: ScreenUtil().setWidth(26),
                        decoration: BoxDecoration(
                            color: _selectIndex == x
                                ? Color.fromRGBO(35, 35, 55, 1)
                                : Colors.transparent),
                        child: Center(
                          child: Text(
                            widget.titles[x],
                            style: _selectIndex == x
                                ? _selectStyle
                                : _defaultStyle,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ));
  }

  void _onTabPageChange(index, {bool isOnTab = false}) {
    if (_selectIndex == index) {
      _isOnTab = false;
      return;
    }
    _selectIndex = index;
    if (!isOnTab) {
      _tabController.animateTo(_selectIndex);
      setState(() {});
      if (widget.inedxFunc != null) widget.inedxFunc(_selectIndex);
    } else {
      _pageController.animateToPage(_selectIndex,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      //等待滑动解锁
      Future.delayed(Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
        if (widget.inedxFunc != null) widget.inedxFunc(_selectIndex);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.defaultStyle == null || widget.selectStyle == null) {
      _defaultStyle = TextStyle(
          color: Color(0xff999999),
          fontSize: ScreenUtil().setSp(13),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
      _selectStyle = TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(13),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
    } else {
      _defaultStyle = widget.defaultStyle;
      _selectStyle = widget.selectStyle;
    }
    _tabController = TabController(length: widget.titles.length, vsync: this);
    _pageController = widget.pageController ?? PageController();

    _pageController.addListener(() {
      // _pageController.
      double page = _pageController.page;

      if (!_isOnTab) {
        if ((page - _selectIndex).abs() > 0.5) {
          _onTabPageChange(page < _selectIndex ? page.floor() : page.ceil(),
              isOnTab: false);
        }
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    //_pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      height: ScreenUtil().setWidth(30),
      width: double.infinity,
      child: widget.isCenter ? Center(child: _dealTabs()) : _dealTabs(),
    );
  }
}
