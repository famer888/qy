import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/episodes_card.dart';

/// 视频-单行横屏 type=13
class VideoSingleRow extends StatelessWidget {
  VideoSingleRow({Key key, this.data}) : super(key: key);
  dynamic data;

  double _w = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;

  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: SizedBox(
            height: ScreenUtil().setWidth(50),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(data["title"] ?? "loading",
                          style: GQStyle.white20medium),
                      SizedBox(width: ScreenUtil().setWidth(8.5)),
                      Expanded(
                        child: Text(data["sub_title"] ?? "loading",
                            style: GQStyle.graya3a2a2_11),
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
                            ],
                          ),
                        )
                ]),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          scrollDirection: Axis.horizontal,
          child: Row(
              children: _values
                  .map((e) => Row(
                        children: [
                          data['content_type'] == 24
                              ? SizedBox(
                                  width: ScreenUtil().setWidth(260),
                                  height: ScreenUtil().setWidth(151 + 42.5),
                                  child: EpisodesCard(
                                    data: e,
                                    imageRatio: 260 / 151,
                                    maxLine: 2,
                                  ))
                              : SizedBox(
                                  width: ScreenUtil().setWidth(260),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (data["content_type"] == 2) {
                                        context.push(CommonUtils.getRealHash(
                                            'comicsdetail/${e["id"] ?? "0"}'));
                                      } else if (data["content_type"] == 6) {
                                        context.push(CommonUtils.getRealHash(
                                            'atlasDetail/${e["id"] ?? "0"}'));
                                      } else {
                                        context.push(CommonUtils.getRealHash(
                                            'videoDetail/${e["id"]}'));
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              height:
                                                  ScreenUtil().setWidth(151),
                                              child: PlatformAwareNetworkImage(
                                                  url: clipImageUrl(
                                                      CommonUtils.getThumb(e),
                                                      inputWidth: ScreenUtil()
                                                          .setWidth(260)),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5))),
                                            ),
                                            Positioned.fill(
                                                child: Column(
                                              children: [
                                                Spacer(),
                                                Container(
                                                  height:
                                                      ScreenUtil().setWidth(50),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: ScreenUtil()
                                                          .setWidth(10),
                                                      vertical: ScreenUtil()
                                                          .setWidth(7.5)),
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          colors: [
                                                        Color.fromRGBO(
                                                            0, 0, 0, 0.6),
                                                        Colors.transparent,
                                                      ],
                                                          begin: Alignment
                                                              .bottomCenter,
                                                          end: Alignment
                                                              .topCenter)),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                                            style: GQStyle
                                                                .white255_11),
                                                        Spacer(),
                                                        Text(
                                                            "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                                            style: GQStyle
                                                                .white255_11),
                                                        SizedBox(
                                                            width: ScreenUtil()
                                                                .setWidth(5))
                                                      ],
                                                    ),
                                                  ),
                                                  // child: ,
                                                )
                                              ],
                                            )),
                                            Positioned(
                                                left:
                                                    ScreenUtil().setWidth(7.5),
                                                top: ScreenUtil().setWidth(7.5),
                                                child:
                                                    CommonUtils.identifyWidget(
                                                        e))
                                          ],
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(42.5),
                                          child: Center(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                e["title"] ?? "loading",
                                                style: GQStyle.white13,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(width: ScreenUtil().setWidth(10))
                        ],
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
