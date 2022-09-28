import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';

class MineCreaterCenterStatus extends StatefulWidget {
  MineCreaterCenterStatus({Key key, this.status = ""}) : super(key: key);
  final String status;

  @override
  State<MineCreaterCenterStatus> createState() =>
      _MineCreaterCenterStatusState();
}

class _MineCreaterCenterStatusState extends State<MineCreaterCenterStatus> {
  int page = 1;
  bool isHud = true;
  List<dynamic> topics = [];
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() {
    topicListMyTopic(page: page, last_ix: last_ix, status: widget.status)
        .then((res) {
      if (res.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data["list"]);
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
        topics = st;
      } else if (st.length > 0) {
        topics.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            _getData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : PullRefreshList(
                isAll: noMore,
                onRefresh: () {
                  page = 1;
                  _getData();
                },
                onLoading: () {
                  page++;
                  _getData();
                },
                child: topics.length == 0
                    ? PageStatus.noData()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        shrinkWrap: true,
                        itemCount: topics.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (topics[index]["status"] == 1) {
                                context.push(
                                    "/minecreatercollectdetail/${topics[index]["id"]}");
                              }
                            },
                            child: Column(
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(8)),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: ScreenUtil().setWidth(111),
                                      height: ScreenUtil().setWidth(137),
                                      child: Stack(
                                        children: [
                                          PlatformAwareNetworkImage(
                                            url: topics[index]["thumb"],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(5))),
                                          ),
                                          topics[index]["is_top"] == 1
                                              ? Positioned(
                                                  left:
                                                      ScreenUtil().setWidth(10),
                                                  top:
                                                      ScreenUtil().setWidth(10),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        5)),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF00edfa),
                                                          Color(0xFF00baef)
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          2))),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        CommonUtils.txt("zd"),
                                                        style:
                                                            GQStyle.white255_11,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          topics[index]["status"] == 1
                                              ? Container()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      topics[index]["status"] ==
                                                              0
                                                          ? CommonUtils.txt(
                                                              "dsh")
                                                          : CommonUtils.txt(
                                                              "shsb"),
                                                      style: topics[index]
                                                                  ["status"] ==
                                                              0
                                                          ? GQStyle
                                                              .white255_13_M
                                                          : GQStyle.red255_13_M,
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(10)),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(topics[index]["title"],
                                            style: GQStyle.white255_15),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(14)),
                                        topics[index]["status"] == 1
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${CommonUtils.renderNumber(topics[index]["views_count"])}${CommonUtils.txt("cbf")} ｜ ${CommonUtils.renderNumber(topics[index]["likes_count"])}${CommonUtils.txt("dz")}",
                                                      style:
                                                          GQStyle.gray163_11),
                                                  SizedBox(
                                                      height: ScreenUtil()
                                                          .setWidth(14)),
                                                  Text(
                                                      "${CommonUtils.txt("go")}${topics[index]["mv_count"]}${CommonUtils.txt("jishu")}",
                                                      style:
                                                          GQStyle.gray163_11),
                                                  SizedBox(
                                                      height: ScreenUtil()
                                                          .setWidth(20)),
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      topicToggleTop(
                                                              id: topics[index]
                                                                  ["id"])
                                                          .then((res) {
                                                        if (res.status == 1) {
                                                          topics[index][
                                                              "is_top"] = topics[
                                                                          index]
                                                                      [
                                                                      "is_top"] ==
                                                                  1
                                                              ? 0
                                                              : 1;
                                                          setState(() {});
                                                        } else {
                                                          CommonUtils.showText(
                                                              res.msg);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: topics[index][
                                                                    "is_top"] ==
                                                                1
                                                            ? Color.fromRGBO(
                                                                255,
                                                                255,
                                                                255,
                                                                0.15)
                                                            : Color(0xFF00edfb),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            2))),
                                                      ),
                                                      width: ScreenUtil()
                                                          .setWidth(65),
                                                      height: ScreenUtil()
                                                          .setWidth(20),
                                                      child: Center(
                                                        child: Text(
                                                            topics[index][
                                                                        "is_top"] ==
                                                                    1
                                                                ? CommonUtils
                                                                    .txt("qxzd")
                                                                : CommonUtils
                                                                    .txt("zd"),
                                                            style: topics[index]
                                                                        [
                                                                        "is_top"] ==
                                                                    1
                                                                ? GQStyle
                                                                    .gray203_11
                                                                : GQStyle
                                                                    .white11),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : topics[index]["status"] == 0
                                                ? Container()
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          CommonUtils.txt(
                                                                  "bjyy") +
                                                              "：",
                                                          style: GQStyle
                                                              .red255_11),
                                                      Text(
                                                        topics[index]
                                                            ["reject_reason"],
                                                        style:
                                                            GQStyle.red255_11,
                                                        maxLines: 4,
                                                      ),
                                                    ],
                                                  ),
                                      ],
                                    )),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setWidth(8)),
                                Container(
                                  height: ScreenUtil().setWidth(0.5),
                                  color: Color.fromRGBO(255, 255, 255, 0.1),
                                )
                              ],
                            ),
                          );
                        }),
              );
  }
}
