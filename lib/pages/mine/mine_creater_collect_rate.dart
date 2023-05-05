import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';

class MineCreaterCollectRate extends BaseWidget {
  MineCreaterCollectRate({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterCollectRateState();
  }
}

class _MineCreaterCollectRateState
    extends BaseWidgetState<MineCreaterCollectRate> {
  dynamic vData;
  List<dynamic> vList;
  bool isHud = true;
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";
  int page = 1;

  _getData() {
    mvsEarnInfo(
      id: widget.id,
      page: page,
      last_ix: last_ix,
    ).then((res) {
      if (res.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data["list"]);
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
        vData = res.data["mv"];
        vList = st;
      } else if (st.length > 0) {
        vList.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("syxq"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : Container(
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setWidth(10)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(111),
                        height: ScreenUtil().setWidth(137),
                        child: Stack(
                          children: [
                            PlatformAwareNetworkImage(
                              url: CommonUtils.getThumb(vData),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(5))),
                            ),
                            Positioned(
                              right: ScreenUtil().setWidth(10),
                              bottom: ScreenUtil().setWidth(10),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(5)),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(2))),
                                ),
                                child: Center(
                                  child: Text(
                                    CommonUtils.getHMTime(vData["duration"]),
                                    style: GQStyle.white255_11_B,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(vData["title"], style: GQStyle.white255_15),
                          SizedBox(height: ScreenUtil().setWidth(14)),
                          Text(
                              "${CommonUtils.renderNumber(vData["play_ct"])}${CommonUtils.txt("cbf")} ｜ ${CommonUtils.renderNumber(vData["count_like"])}${CommonUtils.txt("dz")}",
                              style: GQStyle.gray163_11),
                          SizedBox(height: ScreenUtil().setWidth(14)),
                          Text.rich(TextSpan(children: [
                            TextSpan(
                                text: "${CommonUtils.txt("zsy")}：",
                                style: GQStyle.gray163_13),
                            TextSpan(
                                text: "${vData["income_coins"] ?? ""}",
                                style: GQStyle.blue80_13_M),
                          ])),
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Container(
                  height: ScreenUtil().setWidth(5),
                  color: Color(0xFF23262f),
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                Expanded(
                  child: PullRefreshList(
                    isAll: noMore,
                    onRefresh: () {
                      page = 1;
                      _getData();
                    },
                    onLoading: () {
                      page++;
                      _getData();
                    },
                    child: vList.length == 0
                        ? PageStatus.noData()
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: GQStyle.pagePadding),
                            shrinkWrap: true,
                            itemCount: vList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                // color: Colors.redAccent,
                                height: ScreenUtil().setWidth(62),
                                // alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Container(
                                    //   height: 10,
                                    //   color: Colors.deepOrange,
                                    // ),
                                    Expanded(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: ScreenUtil().setWidth(34),
                                            height: ScreenUtil().setWidth(34),
                                            child: PlatformAwareNetworkImage(
                                              url: CommonUtils.getThumb(
                                                  vList[index]
                                                      ["source_member"]),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(17))),
                                            ),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setWidth(10)),
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            vList[index][
                                                                        "source_member"]
                                                                    [
                                                                    "nickname"] ??
                                                                "",
                                                            style: GQStyle
                                                                .white255_13_M),
                                                        Expanded(
                                                            child: Text(
                                                                '·${vList[index]["desc"] ?? ""}',
                                                                style: GQStyle
                                                                    .graya3a2a2_11_M))
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setWidth(7)),
                                                    Text(
                                                        "${RelativeDateFormat.format(DateTime.parse(vList[index]["created_at"] ?? ""))}",
                                                        style: GQStyle
                                                            .graya3a2a2_12),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            // width: 30,
                                            // height: 10,
                                            // height: double.infinity,
                                            child: Text(
                                                "+${vList[index]["coinCnt"] ?? 0}${CommonUtils.txt("jb")}",
                                                style: GQStyle.blue80_13_M),
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: ScreenUtil().setWidth(44),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: ScreenUtil().setWidth(0.5),
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   height: 10,
                                    //   color: Colors.green,
                                    // ),
                                  ],
                                ),
                              );
                            }),
                  ),
                )
              ],
            ),
          );
  }
}
