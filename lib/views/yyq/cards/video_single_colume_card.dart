import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';

import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/ad_single_colume_card.dart';

class VideoSingleColumeCard extends StatelessWidget {
  VideoSingleColumeCard(
      {Key key,
      this.data,
      this.imageRatio = 175 / 108,
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
      return AdSingleColumeCard(data: Map.from(data));
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
          child: Container(
            color: Color.fromRGBO(21, 21, 42, 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(175),
                  height: _w / imageRatio,
                  child: PlatformAwareNetworkImage(
                      url: clipImageUrl(CommonUtils.getThumb(data),
                          inputWidth: ScreenUtil().setWidth(175)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Spacer(),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data["title"] ?? "",
                            style: GQStyle.white13,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(5),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.from(
                                      List.from(data['tag_list']).length > 2
                                          ? List.from(data['tag_list'])
                                              .sublist(0, 2)
                                          : data['tag_list'])
                                  .map(
                                    (data) => Text(
                                      data,
                                      style: GQStyle.gray95_12,
                                    ),
                                  )
                                  .map((data) => Padding(
                                        padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(10),
                                        ),
                                        child: data,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.getHMTime(data["duration"] ?? 0)}",
                                style: GQStyle.gray95_12),
                            Text(
                                '观看' +
                                    "${CommonUtils.renderFixedNumber(data["count_play"] ?? 0)}"
                                        '人',
                                style: GQStyle.gray95_12),
                            // Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // Sized
              ],
            ),
          ),
        ),
      );
    });
  }
}
