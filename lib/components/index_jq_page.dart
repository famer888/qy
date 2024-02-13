/*
 * @Author: Tom
 * @Date: 2021-12-21 11:51:44
 * @LastEditTime: 2021-12-27 15:15:12
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/components/index_page.dart
 */
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/updateModel.dart';
import 'package:qypj/components/widget/flj_sign_widget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:hive/hive.dart';
import 'package:qypj/views/yyq/search_element_widget.dart';
import 'package:provider/provider.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/kthe_module_layout.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/element.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'dart:ui' as ui;

class IndexJQPage extends BaseWidget {
  IndexJQPage({Key key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _IndexJQPageState();
  }
}

class _IndexJQPageState extends BaseWidgetState<IndexJQPage> {
  List<String> navitems = [];
  List<Widget> pages = [];

  List<dynamic> elements = [];
  List<String> elementIDs = [];

  bool netWorkErr = false;
  String img_url = "";

  void getPageData() async {
    Config c = Provider.of<HomeConfig>(context, listen: false).config;
    if (c == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }
    ElementModel data = await getFisrtTopNavConfig(nav_id: c.aw_id);

    if (data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }

    // {
    //   data.value.add({
    //     'name': '45678',
    //     "link_url": "2",
    //     "api": "/api/element/getConstructById",
    //     "params": {'id': 2},
    //   });
    //   data.value.add({
    //     'name': '999',
    //     "link_url": "2",
    //     "api": "/api/element/getConstructById",
    //     "params": {'id': 2},
    //   });
    // }

    elements = data.value;

    setState(() {
      navitems = data.value.asMap().keys.map<String>((x) {
        return data.value[x]["name"];
      }).toList();

      elementIDs = data.value.asMap().keys.map<String>((x) {
        return data.value[x]["link_url"];
      }).toList();
      pages = data.value.asMap().keys.map((e) {
        LinkModel _link = LinkModel.fromJson(data.value[e]);
        return KTheModuleLayout(
          id: int.parse(_link.linkUrl),
          index: e,
          linkModel: _link,
        );
      }).toList();
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    EventBus().on('IndexNavTapItem', (arg) {
      if (arg['link_url'] != null) {
        int index = elementIDs.indexOf(arg['link_url']);
        EventBus().emit('IndexNavJump', index);
      }
      print(arg);
    });
  }

  @override
  void didUpdateWidget(covariant IndexJQPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && elements.isEmpty) {
      getPageData();
    } else {}
  }

  @override
  void onDestroy() {
    EventBus().off('IndexNavTapItem');
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    List array = Provider.of<HomeConfig>(context, listen: false).config.buoy;
    List<String> vip_level_str =
        Provider.of<HomeConfig>(context, listen: false).config.vip_level_str;
    String vip_name_str =
        Provider.of<HomeConfig>(context, listen: false).config.vip_name_str;
    Member user = Provider.of<HomeConfig>(context, listen: false).member;
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            setState(() {});
            getPageData();
          })
        : navitems.length == 0
            ? Container()
            : Stack(
                children: [
                  // Container(
                  //   height: h,
                  //   child: LImage("banner_bg_n", fit: BoxFit.cover),
                  // ),
                  // Container(
                  //   height: h,
                  //   color: Color.fromRGBO(0, 0, 0, 0.8),
                  //   child: BackdropFilter(
                  //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  //     child: Container(),
                  //   ),
                  // ),
                  Column(
                    children: [
                      SizedBox(
                          height: kIsWeb
                              ? ScreenUtil().setWidth(15)
                              : MediaQuery.of(context).padding.top),
                      Container(
                          color: Colors.transparent,
                          child: const SearchElementWidget()),
                      Expanded(
                        child: YyqDiamondNav(
                          titles: navitems,
                          pages: pages,
                          navColor: Colors.transparent,
                          type: YyqDiamondNavEnum.line,
                          defaultStyle: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: ScreenUtil().setSp(18),
                              overflow: TextOverflow.visible,
                              decoration: TextDecoration.none),
                          selectStyle: TextStyle(
                              color: GQStyle.jellyCyanColor103224185,
                              fontSize: ScreenUtil().setSp(18),
                              // fontWeight: FontWeight.w500,
                              overflow: TextOverflow.visible,
                              decoration: TextDecoration.none),
                        ),
                      )
                    ],
                  ),
                  array.isNotEmpty
                      ? Positioned(
                          right: ScreenUtil().setWidth(7),
                          bottom: ScreenUtil().setWidth(7),
                          child: SizedBox(
                            width: 67.6.w,
                            height: 63.w * array.length,
                            child: ListView.builder(
                                itemCount: array.length,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (cx, index) {
                                  return IndexGaoqianIcon(data: array[index]);
                                }),
                          ),
                        )
                      : Container(),
                  vip_level_str.isNotEmpty &&
                          vip_level_str.contains(user.vip_str) == false &&
                          widget.isShow
                      ? BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.w, sigmaY: 6.w),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context.push("/vip");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: vip_name_str.split("#").map((e) {
                                  if (e.contains("卡")) {
                                    return Text(e, style: GQStyle.blue80_15);
                                  }
                                  return Text(e, style: GQStyle.white15);
                                }).toList(),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {@required double strokeWidth,
      @required double radius,
      @required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}

class IndexGaoqianIcon extends StatefulWidget {
  IndexGaoqianIcon({Key key, this.data}) : super(key: key);
  dynamic data;
  @override
  State<IndexGaoqianIcon> createState() => _IndexGaoqianIconState();
}

class _IndexGaoqianIconState extends State<IndexGaoqianIcon> {
  bool hideGaoqian = false;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              reqWelfClickCount(id: widget.data['id'])
                  .then((value) => CommonUtils.debugPrint(value.msg));
              if (widget.data['link_url'] == null ||
                  widget.data['link_url'].length == 0) return;
              if (widget.data['redirect_type'] == 1) {
                String linkUrl = widget.data['link_url'];
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
              } else if (widget.data['redirect_type'] == 2) {
                CommonUtils.launchURL(widget.data['link_url'].trim());
              }
            },
            child: SizedBox(
              width: 67.6.w,
              height: 63.w,
              child: PlatformAwareNetworkImage(
                url: CommonUtils.getThumb(widget.data),
                background: Colors.transparent,
              ),
            ),
          ),
          SizedBox(height: 10.w),
        ],
      ),
      offstage: hideGaoqian,
    );
  }
}
