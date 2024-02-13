import 'package:flutter/foundation.dart';
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
class CommunityBitPost extends StatefulWidget {
  CommunityBitPost({
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
  State<CommunityBitPost> createState() => _CommunityBitPostState();
}

class _CommunityBitPostState extends State<CommunityBitPost> {
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
              List medias = e["medias"] ?? [];
              List tmp = medias.length > 3 ? medias.sublist(0, 3) : medias;
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
                    context.push("/communitypostbitdetail/${e["id"]}");
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
                            Text.rich(
                              TextSpan(children: [
                                e["is_best"] == 1
                                    ? WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: ScreenUtil().setWidth(2)),
                                          child: Container(
                                            height: ScreenUtil().setWidth(17),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setWidth(5)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  CommonUtils.txt("jhua"),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(11),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                gradient: GQStyle
                                                    .btnGradient_ff00edfd_ffbbe954,
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
                                        "${CommonUtils.renderFixedNumber(e["fake_view_ct"] ?? 0)}",
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
                                  SizedBox(width: 50.w),
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
