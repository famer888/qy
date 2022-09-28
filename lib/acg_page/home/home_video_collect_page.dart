import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';
import 'package:qypj/views/yyq/cards/picture_double_colume_card.dart';

class HomeVideoCollectPage extends BaseWidget {
  HomeVideoCollectPage({Key key, this.id, this.contentType}) : super(key: key);
  String id = "0";
  final int contentType;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomeVideoCollectPageState();
  }
}

class _HomeVideoCollectPageState extends BaseWidgetState<HomeVideoCollectPage> {
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;
  dynamic value;
  List<String> titles = [CommonUtils.txt("rdpx"), CommonUtils.txt("zxpx")];

  showBuyCollect() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int money = Provider.of<HomeConfig>(context, listen: false).member.money;
      bool isInsufficient = money < value["price"];
      YyShowDialog.showdialog(
        context,
        title: isInsufficient
            ? CommonUtils.txt('jbbz')
            : CommonUtils.txt('jbhjsp'),
        btnText:
            isInsufficient ? CommonUtils.txt('qwcz') : CommonUtils.txt('gmgk'),
        callBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            buyPackageVideo(
                    id: value["id"], coins: value["price"], context: context)
                .then((res) {
              if (res.status == 1) {
                CommonUtils.showText(CommonUtils.txt('gmcg'));

                value['is_pay'] = 1;
                setState(() {});
              } else {
                CommonUtils.showText(res.msg);
              }
            });
          }
        },
        content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.graya3a2a2_15,
              child: Column(
                children: [
                  Text.rich(TextSpan(text: CommonUtils.txt('shf'), children: [
                    TextSpan(
                        text: '${value["price"]}' + CommonUtils.txt('jb'),
                        style: GQStyle.jellyCyan_15_M)
                  ])),
                  SizedBox(height: ScreenUtil().setWidth(10)),
                  Text(
                    CommonUtils.txt('zmsq'),
                    style: GQStyle.graya3a2a2_15,
                    maxLines: 2,
                  ),
                ],
              ));
        },
      );
    });
  }

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
  void onCreate() {
    // TODO: implement onCreate
    _pageController = PageController();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _pageController.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Stack(
      children: [
        Column(
          children: [
            FljSliderBar(
              titles: titles,
              pageController: _pageController,
            ),
            Expanded(
              child: PageView(
                onPageChanged: (index) {
                  if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
                },
                controller: _pageController,
                children: [
                  PageViewMixin(
                    child: HomeVideoCollectPageChild(
                      type: "hot",
                      id: widget.id,
                      contentType: widget.contentType,
                      valueFunc: (data) {
                        if (value != null) return;
                        value = data;
                        setAppTitle(title: value['title']);
                        setState(() {});
                      },
                    ),
                  ),
                  PageViewMixin(
                      child: HomeVideoCollectPageChild(
                    type: "new",
                    id: widget.id,
                    contentType: widget.contentType,
                  )),
                ],
              ),
            )
          ],
        ),
        Positioned.fill(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: value == null
                  ? Container(
                      // color: Colors.red,
                      )
                  : value['is_pay'] == 1
                      ? Container()
                      : SizedBox(
                          height: ScreenUtil().setWidth(33),
                          width: ScreenUtil().setWidth(320),
                          child: GestureDetector(
                            onTap: () {
                              if (value == null) {
                                return;
                              }
                              if (value["is_pay"] == 1) {
                                CommonUtils.showText(CommonUtils.txt("yydwcf"));
                                return;
                              }
                              showBuyCollect();
                              setState(() {});
                            },
                            child: Stack(
                              children: [
                                LImage(
                                  "unlock_bg",
                                ),
                                Positioned(
                                  // top: ScreenUtil().setWidth(11),
                                  left: ScreenUtil().setWidth(32),
                                  child: Container(
                                    height: ScreenUtil().setWidth(33),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${value["price"] ?? 0}${CommonUtils.txt("jbjs")}${value["total_num"]}${CommonUtils.txt("byp")}",
                                      style: GQStyle.yellowffbd39_15_M,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: SizedBox(
                                    width: ScreenUtil().setWidth(110),
                                    height: ScreenUtil().setWidth(33),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(4)),
                                      child: Stack(
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              // color: Colors.red,
                                              child: LImage(
                                                'video_unlock_btn',
                                                fit: BoxFit.fill,
                                              )),
                                          Center(
                                              child: Text(
                                            CommonUtils.txt('llqg'),
                                            style: GQStyle.white255_13_M,
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
            ))
      ],
    );
  }
}

class HomeVideoCollectPageChild extends StatefulWidget {
  HomeVideoCollectPageChild(
      {Key key,
      this.id,
      this.type,
      this.param,
      this.contentType = 0,
      this.valueFunc})
      : super(key: key);

  final String id;
  final String type;
  final int contentType;
  final dynamic param;
  final Function(dynamic) valueFunc;

  @override
  State<HomeVideoCollectPageChild> createState() =>
      _HomeVideoCollectPageChildState();
}

class _HomeVideoCollectPageChildState extends State<HomeVideoCollectPageChild> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  dynamic value;
  bool noMore = false;
  bool netWorkErr = false;

  _getData() async {
    Basic t = await collectionList(
        id: widget.id,
        page: page,
        limit: AppGlobal.smallVideoLimit,
        sort: widget.type);
    if (t.data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }

    if (page == 1) {
      noMore = false;
      values = t.data["list"];
      if (widget.valueFunc != null) {
        widget.valueFunc(t.data["detail"]);
      }
    } else if ((t.data["list"] as List<dynamic>).length > 0) {
      values.addAll((t.data["list"] as List<dynamic>));
    } else {
      noMore = true;
    }
    isHud = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _videoList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(8),
          childAspectRatio: 171 / 131.5,
        ),
        itemBuilder: (context, index) {
          var e = values[index];
          return GestureDetector(
            onTap: () {
              context.push(CommonUtils.getRealHash('videoDetail/${e["id"]}'));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: _w / 171 * 96,
                      child: PlatformAwareNetworkImage(
                          url: clipImageUrl(CommonUtils.getThumb(e),
                              inputWidth: ScreenUtil().setWidth(173)),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    Positioned.fill(
                        child: Column(
                      children: [
                        Spacer(),
                        Container(
                          height: ScreenUtil().setWidth(40),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(10),
                              vertical: ScreenUtil().setWidth(7.5)),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color.fromRGBO(0, 0, 0, 0.6),
                                Colors.transparent,
                              ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter)),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${CommonUtils.renderFixedNumber(e["count_play"] ?? 0)}${CommonUtils.txt("cbf")}",
                                    style: GQStyle.white255_11),
                                Spacer(),
                                Text(
                                    "${CommonUtils.getHMTime(e["duration"] ?? 0)}",
                                    style: GQStyle.white255_11),
                                SizedBox(width: ScreenUtil().setWidth(5))
                              ],
                            ),
                          ),
                          // child: ,
                        )
                      ],
                    )),
                    Positioned(
                        left: ScreenUtil().setWidth(7.5),
                        top: ScreenUtil().setWidth(7.5),
                        child: CommonUtils.identifyWidget(e))
                  ],
                ),
                // SizedBox(height: ScreenUtil().setWidth(10)),
                Expanded(
                  child: Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        e["title"] ?? "loading",
                        style: GQStyle.white255_13,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  _mvList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisSpacing: ScreenUtil().setWidth(12),
          childAspectRatio: 110 / 175,
        ),
        itemBuilder: (context, index) {
          var t = values[index];
          return GestureDetector(
            onTap: () {
              context
                  .push(CommonUtils.getRealHash('smallvideodetail/${t["id"]}'));
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
                    // SizedBox(height: ScreenUtil().setWidth(3.5)),
                  ],
                ),
                Positioned(right: 0, top: 0, child: CommonUtils.identiWget(t))
              ],
            ),
          );
        });
  }

  _comicsList() {
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(8),
          childAspectRatio: 111 / 202.5,
        ),
        itemBuilder: (context, index) {
          var e = values[index];
          return AcgCard(data: e);
        });
  }

  _meiPNGList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(8)) /
        2;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: values.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(10),
          childAspectRatio: 171 / 264.5,
        ),
        itemBuilder: (context, index) {
          var t = values[index];
          return PictureDoubleColumeCard(data: t);
        });
  }

  Widget _getListWidget() {
    return _videoList();
    switch (widget.contentType) {
      case 1:
        return _videoList();
        break;
      case 2:
        return _comicsList();
        break;
      case 3:
        return _mvList();
        break;
      case 6:
        return _meiPNGList();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            page = 1;
            _getData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : (values.length == 0
                ? PageStatus.noData()
                : PullRefreshList(
                    onRefresh: () {
                      page = 1;
                      noMore = false;
                      _getData();
                    },
                    onLoading: () {
                      page++;
                      _getData();
                    },
                    child: _getListWidget(),
                    isAll: noMore,
                  ));
  }
}
