import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/pages/mine/app_center.dart';
import 'package:qypj/pages/welfare/welfare_agent_page.dart';
import 'package:qypj/pages/welfare/welfare_task_page.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class WelfarePage extends BaseWidget {
  WelfarePage({Key key, this.isShow}) : super(key: key);
  final bool isShow;

  @override
  BaseWidgetState<WelfarePage> cState() {
    return WelfarePageState();
  }
}

class WelfarePageState extends BaseWidgetState<WelfarePage> {
  int _selectedIndex = 0;
  final GlobalKey<GenCustomNavState> _gennavKey =
      new GlobalKey<GenCustomNavState>();

  @override
  void onCreate() {}

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget appbar() {
    return Container();
  }

  void changeIndex(int index) {
    _gennavKey.currentState.onTabPageChange(index, isOnTab: true);
  }

  // @override
  // Widget backGroundView() {
  //   // TODO: implement backGroundView
  //   return _selectedIndex == 0
  //       ? LImage(
  //           'dl_vip_bg',
  //           width: ScreenUtil().screenWidth,
  //           height: ScreenUtil().screenWidth / 377 * 250,
  //         )
  //       : LImage(
  //           'dl_vip_bg_two',
  //           width: ScreenUtil().screenWidth,
  //           height: ScreenUtil().screenWidth / 376 * 346,
  //         );
  // }

  @override
  Widget pageBody(BuildContext context) {
    Config config = Provider.of<HomeConfig>(context, listen: false).config;
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Expanded(
          child: Stack(
            children: [
              GenCustomNav(
                key: _gennavKey,
                inedxFunc: (p0) {
                  _selectedIndex = p0;
                  setState(() {});
                },
                titles: config.show_app == 1
                    ? [
                        CommonUtils.txt('flrw'),
                        CommonUtils.txt('dlzq'),
                        CommonUtils.txt('yytj'),
                      ]
                    : [
                        CommonUtils.txt('flrw'),
                        CommonUtils.txt('dlzq'),
                      ],
                pages: config.show_app == 1
                    ? [
                        PageViewMixin(
                          child: WelfareTaskPage(
                            isShow: widget.isShow,
                          ),
                        ),
                        PageViewMixin(
                          child: WelfareAgentPage(),
                        ),
                        PageViewMixin(
                          child: AppCenter(),
                        ),
                      ]
                    : [
                        PageViewMixin(
                          child: WelfareTaskPage(
                            isShow: widget.isShow,
                          ),
                        ),
                        PageViewMixin(
                          child: WelfareAgentPage(),
                        ),
                      ],
                defaultStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontSize: ScreenUtil().setSp(18),
                    overflow: TextOverflow.visible,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
                selectStyle: TextStyle(
                    color: Color.fromRGBO(232, 197, 174, 1),
                    fontSize: ScreenUtil().setSp(18),
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.visible,
                    decoration: TextDecoration.none),
                isCenter: true,
              ),
              // Positioned(
              //     child: Container(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: GQStyle.pagePadding,
              //   ),
              //   // color: Colors.deepOrange,
              //   height: GQStyle.navbarHegiht,
              //   child: Row(
              //     children: [
              //       Expanded(child: Container()),
              //       _selectedIndex == 0
              //           ? GestureDetector(
              //               onTap: () {
              //                 context.push('/RechargeRecord/1');
              //               },
              //               child: Text(
              //                 CommonUtils.txt('czjl'),
              //                 style: GQStyle.gray150_14,
              //               ),
              //             )
              //           : GestureDetector(
              //               onTap: () {
              //                 String path =
              //                     '/${Routes.mineAgentProfitListPage}';
              //                 context.push(path);
              //                 // context
              //                 //     .push('/${Routes.mineAgentProfitListPage}');
              //               },
              //               child: Text(
              //                 CommonUtils.txt('symx'),
              //                 style: GQStyle.gray150_14,
              //               ),
              //             )
              //     ],
              //   ),
              // )),
            ],
          ),
        )
      ],
    );
  }
}
