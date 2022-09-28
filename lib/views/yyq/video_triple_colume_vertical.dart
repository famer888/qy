import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/episodes_card.dart';

/// 视频-三列竖屏 type = 17
class VideoTripleColumeVertical extends StatelessWidget {
  VideoTripleColumeVertical({Key key, this.data}) : super(key: key);
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
          data['title'] == null
              ? Container(
                  // height: ScreenUtil().setWidth(10),
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
            crossAxisCount: 3,
            mainAxisSpacing: ScreenUtil().setWidth(0),
            crossAxisSpacing: ScreenUtil().setWidth(8.5),
            childAspectRatio: 111 / 200,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            children: _values
                .map((e) => data['content_type'] == 24
                    ? EpisodesCard(
                        data: e,
                        imageRatio: 111 / 152,
                        maxLine: 2,
                      )
                    : GestureDetector(
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
                          } else {
                            context.push(CommonUtils.getRealHash(
                                'videoDetail/${e["id"]}'));

                            // context.push(CommonUtils.getRealHash(
                            //     'topicsmallvideodetail/${e["id"]}'));
                          }
                        },
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: _w / 111 * 152,
                                  child: PlatformAwareNetworkImage(
                                      url: clipImageUrl(CommonUtils.getThumb(e),
                                          inputWidth:
                                              ScreenUtil().setWidth(128)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                ),
                                SizedBox(
                                  height: ScreenUtil().setWidth(42.5),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e["title"] ?? "loading",
                                      style: GQStyle.white13,
                                      maxLines: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                                left: ScreenUtil().setWidth(7.5),
                                top: ScreenUtil().setWidth(7.5),
                                child: CommonUtils.identifyWidget(e,
                                    isHideCoin: data["content_type"] == 2 ||
                                        data["content_type"] == 6))
                          ],
                        ),
                      ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
