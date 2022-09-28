import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/search_list.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'dart:ui' as ui;
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/utils/networkImage.dart';
import 'dart:math';

class RankPage extends BaseWidget {
  RankPage({Key key, this.type = "day", this.is_book = true}) : super(key: key);

  String type; //'type' => 'enum(day = 日榜,week = 周榜 , like = 人气榜 , sale = 销售榜)'
  bool is_book;

  @override
  State<StatefulWidget> cState() {
    return _RankPageState();
  }
}

class _RankPageState extends BaseWidgetState<RankPage> {
  @override
  void onCreate() {
    // if (searchTag != null) {
    // historyTags = searchTag;
    // }
    // _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      height: GQStyle.navbarHegiht,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: SizedBox(
              height: double.infinity,
              child: LImage(
                "nav_back_n",
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setWidth(20),
                color: Colors.white,
              ),
            ),
            onTap: () {
              finish();
            },
          ),
          Text("", style: GQStyle.white255_18_B),
          Container()
        ],
      ),
    );
  }

  @override
  Widget backGroundView() {
    // TODO: implement backGroundView
    return LImage("rank_bg");
  }

  @override
  Widget pageBody(BuildContext context) {
    var typeDatas = [
      {
        'name': '漫画榜',
        'value': '1',
      },
      {
        'name': '动漫榜',
        'value': '2',
      },
    ];
    var titles = typeDatas.asMap().keys.map<String>((x) {
      return typeDatas[x]["name"];
    }).toList();

    var pages = typeDatas.asMap().keys.map((e) {
      return SingleRankPage(
        is_book: typeDatas[e]["value"] == '1',
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ScreenUtil().setWidth(116),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        Expanded(
          child: RankPageNav(
            titles: titles,
            pages: pages,
            isLine: true,
            defaultStyle: TextStyle(
                color: Color(0xffffffff),
                fontSize: ScreenUtil().setSp(13),
                overflow: TextOverflow.visible,
                decoration: TextDecoration.none),
            selectStyle: TextStyle(
                color: Color.fromRGBO(26, 26, 31, 1),
                fontSize: ScreenUtil().setSp(13),
                overflow: TextOverflow.visible,
                decoration: TextDecoration.none),
            // inedxFunc: (idx) {
            //   setState(() {
            //     // widget.type = []
            //   });;
            // },
          ),
        )
      ],
    );
  }
}

class SingleRankPage extends StatefulWidget {
  SingleRankPage({Key key, this.is_book = true}) : super(key: key);

  bool is_book;

  @override
  State<SingleRankPage> createState() => _SingleRankPageState();
}

class _SingleRankPageState extends State<SingleRankPage> {
  @override
  Widget build(BuildContext context) {
    var titleDatas = [
      {'name': '日热榜', 'value': 'day', 'id': "1"},
      {'name': '周热榜', 'value': 'week', 'id': "2"},
      {'name': '人气榜', 'value': 'like', 'id': "3"},
      {'name': '畅销榜', 'value': 'sale', 'id': "4"},
    ];
    var titles = titleDatas.asMap().keys.map<String>((x) {
      return titleDatas[x]["name"];
    }).toList();

    var pages = titleDatas.asMap().keys.map((e) {
      return SingleRankListView(
        type: titleDatas[e]["value"],
        is_book: widget.is_book,
      );
    }).toList();
    return YyqDiamondNav(
      titles: titles,
      pages: pages,
      type: YyqDiamondNavEnum.line,
      defaultStyle: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(13),
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none),
      selectStyle: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(13),
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.visible,
          decoration: TextDecoration.none),
    );
  }
}

class SingleRankListView extends StatefulWidget {
  SingleRankListView({Key key, this.type = "1", this.is_book = true})
      : super(key: key);

  String type;
  bool is_book;
  @override
  State<SingleRankListView> createState() => _SingleRankListViewState();
}

