import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/views/yyq/acg_triple_colume_vertical_timeline.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

class HomeRecentlyUpdatedPage extends BaseWidget {
  HomeRecentlyUpdatedPage({Key key}) : super(key: key);

  @override
  BaseWidgetState<HomeRecentlyUpdatedPage> cState() =>
      _HomeRecentlyUpdatedPageState();
}

class _HomeRecentlyUpdatedPageState
    extends BaseWidgetState<HomeRecentlyUpdatedPage> {
  bool networkErr = false;
  bool isHud = true;
  dynamic value;

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

  _loadData() async {
    Basic res;
    try {
      res = await comicTimeLine({});
    } catch (e) {
      isHud = false;
      networkErr = true;
      setState(() {});
      return;
    }

    if (res.status == 1) {
      isHud = false;
      networkErr = false;

      value = {'value': res.data, 'more_button': 0};
      _values = res.data;
      for (var i = 0; i < _values.length; i++) {
        var item = _values[i];
        if (item['is_today'] == 1) {
          _selectIndex = todayIndex = i;
        }
      }
      _pageController = PageController(initialPage: _selectIndex);

      setState(() {});
    } else {
      isHud = false;
      networkErr = true;
      setState(() {});
      return;
    }

    print(res);
  }

  @override
  void onCreate() {
    setAppTitle(title: CommonUtils.txt('zjin') + CommonUtils.txt('gx'));
    _loadData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }
  @override
  Widget pageBody(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            _loadData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : true
                ? Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: ScreenUtil().setWidth(15)),
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
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children:
                                            times.asMap().keys.map((index) {
                                          return GestureDetector(
                                            onTap: () {
                                              _selectIndex = index;
                                              //子组建刷新
                                              setState(() {});
                                              //父组件刷新
                                              _isOnTab = true;
                                              _onTabPageChange(index,
                                                  isOnTab: true);
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
                        Expanded(
                          child: Container(
                            // color: Colors.teal,
                            width: double.infinity,
                            height: double.infinity,
                            child: PageView(
                              onPageChanged: (index) {
                                if (!_isOnTab)
                                  _onTabPageChange(index, isOnTab: false);
                              },
                              controller: _pageController,
                              children: [0, 1, 2, 3, 4, 5, 6]
                                  .map((index) => List.from(
                                                  _values[index]['value'])
                                              .length ==
                                          0
                                      ? Container(
                                          // color: Colors.red,
                                          child: PageStatus.noData())
                                      : GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  mainAxisSpacing:
                                                      ScreenUtil().setWidth(5),
                                                  crossAxisSpacing: ScreenUtil()
                                                      .setWidth(8.5),
                                                  childAspectRatio: 111 / 202,
                                                  crossAxisCount: 3),
                                          itemBuilder: (context, itemIndex) {
                                            var e = _values[index]['value']
                                                [itemIndex];

                                            return AcgCard(
                                                data: Map.from(e)
                                                  ..['content_type'] = 2);
                                          },
                                          itemCount:
                                              _values[index]['value'].length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics: BouncingScrollPhysics(),
                                        ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    child: AcgTripleColumeVerticalTimeline(
                      data: value,
                    ),
                  );
  }
}
