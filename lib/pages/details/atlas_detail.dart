import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'dart:ui' as ui;

class AtlasDetail extends StatefulWidget {
  AtlasDetail({Key key, this.id}) : super(key: key);
  final dynamic id;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AtlasDetailState();
  }
}

class _AtlasDetailState extends State<AtlasDetail> {
  Map picDetail;
  List picList;
  bool isLike = false;
  int currentIndex = 0;
  PageController _controller;
  List<TransformationController> transformationControllerList = [];
  bool _scroolEnabled = true;
  List<GlobalKey> keyList = [];
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    getPicDetail(id: widget.id).then((res) {
      CommonUtils.debugPrint(res);
      if (res['status'] != 0) {
        picList = res['data']['resources'];
        picDetail = res['data'];
        isLike = res['data']['userFavorites'] == 1;
        picList.forEach((item) {
          GlobalKey _key = GlobalKey();
          TransformationController transformationController =
              TransformationController();
          transformationControllerList.add(transformationController);
          keyList.add(_key);
        });
        _controller = PageController(initialPage: 0);
        setState(() {});
      } else {
        CommonUtils.showText(res['msg']);
        context.pop();
      }
    });
  }

  Widget _viewQXWidget() {
    if (picDetail["is_free"] == 2) {
      if (picDetail["is_pay"] == 1) {
        return Container();
      } else {
        return Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black26,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${picDetail["view_money"]}${CommonUtils.txt("jbjs")}",
                      style: GQStyle.white255_14_M_V,
                    ),
                    SizedBox(height: ScreenUtil().setWidth(18)),
                    SizedBox(
                      height: ScreenUtil().setWidth(32),
                      width: ScreenUtil().setWidth(120),
                      child: GestureDetector(
                        onTap: () {
                          photoBy(id: picDetail["id"].toString()).then((res) {
                            if (res.status == 1) {
                              picDetail["is_pay"] = 1;
                              setState(() {});
                            } else {
                              CommonUtils.showText(res.msg);
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xFF006077),
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(16))),
                          child: Center(
                            child: Text(
                              CommonUtils.txt("ljzf"),
                              style: GQStyle.white255_14_M_V,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
      }
    } else if (picDetail["is_free"] == 0 || AppGlobal.vipLevel > 0) {
      return Container();
    } else {
      return Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black26,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CommonUtils.txt("kthyjsmt"),
                    style: GQStyle.white255_14_M_V,
                  ),
                  SizedBox(height: ScreenUtil().setWidth(18)),
                  SizedBox(
                    height: ScreenUtil().setWidth(32),
                    width: ScreenUtil().setWidth(120),
                    child: GestureDetector(
                      onTap: () {
                        context.push('/${Routes.vip}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(16))),
                        child: Center(
                          child: RichText(
                              text: TextSpan(
                            text: CommonUtils.txt("ljkt"),
                            style: GQStyle.white255_14_M_V,
                          )),
                          //  Text(
                          //   CommonUtils.txt("ljkt"),
                          //   style: GQStyle.white255_14_M_V,
                          // ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GQStyle.bgColor,
      child: picDetail == null
          ? PageStatus.loading(mounted)
          : Stack(
              children: [
                PageView(
                    controller: _controller,
                    physics: _scroolEnabled
                        ? PageScrollPhysics()
                        : NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: true,
                    onPageChanged: (e) {
                      currentIndex = e;
                      setState(() {});
                    },
                    children: picList
                        .asMap()
                        .keys
                        .map<Widget>((e) => new InteractiveViewer(
                            transformationController:
                                transformationControllerList[e],
                            minScale: 0.3,
                            maxScale: 10,
                            onInteractionStart: (scale) {
                              _scroolEnabled = false;
                              setState(() {});
                            },
                            onInteractionEnd: (scale) {
                              if (transformationControllerList[e]
                                      .value
                                      .getMaxScaleOnAxis() ==
                                  1) {
                                _scroolEnabled = true;
                                setState(() {});
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                isShow = !isShow;
                                setState(() {});
                              },
                              child: PlatformAwareNetworkImage(
                                  background: Colors.black,
                                  key: keyList[e],
                                  noVisibilityDetector: true,
                                  fit: BoxFit.fitWidth,
                                  url: picList[e]['original_url'] ??
                                      picList[e]['url']),
                            )))
                        .toList()),
                // Swiper(
                //   itemBuilder: (BuildContext context, int index) {
                //     return GestureDetector(
                //       onTap: () {
                //         AppGlobal.currentReaderRouteExtra = {
                //           'resources': picList,
                //           'index': index
                //         };
                //         context.push(CommonUtils.getRealHash('atlasList/0'));
                //       },
                //       child: PlatformAwareNetworkImage(
                //         noVisibilityDetector: true,
                //         url: picDetail['resources'][index]['thumb_url'],
                //         fit: BoxFit.none,
                //         background: Colors.black,
                //       ),
                //     );
                //   },
                //   itemCount: picDetail['resources'].length,
                //   pagination: SwiperPagination(
                //     alignment: Alignment.lerp(
                //         Alignment.topRight, Alignment.bottomRight, 0.1),
                //     builder: SwiperCustomPagination(builder:
                //         (BuildContext context, SwiperPluginConfig config) {
                //       return Container(
                //         child: Text(
                //             (config.activeIndex + 1).toString() +
                //                 '/' +
                //                 config.itemCount.toString(),
                //             style: GQStyle.white255_14),
                //       );
                //     }),
                //   ),
                // ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: ScreenUtil().setWidth(116),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.6),
                            Color.fromRGBO(0, 0, 0, 0.0)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Container(
                      height: ScreenUtil().setWidth(300),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.7),
                            Color.fromRGBO(0, 0, 0, 0.0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: GQStyle.pagePadding,
                  right: GQStyle.pagePadding,
                  bottom: ScreenUtil().setWidth(30),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: ScreenUtil().screenWidth -
                            GQStyle.pagePadding * 2 -
                            ScreenUtil().setWidth(70),
                        child: Text(
                          picDetail['title'] ?? "loading",
                          style: GQStyle.white255_14_M_V,
                          textAlign: TextAlign.left,
                          maxLines: 3,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                collectPhoto(
                                        relatedId: picDetail["id"].toString())
                                    .then((value) {
                                  if (value.status == 1) {
                                    isLike = !isLike;
                                    setState(() {});
                                  } else {
                                    CommonUtils.showText(value.msg);
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  LImage(isLike ? "tu_like_n" : "tu_unlike_n",
                                      width: ScreenUtil().setWidth(25),
                                      height: ScreenUtil().setWidth(25)),
                                  Text(
                                    CommonUtils.txt("sc"),
                                    style: GQStyle.white255_14_M_V,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(30)),
                            GestureDetector(
                              onTap: () {
                                context.push(CommonUtils.getRealHash(
                                    'kwantsharetousers'));
                              },
                              child: Column(
                                children: [
                                  LImage("tu_share_n",
                                      width: ScreenUtil().setWidth(25),
                                      height: ScreenUtil().setWidth(25)),
                                  Text(
                                    CommonUtils.txt("fx"),
                                    style: GQStyle.white255_14_M_V,
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(45)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Stack(
                  children: [
                    Center(
                      child: transitionWidget(
                          height: ScreenUtil().setWidth(75),
                          left: isShow
                              ? ScreenUtil().setWidth(5)
                              : ScreenUtil().setWidth(-50),
                          opacity: isShow ? 1 : 0,
                          child: comicButton(
                              type: 'left',
                              onTap: () {
                                if (currentIndex == 0) {
                                  CommonUtils.showText(CommonUtils.txt("dyzl"));
                                  return;
                                }
                                transformationControllerList[currentIndex]
                                    .value = Matrix4.identity()..scale(1.0);
                                _controller.animateToPage(currentIndex - 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              })),
                    ),
                    Center(
                      child: transitionWidget(
                          height: ScreenUtil().setWidth(75),
                          left: isShow
                              ? ScreenUtil().screenWidth -
                                  ScreenUtil().setWidth(50)
                              : ScreenUtil().screenWidth,
                          opacity: isShow ? 1 : 0,
                          child: comicButton(
                              type: 'right',
                              onTap: () {
                                if (currentIndex == picList.length - 1) {
                                  CommonUtils.showText(
                                      CommonUtils.txt("zhyzl"));
                                  return;
                                }
                                transformationControllerList[currentIndex]
                                    .value = Matrix4.identity()..scale(1.0);
                                _controller.animateToPage(currentIndex + 1,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              })),
                    ),
                  ],
                )),
                _viewQXWidget(),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  child: PageTitleBar(
                      title: "${currentIndex + 1}/${picList.length}"),
                )
              ],
            ),
    );
  }

  Widget transitionWidget(
      {int time = 200,
      double height,
      double opacity,
      double width,
      Widget child,
      double left,
      double right,
      double bottom,
      double top}) {
    return Container(
      height: height,
      width: width,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Container(),
          AnimatedPositioned(
              right: right,
              left: left,
              bottom: bottom,
              top: top,
              child: AnimatedOpacity(
                opacity: opacity,
                duration: Duration(milliseconds: time),
                child: child,
              ),
              duration: Duration(milliseconds: time))
        ],
      ),
    );
  }
}

class YyTap extends StatefulWidget {
  YyTap({Key key, this.text}) : super(key: key);
  String text;
  @override
  _YyTapState createState() => _YyTapState();
}

class _YyTapState extends State<YyTap> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8.5)),
          height: ScreenUtil().setWidth(14),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFff4d0b),
                  Color(0xFFfa7c61),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(7))),
          child: Center(
            child: Text(
              '#${widget.text}',
              style: GQStyle.white255_10,
            ),
          ),
        )
      ],
    );
  }
}

Widget comicButton({String type, Function onTap}) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      if (onTap != null) {
        onTap();
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7.5)),
      width: ScreenUtil().setWidth(45),
      height: ScreenUtil().setWidth(75),
      decoration: BoxDecoration(
          color: Color.fromRGBO(0, 0, 0, 0.7),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                  type == 'left' ? ScreenUtil().setWidth(37.5) : 10),
              topRight: Radius.circular(
                  type == 'left' ? 10 : ScreenUtil().setWidth(37.5)),
              bottomLeft: Radius.circular(
                  type == 'left' ? ScreenUtil().setWidth(37.5) : 10),
              bottomRight: Radius.circular(
                  type == 'left' ? 10 : ScreenUtil().setWidth(37.5)))),
      child: Row(
        textDirection: type == 'left' ? TextDirection.ltr : TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LImage(type == 'left' ? 'pre_left_n' : 'pre_right_n',
              width: ScreenUtil().setWidth(12.5),
              height: ScreenUtil().setWidth(16),
              fit: BoxFit.contain),
          DefaultTextStyle(
              style: TextStyle(
                  color: Colors.white, fontSize: ScreenUtil().setSp(12)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(type == 'left'
                      ? CommonUtils.txt("syz")
                      : CommonUtils.txt("xyz")),
                ],
              ))
        ],
      ),
    ),
  );
}