class _SingleRankListViewState extends State<SingleRankListView> {
  List<dynamic> values = [];
  int page = 1;
  bool isHud = true;
  bool noMore = false;
  bool netWorkErr = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            setState(() {});
            _getData();
          })
        : (isHud
            ? PageStatus.loading(mounted)
            : PullRefreshList(
                isAll: noMore,
                onRefresh: () {
                  page = 1;
                  _getData();
                },
                onLoading: () {
                  page += 1;
                  _getData();
                },
                child: values.length == 0
                    ? PageStatus.noData()
                    : Wrap(
                        runSpacing: 18,
                        // EdgeInsets.symmetric(horizontal: ),
                        // shrinkWrap: true,
                        // crossAxisCount: 1,
                        // mainAxisSpacing: GQStyle.pagePadding,
                        // crossAxisSpacing: 0,
                        // childAspectRatio: 349 / (widget.type == "1" ? 125 : 86),
                        // scrollDirection: Axis.vertical,
                        children: values.map((e) => _itemWidget(e)).toList(),
                      ),
              ));
  }

  Widget _itemWidget(dynamic e) {
    // int rank = Random().nextInt(10);
    // rank += 1;
    int rank = e["score_num"] ?? -1;
    String rankString = rank == -1
        ? ""
        : rank < 10
            ? "0${rank}"
            : "${rank}";

    String tags = e["tags"];
    List<String> tagList = tags.split(",");
    tagList.remove("");

    tagList = tagList.length > 2 ? tagList.sublist(0, 2) : tagList;

    return widget.is_book
        ? GestureDetector(
            /// 漫画cell
            onTap: () {
              context.push(
                  CommonUtils.getRealHash('comicsdetail/${e["id"] ?? "0"}'));
            },
            child: Container(
                padding: EdgeInsets.only(
                    left: GQStyle.pagePadding, right: GQStyle.pagePadding),
                height: ScreenUtil().setWidth(125),
                child: Row(
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(95),
                      height: ScreenUtil().setWidth(125),
                      child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(e),
                              inputWidth: ScreenUtil().setWidth(95)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(14)),
                    Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(10)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(200),
                                  child: Text(e["title"] ?? "loading",
                                      style: GQStyle.white255_15, maxLines: 1),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(5)),
                                SizedBox(
                                  width: ScreenUtil().setWidth(200),
                                  child: Text(e["title"] ?? "loading",
                                      style: GQStyle.gray128_11, maxLines: 2),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(19.5)),
                                Container(
                                  width: ScreenUtil().setWidth(200),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: tagList.map((e) {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () =>
                                                {debugPrint("tap tag")},
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: ScreenUtil()
                                                      .setWidth(8.5),
                                                  right: ScreenUtil()
                                                      .setWidth(8.5)),
                                              alignment: Alignment.center,

                                              decoration: BoxDecoration(
                                                color: Color(0xff3d434c),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(10.5))),
                                              ),
                                              height: ScreenUtil().setWidth(21),
                                              // width: ScreenUtil().setWidth(39),
                                              child: Text(
                                                e,
                                                style: GQStyle.white11,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setWidth(10)),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ]),
                          Column(
                            children: [
                              SizedBox(height: 64),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                      width: ScreenUtil().setWidth(32),
                                      height: ScreenUtil().setWidth(31),
                                      child: rank > 3 || rank == -1
                                          ? Container()
                                          : LImage("rankbg${rank}")),
                                  Text(rankString,
                                      style: rank > 3
                                          ? GQStyle.hex666666_24_S
                                          : GQStyle.white255_24_S)
                                ],
                              )
                            ],
                          )
                        ])),
                  ],
                )),
          )
        : GestureDetector(
            /// 动漫cell
            onTap: () {
              context.push(
                  CommonUtils.getRealHash('videoDetail/${e["id"] ?? "0"}'));
            },
            child: Container(
                padding: EdgeInsets.only(
                    left: GQStyle.pagePadding, right: GQStyle.pagePadding),
                height: ScreenUtil().setWidth(86),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.topLeft,
                      // clipBehavior: Clip.hardEdge,
                      children: [
                        SizedBox(
                          height: ScreenUtil().setWidth(86),
                          width: ScreenUtil().setWidth(171),
                          child: PlatformAwareNetworkImage(
                              url: clipImageUrl(CommonUtils.getThumb(e),
                                  inputWidth: ScreenUtil().setWidth(171)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        Positioned.fill(
                          left: -1,
                          top: -1,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: rank == -1
                                ? Container()
                                : LImage(
                                    "rankbg_${rank > 3 ? 4 : rank}",
                                    width: ScreenUtil().setWidth(32),
                                    height: ScreenUtil().setWidth(30.5),
                                  ),
                          ),
                        ),
                        Text(rankString,
                            style: rank > 3
                                ? GQStyle.hex666666_20_S
                                : GQStyle.white255_20_S)
                      ],
                    ),
                    SizedBox(width: ScreenUtil().setWidth(14)),
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(8)),
                            SizedBox(
                              width: ScreenUtil().setWidth(160),
                              child: Text(e["title"] ?? "loading",
                                  style: GQStyle.white255_13, maxLines: 1),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(2)),
                            SizedBox(
                              width: ScreenUtil().setWidth(160),
                              child: Text(e["title"] ?? "loading",
                                  style: GQStyle.gray128_11, maxLines: 1),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(12)),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: tagList.map((e) {
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => {debugPrint("tap tag")},
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            left: ScreenUtil().setWidth(7.5),
                                            right: ScreenUtil().setWidth(7.5)),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          border: Border.all(
                                              width: 0.5,
                                              color: Color(0xffffffff)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(10.5))),
                                        ),
                                        height: ScreenUtil().setWidth(15),
                                        // width: ScreenUtil().setWidth(39),
                                        child: Text(
                                          e,
                                          style: GQStyle.hexa3a2a2_10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                  ],
                                );
                              }).toList(),
                            )),
                          ]),
                    ),
                  ],
                )),
          );
  }

  _getData() {
    (widget.is_book
            ? bookTopList(
                type: widget.type, page: page, limit: AppGlobal.smallVideoLimit)
            : cartoonTopList(
                type: widget.type,
                page: page,
                limit: AppGlobal.smallVideoLimit))
        .then((t) {
      if (t.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      if (page == 1) {
        noMore = false;
        values = t.data["list"];
      } else if ((t.data["list"] as List<dynamic>).length > 0) {
        values.addAll((t.data["list"] as List<dynamic>));
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }
}

class RankPageNav extends StatefulWidget {
  RankPageNav(
      {Key key,
      this.titles,
      this.pages,
      this.defaultStyle,
      this.selectStyle,
      this.isCenter = true,
      this.isLine = false,
      this.inedxFunc})
      : super(key: key);
  List<String> titles;
  List<Widget> pages;
  TextStyle defaultStyle;
  TextStyle selectStyle;
  bool isCenter;
  Function(int) inedxFunc;
  bool isLine; // 扩展支持 横线类型的指示器。默认是false (钻石图片的指示器)

  @override
  State<RankPageNav> createState() => _RankPageNavState();
}

class _RankPageNavState extends State<RankPageNav>
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
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              height: ScreenUtil().setWidth(27),
              width: ScreenUtil().setWidth(180),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(13.5))),
                border: new Border.all(width: 0.5, color: Color(0xffffffff)),
              ),
            ),
            TabBar(
              onTap: (index) {
                _isOnTab = true;
                _onTabPageChange(index, isOnTab: true);
              },
              indicatorColor: Colors.transparent,
              labelPadding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(0)),
              isScrollable: true,
              physics: BouncingScrollPhysics(),
              tabs: widget.titles
                  .asMap()
                  .keys
                  .map(
                    (x) => Tab(
                      height: GQStyle.navbarHegiht, //防止overlayout
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _selectIndex == x
                                  ? Color(0xff00edfd)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(13.5))),
                            ),
                            height: ScreenUtil().setWidth(27),
                            width: ScreenUtil().setWidth(90),
                            child: Text(
                              widget.titles[x],
                              style: _selectIndex == x
                                  ? _selectStyle
                                  : _defaultStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              controller: _tabController,
            ),
          ],
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
