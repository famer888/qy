import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';

class MoreAndMorePNG extends BaseWidget {
  MoreAndMorePNG({Key key, this.id}) : super(key: key);
  String id = "0";

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MoreAndMorePNGState();
  }
}

class _MoreAndMorePNGState extends BaseWidgetState<MoreAndMorePNG> {
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
                child: MoreAndMorePNGChild(
                  type: "hot",
                  id: widget.id,
                  titleFunc: (txt) {
                    setAppTitle(title: txt);
                  },
                ),
              ),
              PageViewMixin(
                  child: MoreAndMorePNGChild(type: "new", id: widget.id)),
            ],
          ),
        )
      ],
    );
  }
}

class MoreAndMorePNGChild extends StatefulWidget {
  MoreAndMorePNGChild({Key key, this.type, this.id, this.titleFunc})
      : super(key: key);
  final String type;
  final String id;
  final Function(String) titleFunc;

  @override
  State<MoreAndMorePNGChild> createState() => _MoreAndMorePNGChildState();
}

class _MoreAndMorePNGChildState extends State<MoreAndMorePNGChild> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  dynamic value;
  String sort = "hot";
  bool noMore = false;
  bool netWorkErr = false;

  _getData() async {
    Basic t = await getElementByIdSecondPage(
        id: widget.id,
        page: page,
        limit: AppGlobal.smallVideoLimit,
        sort: sort);
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
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(12)) /
        2;
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
                child: GridView.count(
                  padding: EdgeInsets.only(
                      left: GQStyle.pagePadding,
                      right: GQStyle.pagePadding,
                      top: GQStyle.pagePadding),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: ScreenUtil().setWidth(10),
                  crossAxisSpacing: ScreenUtil().setWidth(10),
                  childAspectRatio: 169 / 256,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  children: values
                      .map((e) => GestureDetector(
                            onTap: () {
                              context.push(CommonUtils.getRealHash(
                                  'atlasDetail/${e["id"] ?? "0"}'));
                            },
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: _w / 169 * 224,
                                      child: PlatformAwareNetworkImage(
                                          url: CommonUtils.getThumb(e),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                    ),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(3.5)),
                                    Text(e["title"] ?? "loading",
                                        style: GQStyle.white255_14),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(3.5)),
                                  ],
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CommonUtils.identiWget(e,
                                      isHideCoin: true),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ));
  }
}
