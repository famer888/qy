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

class IndexPage extends BaseWidget {
  IndexPage({Key key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _IndexPageState();
  }
}

class _IndexPageState extends BaseWidgetState<IndexPage> {
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
    ElementModel data = await getFisrtTopNavConfig(nav_id: c.nav_id);

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
    getPageData();

    EventBus().on('IndexNavTapItem', (arg) {
      if (arg['link_url'] != null) {
        int index = elementIDs.indexOf(arg['link_url']);
        EventBus().emit('IndexNavJump', index);
      }
      print(arg);
    });
  }

  @override
  void onDestroy() {
    EventBus().off('IndexNavTapItem');
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    print('rebuild IndexPage');

    // var h = kIsWeb
    //     ? ScreenUtil().setWidth(15)
    //     : MediaQuery.of(context).padding.top +
    //         ScreenUtil().setWidth(5 + 30) +
    //         ((ScreenUtil().screenWidth - GQStyle.pagePadding * 2) / 375 * 175) +
    //         GQStyle.navbarHegiht;
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
                      Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: kIsWeb
                                    ? ScreenUtil().setWidth(15)
                                    : MediaQuery.of(context).padding.top),
                          ],
                        ),
                      ),
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
                  // Positioned(
                  //     right: 0,
                  //     bottom: ScreenUtil().setWidth(7),
                  //     child: IndexGaoqianIcon())
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
              hideGaoqian = true;
              setState(() {});
            },
            child: LImage(
              "index_gao_gb",
              width: ScreenUtil().setWidth(16),
              height: ScreenUtil().setWidth(16),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.push("/mineAgentPage");
            },
            child: LImage(
              "index_gao_n",
              width: ScreenUtil().setWidth(73),
              height: ScreenUtil().setWidth(66),
            ),
          )
        ],
      ),
      offstage: hideGaoqian,
    );
  }
}
