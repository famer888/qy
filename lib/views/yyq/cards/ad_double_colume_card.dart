import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';

import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/global.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

class AdDoubleColumeCard extends StatelessWidget {
  AdDoubleColumeCard(
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
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (data['link_url'] == null || data['link_url'].length == 0) return;
          reqAdClickCount(id: data['report_id'], type: data['report_type']);
          if (data['redirect_type'] == 1) {
            String linkUrl = data['link_url'];
            List urlList = linkUrl.split('??');
            Map<String, dynamic> pramas = {};
            if (urlList.first == "ktloadwebview") {
              pramas["url"] = urlList.last.toString().substring(4);
              AppGlobal.webExtra = {"url": pramas.values.first};
              if (kIsWeb) {
                CommonUtils.launchURL(
                    Uri.decodeComponent(pramas.values.first.trim()));
              } else {
                context.push("/${urlList[0]}");
              }
            } else {
              if (urlList.length > 1 && urlList.last != "") {
                urlList[1].split("&").forEach((item) {
                  List stringText = item.split('=');
                  pramas[stringText[0]] =
                      stringText.length > 1 ? stringText[1] : null;
                });
              }
              String pramasStrs = "";
              if (pramas.values.length > 0) {
                pramas.forEach((key, value) {
                  pramasStrs += "/${value}";
                });
              }
              context.push("/${urlList[0]}${pramasStrs}");
            }
          } else if (data['redirect_type'] == 2) {
            CommonUtils.launchURL(data['link_url'].trim());
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
                // Positioned.fill(
                //     child: Column(
                //   children: [
                //     Spacer(),
                //     Container(
                //       height: ScreenUtil().setWidth(40),
                //       padding: EdgeInsets.symmetric(
                //           horizontal: ScreenUtil().setWidth(10),
                //           vertical: ScreenUtil().setWidth(7.5)),
                //       decoration: BoxDecoration(
                //           gradient: LinearGradient(
                //               colors: [
                //             Color.fromRGBO(0, 0, 0, 0.6),
                //             Colors.transparent,
                //           ],
                //               begin: Alignment.bottomCenter,
                //               end: Alignment.topCenter)),
                //       child: Align(
                //         alignment: Alignment.bottomCenter,
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(
                //                 "${CommonUtils.renderFixedNumber(data["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
                //                 style: GQStyle.white255_11),
                //             Spacer(),
                //             Text(
                //                 "${CommonUtils.getHMTime(data["duration"] ?? 0)}",
                //                 style: GQStyle.white255_11),
                //             SizedBox(width: ScreenUtil().setWidth(5))
                //           ],
                //         ),
                //       ),
                //       // child: ,
                //     )
                //   ],
                // )),
                Positioned(
                    left: ScreenUtil().setWidth(0),
                    top: ScreenUtil().setWidth(0),
                    child: Container(
                      width: ScreenUtil().setWidth(38),
                      height: ScreenUtil().setWidth(20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(252, 231, 80, 1),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              ScreenUtil().setWidth(5),
                            ),
                            bottomRight:
                                Radius.circular(ScreenUtil().setWidth(5))),
                      ),
                      child: Center(
                          child: Text(
                        CommonUtils.txt('gg'),
                        style: GQStyle.black12_M,
                      )),
                    ))
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
                        data["description"] ?? data['sub_title'] ?? "4567890-",
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
      );
    });
  }
}
