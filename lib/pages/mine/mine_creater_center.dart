import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/pages/mine/mine_creater_center_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class MineCreaterCenter extends BaseWidget {
  MineCreaterCenter({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterCenterState();
  }
}

class _MineCreaterCenterState extends BaseWidgetState<MineCreaterCenter> {
  PageController _pageController = PageController();
  List<String> labels = [
    CommonUtils.txt("ysh"),
    CommonUtils.txt("dsh"),
    CommonUtils.txt("shsb")
  ];
  dynamic data;

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("czzx"), navColor: Colors.transparent);
    _getData();
  }

  _getData() {
    creatorIncomeTotal().then((res) {
      if (res.status == 1) {
        data = res.data;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return data == null
        ? Container()
        : NestedScrollView(
            headerSliverBuilder: (context, res) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
                          decoration: BoxDecoration(
                            color: Color(0xFF23262f),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(5))),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(TextSpan(children: [
                                      WidgetSpan(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right:
                                                  ScreenUtil().setWidth(7.5)),
                                          child: LImage(
                                            "creator_zp_n",
                                            width: ScreenUtil().setWidth(20),
                                            height: ScreenUtil().setWidth(20),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: CommonUtils.txt("wdzp"),
                                          style: GQStyle.white255_18_M),
                                    ])),
                                    SizedBox(height: ScreenUtil().setWidth(15)),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                CommonUtils.renderFixedNumber(
                                                    data["content_release"] ??
                                                        0),
                                                style: GQStyle.white255_16_M),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(5)),
                                            Text(CommonUtils.txt("yfb"),
                                                style: GQStyle.gray203_11),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                                CommonUtils.renderFixedNumber(
                                                    data["content_init"] ?? 0),
                                                style: GQStyle.white255_16_M),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(5)),
                                            Text(CommonUtils.txt("dsh"),
                                                style: GQStyle.gray203_11),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(15)),
                                color: Color.fromRGBO(255, 255, 255, 0.2),
                                width: ScreenUtil().setWidth(0.5),
                                height: ScreenUtil().setWidth(80),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        context.push("/minencomedetailed");
                                      },
                                      child: Text.rich(TextSpan(children: [
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(7.5)),
                                            child: LImage(
                                              "creator_sy_n",
                                              width: ScreenUtil().setWidth(20),
                                              height: ScreenUtil().setWidth(20),
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                            text: CommonUtils.txt("symx"),
                                            style: GQStyle.white255_18_M),
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    ScreenUtil().setWidth(0)),
                                            child: LImage(
                                              "issue_arrow_n",
                                              width: ScreenUtil().setWidth(20),
                                              height: ScreenUtil().setWidth(20),
                                            ),
                                          ),
                                        )
                                      ])),
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(15)),
                                    Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                CommonUtils.renderFixedNumber(
                                                    data["today_income"] ?? 0),
                                                style: GQStyle.white255_16_M),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(5)),
                                            Text(CommonUtils.txt("jrs"),
                                                style: GQStyle.gray203_11),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                                CommonUtils.renderFixedNumber(
                                                    data["balance_income"] ??
                                                        0),
                                                style: GQStyle.white255_16_M),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(5)),
                                            Text(CommonUtils.txt("qbye"),
                                                style: GQStyle.gray203_11),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(15)),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.push("/minecreatercollect");
                          },
                          child: Container(
                            height: ScreenUtil().setWidth(40),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF115d68), Color(0xFF614e1b)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(4)),
                              ),
                            ),
                            child: Center(
                              child: Text(CommonUtils.txt("xjjj"),
                                  style: GQStyle.white255_13),
                            ),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(20)),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomHeaderDelegate(
                    Container(
                      color: GQStyle.bgColor,
                      child: FljSliderBar(
                        selectStyle: GQStyle.blue80_15_M,
                        defaultStyle: GQStyle.white255_15_M,
                        pageController: _pageController,
                        titles: labels,
                      ),
                    ),
                    minHeight: GQStyle.navbarHegiht,
                    maxHeight: GQStyle.navbarHegiht,
                  ),
                )
              ];
            },
            body: PageView(
              controller: _pageController,
              children: [
                MineCreaterCenterStatus(status: "1"),
                MineCreaterCenterStatus(status: "0"),
                MineCreaterCenterStatus(status: "2"),
              ],
            ),
          );
  }
}
