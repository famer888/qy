import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';

class MoreAndMoreCase extends BaseWidget {
  MoreAndMoreCase({Key key, this.id}) : super(key: key);
  String id = "0";

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MoreAndMoreCaseState();
  }
}

class _MoreAndMoreCaseState extends BaseWidgetState<MoreAndMoreCase> {
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;
  List<String> titles = [CommonUtils.txt("rdpx"), CommonUtils.txt("zxpx")];

  void _onTabPageChange(index, {bool isOnTab = false}) {
    _selectIndex = index;
    if (!isOnTab) {
      setState(() {});
    } else {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      //等待滑动解锁
      Future.delayed(Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
      });
    }
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    _pageController = PageController();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _pageController.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(64)),
          height: ScreenUtil().setWidth(38),
          color: Color.fromRGBO(25, 25, 25, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: titles.asMap().keys.map((x) {
              return GestureDetector(
                onTap: () {
                  _isOnTab = true;
                  _onTabPageChange(x, isOnTab: true);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(titles[x],
                        style: _selectIndex == x
                            ? GQStyle.yellow255_15_M
                            : GQStyle.white255_15_M),
                    // SizedBox(width: ScreenUtil().setWidth(5)),
                    // LImage(
                    //   _selectIndex == x ? "trigon_down_h" : "trigon_down_n",
                    //   width: ScreenUtil().setWidth(9),
                    //   height: ScreenUtil().setWidth(6),
                    // )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
            },
            controller: _pageController,
            children: [
              PageViewMixin(
                child: MoreAndMoreCaseChild(
                  type: "hot",
                  id: widget.id,
                  titleFunc: (txt) {
                    setAppTitle(title: txt);
                  },
                ),
              ),
              PageViewMixin(
                  child: MoreAndMoreCaseChild(type: "new", id: widget.id)),
            ],
          ),
        )
      ],
    );
  }
}

class MoreAndMoreCaseChild extends StatefulWidget {
  MoreAndMoreCaseChild({Key key, this.type, this.id, this.titleFunc})
      : super(key: key);
  final String type;
  final String id;
  final Function(String) titleFunc;

  @override
  State<MoreAndMoreCaseChild> createState() => _MoreAndMoreCaseChildState();
}

class _MoreAndMoreCaseChildState extends State<MoreAndMoreCaseChild> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  dynamic value;
  bool noMore = false;
  bool netWorkErr = false;

  _getData() async {
    Basic t = await getElementByIdSecondPage(
        id: widget.id,
        page: page,
        limit: AppGlobal.smallVideoLimit,
        sort: widget.type);
    if (t.data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }
    if (page == 1) {
      noMore = false;
      values = t.data["value"];
      if (widget.titleFunc != null) {
        widget.titleFunc(t.data["title"] ?? "loading");
      }
    } else if ((t.data["value"] as List<dynamic>).length > 0) {
      values.addAll((t.data["value"] as List<dynamic>));
    } else {
      noMore = true;
    }
    isHud = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    double _cw = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;

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
                child: ListView.builder(
                    padding: EdgeInsets.only(
                        left: GQStyle.pagePadding,
                        right: GQStyle.pagePadding,
                        top: GQStyle.pagePadding),
                    itemCount: values.length,
                    itemBuilder: (context, index) {
                      dynamic t = values[index];
                      if (index == 0) {
                        return GestureDetector(
                            onTap: () {
                              context.push(CommonUtils.getRealHash(
                                  'videoDetail/${t["id"]}'));
                            },
                            child: Stack(children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: _cw / 350 * 200,
                                      child: PlatformAwareNetworkImage(
                                          url: CommonUtils.getThumb(t),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)))),
                                  SizedBox(height: ScreenUtil().setWidth(3.5)),
                                  Text(t["title"] ?? "loading",
                                      style: GQStyle.white255_14),
                                  SizedBox(height: ScreenUtil().setWidth(3.5)),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          "${CommonUtils.renderFixedNumber(t["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                          style: GQStyle.gray105_12),
                                      Text(
                                          "${CommonUtils.getHMTime(t["duration"] ?? 0)}",
                                          style: GQStyle.gray105_12)
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(16.5))
                                ],
                              ),
                              Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CommonUtils.identiWget(t)),
                              Positioned(
                                  top: (_cw / 350 * 200 -
                                          ScreenUtil().setWidth(40)) /
                                      2,
                                  left: (_cw - ScreenUtil().setWidth(40)) / 2,
                                  child: LImage(
                                    "play_n",
                                    width: ScreenUtil().setWidth(40),
                                    height: ScreenUtil().setWidth(40),
                                  ))
                            ]));
                      } else {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.push(CommonUtils.getRealHash(
                                    'videoDetail/${t["id"]}'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(25, 25, 25, 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                height: _cw / 395 * 130,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(177),
                                      child: PlatformAwareNetworkImage(
                                          url: CommonUtils.getThumb(t),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              bottomLeft: Radius.circular(5))),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(12)),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(14)),
                                          Text(t["title"] ?? "loading",
                                              style: GQStyle.white255_14_M),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(17)),
                                          Text(
                                              "${CommonUtils.renderFixedNumber(t["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                              style: GQStyle.gray105_12),
                                          SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(16)),
                                          Text(
                                              "${CommonUtils.getHMTime(t["duration"] ?? 0)}",
                                              style: GQStyle.gray105_12)
                                        ])),
                                    SizedBox(width: ScreenUtil().setWidth(8))
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(10))
                          ],
                        );
                      }
                    }),
              ));
  }
}
