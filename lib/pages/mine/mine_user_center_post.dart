import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
// import 'package:qypj/components/pageview/afterlayout.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class MineUserCenterPost extends StatefulWidget {
  MineUserCenterPost({Key key, this.aff}) : super(key: key);
  final String aff;

  @override
  State<MineUserCenterPost> createState() => _MineUserCenterPostState();
}

class _MineUserCenterPostState extends State<MineUserCenterPost> {
  int page = 1;
  bool isHud = true;
  List<dynamic> data = [];
  bool noMore = false;
  bool netWorkErr = false;
  String last_ix = "";

  _getData() {
    if (widget.aff == null) {
      userMyPosts(
        page: page,
      ).then((res) {
        if (res.data == null) {
          netWorkErr = true;
          setState(() {});
          return;
        }

        List st = res.data;
        // last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
        if (page == 1) {
          noMore = false;
          data = st;
        } else if (st.length > 0) {
          data.addAll(st);
        } else {
          noMore = true;
        }
        isHud = false;
        setState(() {});
      });
    } else {
      peerCenterPost(
        aff: widget.aff,
        page: page,
        last_ix: last_ix,
      ).then((res) {
        if (res.data == null) {
          netWorkErr = true;
          setState(() {});
          return;
        }
        List st = res.data;
        // last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
        if (page == 1) {
          noMore = false;
          data = st;
        } else if (st.length > 0) {
          data.addAll(st);
        } else {
          noMore = true;
        }
        isHud = false;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GQStyle.bgColor,
      child: netWorkErr
          ? PageStatus.noNetWork(onTap: () {
              netWorkErr = false;
              _getData();
            })
          : isHud
              ? PageStatus.loading(mounted)
              : data.length == 0
                  ? PageStatus.noData()
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
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          dynamic e = data[index];
                          List medias = e["medias"] ?? [];
                          List tmp =
                              medias.length > 3 ? medias.sublist(0, 3) : medias;
                          return Container(
                            margin: EdgeInsets.only(
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (e["status"] == 1) {
                                  context
                                      .push("/communitypostdetail/${e["id"]}");
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${RelativeDateFormat.format(DateTime.parse(e["created_at"] ?? ""))}",
                                      style: GQStyle.gray102_14),
                                  Offstage(
                                    offstage: false,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10),
                                          bottom: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(10),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              left: BorderSide(
                                            color: Color(0xFF60B2DC),
                                            width: ScreenUtil().setWidth(2),
                                          )),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10)),
                                            Text.rich(TextSpan(children: [
                                              e["is_best"] == 1
                                                  ? WidgetSpan(
                                                      alignment:
                                                          PlaceholderAlignment
                                                              .middle,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            right: ScreenUtil()
                                                                .setWidth(2)),
                                                        child: Container(
                                                          height: ScreenUtil()
                                                              .setWidth(16),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          5)),
                                                          child: Text(
                                                            CommonUtils.txt(
                                                                "jhua"),
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          11),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          decoration: BoxDecoration(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      234,
                                                                      99,
                                                                      152,
                                                                      1.0),
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      ScreenUtil()
                                                                          .setWidth(
                                                                              2)))),
                                                        ),
                                                      ))
                                                  : TextSpan(),
                                              TextSpan(
                                                  text: e["title"] ?? "",
                                                  style: GQStyle.white255_15)
                                            ])),
                                            tmp.length > 0
                                                ? GridView.count(
                                                    padding: EdgeInsets.only(
                                                        top: ScreenUtil()
                                                            .setWidth(12)),
                                                    shrinkWrap: true,
                                                    crossAxisCount: 3,
                                                    mainAxisSpacing:
                                                        ScreenUtil()
                                                            .setWidth(7),
                                                    crossAxisSpacing:
                                                        ScreenUtil()
                                                            .setWidth(7),
                                                    childAspectRatio: 1.0,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    children: tmp
                                                        .asMap()
                                                        .keys
                                                        .map((x) => Stack(
                                                              children: [
                                                                PlatformAwareNetworkImage(
                                                                  url: tmp[x]["type"] ==
                                                                          2
                                                                      ? tmp[x][
                                                                              "cover"] ??
                                                                          ""
                                                                      : tmp[x][
                                                                              "media_url"] ??
                                                                          "",
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              ScreenUtil().setWidth(5))),
                                                                ),
                                                                tmp[x]["type"] ==
                                                                        2
                                                                    ? Center(
                                                                        child: LImage(
                                                                            "v_play_n",
                                                                            width:
                                                                                ScreenUtil().setWidth(30),
                                                                            height: ScreenUtil().setWidth(30)),
                                                                      )
                                                                    : Container(),
                                                                //大于3张图并且最后一图显示剩余多少张
                                                                x == 2 &&
                                                                        medias.length >
                                                                            3
                                                                    ? Positioned(
                                                                        right: ScreenUtil()
                                                                            .setWidth(
                                                                                6),
                                                                        bottom: ScreenUtil()
                                                                            .setWidth(
                                                                                6),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5)),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: Color.fromRGBO(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                0.5),
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(2))),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "+${medias.length - 3}",
                                                                              style: GQStyle.white255_12,
                                                                            ),
                                                                          ),
                                                                        ))
                                                                    : Container()
                                                              ],
                                                            ))
                                                        .toList(),
                                                  )
                                                : Container(),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(15)),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      context.push(
                                                          "/communitytagdetail/${e["topic"]["id"]}");
                                                    },
                                                    child: Text(
                                                      "#${e["topic"]["name"] ?? ""}",
                                                      style:
                                                          GQStyle.blue96_13_M,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${CommonUtils.renderFixedNumber(e["comment_num"] ?? 0)}${CommonUtils.txt("tpl")} ｜ ${CommonUtils.renderFixedNumber(e["view_num"] ?? 0)}${CommonUtils.txt("llan")} ｜ ${CommonUtils.renderFixedNumber(e["like_num"] ?? 0)}${CommonUtils.txt("dz")}",
                                                    style: GQStyle.gray163_11,
                                                  )
                                                ]),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10)),
                                            e["status"] == 2
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: ScreenUtil()
                                                            .setWidth(10)),
                                                    child: Column(
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
                                                        SizedBox(
                                                            height: ScreenUtil()
                                                                .setWidth(5)),
                                                        Text(
                                                          e["refuse_reason"],
                                                          style:
                                                              GQStyle.red255_11,
                                                          maxLines: 20,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : (e["status"] == 0
                                                    ? Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom: ScreenUtil()
                                                                .setWidth(10)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                CommonUtils.txt(
                                                                        "shzt") +
                                                                    "：" +
                                                                    CommonUtils
                                                                        .txt(
                                                                            'dsh'),
                                                                style: GQStyle
                                                                    .red255_11),
                                                          ],
                                                        ),
                                                      )
                                                    : Container())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
