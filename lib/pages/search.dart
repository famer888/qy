import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/search_list.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/general_banner.dart';

class Search extends BaseWidget {
  Search({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _SearchState();
  }
}

class _SearchState extends BaseWidgetState<Search>
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
    return GestureDetector(
      onTap: () {
        myController.text = text;
        pageStatus = 1;
        setState(() {});
      },
      child: Container(
        height: ScreenUtil().setWidth(30),
        decoration: BoxDecoration(
            color: Color(0xff191919),
            borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))),
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(13)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: GQStyle.white255_14,
            ),
            Container(
              color: Color(0xffffffff),
              height: ScreenUtil().setWidth(13),
              width: ScreenUtil().setWidth(1),
              margin:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            ),
            GestureDetector(
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
      ),
    );
  }

  Widget _prepareSearch() {
    return Expanded(
        child: SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            child: Row(
              children: [
                Text(CommonUtils.txt('ssjl'), style: GQStyle.gray180_16_B),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    historyTags.clear();
                    AppGlobal.appBox.put('search_history', historyTags);
                    setState(() {});
                  },
                  child:
                      Text(CommonUtils.txt('qcjl'), style: GQStyle.gray180_14),
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
                    spacing: ScreenUtil().setWidth(10.5),
                    runSpacing: ScreenUtil().setWidth(15),
                    children: historyTags
                        .asMap()
                        .keys
                        .map((e) => _tagItem(historyTags[e], e))
                        .toList(),
                  ),
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
                            ),
                          ),
                    hotData["top"] == null || hotData["top"].length == 0
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.only(
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding,
                                top: ScreenUtil().setWidth(30)),
                            child: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(30),
                                    child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      children: topList
                                          .asMap()
                                          .keys
                                          .map((x) => Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      selectIndex = x;
                                                      st = hotData["top"][
                                                          topList[selectIndex]
                                                              ["wd"]];
                                                      setState(() {});
                                                    },
                                                    child: Text(
                                                      topList[x]["name"],
                                                      style: selectIndex == x
                                                          ? GQStyle
                                                              .white253_22_B
                                                          : GQStyle
                                                              .gray180_15_M,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(17.5))
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(25)),
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
                                                    pageStatus = 1;
                                                    setState(() {});
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
                                                                          255,
                                                                          70,
                                                                          2,
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
                                        )
                                ],
                              ),
                            ),
                          )
                  ],
                )
        ],
      ),
    ));
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

  Widget _searchHead() {
    return Container(
      margin: EdgeInsets.only(top: top),
      height: ScreenUtil().setWidth(36),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: LImage(
                "nav_back_n",
                width: ScreenUtil().setWidth(22),
                height: ScreenUtil().setWidth(22),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: ScreenUtil().setWidth(30),
            padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().setWidth(15))),
            child: TextField(
              focusNode: _searchFocus,
              // autofocus: true,
              // onSubmitted: _onSubmit,
              onSubmitted: (value) {
                // print(value);
                _searchAct();
              },
              controller: myController,
              textInputAction: TextInputAction.search,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: CommonUtils.txt("pmnyfh"),
                hintStyle: GQStyle.gray180_15_M,
                contentPadding: EdgeInsets.zero,
                fillColor: Color(0xffF0F0F0),
                prefixIcon: Padding(
                  child: LImage(
                    "search_gray_n",
                    width: ScreenUtil().setWidth(35),
                    height: ScreenUtil().setWidth(35),
                  ),
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(10),
                      right: ScreenUtil().setWidth(10)),
                ),
                prefixIconConstraints: BoxConstraints(
                  maxHeight: ScreenUtil().setWidth(35),
                  maxWidth: ScreenUtil().setWidth(35),
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
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
          )),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(5)),
            child: GestureDetector(
              onTap: () {
                _searchFocus.unfocus();
                if (myController.text.isEmpty) {
                  CommonUtils.showText(CommonUtils.txt("qsrgjz"));
                  return;
                }
                if (prevText == myController.text) return;
                prevText = myController.text;
                pageStatus = 1;
                loading = true;
                if (historyTags.indexOf(myController.text) == -1) {
                  historyTags.add(myController.text);
                  AppGlobal.appBox.put('search_history', historyTags);
                }
                setState(() {});
                Timer(Duration(milliseconds: 200), () {
                  loading = false;
                  setState(() {});
                });
              },
              child: Text(
                CommonUtils.txt('ss'),
                style: GQStyle.white255_15_M,
              ),
            ),
          )
        ],
      ),
    );
  }

  _searchAct() {
    _searchFocus.unfocus();
    if (myController.text.isEmpty) {
      CommonUtils.showText(CommonUtils.txt("qsrgjz"));
      return;
    }
    if (prevText == myController.text) return;
    prevText = myController.text;
    pageStatus = 1;
    loading = true;
    if (historyTags.indexOf(myController.text) == -1) {
      historyTags.add(myController.text);
      AppGlobal.appBox.put('search_history', historyTags);
    }
    setState(() {});
    Timer(Duration(milliseconds: 200), () {
      loading = false;
      setState(() {});
    });
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
    // TODO: implement onCreate
    var searchTag = AppGlobal.appBox.get('search_history');
    if (searchTag != null) {
      historyTags = searchTag;
    }

    _getData();
  }

  @override
  void didPush() {
    // TODO: implement didPush
    // super.didPush();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    top =
        kIsWeb ? ScreenUtil().setWidth(15) : MediaQuery.of(context).padding.top;
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _searchFocus.unfocus();
        },
        child: Column(
          children: [
            _searchHead(),
            pageStatus == 0
                ? _prepareSearch()
                : (loading
                    ? Expanded(child: PageStatus.loading(mounted))
                    : _searchResult())
          ],
        ));
  }
}
