import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:hive/hive.dart';

//女优横屏横向滚动 type = 6
class ActrHorScroll extends StatefulWidget {
  ActrHorScroll({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<ActrHorScroll> createState() => _ActrHorScrollState();
}

class _ActrHorScrollState extends State<ActrHorScroll> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(4)) /
      2;
  double _cw = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;
  List<dynamic> _values;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data == null) return;
    _values = widget.data["value"];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LImage(
                  "max_triangle_n",
                  width: ScreenUtil().setWidth(18),
                  height: ScreenUtil().setWidth(18),
                ),
                SizedBox(width: ScreenUtil().setWidth(5.5)),
                Expanded(
                    child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.data["title"] ?? "loading",
                        style: GQStyle.white255_18_B),
                    SizedBox(width: ScreenUtil().setWidth(8.5)),
                    Expanded(
                      child: Text(widget.data["sub_title"] ?? "loading",
                          style: GQStyle.gray168_12),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(8.5)),
                  ],
                )),
                widget.data["more_button"] == 0
                    ? Container()
                    : GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          context.push(
                              '/more_and_more_collect/${_values.first["id"] ?? "0"}/1');
                        },
                        child: Row(
                          children: [
                            Text(CommonUtils.txt("gd"),
                                style: GQStyle.gray205_14),
                            SizedBox(width: ScreenUtil().setWidth(7)),
                            LImage("more_arrow_n",
                                width: ScreenUtil().setWidth(6),
                                height: ScreenUtil().setWidth(12))
                          ],
                        ),
                      )
              ]),
        ),
        SizedBox(height: ScreenUtil().setWidth(11.5)),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          shrinkWrap: true,
          crossAxisCount: 1,
          mainAxisSpacing: 20,
          crossAxisSpacing: 0,
          childAspectRatio: 497 / 440,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: _values
              .map((e) => Stack(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(22),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil().setWidth(22)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color.fromRGBO(25, 25, 25, 1.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: ScreenUtil().setWidth(122)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: ScreenUtil().setWidth(12)),
                                    SizedBox(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(20),
                                        child: Text(e["title"] ?? "loading",
                                            style: GQStyle.white232_16,
                                            maxLines: 1)),
                                    SizedBox(height: ScreenUtil().setWidth(9)),
                                    SizedBox(
                                        width: ScreenUtil().setWidth(200),
                                        height: ScreenUtil().setWidth(15),
                                        child: Text(e["sub_title"] ?? "loading",
                                            style: GQStyle.white232_12,
                                            maxLines: 1)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: (e["value"] as List<dynamic>)
                                      .asMap()
                                      .keys
                                      .map((index) {
                                    List list = e["value"] as List<dynamic>;
                                    dynamic x = list[index];
                                    return Row(
                                      children: [
                                        SizedBox(
                                            width: ScreenUtil().setWidth(6)),
                                        SizedBox(
                                          width: _w,
                                          child: GestureDetector(
                                            onTap: () {
                                              context.push(
                                                  CommonUtils.getRealHash(
                                                      'videoDetail/${x["id"]}'));
                                            },
                                            child: Stack(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: _w / 157 * 91,
                                                      child:
                                                          PlatformAwareNetworkImage(
                                                        url: clipImageUrl(
                                                            CommonUtils
                                                                .getThumb(x),
                                                            inputWidth:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        157)),
                                                        borderRadius: index == 0
                                                            ? BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        5),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        5))
                                                            : index ==
                                                                    list.length -
                                                                        1
                                                                ? BorderRadius.only(
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5))
                                                                : BorderRadius
                                                                    .zero,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setWidth(3.5)),
                                                    Text(
                                                        x["title"] ?? "loading",
                                                        style: GQStyle
                                                            .white232_13),
                                                    SizedBox(
                                                        height: ScreenUtil()
                                                            .setWidth(1.5)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "${CommonUtils.renderFixedNumber(x["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                            style: GQStyle
                                                                .gray105_12),
                                                        Spacer(),
                                                        Text(
                                                            "${CommonUtils.getHMTime(x["duration"] ?? 0)}",
                                                            style: GQStyle
                                                                .gray105_12),
                                                        SizedBox(
                                                            width: ScreenUtil()
                                                                .setWidth(5))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Positioned(
                                                    right: 0,
                                                    top: 0,
                                                    child: CommonUtils.identiWget(
                                                        x,
                                                        topRightRaiuds: index !=
                                                                list.length - 1
                                                            ? 0
                                                            : 5))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList()
                                    ..add(
                                      Row(children: [
                                        SizedBox(
                                            width: ScreenUtil().setWidth(6))
                                      ]),
                                    ),
                                )),
                            SizedBox(height: ScreenUtil().setWidth(18.5)),
                            Center(
                              child: Container(
                                height: ScreenUtil().setWidth(26),
                                width: ScreenUtil().setWidth(235),
                                child: GestureDetector(
                                    onTap: () {
                                      context.push(
                                          '/more_and_more_collect/${e["id"] ?? "0"}/1');
                                    },
                                    child: Stack(
                                      children: [
                                        LImage("sup_n"),
                                        Center(
                                            child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(13.5)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                                                      style:
                                                          GQStyle.white255_12,
                                                    ),
                                                    // Container(
                                                    //   color: Colors.red,
                                                    //   width: 10,
                                                    //   height: 10,
                                                    // ),
                                                    Text(
                                                      e["is_pay"] == 1
                                                          ? CommonUtils.txt(
                                                              "nyyd")
                                                          : CommonUtils.txt(
                                                              "ljqq"),
                                                      style:
                                                          GQStyle.white255_13_M,
                                                    ),
                                                  ],
                                                ))),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(102),
                        height: ScreenUtil().setWidth(93),
                        child: PlatformAwareNetworkImage(
                          url: clipImageUrl(e["resource_url"],
                              inputWidth: ScreenUtil().setWidth(102)),
                          nofigure: true,
                        ),
                      )
                    ],
                  ))
              .toList(),
        ),
        SizedBox(height: ScreenUtil().setWidth(26.5)),
      ],
    );
  }
}
