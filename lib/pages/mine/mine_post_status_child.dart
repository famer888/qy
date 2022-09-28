import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class MinePostStatusChild extends StatefulWidget {
  MinePostStatusChild({Key key, this.type}) : super(key: key);
  String type;

  @override
  State<MinePostStatusChild> createState() => _MinePostStatusChildState();
}

class _MinePostStatusChildState extends State<MinePostStatusChild> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data;

  _getData() {
    userMyPosts(cate: widget.type, page: page).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            networkErr = false;
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
                      padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(5),
                      ),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        dynamic e = data[index];
                        List medias = e["medias"] ?? [];
                        List tmp =
                            medias.length > 3 ? medias.sublist(0, 3) : medias;
                        // double w = 0;
                        // if (e != null) {
                        //   w = CommonUtils.boundingTextSize(
                        //           context,
                        //           e["user"]["nickname"] ?? "",
                        //           GQStyle.white255_15_M)
                        //       .width;
                        // }
                        return Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil().setWidth(15),
                              left: GQStyle.pagePadding,
                              right: GQStyle.pagePadding),
                          decoration: BoxDecoration(
                            color: Color(0xFF23262f),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(10))),
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (e["status"] == 1) {
                                context.push("/communitypostdetail/${e["id"]}");
                              }
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                        ScreenUtil().setWidth(10)),
                                    topRight: Radius.circular(
                                        ScreenUtil().setWidth(10)),
                                  ),
                                  child: LImage(
                                    "comm_post_head_n",
                                    height: ScreenUtil().setWidth(50),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: ScreenUtil().setWidth(50),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "发布时间：${RelativeDateFormat.format(DateTime.parse(e["created_at"] ?? ""))}",
                                                style: GQStyle.white255_15_M),
                                            GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                if (widget.type == "favorite") {
                                                  communityTopicFavorite(
                                                          id: e["id"]
                                                              .toString())
                                                      .then((res) {
                                                    if (res.status == 1) {
                                                      data.remove(e);
                                                      setState(() {});
                                                    } else {
                                                      CommonUtils.showText(
                                                          res.msg);
                                                    }
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(10)),
                                                height:
                                                    ScreenUtil().setWidth(25),
                                                decoration: BoxDecoration(
                                                    color:
                                                        widget.type == "favorite"
                                                            ? Colors.transparent
                                                            : Color(0xFF00eefe),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            ScreenUtil()
                                                                .setWidth(
                                                                    25 / 2))),
                                                    border: Border.all(
                                                        color: widget.type ==
                                                                "favorite"
                                                            ? Color(0xFF00eefe)
                                                            : Colors
                                                                .transparent,
                                                        width: ScreenUtil()
                                                            .setWidth(0.5))),
                                                child: Center(
                                                  child: Text(
                                                    widget.type == "favorite"
                                                        ? CommonUtils.txt("qx")
                                                        : e["status"] == 0
                                                            ? CommonUtils.txt(
                                                                "dsh")
                                                            : e["status"] == 1
                                                                ? CommonUtils
                                                                    .txt("ysh")
                                                                : CommonUtils
                                                                    .txt(
                                                                        "shsb"),
                                                    style: widget.type ==
                                                            "favorite"
                                                        ? GQStyle.blue80_11
                                                        : GQStyle.black13_11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(15)),
                                      Text.rich(TextSpan(children: [
                                        e["is_best"] == 1
                                            ? WidgetSpan(
                                                alignment:
                                                    PlaceholderAlignment.middle,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      right:
                                                          GQStyle.pagePadding),
                                                  child: LImage(
                                                    "comm_txtjh_n",
                                                    width: ScreenUtil()
                                                        .setWidth(32),
                                                    height: ScreenUtil()
                                                        .setWidth(15),
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
                                                  ScreenUtil().setWidth(7),
                                              crossAxisSpacing:
                                                  ScreenUtil().setWidth(7),
                                              childAspectRatio: 1.0,
                                              scrollDirection: Axis.vertical,
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
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            5))),
                                                          ),
                                                          tmp[x]["type"] == 2
                                                              ? Center(
                                                                  child: LImage(
                                                                      "v_play_n",
                                                                      width: ScreenUtil()
                                                                          .setWidth(
                                                                              30),
                                                                      height: ScreenUtil()
                                                                          .setWidth(
                                                                              30)),
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
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            ScreenUtil().setWidth(5)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color
                                                                          .fromRGBO(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              0.5),
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(ScreenUtil().setWidth(2))),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "+${medias.length - 3}",
                                                                        style: GQStyle
                                                                            .white255_12,
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
                                          height: ScreenUtil().setWidth(15)),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                context.push(
                                                    "/communitytagdetail/${e["topic"]["id"]}");
                                              },
                                              child: Text(
                                                "#${e["topic"]["name"] ?? ""}",
                                                style: GQStyle.blue96_13_M,
                                              ),
                                            ),
                                            Text(
                                              "${CommonUtils.renderFixedNumber(e["comment_num"] ?? 0)}${CommonUtils.txt("tpl")} ｜ ${CommonUtils.renderFixedNumber(e["view_num"] ?? 0)}${CommonUtils.txt("llan")} ｜ ${CommonUtils.renderFixedNumber(e["like_num"] ?? 0)}${CommonUtils.txt("dz")}",
                                              style: GQStyle.gray163_11,
                                            )
                                          ]),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(14)),
                                      e["status"] == 2
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: ScreenUtil()
                                                      .setWidth(14)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      CommonUtils.txt("bjyy") +
                                                          "：",
                                                      style: GQStyle.red255_11),
                                                  Text(
                                                    e["refuse_reason"],
                                                    style: GQStyle.red255_11,
                                                    maxLines: 4,
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
  }
}
