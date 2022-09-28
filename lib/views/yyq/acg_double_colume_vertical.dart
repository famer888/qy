import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_double_colume_card.dart';

/// 动漫-两列+竖屏 type = 4
class AcgDoubleColumeVertical extends StatelessWidget {
  AcgDoubleColumeVertical({Key key, this.data}) : super(key: key);
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          // 隐藏 两排 改为一排
          // data['title'] == null
          //     ? Container()
          //     : SizedBox(
          //         height: (data["sub_title"] == null ||
          //                 data["sub_title"].length == 0)
          //             ? ScreenUtil().setWidth(50)
          //             : ScreenUtil().setWidth(60),
          //         child: Center(
          //           child: Row(
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Expanded(
          //                     child: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Row(
          //                       // mainAxisSize: MainAxisSize.min,
          //                       children: [
          //                         LImage(
          //                           'comic.star',
          //                           width: ScreenUtil().setWidth(24),
          //                           height: ScreenUtil().setWidth(20),
          //                         ),
          //                         SizedBox(width: ScreenUtil().setWidth(8.5)),
          //                         Text(data["title"] ?? "loading",
          //                             style: GQStyle.white255_18_B),
          //                         // SizedBox(width: ScreenUtil().setWidth(8.5)),
          //                         // Expanded(
          //                         //   child: Text(
          //                         //       data["sub_title"] ?? "loading",
          //                         //       style: GQStyle.gray168_12),
          //                         // ),
          //                       ],
          //                     ),
          //                     (data["sub_title"] == null ||
          //                             data["sub_title"].length == 0)
          //                         ? Container()
          //                         : Align(
          //                             alignment: Alignment.centerLeft,
          //                             child: Text(
          //                               data["sub_title"] ?? "loading",
          //                               style: GQStyle.graya3a2a2_13,
          //                             ),
          //                           )
          //                   ],
          //                 )),
          //                 SizedBox(width: ScreenUtil().setWidth(8.5)),
          //                 data["more_button"] == 0
          //                     ? Container()
          //                     : GestureDetector(
          //                         behavior: HitTestBehavior.opaque,
          //                         onTap: () {
          //                           context.push('/more_and_more_page',
          //                               extra: data);

          //                           // if (data['more_api'] ==
          //                           //     '/api/element/getElementByIdSecondPage') {
          //                           //   context.push(
          //                           //       "/more_and_more_case/${data["id"] ?? "0"}",
          //                           //       extra: data);
          //                           // } else {
          //                           //   context.push(
          //                           //       "/more_and_more_comc/${data["id"] ?? "0"}");
          //                           // }
          //                         },
          //                         child: Row(
          //                           children: [
          //                             Text(CommonUtils.txt("gdjc"),
          //                                 style: GQStyle.jellyCyan_11),
          //                             LImage(
          //                               'more_arrow_cyan_right',
          //                               width: ScreenUtil().setWidth(17),
          //                               height: ScreenUtil().setWidth(17),
          //                             ),
          //                             // MoreRightArrowWidget(
          //                             //   width: ScreenUtil().setWidth(7.5),
          //                             // ),
          //                           ],
          //                         ),
          //                       )
          //               ]),
          //         ),
          //       ),
          data['title'] == null
              ? Container(
                  // height: ScreenUtil().setWidth(20),
                  )
              : SizedBox(
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
                                'comic.star',
                                width: ScreenUtil().setWidth(24),
                                height: ScreenUtil().setWidth(20),
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
                                      // MoreRightArrowWidget(
                                      //   width: ScreenUtil().setWidth(7.5),
                                      // ),
                                    ],
                                  ),
                                )
                        ]),
                  ),
                ),
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: ScreenUtil().setWidth(5),
            crossAxisSpacing: ScreenUtil().setWidth(8),
            childAspectRatio: 171 / 281,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: _values
                .map((e) => AcgDoubleColumeCard(
                      data: Map.from(e)
                        ..['content_type'] = data['content_type'],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
