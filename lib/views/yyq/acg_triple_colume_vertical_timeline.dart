import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/widget/more_right_arrow_widget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

/// 动漫-三列竖屏-时间轴 type = 8
class AcgTripleColumeVerticalTimeline extends StatefulWidget {
  AcgTripleColumeVerticalTimeline({Key key, this.data}) : super(key: key);
  dynamic data;

  @override
  State<AcgTripleColumeVerticalTimeline> createState() =>
      _ThreeColVerticalTimelineState();
}

class _ThreeColVerticalTimelineState
    extends State<AcgTripleColumeVerticalTimeline> {
  double _w = (ScreenUtil().screenWidth -
          GQStyle.pagePadding * 2 -
          ScreenUtil().setWidth(20)) /
      3;

  List<dynamic> _values;

  int todayIndex;
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;

  void _onTabPageChange(index, {bool isOnTab = false}) {
    _selectIndex = index;
    if (!isOnTab) {
      setState(() {});
    } else {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.linear);
      //等待滑动解锁
      Future.delayed(Duration(milliseconds: 200), () {
        _isOnTab = false;
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.data == null) return;
    _values = widget.data["value"];
    for (var i = 0; i < _values.length; i++) {
      var item = _values[i];
      if (item['is_today'] == 1) {
        _selectIndex = todayIndex = i;
      }
    }
    _pageController = PageController(initialPage: _selectIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hideTitle = widget.data["more_button"] == 0;
    hideTitle = false;
    int maxCount = 0;
    for (var item in _values) {
      int count = item['value'].length;
      if (maxCount < count) {
        maxCount = count;
      }
    }
    maxCount = max(maxCount, 1);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      child: Column(
        children: [
          hideTitle
              ? Container()
              : SizedBox(
                  height: ScreenUtil().setWidth(50),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              LImage(
                                'comic_hot',
                                width: ScreenUtil().setWidth(21),
                                scale: 1,
                              ),
                              SizedBox(width: ScreenUtil().setWidth(8.5)),
                              Text(widget.data["title"] ?? "loading",
                                  style: GQStyle.white255_18_B),
                              SizedBox(width: ScreenUtil().setWidth(8.5)),
                              Expanded(
                                child: Text(
                                    widget.data["sub_title"] ?? "loading",
                                    style: GQStyle.gray168_12),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(8.5)),
                            ],
                          )),
                          // widget.data["more_button"] == 0
                          //     ? Container()
                          //     :
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              context.push('/recentlyupdate');
                              // context.push('/more_and_more_page',
                              //     extra: widget.data);
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
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: ScreenUtil().setWidth(15),
                  top: !hideTitle ? 0 : ScreenUtil().setWidth(15)),
              child: SizedBox(
                width: ScreenUtil().setWidth(350),
                height: ScreenUtil().setWidth(33),
                child: Stack(
                  children: [
                    LImage('timeline_bg'),
                    Positioned.fill(
                      child: Builder(builder: (context) {
                        List times = [
                          CommonUtils.txt('zhoy'),
                          CommonUtils.txt('zhoe'),
                          CommonUtils.txt('zhos'),
                          CommonUtils.txt('zhosi'),
                          CommonUtils.txt('zhow'),
                          CommonUtils.txt('zhol'),
                          CommonUtils.txt('zhor')
                        ];
                        // "zhoy": "周一",
                        // "zhoe": "周二",
                        // "zhos": "周三",
                        // "zhosi": "周四",
                        // "zhow": "周五",
                        // "zhol": "周六",
                        // "zhor": "周日",];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: times.asMap().keys.map((index) {
                            return GestureDetector(
                              onTap: () {
                                _selectIndex = index;
                                //子组建刷新
                                setState(() {});
                                //父组件刷新
                                _isOnTab = true;
                                _onTabPageChange(index, isOnTab: true);
                              },
                              child: Text(
                                todayIndex == index
                                    ? CommonUtils.txt('jt')
                                    : times[index],
                                style: _selectIndex == index
                                    ? GQStyle.jellyCyan_15
                                    : GQStyle.white255_13,
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Opacity(
                opacity: 0,
                child: GridView.count(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  mainAxisSpacing: ScreenUtil().setWidth(5),
                  crossAxisSpacing: ScreenUtil().setWidth(8.5),
                  childAspectRatio: 111 / 202,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  children: ('1' * maxCount)
                      .characters
                      .map((e) => Container())
                      .toList(),
                ),
              ),
              Positioned.fill(
                child: Container(
                  // color: Colors.teal,
                  width: double.infinity,
                  height: double.infinity,
                  child: PageView(
                    onPageChanged: (index) {
                      if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
                    },
                    controller: _pageController,
                    children: [0, 1, 2, 3, 4, 5, 6]
                        .map((index) =>
                            List.from(_values[index]['value']).length == 0
                                ? Container(
                                    // color: Colors.red,
                                    child: PageStatus.noData())
                                : GridView.count(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: GQStyle.pagePadding),
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: ScreenUtil().setWidth(5),
                                    crossAxisSpacing:
                                        ScreenUtil().setWidth(8.5),
                                    childAspectRatio: 111 / 202,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: List.from(_values[index]['value'])
                                        .map((e) => AcgCard(
                                              data: Map.from(e)
                                                ..['content_type'] =
                                                    widget.data['content_type'],
                                            ))
                                        .toList(),
                                  ))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
