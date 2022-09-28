import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class GenCustomNav extends StatefulWidget {
  GenCustomNav(
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
  GenCustomNavState createState() => GenCustomNavState();
}

class GenCustomNavState extends State<GenCustomNav>
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
              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(16)),
          isScrollable: true,
          physics: BouncingScrollPhysics(),
          tabs: widget.titles
              .asMap()
              .keys
              .map((x) => Tab(
                    child: Row(
                      children: [
                        Text(
                          widget.titles[x],
                          style:
                              _selectIndex == x ? _selectStyle : _defaultStyle,
                        )
                      ],
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ));
  }

  void onTabPageChange(index, {bool isOnTab = false}) {
    _onTabPageChange(index, isOnTab: isOnTab);
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
          color: Color.fromRGBO(180, 180, 180, 1),
          fontSize: ScreenUtil().setSp(15),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
      _selectStyle = TextStyle(
          color: Color.fromRGBO(0, 237, 253, 1),
          fontSize: ScreenUtil().setSp(22),
          fontWeight: FontWeight.bold,
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
}
