import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';

enum YyqDiamondNavEnum {
  chestnut,
  line,
  cover,
}

class YyqDiamondNav extends StatefulWidget {
  YyqDiamondNav(
      {Key key,
      this.titles,
      this.pages,
      this.defaultStyle,
      this.selectStyle,
      this.isCenter = false,
      this.navColor = Colors.transparent,
      this.labelPadding = 10,
      this.inedxFunc,
      this.jumpFunc,
      this.type = YyqDiamondNavEnum.line})
      : super(key: key);
  List<String> titles;
  List<Widget> pages;
  TextStyle defaultStyle;
  TextStyle selectStyle;
  bool isCenter;
  Color navColor;
  Function(int) inedxFunc;
  Function(int) jumpFunc;
  bool isLine; // 扩展支持 横线类型的指示器。默认是false (钻石图片的指示器)
  double labelPadding;
  YyqDiamondNavEnum type; //0菱角 1下划线 2覆盖

  @override
  State<YyqDiamondNav> createState() => _GenCustomNavState();
}

class _GenCustomNavState extends State<YyqDiamondNav>
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
          highlightColor: Colors.transparent, splashColor: Colors.transparent),
      child: TabBar(
        onTap: (index) {
          _isOnTab = true;
          _onTabPageChange(index, isOnTab: true);
        },
        indicatorColor: Colors.transparent,
        labelPadding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(widget.labelPadding)),
        isScrollable: true,
        physics: BouncingScrollPhysics(),
        tabs: widget.titles
            .asMap()
            .keys
            .map(
              (x) => Container(
                child: Tab(
                  // text: widget.titles[x],

                  height: GQStyle.navbarHegiht, //防止overlayout
                  child: _bottomIndicator(x),
                ),
              ),
            )
            .toList(),
        controller: _tabController,
      ),
    );
  }

  /// 根据 isLine 选择 横线类型的指示器 或者 钻石图片的指示器
  Widget _bottomIndicator(int x) {
    if (widget.type == YyqDiamondNavEnum.chestnut) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.titles[x],
            style: _selectIndex == x ? _selectStyle : _defaultStyle,
          ),
          SizedBox(
              width: ScreenUtil().setWidth(9),
              height: ScreenUtil().setWidth(9),
              child: _selectIndex == x
                  ? LImage(
                      'nav_diamond',
                    )
                  : Container())
        ],
      );
    } else if (widget.type == YyqDiamondNavEnum.line) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.titles[x],
            style: _selectIndex == x ? _selectStyle : _defaultStyle,
          ),
          SizedBox(
              width: ScreenUtil().setWidth(21.5),
              height: ScreenUtil().setWidth(3.5),
              child: (_selectIndex == x)
                  ? Container(
                      decoration: BoxDecoration(
                        color: GQStyle.jellyCyanColor103224185,
                        borderRadius:
                            BorderRadius.all(Radius.circular(3.5 / 2)),
                      ),
                      height: ScreenUtil().setWidth(3),
                    )
                  : Container())
        ],
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(12)),
        height: ScreenUtil().setWidth(24),
        decoration: BoxDecoration(
          gradient: _selectIndex == x
              ? LinearGradient(
                  colors: [Color(0xFF00baef), Color(0xFF00edfa)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(12))),
          border: _selectIndex == x
              ? null
              : Border.all(
                  color: Color(0xffffffff), width: ScreenUtil().setWidth(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.titles[x],
              style:
                  _selectIndex == x ? GQStyle.white255_13 : GQStyle.gray163_13,
            )
          ],
        ),
      );
    }
  }

  void _onTabPageChange(index,
      {bool isOnTab = false, bool forceRefreashTab = false}) {
    if (_selectIndex == index) {
      _isOnTab = false;
      return;
    }
    _selectIndex = index;

    if (_selectIndex < 0 || _selectIndex > widget.titles.length) {
      return;
    }
    if (!isOnTab) {
      _tabController.animateTo(_selectIndex);

      setState(() {});
      if (widget.inedxFunc != null) widget.inedxFunc(_selectIndex);
    } else {
      _pageController.animateToPage(_selectIndex,
          duration: Duration(milliseconds: 200), curve: Curves.linear);

      if (forceRefreashTab == true) {
        _tabController.animateTo(_selectIndex);
      }
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
          color: Color.fromRGBO(172, 171, 176, 1),
          fontSize: ScreenUtil().setSp(15),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none);
      _selectStyle = TextStyle(
          color: Color.fromRGBO(237, 140, 45, 1),
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

    EventBus().on('IndexNavJump', (arg) {
      int index = arg;
      // _tabController.animateTo(index);

      if (index >= 0 && index < widget.titles.length) {
        _isOnTab = true;
        _onTabPageChange(index, isOnTab: _isOnTab, forceRefreashTab: true);
      }

      // _onTabPageChange(index, isOnTab: false);
    });

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _pageController.dispose();

    EventBus().off('IndexNavJump');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.titles.length == 0
        ? Container()
        : Column(
            children: [
              Container(
                color: widget.navColor,
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
