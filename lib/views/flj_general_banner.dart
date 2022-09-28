import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class FljGeneralBanner extends StatefulWidget {
  FljGeneralBanner({
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
  _FljGeneralBannerState createState() => _FljGeneralBannerState();
}

class _FljGeneralBannerState extends State<FljGeneralBanner> {
  bool firstNoti = true;
  SwiperController bottomController = SwiperController();
  // SwiperController upperController = SwiperController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = ScreenUtil().screenWidth;
    double _height = _width / 375 * widget.height;

    double viewportFraction = 0.9;
    double scale = 0.9;

    return widget.data.length == 0 || widget.data == null
        ? Container()
        : LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
            return Container(
              height: _height,
              margin:
                  EdgeInsets.only(bottom: ScreenUtil().setWidth(widget.bottom)),
              child: Stack(
                children: [
                  Swiper(
                    controller: bottomController,
                    autoplay: false,
                    itemBuilder: (BuildContext context, int index) {
                      return PlatformAwareNetworkImage(
                        noVisibilityDetector: true,
                        url: widget.data == null
                            ? ''
                            : CommonUtils.getThumb(widget.data[index]),
                      );
                    },
                    itemCount: widget.data == null ? 1 : widget.data.length,
                  ),
                  Positioned.fill(
                    // alignment: Alignment.bottomCenter,
                    child: ClipRect(
                      clipBehavior: Clip.hardEdge,
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                          child: Container(
                            // width: 200,
                            // height: ScreenUtil().setWidth(63),
                            color: Colors.black.withAlpha((255 * 0.4).toInt()),
                          )),
                    ),
                  ),
                  Positioned.fill(
                    top: _height * (1 - viewportFraction) / 2,
                    bottom: _height * (1 - viewportFraction) / 2,
                    child: Swiper(
                      // controller: upperController,
                      autoplay: widget.data.length > 1,
                      onIndexChanged: (x) {
                        bottomController.move(x, animation: false);
                        _selectedIndex = x;
                        setState(() {});
                        // if (!kIsWeb && widget.needNoti) {
                        //   EventBus().emit("INDEX-TOP-BGIMG",
                        //       {"img_url": CommonUtils.getThumb(widget.data[x])});
                        // }
                      },
                      // layout: SwiperLayout.CUSTOM,
                      // customLayoutOption: CustomLayoutOption(
                      //         startIndex: 0, stateCount: widget.data.length)
                      //     .addScale([2, 1, 3], Alignment.bottomCenter),
                      viewportFraction: viewportFraction,
                      scale: scale,
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
                                AppGlobal.webExtra = {
                                  "url": pramas.values.first
                                };
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
                                    pramas[stringText[0]] =
                                        stringText.length > 1
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
                            } else if (widget.data[index]['redirect_type'] ==
                                2) {
                              CommonUtils.launchURL(
                                  widget.data[index]['link_url'].trim());
                            }
                          },
                          child: PlatformAwareNetworkImage(
                            noVisibilityDetector: true,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(widget.radius)),
                            url: widget.data == null
                                ? ''
                                : CommonUtils.getThumb(widget.data[index]),
                          ),
                        );
                      },
                      itemCount: widget.data == null ? 1 : widget.data.length,
                      // pagination: SwiperPagination(builder:
                      //     SwiperCustomPagination(builder: (context, config) {
                      //   int count = widget.data.length;
                      //   return Container(
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: List.generate(count, (index) {
                      //         return config.activeIndex == index
                      //             ? Container(
                      //                 width: ScreenUtil().setWidth(10),
                      //                 height: ScreenUtil().setWidth(5),
                      //                 margin: EdgeInsets.only(
                      //                     right: ScreenUtil().setWidth(5)),
                      //                 color: Color(0xFFF04B3E),
                      //               )
                      //             : Container(
                      //                 width: ScreenUtil().setWidth(10),
                      //                 height: ScreenUtil().setWidth(5),
                      //                 margin: EdgeInsets.only(
                      //                     right: ScreenUtil().setWidth(5)),
                      //                 color: Color(0xFFFFFFFF),
                      //               );
                      //       }),
                      //     ),
                      //   );
                      // })),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: 0,
                      child: ClipPath(
                        clipBehavior: Clip.hardEdge,
                        clipper: PaginationClipper(),
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                          // width: ScreenUtil().setWidth(130),
                          height: ScreenUtil().setWidth(19),
                          color: Color.fromRGBO(26, 26, 31, 1),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(44)),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  widget.data.length,
                                  (index) {
                                    var container = Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(2)),
                                        child: ClipPath(
                                            clipper: PaginationSubItemClipper(),
                                            child: Container(
                                              width: ScreenUtil().setWidth(10),
                                              height: ScreenUtil().setWidth(10),
                                              color: _selectedIndex == index
                                                  ? GQStyle.cyanColor00edfd
                                                  : Color(0xff61656c),
                                            )));
                                    return container;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: ClipPath(
                        clipBehavior: Clip.hardEdge,
                        clipper: BannerTopClipper(),
                        child: Container(
                          padding:
                              EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                          height: ScreenUtil().setWidth(19),
                          color: widget.data.first['for_cartoon_discover'] !=
                                      null &&
                                  widget.data.first['for_cartoon_discover'] ==
                                      true
                              ? GQStyle.bgColor
                              : GQStyle.naviColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(44)),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  widget.data.length,
                                  (index) {
                                    var container = Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: ScreenUtil().setWidth(2)),
                                    );
                                    return container;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            );
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bottomController.dispose();
    super.dispose();
  }
}

class PaginationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double margin = ScreenUtil().setWidth(10);
    path.moveTo(margin, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(margin, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class BannerTopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double margin = ScreenUtil().setWidth(10);
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width - margin, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class PaginationSubItemClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double margin = size.width / 2;
    path.moveTo(margin, 0);
    path.lineTo(size.width, 0);
    path.lineTo(margin, size.height);
    path.lineTo(0, size.height);
    path.lineTo(margin, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
