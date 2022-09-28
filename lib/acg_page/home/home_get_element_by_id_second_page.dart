import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/jelly_slider_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';
import 'package:qypj/views/yyq/cards/ad_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/episodes_card.dart';
import 'package:qypj/views/yyq/cards/picture_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card.dart';

class HomeGetElementByIdSecondPage extends BaseWidget {
  HomeGetElementByIdSecondPage(
      {Key key, this.param, this.contentType, this.title})
      : super(key: key);
  dynamic param;
  final int contentType;
  String title;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomeGetElementByIdSecondPageState();
  }
}

class _HomeGetElementByIdSecondPageState
    extends BaseWidgetState<HomeGetElementByIdSecondPage> {
  PageController _pageController;
  int _selectIndex = 0;
  bool _isOnTab = false;
  List<String> titles = [CommonUtils.txt("zxpx"), CommonUtils.txt("rdpx")];
  Widget bannerWidget;

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

    if (widget.title != null) {
      setAppTitle(title: widget.title);
    }
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _pageController.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return Column(
      children: [
        bannerWidget != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                child: bannerWidget,
              )
            : Container(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          child: JellySliderBar(
            titles: titles,
            pageController: _pageController,
          ),
        ),
        Expanded(
          child: PageView(
            onPageChanged: (index) {
              if (!_isOnTab) _onTabPageChange(index, isOnTab: false);
            },
            controller: _pageController,
            children: [
              PageViewMixin(
                child: HomeGetElementByIdSecondPageChild(
                  type: "new",
                  param: widget.param,
                  contentType: widget.contentType,
                  bannerFunc: (p0) {
                    if (p0 != null && p0.length > 0) {
                      if (bannerWidget == null) {
                        bannerWidget = GeneralBanner(
                          data: p0,
                          height: 150,
                          radius: 5,
                          bottom: ScreenUtil().setWidth(10),
                        );
                        setState(() {});
                      }
                    }
                  },
                ),
              ),
              PageViewMixin(
                  child: HomeGetElementByIdSecondPageChild(
                type: "hot",
                param: widget.param,
                contentType: widget.contentType,
              )),
            ],
          ),
        )
      ],
    );
  }
}

class HomeGetElementByIdSecondPageChild extends StatefulWidget {
  HomeGetElementByIdSecondPageChild(
      {Key key,
      this.type,
      this.param,
      this.contentType = 0,
      this.titleFunc,
      this.bannerFunc})
      : super(key: key);
  final String type;
  final int contentType;
  final dynamic param;
  final Function(String) titleFunc;
  final Function(dynamic) bannerFunc;

  @override
  State<HomeGetElementByIdSecondPageChild> createState() =>
      _HomeGetElementByIdSecondPageChildState();
}

class _HomeGetElementByIdSecondPageChildState
    extends State<HomeGetElementByIdSecondPageChild> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  dynamic value;
  bool noMore = false;
  bool netWorkErr = false;

  _getData() async {
    Map param = Map.from(widget.param);

    param.addAll({
      'page': page,
      'limit': AppGlobal.smallVideoLimit,
      "sort": widget.type
    });

    Basic t = await getListConstructWithParam(data: param);
    if (t.data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }
    if (page == 1) {
      noMore = false;
      values = t.data["list"];

      if (widget.titleFunc != null) {
        // widget.titleFunc(t.data["title"] ?? "loading");
      }

      if (widget.bannerFunc != null) {
        widget.bannerFunc(t.data['banner']);
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
          childAspectRatio: 171 / 142,
        ),
        itemBuilder: (context, index) {
          var e = values[index];

          return VideoDoubleColumeCard(
              data: Map.from(e)..addAll({'content_type': 1}));
          return e['url'] != null
              ? AdDoubleColumeCard(data: Map.from(e))
              : VideoDoubleColumeCard(
                  data: Map.from(e)..addAll({'content_type': 1}));
          return widget.contentType == 24
              ? EpisodesCard(
                  data: e,
                )
              : VideoDoubleColumeCard(
                  data: Map.from(e)
                    ..addAll({'content_type': widget.contentType}));
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
          e['content_type'] = widget.contentType;
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
    switch (widget.contentType) {
      case 1:
        return _videoList();
        break;
      case 16:
        return _videoList();
        break;
      case 24:
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
