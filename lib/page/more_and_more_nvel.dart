import 'package:bot_toast/bot_toast.dart';
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

class MoreAndMoreNvel extends BaseWidget {
  MoreAndMoreNvel(
      {Key key, this.sort = "", this.type = "", this.categories = ""})
      : super(key: key);
  String sort;
  String type;
  String categories;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MoreAndMoreNvelState();
  }
}

class _MoreAndMoreNvelState extends BaseWidgetState<MoreAndMoreNvel> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  bool noMore = false;
  bool netWorkErr = false;
  List<dynamic> selecteds = [];

  @override
  void onCreate() {
    // TODO: implement onCreate
    if (widget.sort == "0") {
      widget.sort = "new";
    }
    if (widget.type == "0") {
      widget.type = "";
    }
    if (widget.categories == "0") {
      widget.categories = "";
    }

    setAppTitle(title: CommonUtils.txt("gd"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  _getData({bool showHud = false}) async {
    if (showHud) CommonUtils.startLoadGIF(tip: CommonUtils.txt("jzz"));
    Basic t = await nvelList(
        sort: widget.sort,
        chapter: widget.type,
        category: widget.categories,
        page: page);
    if (showHud) BotToast.closeAllLoading();
    if (t.data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }

    selecteds = t.data["cate"];
    List<dynamic> data = t.data["items"];

    if (page == 1) {
      noMore = false;
      values = data;
    } else if (data.length > 0) {
      values.addAll(data);
    } else {
      noMore = true;
    }
    isHud = false;
    setState(() {});
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    double _cw = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;

    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            isHud = true;
            setState(() {});
            _getData();
          })
        : (isHud
            ? PageStatus.loading(mounted)
            : Column(
                children: [
                  Column(
                    children: selecteds.map((e) {
                      List<dynamic> items = e["items"];
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(18)),
                            height: ScreenUtil().setWidth(30),
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: items.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var flag = false;
                                  var result = items[index]["value"].toString();
                                  if (e["value"] == "sort") {
                                    flag = widget.sort == result;
                                  } else if (e["value"] == "chapter") {
                                    flag = widget.type == result;
                                  } else {
                                    flag = widget.categories == result;
                                  }
                                  return Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        var result =
                                            items[index]["value"].toString();
                                        if (widget.sort == result &&
                                            widget.type == result &&
                                            widget.categories == result) return;
                                        if (e["value"] == "sort") {
                                          widget.sort = result;
                                        } else if (e["value"] == "chapter") {
                                          widget.type = result;
                                        } else {
                                          widget.categories = result;
                                        }
                                        page = 1;
                                        _getData(showHud: true);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: GQStyle.pagePadding),
                                        decoration: BoxDecoration(
                                            color: flag
                                                ? Color(0xFFff4d0b)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: Center(
                                          child: Text(
                                              "${items[index]["label"] ?? "loading"}",
                                              style: flag
                                                  ? GQStyle.white255_14_M
                                                  : GQStyle.gray137_14_M),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(10))
                                  ]);
                                }),
                          ),
                          SizedBox(height: ScreenUtil().setWidth(15))
                        ],
                      );
                    }).toList(),
                  ),
                  Expanded(
                    child: values.length == 0
                        ? PageStatus.noData()
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              shrinkWrap: true,
                              crossAxisCount: 1,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 0,
                              childAspectRatio: 349 / 114,
                              scrollDirection: Axis.vertical,
                              children: values
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          context.push(CommonUtils.getRealHash(
                                              'novelDetail/${e["id"] ?? "0"}'));
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(
                                                ScreenUtil().setWidth(10)),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    25, 25, 25, 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(70),
                                                  child:
                                                      PlatformAwareNetworkImage(
                                                          url: clipImageUrl(
                                                              CommonUtils
                                                                  .getThumb(e),
                                                              inputWidth:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          70)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                ),
                                                SizedBox(
                                                    width: ScreenUtil()
                                                        .setWidth(7)),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setWidth(5)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: ScreenUtil()
                                                              .setWidth(150),
                                                          child: Text(
                                                              e["title"] ??
                                                                  "loading",
                                                              style: GQStyle
                                                                  .white255_14_M),
                                                        ),
                                                        Spacer(),
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            LImage(
                                                              "capter_n",
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          12),
                                                              height:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          14),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            5)),
                                                            Text(
                                                                e["views_count"]
                                                                    .toString(),
                                                                style: GQStyle
                                                                    .white255_14)
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setWidth(13)),
                                                    Text(e["desc"] ?? "loading",
                                                        style:
                                                            GQStyle.gray128_11,
                                                        maxLines: 3),
                                                  ],
                                                )),
                                              ],
                                            )),
                                      ))
                                  .toList(),
                            )),
                  )
                ],
              ));
  }
}
