import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

//帖子
class CommunityPost extends StatefulWidget {
  CommunityPost({
    Key key,
    this.showHead = true,
    this.data,
    this.noHead = false,
    this.replace = false,
    this.forScroller = false,
  }) : super(key: key);
  final bool showHead;
  final bool noHead;
  final List<dynamic> data;
  final bool replace;
  final bool forScroller;

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.noHead
              ? Container()
              : Column(
                  children: [
                    widget.showHead
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: GQStyle.pagePadding),
                            child: Text(CommonUtils.txt("lzngxqbq"),
                                style: GQStyle.white255_18_M),
                          )
                        : Container(),
                    SizedBox(height: ScreenUtil().setWidth(10))
                  ],
                ),
          Column(
            children: widget.data.map((e) {
              CommonUtils.debugPrint("${e["title"]}---${e["medias"]}");
              List medias = e["medias"] ?? [];
              List tmp = medias.length > 3 ? medias.sublist(0, 3) : medias;
              double w = 0;
              if (e != null && e["user"] != null) {
                w = CommonUtils.boundingTextSize(context,
                        e["user"]["nickname"] ?? "", GQStyle.white255_15_M)
                    .width;
              }
              return Container(
                margin: EdgeInsets.only(
                    bottom: ScreenUtil().setWidth(15),
                    left: GQStyle.pagePadding,
                    right: GQStyle.pagePadding),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(21, 21, 42, 1),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(10))),
                ),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.push("/communitypostdetail/${e["id"]}");
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: GQStyle.pagePadding),
                            SizedBox(
                              height: ScreenUtil().setWidth(50),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: ScreenUtil().setWidth(50),
                                    height: ScreenUtil().setWidth(50),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        context.push(
                                            '/mineUserCenter/${e["user"]["aff"]}');
                                      },
                                      child: PlatformAwareNetworkImage(
                                        imageName: "flj_logo_icon",
                                        url: e["user"]["thumb"] ?? "",
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(25))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(9.5)),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: w >
                                                      ScreenUtil().setWidth(130)
                                                  ? ScreenUtil().setWidth(130)
                                                  : w,
                                              child: Text(
                                                e["user"]["nickname"] ?? "",
                                                style: GQStyle.white255_15_M,
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(9)),
                                            e["user"]["vip_level"] > 0
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        7)),
                                                    height: ScreenUtil()
                                                        .setWidth(15),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        7.5))),
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFFf5e0d1),
                                                            Color(0xFFfbeadd),
                                                            Color(0xFFf4d4b5),
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        )),
                                                    child: Center(
                                                      child: Text(
                                                        CommonUtils.txt("vvp"),
                                                        style:
                                                            GQStyle.brown_10_B,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                                width: ScreenUtil().setWidth(
                                                    e["user"]["vip_level"] > 0
                                                        ? 8
                                                        : 0)),
                                            e["user"]["auth_status"] == 1
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        7)),
                                                    height: ScreenUtil()
                                                        .setWidth(15),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(Radius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        7.5))),
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFFffca43),
                                                            Color(0xFFff7d3e)
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        )),
                                                    child: Center(
                                                      child: Text(
                                                        CommonUtils.txt(
                                                            "cuangz"),
                                                        style: GQStyle
                                                            .white255_10_B,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(2)),
                                        Text(
                                          RelativeDateFormat.format(
                                              DateTime.parse(
                                                  e["created_at"] ?? "")),
                                          style: GQStyle.gray163_11,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(5)),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      communityFollowUser(
                                              aff: e["user"]["aff"].toString())
                                          .then((res) {
                                        if (res.status == 1) {
                                          e["user"]["is_follow"] =
                                              e["user"]["is_follow"] == 1
                                                  ? 0
                                                  : 1;
                                          setState(() {});
                                        } else {
                                          CommonUtils.showText(res.msg);
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: ScreenUtil().setWidth(55),
                                      height: ScreenUtil().setWidth(25),
                                      decoration: BoxDecoration(
                                          color: e["user"]["is_follow"] == 1
                                              ? Color(0xFF60b2dc)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(ScreenUtil()
                                                  .setWidth(25 / 2))),
                                          border: Border.all(
                                              color: e["user"]["is_follow"] == 1
                                                  ? Colors.transparent
                                                  : Color(0xFF60b2dc),
                                              width:
                                                  ScreenUtil().setWidth(0.5))),
                                      child: Center(
                                        child: Text(
                                          e["user"]["is_follow"] == 1
                                              ? CommonUtils.txt("ygz")
                                              : "+ ${CommonUtils.txt("gz")}",
                                          style: e["user"]["is_follow"] == 1
                                              ? GQStyle.white11
                                              : GQStyle.blue80_11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            Text.rich(
                              TextSpan(children: [
                                e["is_best"] == 1
                                    ? WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(2)),
                                          child: Container(
                                            height: ScreenUtil().setWidth(16),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(5)),
                                            child: Text(
                                              CommonUtils.txt("jhua"),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(11),
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    234, 99, 152, 1.0),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(ScreenUtil()
                                                        .setWidth(2)))),
                                          ),
                                        ))
                                    : TextSpan(),
                                TextSpan(
                                  text: e["title"] != null
                                      ? CommonUtils.convertEmojiAndHtml(
                                          e["title"])
                                      : "",
                                  style: GQStyle.white255_15,
                                )
                              ]),
                            ),
                            tmp.length > 0
                                ? GridView.count(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(12)),
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: ScreenUtil().setWidth(7),
                                    crossAxisSpacing: ScreenUtil().setWidth(7),
                                    childAspectRatio: 1.0,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: tmp
                                        .asMap()
                                        .keys
                                        .map((x) => Stack(
                                              children: [
                                                PlatformAwareNetworkImage(
                                                  url: tmp[x]["type"] == 2
                                                      ? tmp[x]["cover"] ?? ""
                                                      : tmp[x]["media_url"] ??
                                                          "",
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          ScreenUtil()
                                                              .setWidth(5))),
                                                ),
                                                tmp[x]["type"] == 2
                                                    ? Center(
                                                        child: LImage(
                                                            "v_play_n",
                                                            width: ScreenUtil()
                                                                .setWidth(30),
                                                            height: ScreenUtil()
                                                                .setWidth(30)),
                                                      )
                                                    : Container(),
                                                //大于3张图并且最后一图显示剩余多少张
                                                x == 2 && medias.length > 3
                                                    ? Positioned(
                                                        right: ScreenUtil()
                                                            .setWidth(6),
                                                        bottom: ScreenUtil()
                                                            .setWidth(6),
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          5)),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.5),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            2))),
                                                          ),
                                                          child: Center(
                                                            child: Text(
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
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      LImage("commun_eye_n",
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20)),
                                      SizedBox(width: ScreenUtil().setWidth(2)),
                                      Text(
                                        "${CommonUtils.renderFixedNumber(e["view_num"] ?? 0)}",
                                        style: GQStyle.gray199_13,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      LImage("commun_like_n",
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20)),
                                      SizedBox(width: ScreenUtil().setWidth(2)),
                                      Text(
                                        "${CommonUtils.renderFixedNumber(e["like_num"] ?? 0)}",
                                        style: GQStyle.gray199_13,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      LImage("commun_cmt_n",
                                          width: ScreenUtil().setWidth(20),
                                          height: ScreenUtil().setWidth(20)),
                                      SizedBox(width: ScreenUtil().setWidth(2)),
                                      Text(
                                        "${CommonUtils.renderFixedNumber(e["comment_num"] ?? 0)}",
                                        style: GQStyle.gray199_13,
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      context.push(
                                        "/communitytagdetail/${e["topic"]["id"]}",
                                        replace: widget.replace,
                                      );
                                    },
                                    child: Text(
                                      "#${e["topic"]["name"] ?? ""}",
                                      style: GQStyle.blue96_13_M,
                                    ),
                                  )
                                ]),
                            SizedBox(height: ScreenUtil().setWidth(14)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
