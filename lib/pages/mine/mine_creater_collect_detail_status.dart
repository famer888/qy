import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';

class MineCreaterCollectDetailStatus extends StatefulWidget {
  MineCreaterCollectDetailStatus({Key key, this.status = "", this.id})
      : super(key: key);
  final String status;
  final String id;

  @override
  State<MineCreaterCollectDetailStatus> createState() =>
      _MineCreaterCollectDetailStatusState();
}

class _MineCreaterCollectDetailStatusState
    extends State<MineCreaterCollectDetailStatus> {
  int page = 1;
  bool isHud = true;
  List<dynamic> videos = [];
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
    topicCollectForVideo(
            id: widget.id, page: page, last_ix: last_ix, status: widget.status)
        .then((res) {
      if (res.data == null) {
        netWorkErr = true;
        setState(() {});
        return;
      }
      List st = res.data;
      // last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
        videos = st;
      } else if (st.length > 0) {
        videos.addAll(st);
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
                child: videos.length == 0
                    ? PageStatus.noData()
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        shrinkWrap: true,
                        itemCount: videos.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (videos[index]["status"] == 3) {}
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
                                            url: CommonUtils.getThumb(
                                                videos[index]),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(5))),
                                          ),
                                          Positioned(
                                            right: ScreenUtil().setWidth(10),
                                            bottom: ScreenUtil().setWidth(10),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      ScreenUtil().setWidth(5)),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(2))),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  CommonUtils.getHMTime(
                                                      videos[index]
                                                          ["duration"]),
                                                  style: GQStyle.white255_11_B,
                                                ),
                                              ),
                                            ),
                                          ),
                                          videos[index]["status"] == 3
                                              ? Container()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      videos[index]["status"] ==
                                                              0
                                                          ? CommonUtils.txt(
                                                              "dsh")
                                                          : videos[index][
                                                                      "status"] ==
                                                                  1
                                                              ? CommonUtils.txt(
                                                                  "hdz")
                                                              : CommonUtils.txt(
                                                                  "shsb"),
                                                      style: videos[index]
                                                                  ["status"] ==
                                                              0
                                                          ? GQStyle
                                                              .white255_13_M
                                                          : videos[index][
                                                                      "status"] ==
                                                                  1
                                                              ? GQStyle
                                                                  .green0_13_M
                                                              : GQStyle
                                                                  .red255_13_M,
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
                                        Text(videos[index]["title"],
                                            style: GQStyle.white255_15),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(14)),
                                        videos[index]["status"] == 3
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      "${CommonUtils.renderNumber(videos[index]["play_ct"])}${CommonUtils.txt("cbf")} ｜ ${CommonUtils.renderNumber(videos[index]["count_like"])}${CommonUtils.txt("dz")}",
                                                      style:
                                                          GQStyle.gray163_11),
                                                  SizedBox(
                                                      height: ScreenUtil()
                                                          .setWidth(14)),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text.rich(
                                                          TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                CommonUtils.txt(
                                                                        "jg") +
                                                                    "：",
                                                            style: GQStyle
                                                                .white255_11_03),
                                                        TextSpan(
                                                            text:
                                                                "${AppGlobal.vipLevel > 0 ? videos[index]["discount_coins"] : videos[index]["coins"]}${CommonUtils.txt("jb")}",
                                                            style: GQStyle
                                                                .blue80_11_M),
                                                      ])),
                                                      Text.rich(
                                                          TextSpan(children: [
                                                        TextSpan(
                                                            text:
                                                                CommonUtils.txt(
                                                                        "zsy") +
                                                                    "：",
                                                            style: GQStyle
                                                                .white255_11_03),
                                                        TextSpan(
                                                            text:
                                                                "${videos[index]["income_coins"]}${CommonUtils.txt("jb")}",
                                                            style: GQStyle
                                                                .blue80_11_M),
                                                      ]))
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: ScreenUtil()
                                                          .setWidth(20)),
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      context.push(CommonUtils
                                                          .getRealHash(
                                                              "minecreatercollectrate/${videos[index]["id"]}"));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Color.fromRGBO(
                                                            255,
                                                            255,
                                                            255,
                                                            0.15),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            2))),
                                                      ),
                                                      width: ScreenUtil()
                                                          .setWidth(60),
                                                      height: ScreenUtil()
                                                          .setWidth(20),
                                                      child: Center(
                                                        child: Text(
                                                            CommonUtils.txt(
                                                                    "cksy") +
                                                                ">",
                                                            style: GQStyle
                                                                .gray163_10),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : videos[index]["status"] == 0 ||
                                                    videos[index]["status"] == 1
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
                                                        videos[index]
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
