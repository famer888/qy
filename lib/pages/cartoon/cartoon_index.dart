import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/tiktok_featured_short_video.dart';
import 'package:qypj/pages/cartoon/cartoon_discover.dart';
import 'package:qypj/pages/cartoon/cartoon_endrawer.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/pageviewmixin.dart';

class CartoonIndex extends StatefulWidget {
  CartoonIndex({Key key, this.isShow}) : super(key: key);
  bool isShow;

  @override
  _CartoonIndexState createState() => _CartoonIndexState();
}

class _CartoonIndexState extends State<CartoonIndex>
    with SingleTickerProviderStateMixin {
  bool isHud = true;
  List<String> navList = [
    CommonUtils.txt("tjan"),
    CommonUtils.txt("faxia"),
    CommonUtils.txt("gz"),
  ];
  dynamic topic;

  TabController _tabController;
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;
  TextStyle _defaultStyle = TextStyle(
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.visible,
      decoration: TextDecoration.none);
  TextStyle _selectStyle = TextStyle(
      color: Color.fromRGBO(0, 237, 253, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.visible,
      decoration: TextDecoration.none);

  Widget _dealTabs() {
    return Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: TabBar(
          onTap: (index) {
            _isOnTab = true;
            _onTabPageChange(index, isOnTab: true);
          },
          indicator: BoxDecoration(),
          indicatorColor: Colors.transparent,
          labelPadding: EdgeInsets.symmetric(horizontal: 12.5),
          isScrollable: true,
          physics: BouncingScrollPhysics(),
          tabs: navList
              .asMap()
              .keys
              .map((x) => Container(
                    child: Tab(
                      height: GQStyle.navbarHegiht, //防止overlayout
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            navList[x],
                            style: _selectIndex == x
                                ? _selectStyle
                                : _defaultStyle,
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
                      ),
                    ),
                  ))
              .toList(),
          controller: _tabController,
        ));
  }

  List<Widget> _pages() {
    return [
      kIsWeb
          ? TikTokFeaturedShortVideo(type: 1)
          : PageViewMixin(child: TikTokFeaturedShortVideo(type: 1)),
      kIsWeb ? CartoonDiscover() : PageViewMixin(child: CartoonDiscover()),
      kIsWeb
          ? TikTokFeaturedShortVideo(type: 0)
          : PageViewMixin(child: TikTokFeaturedShortVideo(type: 0)),
    ];
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
    } else {
      _pageController.animateToPage(_selectIndex,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      //等待滑动解锁
      Future.delayed(Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: navList.length, vsync: this);
    _pageController = PageController();
    // Future.delayed(Duration(milliseconds: 100), () {
    //   _onTabPageChange(1, isOnTab: true);
    // });
    EventBus().on('OpenDrawerJJ', (arg) {
      CommonUtils.debugPrint(arg);
      topic = arg;
      setState(() {
        _scaffoldKey.currentState.openEndDrawer();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    EventBus().off('OpenDrawerJJ');
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: topic == null ? Container() : CartoonEndrawer(data: topic),
      endDrawerEnableOpenDragGesture: false,
      key: _scaffoldKey,
      body: navList.length == 0
          ? Container()
          : Stack(
              children: [
                PageView(
                  onPageChanged: (index) {
                    if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
                  },
                  controller: _pageController,
                  children: _pages(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: ScreenUtil().setWidth(116),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.6),
                            Color.fromRGBO(0, 0, 0, 0.0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: _selectIndex == 1
                      ? Color(0xFF23262f)
                      : Colors.transparent,
                  padding: EdgeInsets.only(
                    top: kIsWeb
                        ? ScreenUtil().setWidth(10)
                        : MediaQuery.of(context).padding.top,
                    left: GQStyle.pagePadding,
                    right: GQStyle.pagePadding,
                  ),
                  height: (kIsWeb
                          ? ScreenUtil().setWidth(10)
                          : MediaQuery.of(context).padding.top) +
                      GQStyle.navbarHegiht,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Member member =
                              Provider.of<HomeConfig>(context, listen: false)
                                  .member;
                          if (member.authStatus == 0) {
                            context.push("/minecreaterapply");
                          } else {
                            context.push("/minecreatercenter");
                          }
                        },
                        child: LImage(
                          "cartoon_up_n",
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setWidth(25),
                        ),
                      ),
                      Center(child: _dealTabs()),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          context.push("/search");
                        },
                        child: LImage(
                          "cartoon_search_n",
                          width: ScreenUtil().setWidth(25),
                          height: ScreenUtil().setWidth(25),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
