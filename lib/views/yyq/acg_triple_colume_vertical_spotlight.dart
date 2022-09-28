import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

/// 动漫-三列竖屏+焦点 type = 6
class AcgTripleColumeVerticalSpotlight extends StatelessWidget {
  AcgTripleColumeVerticalSpotlight({Key key, this.data}) : super(key: key);
  dynamic data;

  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;
  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          SizedBox(
            height: ScreenUtil().setWidth(50),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LImage(
                          'comic_hot',
                          width: ScreenUtil().setWidth(21),
                          scale: 1,
                        ),
                        SizedBox(width: ScreenUtil().setWidth(8.5)),
                        Text(data["title"] ?? "loading",
                            style: GQStyle.white255_18_B),
                        SizedBox(width: ScreenUtil().setWidth(8.5)),
                        Expanded(
                          child: Text(data["sub_title"] ?? "loading",
                              style: GQStyle.gray168_12),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(8.5)),
                      ],
                    )),
                    data["more_button"] == 0
                        ? Container()
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              context.push('/more_and_more_page', extra: data);
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
                                // MoreRightArrowWidget(
                                //   width: ScreenUtil().setWidth(7.5),
                                // ),
                              ],
                            ),
                          )
                  ]),
            ),
          ),
          Builder(builder: (context) {
            dynamic e = _values.first;

            double _w = (ScreenUtil().screenWidth - GQStyle.pagePadding * 2);
            return SizedBox(
              height: _w / 350 * (200 + 50),
              child: AcgCard(
                data: e,
                imageRatio: 350 / 200,
              ),
            );
          }),
          Builder(builder: (context) {
            List<dynamic> t = _values;
            t = t.sublist(1, t.length);
            double _w = (ScreenUtil().screenWidth -
                    GQStyle.pagePadding * 2 -
                    ScreenUtil().setWidth(8.5)) /
                3;
            return GridView.count(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().setWidth(5),
              crossAxisSpacing: ScreenUtil().setWidth(8.5),
              childAspectRatio: 111 / 202,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: t
                  .map((e) => AcgCard(
                        data: Map.from(e)
                          ..['content_type'] = data['content_type'],
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}
