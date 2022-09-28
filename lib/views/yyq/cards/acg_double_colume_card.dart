import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

// 这个有连载的标识
class AcgDoubleColumeCard extends StatelessWidget {
  AcgDoubleColumeCard({Key key, this.data, this.imageRatio = 171 / 231})
      : super(key: key);
  dynamic data;
  final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (data['content_type'] == 2) {
            // 漫画
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}'));
          } else if (data['content_type'] == 1 || data['content_type'] == 16) {
            context.push(
                CommonUtils.getRealHash('videoDetail/${data["id"] ?? "0"}'));
          } else if (data['content_type'] == 24) {
            // 番剧
            context.push(CommonUtils.getRealHash(
                'videoDetail/${data["first_mvid"] ?? '0'}'));
          } else {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}'));
          }
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _w / imageRatio,
                  child: PlatformAwareNetworkImage(
                      url: clipImageUrl(CommonUtils.getThumb(data),
                          inputWidth: ScreenUtil().setWidth(128)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   height: ScreenUtil().setWidth(15),
                          //   child: ListView(
                          //     // shrinkWrap: true,
                          //     physics: NeverScrollableScrollPhysics(),
                          //     scrollDirection: Axis.horizontal,
                          //     children: List.from(data['tag_list'])
                          //         .map(
                          //           (e) => StatusStrokBorderText(
                          //             title: '$e',
                          //           ),
                          //         )
                          //         .toList()
                          //         .map((e) {
                          //       Widget w = Padding(
                          //         padding: EdgeInsets.only(
                          //           right: ScreenUtil().setWidth(10),
                          //         ),
                          //         child: e,
                          //       );
                          //       return w;
                          //     }).toList()
                          //       ..add(
                          //         Text(
                          //           data["title"] ?? "loading",
                          //           style: GQStyle.white13,
                          //         ),
                          //       ),
                          //   ),
                          // ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              data['content_type'] != 2
                                  ? Container()
                                  : SizedBox(
                                      height: ScreenUtil().setWidth(15),
                                      child: ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: List.from(data['tag_list'])
                                            .map(
                                              (e) => StatusStrokBorderText(
                                                title: '$e',
                                              ),
                                            )
                                            .toList()
                                            .map((e) => Padding(
                                                  padding: EdgeInsets.only(
                                                    right: ScreenUtil()
                                                        .setWidth(10),
                                                  ),
                                                  child: e,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                              Expanded(
                                child: Text(
                                  data["title"] ?? "",
                                  style: GQStyle.white13,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            data["description"] ?? data['sub_title'] ?? "",
                            style: GQStyle.graya3a2a2_11,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Positioned(
            //     left: ScreenUtil().setWidth(7.5),
            //     top: ScreenUtil().setWidth(7.5),
            //     child: CommonUtils.identifyWidget(data))
          ],
        ),
      );
    });
  }
}
