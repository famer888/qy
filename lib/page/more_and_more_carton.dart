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

class MoreAndMoreCarton extends BaseWidget {
  MoreAndMoreCarton({Key key, this.id}) : super(key: key);
  String id = "0";

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MoreAndMoreCartonState();
  }
}

class _MoreAndMoreCartonState extends BaseWidgetState<MoreAndMoreCarton> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  bool noMore = false;
  bool netWorkErr = false;
  List<dynamic> selecteds = [];
  String sort = "new";

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("dman"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  _getData({bool showHud = false}) async {
    if (showHud) CommonUtils.startLoadGIF(tip: CommonUtils.txt("jzz"));
    Basic t = await comicList(
      sort: sort,
      element_id: widget.id,
      page: page,
    );
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
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;

    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
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
                                    flag = sort == result;
                                  } else if (e["value"] == "category") {
                                    flag = widget.id == result;
                                  }
                                  return Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        var result =
                                            items[index]["value"].toString();
                                        if (sort == result &&
                                            widget.id == result) return;
                                        if (e["value"] == "sort") {
                                          sort = result;
                                        } else if (e["value"] == "category") {
                                          widget.id = result;
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
                                                  : GQStyle.gray137_14_M,
                                              textAlign: TextAlign.center),
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
                              crossAxisCount: 2,
                              mainAxisSpacing: ScreenUtil().setWidth(4),
                              crossAxisSpacing: ScreenUtil().setWidth(4),
                              childAspectRatio: 224 / 196,
                              scrollDirection: Axis.vertical,
                              children: values
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          context.push(CommonUtils.getRealHash(
                                              'videoDetail/${e["id"]}'));
                                        },
                                        child: Stack(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: _w / 173 * 100,
                                                  child:
                                                      PlatformAwareNetworkImage(
                                                          url: clipImageUrl(
                                                              CommonUtils
                                                                  .getThumb(e),
                                                              inputWidth:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          173)),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(3.5)),
                                                Text(e["title"] ?? "loading",
                                                    style: GQStyle.white255_14),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(3.5)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        "${CommonUtils.renderFixedNumber(e["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                        style:
                                                            GQStyle.gray105_11),
                                                    Spacer(),
                                                    Text(
                                                        "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                                        style:
                                                            GQStyle.gray105_11),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(5))
                                                  ],
                                                )
                                              ],
                                            ),
                                            Positioned(
                                                right: 0,
                                                top: 0,
                                                child:
                                                    CommonUtils.identiWget(e))
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            )),
                  )
                ],
              ));
  }
}
