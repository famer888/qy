/*
 * @Author: Tom
 * @Date: 2021-12-21 11:51:44
 * @LastEditTime: 2021-12-27 15:15:12
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/components/index_page.dart
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class ManhuaIndexPage extends BaseWidget {
  ManhuaIndexPage({Key key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _ManhuaIndexPageState();
  }
}

class _ManhuaIndexPageState extends BaseWidgetState<ManhuaIndexPage> {
  List<String> navitems = [];
  List<Widget> pages = [];
  bool netWorkErr = false;
  String img_url = "";
  bool isHud = true;

  void getPageData() async {
    Config c = Provider.of<HomeConfig>(context, listen: false).config;
    if (c == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }
    ElementModel data = await getFisrtTopNavConfig(nav_id: c.mh_navid);
    if (data == null) {
      netWorkErr = true;
      isHud = false;

      setState(() {});
      return;
    }

    netWorkErr = false;
    isHud = false;

    setState(() {
      navitems = data.value.asMap().keys.map<String>((x) {
        return data.value[x]["name"];
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
  void didUpdateWidget(covariant ManhuaIndexPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
      getPageData();
    }
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    // getPageData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    print('rebuild ManhuaIndexPage');

    var h = kIsWeb
        ? ScreenUtil().setWidth(15)
        : MediaQuery.of(context).padding.top +
            ScreenUtil().setWidth(5 + 30) +
            ((ScreenUtil().screenWidth - GQStyle.pagePadding * 2) / 375 * 175) +
            GQStyle.navbarHegiht;
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            isHud = true;

            setState(() {});
            getPageData();
          })
        : isHud && widget.isShow
            ? PageStatus.loading(mounted)
            : navitems.length == 0
                ? Container()
                : Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            color: Color(0xFF23262f),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                    height: kIsWeb
                                        ? ScreenUtil().setWidth(15)
                                        : MediaQuery.of(context).padding.top),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: GQStyle.pagePadding,
                                      right: GQStyle.pagePadding,
                                      top: ScreenUtil().setWidth(5)),
                                  height: ScreenUtil().setWidth(53),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: GestureDetector(
                                        onTap: () {
                                          context.push('/${Routes.search}');
                                        },
                                        child: Container(
                                          height: ScreenUtil().setWidth(30),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenUtil()
                                                          .setWidth(15)),
                                              color: Color.fromRGBO(
                                                  26, 26, 31, 1)),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(10)),
                                              LImage("search_g",
                                                  width:
                                                      ScreenUtil().setWidth(12),
                                                  height: ScreenUtil()
                                                      .setWidth(12)),
                                              SizedBox(
                                                  width:
                                                      ScreenUtil().setWidth(8)),
                                              Text(
                                                CommonUtils.txt("stzdmmhbt"),
                                                style: GQStyle.gray666666_11,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(57),
                                      ),
                                      FljSignWidget()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: YyqDiamondNav(
                              titles: navitems,
                              pages: pages,
                              navColor: GQStyle.naviColor,
                              defaultStyle: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  fontSize: ScreenUtil().setSp(18),
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                              selectStyle: TextStyle(
                                  color: Color(0xff00edfd),
                                  fontSize: ScreenUtil().setSp(18),
                                  // fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.visible,
                                  decoration: TextDecoration.none),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
  }
}
