import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';

import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';

class AdSingleColumeCard extends StatelessWidget {
  AdSingleColumeCard(
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
      return AdDoubleColumeCard(data: Map.from(data));
    }
    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        onTap: () {
          if (data['link_url'] == null || data['link_url'].length == 0) return;
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
          child: Container(
            color: Color.fromRGBO(21, 21, 42, 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(175),
                      height: _w / imageRatio,
                      child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(data),
                              inputWidth: ScreenUtil().setWidth(175)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(8)),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data["title"] ?? "",
                            style: GQStyle.white13,
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(5),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data["description"] ?? data['sub_title'] ?? "",
                            style: GQStyle.graya3a2a2_11,
                            maxLines: 1,
                          ),
                        ),
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
