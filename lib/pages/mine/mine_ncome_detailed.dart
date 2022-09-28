import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/mine/mine_ncome_detailed_child.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class MineNcomeDetailed extends BaseWidget {
  MineNcomeDetailed({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineNcomeDetailedState();
  }
}

class _MineNcomeDetailedState extends BaseWidgetState<MineNcomeDetailed> {
  dynamic topData;

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(
        title: CommonUtils.txt("symx"),
        navColor: Colors.transparent,
        rightW: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.push('/mineAgentToCashPage/1');
          },
          child: Container(
            padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
            height: ScreenUtil().setWidth(25),
            decoration: BoxDecoration(
                color: Color(0xFF00eefc),
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenUtil().setWidth(25 / 2)))),
            child: Center(
              child: Text(
                CommonUtils.txt("sytx"),
                style: GQStyle.black0d141f_11,
              ),
            ),
          ),
        ));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  _getData() {
    creatorIncomeTotal().then((res) {
      if (res.status == 1) {
        topData = res.data;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      }
    });
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return topData == null
        ? Container()
        : Column(
            children: [
              SizedBox(height: ScreenUtil().setWidth(10)),
              Container(
                margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(5),
                    vertical: GQStyle.pagePadding),
                decoration: BoxDecoration(
                  color: Color(0xFF23262f),
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(5))),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("${topData["today_mv_income"] ?? "0"}",
                                style: GQStyle.white255_18_M),
                            SizedBox(height: ScreenUtil().setWidth(3)),
                            Text(CommonUtils.txt("jrspsy"),
                                style: GQStyle.gray203_11)
                          ],
                        ),
                        Container(
                          height: ScreenUtil().setWidth(45),
                          width: ScreenUtil().setWidth(0.5),
                          color: Colors.white24,
                        ),
                        Column(
                          children: [
                            Text("${topData["today_post_income"] ?? "0"}",
                                style: GQStyle.white255_18_M),
                            SizedBox(height: ScreenUtil().setWidth(3)),
                            Text(CommonUtils.txt("jrdssy"),
                                style: GQStyle.gray203_11)
                          ],
                        )
                      ],
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: GQStyle.pagePadding),
                      height: ScreenUtil().setWidth(0.5),
                      color: Colors.white24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text("${topData["today_income"] ?? "0"}",
                                style: GQStyle.white255_18_M),
                            SizedBox(height: ScreenUtil().setWidth(3)),
                            Text(CommonUtils.txt("jrs"),
                                style: GQStyle.gray203_11)
                          ],
                        ),
                        Column(
                          children: [
                            Text("${topData["month_income"] ?? "0"}",
                                style: GQStyle.white255_18_M),
                            SizedBox(height: ScreenUtil().setWidth(3)),
                            Text(CommonUtils.txt("bysy"),
                                style: GQStyle.gray203_11)
                          ],
                        ),
                        Column(
                          children: [
                            Text("${topData["total_income"] ?? "0"}",
                                style: GQStyle.white255_18_M),
                            SizedBox(height: ScreenUtil().setWidth(3)),
                            Text(CommonUtils.txt("ljsy"),
                                style: GQStyle.gray203_11)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setWidth(10)),
              Expanded(
                child: YyqDiamondNav(
                  titles: [
                    CommonUtils.txt("qb"),
                    CommonUtils.txt("shp"),
                    CommonUtils.txt("das")
                  ],
                  pages: [
                    MineNcomeDetailedChild(),
                    MineNcomeDetailedChild(
                      source: "mv",
                    ),
                    MineNcomeDetailedChild(
                      source: "post",
                    )
                  ],
                  type: YyqDiamondNavEnum.line,
                  selectStyle: GQStyle.blue80_15_M,
                  defaultStyle: GQStyle.white255_15_M,
                ),
              )
            ],
          );
  }
}
