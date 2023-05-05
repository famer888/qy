import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/mixin/element_mixin.dart';
import 'package:qypj/model/construct.dart';
import 'package:qypj/model/element.dart';
import 'package:qypj/model/home_package_list_construct.dart';
import 'package:qypj/model/home_pure_list_construct.dart';
import 'package:qypj/model/ranklistConstruct.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/views/yyq/commend_navigation_bar.dart';
import 'package:qypj/views/yyq/list_sort_switch.dart';

class KTheModuleLayout extends StatefulWidget {
  KTheModuleLayout({Key key, this.id, this.index, this.linkModel})
      : super(key: key);
  final int id;
  final int index;
  final LinkModel linkModel;
  bool forCartoonDiscover;

  @override
  _KTheModuleLayoutState createState() => _KTheModuleLayoutState();
}

class _KTheModuleLayoutState extends State<KTheModuleLayout> with ElementMixin {
  ScrollController _controller;
  int page = 1;
  bool isAll = false;
  int limit = 15;
  bool networkErr = false;
  bool isHud = true;
  ConstructModel cm_data;
  bool isPureList = false; // 是否是纯列表
  List listParam = [];

  bool showPureListBtn = true;

  Widget bannerWidget;
  CommendNavigationBar navWidget;
  Widget sortWidget;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    List tps = Provider.of<HomeConfig>(context, listen: false).config.sort_nav;
    for (var x = 0; x < tps.length; x++) {
      var map = tps[x];
      if (x == 0) {
        map['selected'] = true;
      }
      map['selected'] = false;
      listParam.add(map);
    }
    EventBus().on('', (sds) {});
    getPageData();
    _pureChooseIndex(0);
  }

  Future getPageData() async {
    Map param = Map.from(widget.linkModel.params);
    param['page'] = page;
    param['limit'] = limit;

    if (isPureList) {
      for (var item in listParam) {
        if (item['selected'] == true) {
          param['sort'] = item['type'];
        }
      }
    }

    var res = await getConstructByApiLink(
        apiLink: widget.linkModel.api, params: param);

    if (res == null) {
      networkErr = true;
      setState(() {});
      return;
    }

    if (res.runtimeType == RanklistConstructModel) {
      // 排行榜
      if (page == 1) {
        isAll = false;
        cm_data = ConstructModel();
        cm_data.elements = [];

        Map item = {};
        item['value'] = res.list;

        Map topList = Map.from(res.toplist);
        topList['type'] = 10;

        if (widget.linkModel.api.contains('/api/book/toplist_construct')) {
          // 漫画

          bool vertical =
              (res as RanklistConstructModel).displayType == 'vertical';
          if (vertical) {
            item['type'] = 9; // 漫画列表改为3列显示
          } else {
            item['type'] = 2; // 动漫 两列横屏
          }
          topList['content_type'] = 2;
        } else {
          // 视频
          // item['type'] = 14; // 视频两列横屏
          // item['type'] = 4; // 动漫 两列 竖屏
          // item['type'] = 101; // 视频 2列 竖屏

          bool vertical =
              (res as RanklistConstructModel).displayType == 'vertical';
          if (vertical) {
            item['type'] = 17; // 视频 3列 竖屏
          } else {
            item['type'] = 14; // 视频两列横屏
          }
          topList['content_type'] = 1;
        }

        if (res.banner.length > 0) {
          // 如果有banner
          Map item = {};
          item['value'] = res.banner;
          item['type'] = 1;
          cm_data.elements.add(item);
        }

        cm_data.elements.add(topList);
        cm_data.elements.add(item);
      } else if (res.list.length > 0) {
        Map item = cm_data.elements.last;

        List list = item['value'];
        list.addAll(res.list);

        item['value'] = list;

        // cm_data.elements.addAll(res.list);
      } else {
        isAll = true;
      }
    } else if (res.runtimeType == HomePackageListConstructModel) {
      // 合集

      HomePackageListConstructModel model = res;
      if (page == 1) {
        isAll = false;
        cm_data = ConstructModel();
        cm_data.elements = [];

        // res.list.removeAt(0);

        if (res.banner.length > 0) {
          // 如果有banner
          Map item = {};
          item['value'] = res.banner;
          item['type'] = 1;
          cm_data.elements.add(item);
        }

        Map item = Map.from(res.package);
        item['title'] = null;
        item['value'] = res.list;

        item['content_type'] = model.contentType;
        item['type'] = 2;

        // item = {'value': item};
        // item['type'] = 15;

        cm_data.elements.add(item);
      } else if (res.list.length > 0) {
        Map item = cm_data.elements.last;

        List list = item['value'];
        list.addAll(res.list);

        item['value'] = list;

        // cm_data.elements.addAll(res.list);
      } else {
        isAll = true;
      }
    } else if (res.runtimeType == HomePureListConstructModel) {
      // 纯列表

      HomePureListConstructModel model = res;
      isPureList = true;

      if (page == 1) {
        isAll = false;
        cm_data = ConstructModel();
        cm_data.elements = [];

        // res.list.removeAt(0);

        if (res.banner.length > 0) {
          // 如果有banner
          Map item = {};
          item['value'] = res.banner;
          item['type'] = 1;
          // cm_data.elements.add(item);

          bannerWidget = GeneralBanner(
            data: res.banner,
            height: 150,
            radius: 5,
            bottom: 5,
          );
        } else {
          // if (kDebugMode) {
          //   bannerWidget = Container(
          //     color: Colors.white,
          //     height: ScreenUtil().setWidth(150),
          //   );
          // }
        }

        if (res.nav.length > 0) {
          // 如果有nav
          Map item = {};
          item['value'] = res.nav;
          item['type'] = 18;
          // cm_data.elements.add(item);

          navWidget = CommendNavigationBar(data: item);
        }

        // 加入 最新 最热
        {
          Map item = {};
          item['value'] = listParam;
          item['type'] = 1002;
          item['id'] = widget.id;

          // cm_data.elements.add(item);

          sortWidget = Container(
            // color: Colors.blueGrey,
            height: ScreenUtil().setWidth(30),
            child: ListSortSwitch(
              data: item,
              chooseFunc: (index) async {
                // _pureChooseIndex(index);
                var item = listParam[index];

                if (item['selected'] == true) {
                  // 展开 而且已经选中

                } else {
                  _pureChooseIndex(index);
                  setState(() {});
                  page = 1;

                  // BotToast.showLoading();

                  BotToast.showWidget(toastBuilder: (
                    CancelFunc cancelFunc,
                  ) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: GQStyle.jellyCyanColor103224185,
                      ),
                    );
                  });
                  await getPageData();
                  // BotToast.closeAllLoading();

                  _controller.animateTo(0,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                  BotToast.removeAll();
                }
              },
            ),
          );
        }

        if ((res.list.length > 0)) {
          // 纯列表 有数据才加入
          Map item = {};
          item['value'] = res.list;
          item['type'] = widget.linkModel.elementType();

          if (model.api.contains('cartoon')) {
            item['content_type'] = 16;
          } else if (model.api.contains('mv')) {
            item['content_type'] = 1;
            item['type'] = 14;
          } else if (model.api.contains('book')) {
            item['content_type'] = 2;
          } else if (model.api.contains('topic')) {
            item['content_type'] = 24;
          } else if (model.api.contains('pic')) {
            item['content_type'] = 6;
            item['type'] = 11;
          }

          cm_data.elements.add(item);
        }
      } else if (res.list.length > 0) {
        Map item = cm_data.elements.last;

        List list = item['value'];
        list.addAll(res.list);

        item['value'] = list;

        // cm_data.elements.addAll(res.list);
      } else {
        isAll = true;
      }
    } else {
      if (page == 1) {
        isAll = false;
        cm_data = res;
      } else if (res.elements.length > 0) {
        cm_data.elements.addAll(res.elements);
      } else {
        isAll = true;
      }
    }

    if (widget.forCartoonDiscover != null && widget.forCartoonDiscover) {
      if (cm_data.elements.first['type'] == 1) {
        if (cm_data.elements.first['value'].length > 0) {
          cm_data.elements.first['value'].first['for_cartoon_discover'] = true;
        }
      }
    }

    isHud = false;
    if (mounted) setState(() {});
  }

  _pureChooseIndex(int index) {
    for (var item in listParam) {
      item['selected'] = false;
    }
    listParam[index]['selected'] = true;
  }

  @override
  void dispose() {
    super.dispose();
    if (_controller != null) {
      _controller.dispose();
    }
  }

  List<Widget> _getAllWidget() {
    List<Widget> all = [];
    all = cm_data.elements.map((e) {
      return getElement(element: e);
    }).toList();
    // ..insert(0, SearchElementWidget());

    return all;
  }

  @override
  Widget build(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            networkErr = false;
            setState(() {});
            getPageData();
          })
        : Container(
            color: Colors.transparent,
            child: isHud
                ? PageStatus.loading(mounted)
                : cm_data.elements.length == 0 &&
                        bannerWidget == null &&
                        navWidget == null
                    ? PageStatus.noData()
                    : Stack(
                        children: [
                          cm_data?.elements == null
                              ? Container()
                              : Column(
                                  children: [
                                    Expanded(
                                      child: NestedScrollView(
                                        controller: _controller,
                                        headerSliverBuilder:
                                            (context, innerBoxIsScrolled) {
                                          return [
                                            // SliverPersistentHeader(
                                            //     pinned: true,
                                            //     delegate: IndexPageHeaderDelegate(
                                            //         const SearchElementWidget())),
                                            // SliverToBoxAdapter(
                                            //   child: bannerWidget != null
                                            //       ? Container(
                                            //           padding: EdgeInsets.only(
                                            //               top: ScreenUtil()
                                            //                   .setWidth(10)),
                                            //           margin:
                                            //               EdgeInsets.symmetric(
                                            //                   horizontal: GQStyle
                                            //                       .pagePadding),
                                            //           child: bannerWidget,
                                            //         )
                                            //       : Container(),
                                            // ),

                                            // SliverToBoxAdapter(
                                            //   child: navWidget != null
                                            //       ? navWidget
                                            //       : Container(),
                                            // ),

                                            SliverToBoxAdapter(
                                              child: Column(
                                                children: [
                                                  bannerWidget != null
                                                      ? Container(
                                                          padding: EdgeInsets.only(
                                                              top: ScreenUtil()
                                                                  .setWidth(
                                                                      10)),
                                                          margin: EdgeInsets.symmetric(
                                                              horizontal: GQStyle
                                                                  .pagePadding),
                                                          child: bannerWidget,
                                                        )
                                                      : Container(),
                                                  navWidget ?? Container()
                                                ],
                                              ),
                                            ),

                                            // navWidget ?? Container(),
                                            // sortWidget ?? Container()

                                            SliverPersistentHeader(
                                                pinned: true,
                                                delegate:
                                                    IndexPageHeaderDelegate(
                                                        Stack(
                                                          children: [
                                                            Positioned(
                                                                top: -10,
                                                                left: 0,
                                                                right: 0,
                                                                height: ScreenUtil()
                                                                    .screenHeight,
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: double
                                                                      .infinity,
                                                                  color: GQStyle
                                                                      .bgColor,
                                                                  // color: Colors
                                                                  //     .deepOrange,
                                                                )),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  // color: GQStyle
                                                                  //     .bgColor,
                                                                  child: sortWidget ??
                                                                      Container(),
                                                                ),
                                                                Spacer()
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        maxHeight:
                                                            (sortWidget != null
                                                                ? ScreenUtil()
                                                                    .setWidth(
                                                                        40)
                                                                : 0),
                                                        minHeight:
                                                            (sortWidget != null
                                                                ? ScreenUtil()
                                                                    .setWidth(
                                                                        40)
                                                                : 0)))
                                          ];
                                        },
                                        body: cm_data.elements.length == 0
                                            ? PageStatus.noData()
                                            : PullRefreshList(
                                                onRefresh: () {
                                                  page = 1;
                                                  getPageData();
                                                },
                                                onLoading: () {
                                                  page++;
                                                  getPageData();
                                                },
                                                child: ListView(
                                                    shrinkWrap: true,
                                                    children: _getAllWidget()),
                                              ),
                                        // slivers: [
                                        //   // SliverList(
                                        //   //     delegate: SliverChildListDelegate([
                                        //   //   const SearchElementWidget(),
                                        //   //   Container(
                                        //   //     padding: EdgeInsets.only(
                                        //   //         top: ScreenUtil().setWidth(10)),
                                        //   //     margin: EdgeInsets.symmetric(
                                        //   //         horizontal: GQStyle.pagePadding),
                                        //   //     child: bannerWidget ?? Container(),
                                        //   //   ),
                                        //   //   navWidget ?? Container(),
                                        //   //   sortWidget ?? Container()
                                        //   // ])),

                                        //   SliverPersistentHeader(
                                        //       delegate:
                                        //           IndexPageHeaderDelegate(
                                        //               ListView(
                                        //     children: [
                                        //       navWidget ?? Container(),
                                        //       sortWidget ?? Container()
                                        //     ],
                                        //   ))),

                                        //   bannerWidget != null
                                        //       ? Container(
                                        //           padding: EdgeInsets.only(
                                        //               top: ScreenUtil()
                                        //                   .setWidth(10)),
                                        //           margin:
                                        //               EdgeInsets.symmetric(
                                        //                   horizontal: GQStyle
                                        //                       .pagePadding),
                                        //           child: bannerWidget)
                                        //       : SliverToBoxAdapter(),

                                        //   cm_data.elements.length == 0
                                        //       ? SliverToBoxAdapter(
                                        //           child: PageStatus.noData(),
                                        //         )
                                        //       : SliverList(
                                        //           delegate:
                                        //               SliverChildListDelegate(
                                        //                   _getAllWidget()))
                                        // ],
                                      ),
                                    ),
                                  ],
                                ),
                          Visibility(
                            visible: false,
                            child: AnimatedPositioned(
                                duration: Duration(milliseconds: 200),
                                right: showPureListBtn
                                    ? 0
                                    : -(ScreenUtil().setWidth(44.5) * 2 +
                                        ScreenUtil().setWidth(6.5 + 1)),
                                top: ScreenUtil().setWidth(40),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          ScreenUtil().setWidth(12.5)),
                                      bottomLeft: Radius.circular(
                                          ScreenUtil().setWidth(12.5))),
                                  child: Container(
                                      // width: 100,
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(6.5)),
                                      height: ScreenUtil().setWidth(25),
                                      decoration: BoxDecoration(
                                        color: Color(0xff26313b),
                                      ),
                                      child: Center(
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (contenxt, index) {
                                              var item = listParam[index];
                                              CommonUtils.debugPrint(
                                                  "listview: $item");
                                              return GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  if (!showPureListBtn) {
                                                    showPureListBtn =
                                                        !showPureListBtn;
                                                    setState(() {});
                                                    return;
                                                  } else {
                                                    if (item['selected'] ==
                                                        true) {
                                                      // 展开 而且已经选中

                                                    } else {
                                                      _pureChooseIndex(index);
                                                      showPureListBtn =
                                                          !showPureListBtn;
                                                      setState(() {});
                                                      page = 1;
                                                      getPageData();
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  width: ScreenUtil()
                                                      .setWidth(44.5),
                                                  child: Center(
                                                    child: Text(item['title'],
                                                        style: item['selected'] ==
                                                                true
                                                            ? GQStyle
                                                                .white13medium
                                                            : GQStyle
                                                                .gray102_13),
                                                  ),
                                                ),
                                              );
                                            },
                                            itemCount: listParam.length),
                                      )),
                                )),
                          )
                        ],
                      ),
          );
  }
}

class IndexPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  IndexPageHeaderDelegate(this.child,
      {this.minHeight = 50, this.maxHeight = 50});

  Widget child;
  final double minHeight;
  final double maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
