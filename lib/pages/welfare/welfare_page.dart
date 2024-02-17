import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/mine/app_center.dart';
import 'package:qypj/pages/welfare/welfare_agent_page.dart';
import 'package:qypj/pages/welfare/welfare_task_page.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/pageviewmixin.dart';

class WelfarePage extends BaseWidget {
  WelfarePage({Key key}) : super(key: key);

  @override
  BaseWidgetState<WelfarePage> cState() {
    return WelfarePageState();
  }
}

class WelfarePageState extends BaseWidgetState<WelfarePage> {
  int _selectedIndex = 0;

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
        SizedBox(height: GQStyle.topHeight),
        Expanded(
          child: Stack(
            children: [
              YyqDiamondNav(
                inedxFunc: (p0) {
                  _selectedIndex = p0;
                  setState(() {});
                },
                navColor: Colors.transparent,
                type: YyqDiamondNavEnum.line,
                titles: config.show_app == 1
                    ? [
                        CommonUtils.txt('dlzq'),
                        CommonUtils.txt('flrw'),
                        CommonUtils.txt('yytj'),
                      ]
                    : [
                        CommonUtils.txt('dlzq'),
                        CommonUtils.txt('flrw'),
                      ],
                pages: config.show_app == 1
                    ? [
                        PageViewMixin(
                          child: WelfareAgentPage(),
                        ),
                        PageViewMixin(
                          child: WelfareTaskPage(),
                        ),
                        PageViewMixin(
                          child: AppCenter(),
                        ),
                      ]
                    : [
                        PageViewMixin(
                          child: WelfareAgentPage(),
                        ),
                        PageViewMixin(
                          child: WelfareTaskPage(),
                        ),
                      ],
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
                isCenter: true,
              ),
              Positioned(
                top: 12.w,
                left: GQStyle.pagePadding,
                child: GestureDetector(
                  child: LImage(
                    "nav_back_n",
                    width: ScreenUtil().setWidth(20),
                    height: ScreenUtil().setWidth(20),
                  ),
                  onTap: () {
                    finish();
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
