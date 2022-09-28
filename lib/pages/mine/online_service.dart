import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

import '../../global.dart';

class OnlineService extends BaseWidget {
  OnlineService({Key key}) : super(key: key);

  @override
  _OnlineServiceState cState() => _OnlineServiceState();
}

class _OnlineServiceState extends BaseWidgetState<OnlineService> {
  Widget _questionItem(data) {
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(32.5)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['problem'], style: GQStyle.gray203_15medium),
          SizedBox(
            height: ScreenUtil().setWidth(15),
          ),
          Text(
            data['reply'],
            style: TextStyle(
                color: Color.fromRGBO(153, 153, 153, 1),
                fontSize: ScreenUtil().setSp(12),
                height: 1.7,
                fontFamily: GQStyle.hanyi),
          ),
          SizedBox(
            height: ScreenUtil().setWidth(10),
          ),
          Container(
            height: 0.5,
            color: Color.fromRGBO(21, 21, 42, 1),
          )
        ],
      ),
    );
  }

  @override
  void onCreate() {
    setAppTitle(title: CommonUtils.txt('cjwt'));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().setWidth(10),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              child: Text(CommonUtils.txt("cjwtyfk"),
                  style: GQStyle.white255_22_M)),
          // SizedBox(
          // height: ScreenUtil().setWidth(10),
          // ),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(10)),
            child: Column(
              children: AppGlobal.helpList
                  .asMap()
                  .keys
                  .map((e) => _questionItem(AppGlobal.helpList[e]))
                  .toList(),
            ),
          )),
        ],
      ),
      Positioned(
          right: ScreenUtil().setWidth(17),
          bottom: ScreenUtil().setWidth(50),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.push(CommonUtils.getRealHash('customerService'));
            },
            child: Container(
                width: ScreenUtil().setWidth(60),
                height: ScreenUtil().setWidth(60),
                child: LImage(
                  "wd_zzkf",
                  fit: BoxFit.fill,
                )),
          )),
      // Padding(
      //   padding: EdgeInsets.only(
      //     left: GQStyle.pagePadding,
      //     right: GQStyle.pagePadding,
      //     bottom: ScreenUtil().setWidth(51),
      //     top: GQStyle.pagePadding,
      //   ),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       // Container(
      //       //   width: ScreenUtil().setWidth(150.5),
      //       //   height: ScreenUtil().setWidth(35),
      //       //   decoration: BoxDecoration(
      //       //       borderRadius:
      //       //           BorderRadius.circular(ScreenUtil().setWidth(17.5)),
      //       //       gradient: LinearGradient(
      //       //           colors: [Color(0xfff36f65), Color(0xffff6a4a)],
      //       //           begin: Alignment.topLeft,
      //       //           end: Alignment.bottomRight)),
      //       //   child: Center(
      //       //     child: Text(
      //       //       '游戏客服通道',
      //       //       style: DefaultStyle.white12,
      //       //     ),
      //       //   ),
      //       // ),
      //       GestureDetector(
      //         behavior: HitTestBehavior.translucent,
      //         onTap: () {
      //           context.push(CommonUtils.getRealHash('customerService'));
      //         },
      //         child: Container(
      //             width: ScreenUtil().setWidth(60),
      //             height: ScreenUtil().setWidth(60),
      //             child: LImage(
      //               "wd_zzkf",
      //               fit: BoxFit.fill,
      //             )),
      //       )
      //     ],
      //   ),
      // )
    ]);
  }
}
