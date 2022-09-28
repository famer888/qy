import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class AcgCard extends StatelessWidget {
  AcgCard(
      {Key key,
      this.data,
      this.imageRatio = 111 / 152,
      this.replace = false,
      this.hideIdentify = false,
      this.isForBuyPage = false})
      : super(key: key);
  final dynamic data;
  final double imageRatio;
  final bool replace;
  final bool hideIdentify;
  final bool isForBuyPage; // 是不是在 我的购买页面显示的
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (data['content_type'] == 2) {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}')
                    .replaceAll(RegExp(r"comicsdetail/.*"),
                        'comicsdetail/${data["id"] ?? "0"}'),
                replace: replace);
          } else if (data['content_type'] == 1 || data['content_type'] == 16) {
            context.push(
                CommonUtils.getRealHash('videoDetail/${data["id"] ?? "0"}'));
          } else if (data['content_type'] == 24) {
            context.push(CommonUtils.getRealHash(
                'videoDetail/${data["first_mvid"] ?? '0'}'));
          } else {
            context.push(
                CommonUtils.getRealHash('comicsdetail/${data["id"] ?? "0"}')
                    .replaceAll(RegExp(r"comicsdetail/.*"),
                        'comicsdetail/${data["id"] ?? "0"}'),
                replace: replace);
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
                          inputWidth: _w),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
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
                          isForBuyPage
                              ? Text(
                                  data["finished"] == 1
                                      ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${data["series"]}${CommonUtils.txt("hua")}"
                                      : "${CommonUtils.txt("gxz")}${data["series"]}${CommonUtils.txt("hua")}",
                                  style: GQStyle.gray128_11,
                                )
                              : Text(
                                  data["description"] ??
                                      data['sub_title'] ??
                                      "",
                                  style: GQStyle.graya3a2a2_11,
                                  maxLines: 1,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                left: ScreenUtil().setWidth(7.5),
                top: ScreenUtil().setWidth(7.5),
                child: Visibility(
                    visible: !hideIdentify && false,
                    child: CommonUtils.identifyWidget(data)))
          ],
        ),
      );
    });
  }
}
