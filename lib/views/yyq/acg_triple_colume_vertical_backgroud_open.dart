import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_backgroud_card.dart';

/// 动漫-三列竖屏+背景+开通 type = 5
class AcgTripleColumeVerticalBackgroudOpen extends StatelessWidget {
  AcgTripleColumeVerticalBackgroudOpen({Key key, this.data}) : super(key: key);
  dynamic data;

  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;
  List<dynamic> _values;

  @override
  Widget build(BuildContext context) {
    if (data == null) return Container();
    _values = data["value"];
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().setWidth(10),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          decoration: BoxDecoration(
              // color: Color(0xff324f5b), // Color(0xff125d67),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff125d67),
                    Color(0xff324f5b),
                    // Colors.deepOrange
                  ]),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))),
          child: Stack(
            children: [
              // Positioned(top: 0, right: 0, left: 0, child: LImage('')),
              Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: ScreenUtil().setWidth(50),
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LImage(
                                "yzdz",
                                width: ScreenUtil().setWidth(20),
                                height: ScreenUtil().setWidth(20),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(6)),
                              Expanded(
                                  child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(data["title"] ?? "loading",
                                      style: GQStyle.white255_18_B),
                                  SizedBox(width: ScreenUtil().setWidth(8.5)),
                                  Expanded(
                                    child: Text(data["sub_title"] ?? "loading",
                                        style: GQStyle.gray168_12),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(8.5)),
                                ],
                              )),
                              data["more_button"] == 0
                                  ? Container()
                                  : GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        context.push('/more_and_more_page',
                                            extra: data);
                                      },
                                      child: Row(
                                        children: [
                                          Text(CommonUtils.txt("gdjc"),
                                              style: GQStyle.jellyCyan_11),
                                          LImage(
                                            'more_arrow_cyan_right',
                                            width: ScreenUtil().setWidth(17),
                                            height: ScreenUtil().setWidth(17),
                                          ),
                                          // MoreRightArrowWidget(
                                          //   width: ScreenUtil().setWidth(7.5),
                                          // ),
                                        ],
                                      ),
                                    )
                            ]),
                      ),
                    ),
                    GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: ScreenUtil().setWidth(10),
                      crossAxisSpacing: ScreenUtil().setWidth(10),
                      childAspectRatio: 100 / 175.0,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      children: _values
                          .map((e) => AcgBackgroudCard(
                              data: Map.from(e)
                                ..['content_type'] = data['content_type']))
                          .toList(),
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(91),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            context.push(CommonUtils.getRealHash('vip'));
                          },
                          child: SizedBox(
                            width: ScreenUtil().setWidth(320),
                            height: ScreenUtil().setWidth(40),
                            child: Stack(children: [
                              LImage(
                                '',
                              ),
                              Center(
                                child: Text(
                                  CommonUtils.txt('khy'),
                                  style: GQStyle.yellowffbd39_15_M,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ScreenUtil().setWidth(10),
        )
      ],
    );
  }
}
