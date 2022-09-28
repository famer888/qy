import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

/// 动漫-两列+小竖屏 type = 3
class AcgDoubleColumeVerticalSmall extends StatelessWidget {
  AcgDoubleColumeVerticalSmall({Key key, this.data}) : super(key: key);
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
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: ScreenUtil().setWidth(10),
            crossAxisSpacing: ScreenUtil().setWidth(10),
            childAspectRatio: 173.5 / 90,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: _values
                .map((e) => GestureDetector(
                      onTap: () {
                        if (data["content_type"] == 2) {
                          context.push(CommonUtils.getRealHash(
                              'comicsdetail/${e["id"] ?? "0"}'));
                        } else if (data["content_type"] == 6) {
                          context.push(CommonUtils.getRealHash(
                              'atlasDetail/${e["id"] ?? "0"}'));
                        } else if (data["content_type"] == 3) {
                          context.push(CommonUtils.getRealHash(
                              'novelDetail/${e["id"] ?? "0"}'));
                        }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: ScreenUtil().setWidth(70),
                                height: ScreenUtil().setWidth(90),
                                child: PlatformAwareNetworkImage(
                                    url: clipImageUrl(CommonUtils.getThumb(e),
                                        inputWidth: ScreenUtil().setWidth(110)),
                                    borderRadius: BorderRadius.circular(
                                        ScreenUtil().setWidth(5))),
                              ),
                              Positioned(
                                  left: ScreenUtil().setWidth(7.5),
                                  top: ScreenUtil().setWidth(7.5),
                                  child: CommonUtils.identifyWidget(e,
                                      isHideCoin: data["content_type"] == 2 ||
                                          data["content_type"] == 6))
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              // color: Colors.deepOrange,
                              padding: EdgeInsets.all(
                                ScreenUtil().setWidth(9.5),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e["title"] ?? "loading",
                                      style: GQStyle.white255_14),

                                  SingleChildScrollView(
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.from(
                                              List.from(e['tag_list']).length >
                                                      2
                                                  ? List.from(e['tag_list'])
                                                      .sublist(0, 2)
                                                  : e['tag_list'])
                                          .map(
                                            (e) =>
                                                StatusStrokBorderText(title: e),
                                          )
                                          .map((e) => Padding(
                                                padding: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().setWidth(10),
                                                ),
                                                child: e,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  Container()
                                  // data["content_type"] == 6 //美图标识
                                  //     ? Container()
                                  //     : Text(
                                  //         e["finished"] == 1
                                  //             ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${e["series"]}${CommonUtils.txt("hua")}"
                                  //             : "${CommonUtils.txt("gxz")}${e["series"]}${CommonUtils.txt("hua")}",
                                  //         style: GQStyle.gray128_11,
                                  //         strutStyle:
                                  //             StrutStyle(height: 1),
                                  //       )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(10),
          )
        ],
      ),
    );
  }
}
