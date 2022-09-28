import 'dart:async';
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

import 'dart:ui' as ui;

class SearchMainPage extends BaseWidget {
  SearchMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _SearchMainPageState();
  }
}

class _SearchMainPageState extends BaseWidgetState<SearchMainPage>
    with TickerProviderStateMixin {
  TextEditingController myController = TextEditingController();
  TabController _tabController;
  int pageStatus = 0;
  int currentTab = 0;
  String prevText;
  List historyTags = [];
  bool loading = false;
  double top = 0.0;
  dynamic hotData;
  List<dynamic> topList = [
    {"wd": "all", "name": CommonUtils.txt('rszb')},
    {"wd": "mv", "name": CommonUtils.txt('yp')},
    {"wd": "vlog", "name": CommonUtils.txt('dsp')},
    {"wd": "book", "name": CommonUtils.txt('mh')},
    {"wd": "girl", "name": CommonUtils.txt('ym')},
    {"wd": "pic", "name": CommonUtils.txt('mt')},
    {"wd": "story", "name": CommonUtils.txt('xs')}
  ];
  int selectIndex = 0;
  FocusNode _searchFocus = FocusNode();

  List tabList = [
    {'id': 1, 'name': CommonUtils.txt('yp')},
    {'id': 2, 'name': CommonUtils.txt('dsp')},
    {'id': 3, 'name': CommonUtils.txt('mh')},
    {'id': 4, 'name': CommonUtils.txt('xs')},
    {'id': 5, 'name': CommonUtils.txt('mt')},
    {'id': 6, 'name': CommonUtils.txt('ym')},
    {'id': 7, 'name': CommonUtils.txt('ll')},
  ];
  List<dynamic> st;

  Widget _tagItem(String text, int index) {
    return Container(
      height: ScreenUtil().setWidth(30),
      decoration: BoxDecoration(
          color: Color.fromRGBO(47, 47, 66, 1),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))),
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(13)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              myController.text = text;
              _searchAct();
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(100)),
              // BoxConstraints.tightFor(width: ScreenUtil().setWidth(100)),
              child: Text(
                text,
                style: GQStyle.white255_14,
              ),
            ),
          ),
          Container(
            color: Color(0xffffffff),
            height: ScreenUtil().setWidth(13),
            width: ScreenUtil().setWidth(1),
            margin: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              historyTags.removeAt(index);
              AppGlobal.appBox.put('search_history', historyTags);
              setState(() {});
            },
            child: LImage(
              "record_del_n",
              width: ScreenUtil().setWidth(10),
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }

  Widget _prepareSearch() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: ScreenUtil().setWidth(15),
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(15)),
            child: Row(
              children: [
                Text(CommonUtils.txt('ssjl'), style: GQStyle.white255_18_M),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    historyTags.clear();
                    AppGlobal.appBox.put('search_history', historyTags);
                    setState(() {});
                  },
                  child: Text(CommonUtils.txt('qcjl'),
                      style: GQStyle.jellyCyan_13),
                ),
              ],
            ),
          ),
          historyTags.isEmpty
              ? PageStatus.noData(text: CommonUtils.txt('myss'))
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  child: Wrap(
                    spacing: ScreenUtil().setWidth(10),
                    runSpacing: ScreenUtil().setWidth(10),
                    children: historyTags
                        .asMap()
                        .keys
                        .map((e) => _tagItem(historyTags[e], e))
                        .toList(),
                  ),
                ),
          SizedBox(
            height: 0,
          ),
          hotData == null
              ? Container()
              : Column(
                  children: [
                    hotData["banner"] == null || hotData["banner"].length == 0
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding,
                                top: ScreenUtil().setWidth(16)),
                            child: GeneralBanner(
                              height: 100,
                              data: hotData["banner"],
                              radius: 5.0,
                            ),
                          ),
                    hotData["top"] == null || hotData["top"].length == 0
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding,
                                top: ScreenUtil().setWidth(10)),
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(30),
                                    child: Builder(builder: (context) {
                                      int x = 0;
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              selectIndex = x;
                                              st = hotData["top"]
                                                  [topList[selectIndex]["wd"]];
                                              setState(() {});
                                            },
                                            child: Text(
                                              topList[x]["name"],
                                              style: selectIndex == x
                                                  ? GQStyle.jellyCyan_18_M
                                                  : GQStyle.gray180_15_M,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setWidth(10))
                                        ],
                                      );
                                    }),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(10)),
                                  st == null || st.length == 0
                                      ? Container()
                                      : Column(
                                          children: st.asMap().keys.map((x) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    myController.text =
                                                        st[x]["work"];
                                                    _searchAct();
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        height: ScreenUtil()
                                                            .setWidth(20),
                                                        width: ScreenUtil()
                                                            .setWidth(20),
                                                        decoration:
                                                            BoxDecoration(
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Color(x == 0
                                                                        ? 0xFFff9020
                                                                        : (x == 1
                                                                            ? 0xFF1afbb5
                                                                            : (x == 2
                                                                                ? 0xFFa3fb59
                                                                                : 0xFF7e7d8b))),
                                                                    Color(x == 0
                                                                        ? 0xFFf55b5b
                                                                        : (x == 1
                                                                            ? 0xFF13c4d6
                                                                            : (x == 2
                                                                                ? 0xFF21da3f
                                                                                : 0xFF9c9ea7)))
                                                                  ],
                                                                  begin: Alignment
                                                                      .centerLeft,
                                                                  end: Alignment
                                                                      .centerRight,
                                                                ),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            3))),
                                                        child: Center(
                                                          child: Text(
                                                            "${x + 1}",
                                                            style: GQStyle
                                                                .white255_13_B,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: ScreenUtil()
                                                              .setWidth(10)),
                                                      Expanded(
                                                        child: Text(
                                                          st[x]["work"] ??
                                                              "loading",
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    236,
                                                                    236,
                                                                    236,
                                                                    1.0),
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(13),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(110),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            LImage(
                                                              "sear_hotkey_n",
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          11),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          12),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          5),
                                                            ),
                                                            Text(
                                                                "${CommonUtils.renderFixedNumber(st[x]["num"])}" +
                                                                    CommonUtils
                                                                        .txt(
                                                                            'rd'),
                                                                style:
                                                                    TextStyle(
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          231,
                                                                          98,
                                                                          54,
                                                                          1.0),
                                                                  fontSize:
                                                                      ScreenUtil()
                                                                          .setSp(
                                                                              13),
                                                                ))
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(15))
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                  // st == null || st.length == 0
                                  //     ? Container()
                                  // : Container(
                                  //     padding: EdgeInsets.all(
                                  //         ScreenUtil().setWidth(10)),
                                  //     decoration: BoxDecoration(
                                  //       color: Color(0xff23262f),
                                  //       borderRadius: BorderRadius.circular(
                                  //           ScreenUtil().setWidth(5)),
                                  //     ),
                                  //     child: Column(
                                  //       children: st.asMap().keys.map((x) {
                                  //         return GestureDetector(
                                  //           behavior:
                                  //               HitTestBehavior.translucent,
                                  //           onTap: () {
                                  //             myController.text =
                                  //                 st[x]["work"];
                                  //             _searchAct();
                                  //           },
                                  //           child: SizedBox(
                                  //             height:
                                  //                 ScreenUtil().setWidth(23),
                                  //             child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment
                                  //                       .spaceBetween,
                                  //               children: [
                                  //                 Text(
                                  //                   "${x + 1}、",
                                  //                   style: GQStyle
                                  //                       .grayaaa9a8_13,
                                  //                 ),
                                  //                 // SizedBox(
                                  //                 //     width: ScreenUtil()
                                  //                 //         .setWidth(10)),
                                  //                 Expanded(
                                  //                   child: Text(
                                  //                     st[x]["work"] ??
                                  //                         "loading",
                                  //                     style: GQStyle
                                  //                         .white255_13,
                                  //                     maxLines: 1,
                                  //                   ),
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: ScreenUtil()
                                  //                       .setWidth(110),
                                  //                   child: Row(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .end,
                                  //                     children: [
                                  //                       Text(
                                  //                           "${CommonUtils.renderFixedNumber(st[x]["num"])}" +
                                  //                               CommonUtils
                                  //                                   .txt(
                                  //                                       'rd'),
                                  //                           style: GQStyle
                                  //                               .grayaaa9a8_11)
                                  //                     ],
                                  //                   ),
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         );
                                  //       }).toList(),
                                  //     ),
                                  //   )
                                ],
                              ),
                            ),
                          )
                  ],
                )
        ],
      ),
    );
  }

  Widget _searchResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: ScreenUtil().screenHeight - ScreenUtil().setWidth(36) - top,
          child: GenCustomNav(
            titles: tabList.map<String>((e) => e["name"]).toList(),
            pages: tabList
                .map(
                  (e) => PageViewMixin(
                    child: SearchList(type: e['id'], value: myController.text),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  _searchAct() {
    _searchFocus.unfocus();
    if (myController.text.isEmpty) {
      CommonUtils.showText(CommonUtils.txt("qsrgjz"));
      return;
    }
    prevText = myController.text.replaceAll("/", "|");

    if (historyTags.indexOf(myController.text) == -1) {
      historyTags.add(myController.text);
      AppGlobal.appBox.put('search_history', historyTags);
    }

    context.push('/searchResult/$prevText');
  }

  _getData() {
    searchHotList().then((res) {
      if (res.status == 1) {
        hotData = res.data;
        st = hotData["top"][topList[selectIndex]["wd"]];

        /// 选项卡控制器
        _tabController = TabController(
          length: tabList.length,
          vsync: this,
        );
        _tabController.addListener(() {
          if (_tabController.index.toDouble() ==
              _tabController.animation.value) {
            setState(() {
              currentTab = _tabController.index;
            });
          }
        });
        setState(() {});
      } else {
        CommonUtils.txt(res.msg);
      }
    });
  }

  @override
  void onCreate() {
    var searchTag = AppGlobal.appBox.get('search_history');
    if (searchTag != null) {
      historyTags = searchTag;
    }

    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget appbar() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      height: GQStyle.navbarHegiht,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: SizedBox(
              height: GQStyle.navbarHegiht,
              child: LImage(
                "nav_back_n",
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setWidth(20),
              ),
            ),
            onTap: () {
              finish();
            },
          ),
          Expanded(
            child: Container(
              height: ScreenUtil().setWidth(35),
              margin:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(14)),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(47, 47, 66, 1),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(35 / 2.0))),
                child: TextField(
                  cursorColor: Colors.white,
                  focusNode: _searchFocus,
                  // autofocus: true,
                  // onSubmitted: _onSubmit,
                  onSubmitted: (value) {
                    // print(value);
                    _searchAct();
                  },

                  controller: myController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: CommonUtils.txt("pmnyfh"),
                    hintStyle: GQStyle.gray8f8e90_13,
                    contentPadding: EdgeInsets.zero,
                    fillColor: Color(0xffe6e4e4),
                    prefixIcon: Padding(
                      child: LImage(
                        "search_g",
                        width: ScreenUtil().setWidth(12),
                        height: ScreenUtil().setWidth(12),
                      ),
                      padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10)),
                    ),
                    prefixIconConstraints: BoxConstraints(
                      maxHeight: ScreenUtil().setWidth(35),
                      maxWidth: ScreenUtil().setWidth(35),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: ScreenUtil().setWidth(9),
                          width: .5,
                          // color: Colors.white,
                          color: Color(0xa3a2a2),
                          // color: Color.fromRGBO(26, 26, 31, 1),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(4.5),
                        ),
                      ],
                    ),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenUtil().setSp(13),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _searchAct();
            },
            child: Text(
              CommonUtils.txt('ss'),
              style: GQStyle.white255_14,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    // return Container(
    //   color: Colors.red,
    // );
    top =
        kIsWeb ? ScreenUtil().setWidth(15) : MediaQuery.of(context).padding.top;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _searchFocus.unfocus();
        },
        child: _prepareSearch());
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Color color1 = Colors.red;
    Color color2 = Colors.cyan;

    int all = 1000;
    for (var i = 0; i < all; i++) {
      double progress = i / all.toDouble();
      double nextProgress = (i + 1) / all.toDouble();

      Path path = Path();

      path.moveTo(size.width * progress, 0);
      path.lineTo(size.width * nextProgress, 0);
      path.lineTo(size.width * nextProgress, size.height);
      path.lineTo(size.width * progress, size.height);
      // path.lineTo(0, 0);

      // canvas.drawShadow(path, Color.lerp(color1, color2, progress), 10, true);
      canvas.drawShadow(path, Colors.red, 10, true);
    }
    // path.moveTo(0, 0);
    // path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // // path.lineTo(0, 0);
    // canvas.drawShadow(path, Color(0xffffFF00), 10, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SomeWidget extends StatelessWidget {
  const SomeWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double alpha = 0.5;
    Color color1 = Color(0xff00edfd).withAlpha((alpha * 255).toInt());
    Color color2 = Color(0xffbc53e0).withAlpha((alpha * 255).toInt());

    Offset offset = Offset(0, 0);
    double blurRadius = 10;
    double spreadRadius = 3.5;

    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      List widgets = [];

      Widget left = Container(
        height: height,
        width: height / 2,
        decoration: BoxDecoration(
            color: color1,
            boxShadow: [
              BoxShadow(
                  color: color1,
                  offset: offset,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius),
            ],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(height / 2),
                bottomLeft: Radius.circular(height / 2))),
      );

      Widget right = Container(
        height: height,
        width: height / 2,
        decoration: BoxDecoration(
            color: color2,
            boxShadow: [
              BoxShadow(
                  color: color2,
                  offset: offset,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius),
            ],
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(height / 2),
                bottomRight: Radius.circular(height / 2))),
      );

      double middleWidth = width - height;
      int all = 100;
      for (var i = 0; i < all; i++) {
        double progress = i / all.toDouble();
        double nextProgress = (i + 1) / all.toDouble();

        Widget widget = Container(
          height: height,
          width: middleWidth / all,
          decoration: BoxDecoration(
            // color: Color.lerp(color1, color2, progress),
            boxShadow: [
              BoxShadow(
                  color: Color.lerp(color1, color2, progress),
                  offset: offset,
                  blurRadius: blurRadius,
                  spreadRadius: spreadRadius / 2),
            ],
          ),
        );

        widgets.add(widget);
      }

      widgets.insert(0, left);
      widgets.add(right);

      return Row(
        children: [...widgets],
      );
    });
  }
}
