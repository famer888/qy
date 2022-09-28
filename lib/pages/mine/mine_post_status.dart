import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/pages/mine/mine_post_status_child.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class MinePostStatus extends BaseWidget {
  MinePostStatus({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MinePostStatusState();
  }
}

class _MinePostStatusState extends BaseWidgetState<MinePostStatus> {
  List<String> tabs = [CommonUtils.txt("tzfb"), CommonUtils.txt("sc")];
  bool isHud = true;
  dynamic data;

  _getData() {
    userPostIncome().then((res) {
      if (res.status == 1) {
        data = res.data;
        isHud = false;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      }
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("wdtz"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : Container(
            padding: EdgeInsets.symmetric(vertical: GQStyle.pagePadding),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  padding: EdgeInsets.all(GQStyle.pagePadding),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(0, 237, 253, 0.1),
                        Color.fromRGBO(187, 233, 84, 0.1)
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(2))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("${data["day_num"] ?? 0}",
                              style: GQStyle.white255_18_M),
                          Text(CommonUtils.txt("jrdssy"),
                              style: GQStyle.gray203_11),
                          SizedBox(height: ScreenUtil().setWidth(5)),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context
                                  .push(CommonUtils.getRealHash('coinDetail'));
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(30),
                              decoration: BoxDecoration(
                                gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(2)),
                                ),
                              ),
                              child: Center(
                                child: Text(CommonUtils.txt("symx"),
                                    style: GQStyle.white255_13),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: ScreenUtil().setWidth(0.5),
                        height: ScreenUtil().setWidth(60),
                        color: Colors.white24,
                      ),
                      Column(
                        children: [
                          Text("${data["total_num"] ?? 0}",
                              style: GQStyle.white255_18_M),
                          Text(CommonUtils.txt("ljsy"),
                              style: GQStyle.gray203_11),
                          SizedBox(height: ScreenUtil().setWidth(5)),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context.push('/mineAgentToCashPage/1');
                            },
                            child: Container(
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(30),
                              decoration: BoxDecoration(
                                gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(2)),
                                ),
                              ),
                              child: Center(
                                child: Text(CommonUtils.txt("ljtx"),
                                    style: GQStyle.white255_13),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: FljSliderNav(titles: tabs, pages: [
                    MinePostStatusChild(type: "release"),
                    MinePostStatusChild(type: "favorite"),
                  ]),
                )
              ],
            ),
          );
  }
}
