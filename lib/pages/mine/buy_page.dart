import 'package:flutter/material.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

class BuyPage extends StatefulWidget {
  BuyPage({Key key}) : super(key: key);

  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> with TickerProviderStateMixin {
  final myController = TextEditingController();
  TabController _tabController;
  int currentTab = 0;
  List tabList = [
    {'id': 1, 'name': CommonUtils.txt('sping')},
    {'id': 11, 'name': CommonUtils.txt('ssmj')},
    {'id': 2, 'name': CommonUtils.txt('mh')},
    // {'id': 3, 'name': CommonUtils.txt('xs')},
    {'id': 6, 'name': CommonUtils.txt('mt')},
    {'id': 99, 'name': CommonUtils.txt('hjsp')},
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
        currentTab = _tabController.index;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: SafeArea(
          child: Column(
        children: [
          PageTitleBar(
            title: CommonUtils.txt('wdgm'),
          ),
          Expanded(
            child: FljSliderNav(
              titles: tabList.map<String>((e) => e["name"]).toList(),
              pages: tabList
                  .map((e) => PageViewMixin(
                        child: BuyList(
                          type: e['id'],
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      )),
    );
  }
}

class BuyList extends StatefulWidget {
  BuyList({Key key, this.type}) : super(key: key);
  final int type;

  @override
  _BuyListState createState() => _BuyListState();
}

class _BuyListState extends State<BuyList> {
  List<dynamic> dataList;
  bool isHud = true;
  int page = 1;
  bool netError = false;
  bool noMore = false;

  _getData() async {
    var result = await getUserBuy(page: page, type: widget.type);
    if (result == null) {
      netError = true;
      setState(() {});
    }
    List<dynamic> st = result['data']["list"];
    if (page == 1) {
      noMore = false;
      dataList = st;
    } else if (st.length > 0) {
      dataList.addAll(st);
    } else {
      noMore = true;
    }
    netError = false;
    isHud = false;
    setState(() {});
  }

  Widget _videoList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ScreenUtil().setWidth(4),
              crossAxisSpacing: ScreenUtil().setWidth(4),
              childAspectRatio: 224 / 196,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              return GestureDetector(
                onTap: () {
                  if (t["mv_type"] == 1) {
                    context.push(
                        CommonUtils.getRealHash('videoDetail/${t["id"]}'));
                  } else {
                    context.push(
                        CommonUtils.getRealHash('smallvideodetail/${t["id"]}'));
                  }
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _w / 173 * 100,
                          child: PlatformAwareNetworkImage(
                              url: clipImageUrl(CommonUtils.getThumb(t),
                                  inputWidth: ScreenUtil().setWidth(173)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Text(t["title"] ?? "loading",
                            style: GQStyle.white255_14),
                        SizedBox(height: ScreenUtil().setWidth(3.5)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.renderFixedNumber(t["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                style: GQStyle.gray105_11),
                            Spacer(),
                            Text("${CommonUtils.getHMTime(t["duration"] ?? 0)}",
                                style: GQStyle.gray105_11),
                            SizedBox(width: ScreenUtil().setWidth(5))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }));
  }

  Widget _mvList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return PullRefreshList(
      isAll: noMore,
      onRefresh: () {
        page = 1;
        _getData();
      },
      onLoading: () {
        page += 1;
        _getData();
      },
      child: GridView.builder(
          cacheExtent: ScreenUtil().screenHeight * 5,
          padding: EdgeInsets.symmetric(
              horizontal: GQStyle.pagePadding,
              vertical: ScreenUtil().setWidth(10)),
          itemCount: dataList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: ScreenUtil().setWidth(12),
            crossAxisSpacing: ScreenUtil().setWidth(12),
            childAspectRatio: 110 / 175,
          ),
          itemBuilder: (context, index) {
            var t = dataList[index];
            return GestureDetector(
              onTap: () {
                context.push(
                    CommonUtils.getRealHash('smallvideodetail/${t["id"]}'));
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
                      SizedBox(height: ScreenUtil().setWidth(3.5)),
                      Text(t["title"] ?? "loading",
                          style: GQStyle.white255_14, maxLines: 1),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _comicsList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().setWidth(5),
              crossAxisSpacing: ScreenUtil().setWidth(8.5),
              childAspectRatio: 111 / 202,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];

              return AcgCard(
                isForBuyPage: true,
                data: Map.from(t)..['content_type'] = 2,
              );

              // 旧的样式 不用了
              // return GestureDetector(
              //   onTap: () {
              //     context.push(CommonUtils.getRealHash(
              //         'comicsdetail/${t["id"] ?? "0"}'));
              //   },
              //   child: Stack(
              //     children: [
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           SizedBox(
              //             height: _w / 110 * 147,
              //             child: PlatformAwareNetworkImage(
              //                 url: clipImageUrl(CommonUtils.getThumb(t),
              //                     inputWidth: ScreenUtil().setWidth(110)),
              //                 borderRadius:
              //                     BorderRadius.all(Radius.circular(5))),
              //           ),
              //           SizedBox(height: ScreenUtil().setWidth(10)),
              //           Text(t["title"] ?? "loading",
              //               style: GQStyle.white255_14_M),
              //           SizedBox(height: ScreenUtil().setWidth(6)),
              //           Text(
              //             t["finished"] == 1
              //                 ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${t["series"]}${CommonUtils.txt("hua")}"
              //                 : "${CommonUtils.txt("gxz")}${t["series"]}${CommonUtils.txt("hua")}",
              //             style: GQStyle.gray128_11,
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            }));
  }

  Widget _novelList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 25,
              crossAxisSpacing: 10,
              childAspectRatio: 219 / 398,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(10)),
                        Text(t["title"] ?? "loading",
                            style: GQStyle.white255_14_M),
                        SizedBox(height: ScreenUtil().setWidth(6)),
                        Text(
                          t["finished"] == 1
                              ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${t["series"]}${CommonUtils.txt("hua")}"
                              : "${CommonUtils.txt("gxz")}${t["series"]}${CommonUtils.txt("hua")}",
                          style: GQStyle.gray128_11,
                        )
                      ],
                    ),
                  ],
                ),
              );
            }));
  }

  Widget _beautyPNGList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(12)) /
        2;
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 12,
              childAspectRatio: 340 / 530,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              return GestureDetector(
                onTap: () {
                  context.push(
                      CommonUtils.getRealHash('atlasDetail/${t["id"] ?? "0"}'));
                },
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: _w / 169 * 224,
                          child: PlatformAwareNetworkImage(
                              url: CommonUtils.getThumb(t),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(10)),
                        Text(t["title"] ?? "loading",
                            style: GQStyle.white255_14_M),
                        SizedBox(height: ScreenUtil().setWidth(6)),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }

  Widget _packageList() {
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              var t = dataList[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(
                          '/more_and_more_collect/${t["id"] ?? "0"}/${t["type"] ?? "1"}');
                    },
                    child: Container(
                      height: ScreenUtil().setWidth(180.6),
                      child: Stack(children: [
                        PlatformAwareNetworkImage(
                            url: CommonUtils.getThumb(t),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color.fromRGBO(0, 0, 0, 0.68))),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                t["title"] ?? "loading",
                                style: GQStyle.white255_18_B,
                              )),
                              SizedBox(height: ScreenUtil().setWidth(14)),
                              Center(
                                  child: Text(
                                t["sub_title"] ?? "loading",
                                style: GQStyle.gray202_14,
                              )),
                            ])
                      ]),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(30))
                ],
              );
            }));
  }

  Widget _beautyYueMList() {
    return PullRefreshList(
        isAll: noMore,
        onRefresh: () {
          page = 1;
          _getData();
        },
        onLoading: () {
          page += 1;
          _getData();
        },
        child: GridView.builder(
            cacheExtent: ScreenUtil().screenHeight * 5,
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding,
                vertical: ScreenUtil().setWidth(20)),
            itemCount: dataList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 25,
              crossAxisSpacing: 12,
              childAspectRatio: 340 / 450,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              return Container();
            }));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  getListWidget() {
    switch (widget.type) {
      case 1:
        return _videoList();
        break;
      case 11:
        return _mvList();
        break;
      case 2:
        return _comicsList();
        break;
      case 3:
        return _novelList();
        break;
      case 6:
        return _beautyPNGList();
        break;
      case 7:
        return _beautyYueMList();
        break;
      case 99:
        return _packageList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return netError
        ? PageStatus.noNetWork()
        : isHud
            ? PageStatus.loading(mounted)
            : (dataList.length > 0 ? getListWidget() : PageStatus.noData());
  }
}
