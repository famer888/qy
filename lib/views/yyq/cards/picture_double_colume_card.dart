import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class PictureDoubleColumeCard extends StatelessWidget {
  PictureDoubleColumeCard({Key key, this.data, this.imageRatio = 171 / 231})
      : super(key: key);
  dynamic data;
  final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          context.push(
              CommonUtils.getRealHash('atlasDetail/${data["id"] ?? "0"}'));
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
                          inputWidth: ScreenUtil().setWidth(171)),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
                // SizedBox(height: ScreenUtil().setWidth(3.5)),

                Expanded(
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(data["title"] ?? "loading",
                          style: GQStyle.white255_13),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                left: ScreenUtil().setWidth(7.5),
                top: ScreenUtil().setWidth(7.5),
                child: CommonUtils.identifyWidget(data))
          ],
        ),
      );
    });
  }
}
