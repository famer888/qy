import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/picture_double_colume_card.dart';

/// 美图-两列 type=11
class PictureDoubleColume extends StatelessWidget {
  PictureDoubleColume({Key key, this.data}) : super(key: key);
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
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(data["title"] ?? "loading",
                              style: GQStyle.white20medium),
                          SizedBox(width: ScreenUtil().setWidth(3.5)),
                          Text(data["sub_title"] ?? "loading",
                              style: GQStyle.graya3a2a2_11),
                        ],
                      ),
                      // SizedBox(width: ScreenUtil().setWidth(8.5)),
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
        SizedBox(height: ScreenUtil().setWidth(11.5)),
        GridView.count(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(10),
          childAspectRatio: 171 / 264.5,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          children:
              _values.map((e) => PictureDoubleColumeCard(data: e)).toList(),
        ),
      ],
    );
  }
}
