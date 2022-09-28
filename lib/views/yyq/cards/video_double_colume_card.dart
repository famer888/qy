import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';

import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';

class VideoDoubleColumeCard extends StatelessWidget {
  VideoDoubleColumeCard(
      {Key key,
      this.data,
      this.imageRatio = 171 / 96,
      this.replace = false,
      this.maxLine = 1})
      : super(key: key);
  dynamic data;
  final double imageRatio;
  final bool replace;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    if (data['url'] != null) {
      return AdDoubleColumeCard(data: Map.from(data));
    }
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (replace) {
            context.push(
                CommonUtils.getRealHash().replaceAll(
                    RegExp(r"videoDetail/.*"), 'videoDetail/${data["id"]}'),
                replace: true);
          } else {
            context.push(CommonUtils.getRealHash('videoDetail/${data["id"]}'));
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: _w / imageRatio,
                  child: PlatformAwareNetworkImage(
                      url: clipImageUrl(CommonUtils.getThumb(data),
                          inputWidth: ScreenUtil().setWidth(173)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Positioned.fill(
                    child: Column(
                  children: [
                    Spacer(),
                    Container(
                      height: ScreenUtil().setWidth(40),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10),
                          vertical: ScreenUtil().setWidth(7.5)),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Color.fromRGBO(0, 0, 0, 0.6),
                            Colors.transparent,
                          ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter)),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.renderFixedNumber(data["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                style: GQStyle.white255_11),
                            Spacer(),
                            Text(
                                "${CommonUtils.getHMTime(data["duration"] ?? 0)}",
                                style: GQStyle.white255_11),
                            SizedBox(width: ScreenUtil().setWidth(5))
                          ],
                        ),
                      ),
                      // child: ,
                    )
                  ],
                )),
                // Positioned(
                //     left: ScreenUtil().setWidth(7.5),
                //     top: ScreenUtil().setWidth(7.5),
                //     child: CommonUtils.identifyWidget(data))
              ],
            ),
            // SizedBox(height: ScreenUtil().setWidth(10)),
            Expanded(
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          data["title"] ?? "",
                          style: GQStyle.white13,
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        (data['created_at'] != null
                                ? RelativeDateFormat.format(DateTime.parse(
                                        data["created_at"] ?? "")) +
                                    ' / '
                                : '') +
                            CommonUtils.txt('pl') +
                            '${data['count_comment']}',
                        style: GQStyle.graya3a2a2_11,
                      ),
                      // Text(
                      //   '2小时前更新/评论2',
                      //   // data["description"] ?? data['sub_title'] ?? "4567890-",
                      //   style: GQStyle.graya3a2a2_11,
                      //   maxLines: 1,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
