import 'package:flutter/material.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/card/comics_card.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/card/v34card.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

class WatchHistoryPage extends BaseWidget {
  WatchHistoryPage({Key key}) : super(key: key);

  @override
  _WatchHistoryPageState cState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends BaseWidgetState<WatchHistoryPage>
    with TickerProviderStateMixin {
  final myController = TextEditingController();
  TabController _tabController;
  int currentTab = 0;
  List tabList = [
    {
      'id': 1,
      'name': CommonUtils.txt('shp'),
    },
    {
      'id': 2,
      'name': CommonUtils.txt('mh'),
    },
    // {
    //   'id': 3,
    //   'name': CommonUtils.txt('xs'),
    // },
    {
      'id': 4,
      'name': CommonUtils.txt('ssmj'),
    }
  ];
  @override
  void initState() {
    super.initState();

    /// 选项卡控制器
    _tabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_tabController.index.toDouble() == _tabController.animation.value) {
        setState(() {
          currentTab = _tabController.index;
        });
      }
    });
  }

  @override
  void onCreate() {
    setAppTitle(title: CommonUtils.txt('lljl'));
    // TODO: implement onCreate
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return FljSliderNav(
      titles: tabList.map<String>((e) => e["name"]).toList(),
      pages: tabList
          .map((e) => PageViewMixin(
                child: HistoryList(
                  type: e['id'],
                ),
              ))
          .toList(),
    );
  }
}

class HistoryList extends StatefulWidget {
  HistoryList({Key key, this.type}) : super(key: key);
  int type;
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  List history = [];
  @override
  void initState() {
    super.initState();
    reloadList();
  }

  reloadList() {
    List boxdata;

    switch (widget.type) {
      case 1:
        boxdata = AppGlobal.videoWatchRecordBox.values.toList();
        break;
      case 2:
        boxdata = AppGlobal.manhuaWatchRecordBox.values.toList();
        break;
      case 3:
        boxdata = AppGlobal.bookWatchRecordBox.values.toList();
        break;
      default:
        boxdata = AppGlobal.smallVideoWatchRecordBox.values.toList();
    }
    boxdata.sort(
        (left, right) => right['recordTimer'].compareTo(left['recordTimer']));
    history = boxdata;
    setState(() {});
  }

  @override
  void didUpdateWidget(HistoryList oldWidget) {
    super.didUpdateWidget(oldWidget);
    reloadList();

    // CommonUtils.showText('text');
  }

  _videoList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return GridView.count(
      padding: EdgeInsets.only(
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding,
          top: GQStyle.pagePadding),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: ScreenUtil().setWidth(4),
      crossAxisSpacing: ScreenUtil().setWidth(4),
      // childAspectRatio: 173 / 166,
      childAspectRatio: 224 / 196,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      children: history
          .map((e) => GestureDetector(
                onTap: () {
                  context
                      .push(CommonUtils.getRealHash('videoDetail/${e["id"]}'));
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _w / 173 * 100,
                          child: PlatformAwareNetworkImage(
                              url: clipImageUrl(CommonUtils.getThumb(e),
                                  inputWidth: ScreenUtil().setWidth(173)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Text(e["title"] ?? "loading",
                            style: GQStyle.white255_14),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                style: GQStyle.gray105_11),
                            Spacer(),
                            Text("${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                style: GQStyle.gray105_11),
                            SizedBox(width: ScreenUtil().setWidth(5))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  _smallVideoList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(8)) /
        3;
    return GridView.count(
      padding: EdgeInsets.only(
          left: GQStyle.pagePadding,
          right: GQStyle.pagePadding,
          top: GQStyle.pagePadding),
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: ScreenUtil().setWidth(4),
      crossAxisSpacing: ScreenUtil().setWidth(4),
      childAspectRatio: 7 / 12,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      children: history
          .map((e) => GestureDetector(
                onTap: () {
                  context.push(
                      CommonUtils.getRealHash('smallvideodetail/${e["id"]}'));
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _w / 7 * 10,
                          child: PlatformAwareNetworkImage(
                              url: CommonUtils.getThumb(e),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(12)),
                        Text(e["title"] ?? "loading",
                            style: GQStyle.gray192_13_B),
                      ],
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  _comicsList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(20)),
        itemCount: history.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(5),
          crossAxisSpacing: ScreenUtil().setWidth(8.5),
          childAspectRatio: 111 / 202,
        ),
        itemBuilder: (context, index) {
          var t = history[index];
          return AcgCard(
            data: Map.from(t)..['content_type'] = 2,
            hideIdentify: true,
          );
        });
  }

  _novelList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(20)),
        itemCount: history.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 25,
          crossAxisSpacing: 10,
          childAspectRatio: 219 / 398,
        ),
        itemBuilder: (context, index) {
          var t = history[index];
          return GestureDetector(
            onTap: () {
              context.push(
                  CommonUtils.getRealHash('novelDetail/${t["id"] ?? "0"}'));
            },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _w / 110 * 147,
                      child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(t),
                              inputWidth: ScreenUtil().setWidth(110)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    SizedBox(height: ScreenUtil().setWidth(10)),
                    Text(t["title"] ?? "loading", style: GQStyle.white255_14_M),
                    SizedBox(height: ScreenUtil().setWidth(6)),
                  ],
                ),
              ],
            ),
          );
        });
  }

  getListWidget() {
    switch (widget.type) {
      case 1:
        return _videoList();
        break;
      case 2:
        return _comicsList();
        break;
      case 3:
        return _novelList();
        break;
      case 4:
        return _smallVideoList();
        break;
      default:
        return _comicsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return history == null || history.isEmpty
        ? PageStatus.noData()
        : getListWidget();
  }
}
