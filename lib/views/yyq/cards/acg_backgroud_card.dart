import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class AcgBackgroudCard extends StatelessWidget {
  AcgBackgroudCard({Key key, this.data}) : super(key: key);
  dynamic data;
  // final double imageRatio;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      // double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (data['content_type'] == 2) {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}'));
          } else if (data['content_type'] == 1 || data['content_type'] == 16) {
            context.push(
                CommonUtils.getRealHash('videoDetail/${data["id"] ?? "0"}'));
          } else if (data['content_type'] == 24) {
            context.push(CommonUtils.getRealHash(
                'videoDetail/${data["first_mvid"] ?? '0'}'));
          } else {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}'));
          }
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
              color: Color(0xff062a36),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: ScreenUtil().setWidth(130),
                    child: PlatformAwareNetworkImage(
                      url: clipImageUrl(CommonUtils.getThumb(data),
                          inputWidth: ScreenUtil().setWidth(110)),
                    ),
                  ),
                  // Positioned(
                  //     left: ScreenUtil().setWidth(7.5),
                  //     top: ScreenUtil().setWidth(7.5),
                  //     child: CommonUtils.identifyWidget(data))
                ],
              ),
              Expanded(
                child: Padding(
                  // color: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(5.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(data["title"] ?? "loading",
                              style: GQStyle.white255_14),
                        ),
                        data['content_type'] == 2
                            ? Text(
                                data["finished"] == 1
                                    ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${data["series"]}${CommonUtils.txt("hua")}"
                                    : "${CommonUtils.txt("gxz")}${data["series"]}${CommonUtils.txt("hua")}",
                                style: GQStyle.gray128_11,
                                strutStyle: StrutStyle(height: 1),
                              )
                            : Text(
                                data["tags"] != null
                                    ? data["tags"]
                                        .toString()
                                        .replaceAll(',', ' ')
                                    : '',
                                style: GQStyle.gray128_11)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
