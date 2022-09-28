import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/episodes_card.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card_fix.dart';

/// 视频-两列  type = 14
class VideoDoubleColume extends StatelessWidget {
  VideoDoubleColume({Key key, this.data}) : super(key: key);
  dynamic data;

  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Column(
      children: [
        data['title'] == null
            ? Container(
                height: ScreenUtil().setWidth(0),
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
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(22),
          crossAxisSpacing: ScreenUtil().setWidth(10),
          childAspectRatio: 171 / (142 + 30),
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children: _values
              .map((e) => Container(
                      // decoration: e['url'] != null
                      //     ? BoxDecoration()
                      //     : BoxDecoration(
                      //         border: Border.all(
                      //             color: Color.fromRGBO(235, 235, 235, .5))),
                      child: VideoDoubleColumeCardFix(
                    data: Map.from(e),
                    noRadius: true,
                  )))
              .toList(),
        ),
      ],
    );
  }
}
