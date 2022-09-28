import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';

import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class EpisodesCard extends StatelessWidget {
  EpisodesCard(
      {Key key, this.data, this.imageRatio = 171 / 96, this.maxLine = 1})
      : super(key: key);
  dynamic data;
  final double imageRatio;
  final int maxLine;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          context.push(CommonUtils.getRealHash(
              'videoDetail/${data["first_mvid"] ?? '0'}'));
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
                                CommonUtils.txt('go') +
                                    '${data["mv_count"]}' +
                                    CommonUtils.txt('hua'),
                                style: GQStyle.white255_11),
                            Spacer(),

                            Text(
                                (data['finished'] == 1
                                    ? CommonUtils.txt("ywj")
                                    : CommonUtils.txt("lz")),
                                // '·' +
                                // '${CommonUtils.txt("gxz")}${data["mv_count"]}${CommonUtils.txt("hua")}',
                                style: GQStyle.white255_11),

                            // Text(
                            //     "${CommonUtils.renderFixedNumber(data["likes_count"] ?? 0)}喜欢", //${CommonUtils.txt("xh")}",
                            //     style: GQStyle.white255_11),

                            // Text(
                            //     "${CommonUtils.getHMTime(data["duration"] ?? 0)}",
                            //     style: GQStyle.white255_11),
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
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data["title"] ?? "loading",
                    style: GQStyle.white255_13,
                    maxLines: maxLine,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
