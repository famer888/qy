import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/episodes_card.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card.dart';

/// 视频-两列+抢购  type = 15
class VideoDoubleColumeRob extends StatelessWidget {
  VideoDoubleColumeRob({Key key, this.data}) : super(key: key);
  dynamic data;

  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(8)) /
      2;
  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Column(
      children: [
        data['title'] == null
            ? Container(
                // height: ScreenUtil().setWidth(10),
                )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: SizedBox(
                  height: ScreenUtil().setWidth(50),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(data["title"] ?? "loading",
                            style: GQStyle.white20medium),
                        SizedBox(width: ScreenUtil().setWidth(7.5)),
                        Expanded(
                          child: Text(data["sub_title"] ?? "loading",
                              style: GQStyle.graya3a2a2_13),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(8.5)),
                        data["more_button"] == 0
                            ? Container()
                            : GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  context.push('/more_and_more_page',
                                      extra: data);
                                },
                                child: Row(
                                  children: [
                                    Text(CommonUtils.txt("gdjc"),
                                        style: GQStyle.jellyCyan_11),
                                    LImage(
                                      'more_arrow_cyan_right',
                                      width: ScreenUtil().setWidth(17),
                                      height: ScreenUtil().setWidth(17),
                                    ),
                                  ],
                                ),
                              )
                      ]),
                ),
              ),
        // SizedBox(height: ScreenUtil().setWidth(11.5)),
        Column(
          children: _values.map((e) {
            List<dynamic> t = e["value"];
            // t = t.sublist(1, t.length);

            return Column(
              children: [
                GridView.count(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: ScreenUtil().setWidth(4.5),
                  crossAxisSpacing: ScreenUtil().setWidth(8),
                  childAspectRatio: 171 / 131.5,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  children: t
                      .map((se) => e['content_type'] == 24
                          ? EpisodesCard(
                              data: se,
                            )
                          : VideoDoubleColumeCard(
                              data: Map.from(se)
                                ..addAll(
                                    {'content_type': data['content_type']})))
                      .toList(),
                ),
                SizedBox(height: ScreenUtil().setWidth(8.5)),
                Center(
                    child: SizedBox(
                  height: ScreenUtil().setWidth(33),
                  width: ScreenUtil().setWidth(320),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .push('/more_and_more_collect/${e["id"] ?? "0"}/1');
                    },
                    child: Stack(
                      children: [
                        LImage(
                          "unlock_bg",
                        ),
                        Positioned(
                          // top: ScreenUtil().setWidth(11),
                          left: ScreenUtil().setWidth(32),
                          child: Container(
                            height: ScreenUtil().setWidth(33),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${e["price"] ?? 0}${CommonUtils.txt("jbjs")}${e["total_num"]}${CommonUtils.txt("byp")}",
                              style: GQStyle.yellowffbd39_15_M,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: SizedBox(
                            width: ScreenUtil().setWidth(110),
                            height: ScreenUtil().setWidth(33),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(4)),
                              child: Stack(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      // color: Colors.red,
                                      child: LImage(
                                        'video_unlock_btn',
                                        fit: BoxFit.fill,
                                      )),
                                  Center(
                                      child: Text(
                                    CommonUtils.txt('llqg'),
                                    style: GQStyle.white255_13_M,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
                SizedBox(height: ScreenUtil().setWidth(15))
              ],
            );
          }).toList(),
        ),
        SizedBox(height: _values.length == 0 ? ScreenUtil().setWidth(10) : 0)
      ],
    );
  }
}

class RobBuyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = size.height / 2.0;

    double leftMargin = size.width / 6;

    Path path = Path();
    path.moveTo(leftMargin, 0);

    path.lineTo(size.width - radius, 0);

    path.arcToPoint(Offset(size.width - radius, size.height),
        radius: Radius.circular(radius), clockwise: true);

    path.lineTo(0, size.height);
    path.lineTo(leftMargin, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
