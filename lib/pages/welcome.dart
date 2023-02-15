import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/home.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  DateTime lastPopTime;
  Map adsmap = AppGlobal.appBox?.get('ads');
  String weburl = AppGlobal.appBox?.get('office_web') ?? "";
  int count = 6;
  int startIndex = 0;
  bool isCheck = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLines();
  }

  @override
  Widget build(BuildContext context) {
    AppGlobal.appContext = context;
    return WillPopScope(
        child: Scaffold(
          backgroundColor: GQStyle.bgColor,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus.unfocus();
              }
            },
            child: AppGlobal.apiBaseURL.isEmpty
                ? Center(
                    child: isCheck
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                    text: CommonUtils.txt('jcxlsd'),
                                    style: GQStyle.gray14),
                              ),
                              SizedBox(height: 20.w),
                              weburl.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {
                                        CommonUtils.launchURL(weburl);
                                      },
                                      child: Text(
                                        CommonUtils.txt('gwdzdz') + '：$weburl',
                                        style: GQStyle.red14,
                                        maxLines: 3,
                                      ),
                                    )
                                  : Container()
                            ],
                          )
                        : PageStatus.noNetWork(
                            text: CommonUtils.txt('wfljqsz'),
                            onTap: () {
                              checkLines();
                            }),
                  )
                : adsmap == null
                    ? Home()
                    : startLaunchPNG(),
          ),
        ),
        onWillPop: () async {
          //点击返回键的操作
          if (lastPopTime == null ||
              DateTime.now().difference(lastPopTime) >
                  const Duration(seconds: 2)) {
            lastPopTime = DateTime.now();
            CommonUtils.showText(CommonUtils.txt('zatck'));
            return false;
          } else {
            lastPopTime = DateTime.now();
            await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            return true;
          }
        });
  }

  //加载AD图
  Widget startLaunchPNG() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (adsmap['url'] == '' || adsmap['url'] == null) return;
            CommonUtils.launchURL(adsmap['url']);
          },
          child: Image.memory(
            adsmap['image'],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.w,
          right: 15.w,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (count > 0) return;
              adsmap = null;
              setState(() {});
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(35.w),
              ),
              child: Center(
                child: Text(
                  '${count > 0 ? count : CommonUtils.txt('adtg')}',
                  style: GQStyle.white15semibold,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void adsWatch() {
    if (adsmap == null) {
      setState(() {});
      return;
    }
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (count <= 0) {
        timer.cancel();
        return;
      }
      count--;
      setState(() {});
    });
  }

  void checkLines() {
    //检测线路
    CommonUtils.checkline(
      onFailed: () {
        isCheck = false;
        setState(() {});
      },
      onSuccess: () {
        if (startIndex == 0) {
          startIndex = 1;
          adsWatch();
        }
      },
    );
  }
}
