import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/home.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class Welcome extends StatefulWidget {
  Welcome({Key key}) : super(key: key);
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Map yyads;
  int curTime = 5;
  Timer _timer;
  int currenIndex = 0;
  toHome() {
    currenIndex = 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    dynamic ads = AppGlobal.appBox.get('ads');
    if (ads != null) {
      yyads = ads;
      setState(() {});
    }
    adsCountDown();
    CommonUtils.checkline(onFailed: () {
      if (yyads == null) {
        toHome();
      }
      BotToast.showText(
          text: '无法连接服务器，请检查手机网络设置',
          textStyle: TextStyle(
              fontSize: ScreenUtil().setWidth(15), color: Colors.white),
          align: Alignment(0, 0),
          duration: new Duration(seconds: 5));
    }, onSuccess: () {
      if (yyads == null) {
        toHome();
      }
    });
  }

  void adsCountDown() {
    if (yyads == null) return;
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (curTime <= 0) {
        _timer.cancel();
      }
      curTime--;
      setState(() {});
    });
  }

  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // 点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            BotToast.showText(
                text: CommonUtils.txt('zatck'), align: Alignment(0, 0));
          } else {
            lastPopTime = DateTime.now();
            // 退出app
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
          return;
        },
        child: Scaffold(
          backgroundColor: Color.fromRGBO(0, 2, 9, 1.0),
          body: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: IndexedStack(
              index: currenIndex,
              children: [
                yyads != null
                    ? Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (yyads['url'] == '' || yyads['url'] == null)
                                return;
                              CommonUtils.launchURL(yyads['url']);
                            },
                            child: Image.memory(
                              yyads['image'],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: (kIsWeb
                                    ? 0
                                    : MediaQuery.of(context).padding.top) +
                                ScreenUtil().setWidth(10),
                            right: ScreenUtil().setWidth(15),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (curTime <= 0) {
                                  toHome();
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setWidth(5),
                                    horizontal: ScreenUtil().setWidth(15)),
                                height: ScreenUtil().setWidth(35),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(35)),
                                ),
                                child: Center(
                                  child: Text(
                                    '${curTime <= 0 ? CommonUtils.txt('adtg') : curTime}',
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: ScreenUtil().setSp(15),
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    : (kIsWeb
                        ? LImage("lanch_n",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity)
                        : Center(
                            child: Text("数据初始化中···", style: GQStyle.gray16),
                          )),
                currenIndex != 1
                    ? (kIsWeb
                        ? LImage("lanch_n",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity)
                        : Center(
                            child: Text("数据初始化中···", style: GQStyle.gray16),
                          ))
                    : Home()
              ],
            ),
          ),
        ));
  }
}
