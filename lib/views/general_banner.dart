import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/global.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';

class GeneralBanner extends StatefulWidget {
  GeneralBanner({
    Key key,
    this.height = 3,
    this.data,
    this.radius = 0.0,
    this.bottom = 20,
    this.pad = 13.0,
    this.needNoti = false,
  }) : super(key: key);
  final int height;
  final dynamic data;
  final double radius;
  final double bottom;
  final double pad;
  final bool needNoti;
  @override
  _GeneralBannerState createState() => _GeneralBannerState();
}

class _GeneralBannerState extends State<GeneralBanner> {
  bool firstNoti = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width =
        ScreenUtil().screenWidth - ScreenUtil().setWidth(widget.pad) * 2;
    double _height = _width / 350 * widget.height;

    return widget.data.length == 0 || widget.data == null
        ? Container()
        : LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
            return Container(
              clipBehavior: Clip.hardEdge,
              height: _height,
              margin:
                  EdgeInsets.only(bottom: ScreenUtil().setWidth(widget.bottom)),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(widget.radius))),
              ),
              child: Stack(
                children: [
                  Swiper(
                    autoplay: widget.data.length > 1,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (widget.data[index]['link_url'] == null ||
                              widget.data[index]['link_url'].length == 0)
                            return;
                          if (widget.data[index]['redirect_type'] == 1) {
                            String linkUrl = widget.data[index]['link_url'];
                            List urlList = linkUrl.split('??');
                            Map<String, dynamic> pramas = {};
                            if (urlList.first == "ktloadwebview") {
                              pramas["url"] =
                                  urlList.last.toString().substring(4);
                              AppGlobal.webExtra = {"url": pramas.values.first};
                              if (kIsWeb) {
                                CommonUtils.launchURL(Uri.decodeComponent(
                                    pramas.values.first.trim()));
                              } else {
                                context.push("/${urlList[0]}");
                              }
                            } else {
                              if (urlList.length > 1 && urlList.last != "") {
                                urlList[1].split("&").forEach((item) {
                                  List stringText = item.split('=');
                                  pramas[stringText[0]] = stringText.length > 1
                                      ? stringText[1]
                                      : null;
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
                          } else if (widget.data[index]['redirect_type'] == 2) {
                            CommonUtils.launchURL(
                                widget.data[index]['link_url'].trim());
                          }
                        },
                        child: PlatformAwareNetworkImage(
                            noVisibilityDetector: true,
                            url: widget.data == null
                                ? ''
                                : CommonUtils.getThumb(widget.data[index])),
                      );
                    },
                    itemCount: widget.data == null ? 1 : widget.data.length,
                    pagination: SwiperPagination(builder:
                        SwiperCustomPagination(builder: (context, config) {
                      int count = widget.data.length;
                      return Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(count, (index) {
                            return config.activeIndex == index
                                ? Container(
                                    width: ScreenUtil().setWidth(5),
                                    height: ScreenUtil().setWidth(5),
                                    margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(7)),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(2.5))),
                                    ),
                                  )
                                : Container(
                                    width: ScreenUtil().setWidth(5),
                                    height: ScreenUtil().setWidth(5),
                                    margin: EdgeInsets.only(
                                        right: ScreenUtil().setWidth(7)),
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(210, 210, 210, 1.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(2.5))),
                                    ),
                                  );
                          }),
                        ),
                      );
                    })),
                  ),
                ],
              ),
            );
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
