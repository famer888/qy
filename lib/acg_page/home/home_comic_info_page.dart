import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/card/newComicsCard.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/comicsDetail.dart';
import 'package:qypj/pages/details/atlas_detail.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';

class HomeComicInfoPage extends BaseWidget {
  HomeComicInfoPage({Key key, this.id}) : super(key: key);
  final int id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _AcgComicDetailPageState();
  }
}

class _AcgComicDetailPageState extends BaseWidgetState<HomeComicInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = true;
  int watchLog;
  Data data;
  List<String> newestSeries = [];
  int newestSeriesNum = 0;
  List recommendList = [];
  bool isFavorites = false;
  PageController _pageController;
  bool ascend = true; //排序 升序还是降序

  bool descFold = true; // 简介是否折叠

  getPageData() {
    newestSeries.clear();
    getComicDetail(id: widget.id).then((res) {
      if (res.status != 0) {
        loading = false;
        AppGlobal.comicThumb = res.data.thumb;
        data = res.data;
        AppGlobal.comicData = data;
        isFavorites = res.data.userFavorites == 1;
        watchLog = data.watchLog;
        newestSeriesNum = res.data.newestSeries;
        if (newestSeriesNum < 9 && newestSeriesNum > 0) {
          for (int x = 1; x <= newestSeriesNum; x++) {
            newestSeries.add(x.toString());
          }
        } else if (newestSeriesNum >= 9) {
          for (int x = 1; x < 5; x++) {
            newestSeries.add(x.toString());
          }
          for (int x = newestSeriesNum - 2; x <= newestSeriesNum; x++) {
            if (x == (newestSeriesNum - 2)) {
              newestSeries.add("・・・");
            }
            newestSeries.add(x.toString());
          }
        }
        comicsEpisode(book_id: data.dataId.toString()).then((value) {
          AppGlobal.blues = value.data;
          getRecommendComicsList(
                  limit: 10, id: widget.id, category: res.data.categories)
              .then((res) {
            recommendList = res.data;
            setState(() {});
          });
        });
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  Widget _episdItem({bool sortAscend = false}) {
    List list = AppGlobal.blues;

    List temp;

    if (sortAscend) {
      temp = list;
    } else {
      temp = [];
      for (var item in AppGlobal.blues) {
        temp.insert(0, item);
      }
    }
    return Container(
      child: Column(
        children: [
          Column(
            children: temp.map((e) {
              var str = CommonUtils.txt("mf");
              bool isLocked = true;

              /// 0 免费
              /// 1 VIP
              /// 2 金币
              /// 3 限时免费
              /// 4 新人免费
              if (e["is_free"] == 0 || e["is_free"] == 3 || e["is_free"] == 4) {
                isLocked = false;
                str = CommonUtils.txt("mf");

                if (kDebugMode) {
                  if (e["is_free"] == 3) {
                    str = CommonUtils.txt('xm');
                  } else if (e["is_free"] == 4) {
                    str = CommonUtils.txt('xrmf');
                  }
                }
              } else if (e["is_free"] == 1) {
                str = CommonUtils.txt("vvp");
              } else if (e["is_free"] == 2 && e["is_pay"] == 1) {
                isLocked = false;

                str = CommonUtils.txt("yyd");
              } else {
                str = "${e["view_money"]}${CommonUtils.txt("jb")}";
              }

              return GestureDetector(
                onTap: () {
                  swichComic(e["episode"]);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  height: ScreenUtil().setWidth(40),
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(25, 25, 25, 1.0),
                    // borderRadius: BorderRadius.all(Radius.circular(2.5)),
                    border: Border(
                        bottom: BorderSide(color: Color(0xff26313b), width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        // constraints: BoxConstraints.tightFor(
                        //     width: ScreenUtil().setWidth(200)),
                        child: Expanded(
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  e["episode_title"].length > 20
                                      ? e["episode_title"]
                                              .toString()
                                              .substring(0, 18) +
                                          '...'
                                      : e["episode_title"],
                                  style: GQStyle.white255_13),
                              isLocked
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(7.5)),
                                      child: LImage('comic_lock',
                                          width: ScreenUtil().setWidth(6),
                                          height: ScreenUtil().setWidth(8)),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: ScreenUtil().setWidth(10)),
                      // Spacer(),
                      StatusBorderText(
                        title: str,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: ScreenUtil().setWidth(4)),
        ],
      ),
    );
  }

  // Widget selectItem(String value) {
  //   return GestureDetector(
  //     onTap: () {
  //       if (value != "・・・") {
  //         if (AppGlobal.vipLevel >= 2) {
  //           AppGlobal.currentReaderRouteExtra = {
  //             'id': data.dataId,
  //             'episode': value,
  //             'title': data.title,
  //             'allEpisode': data.newestSeries,
  //             'type': data.finished
  //           };
  //           context.push(CommonUtils.getRealHash('comicReader/$value'));
  //         } else {
  //           YyShowDialog.showdialog(
  //             context,
  //             title: CommonUtils.txt("ts"),
  //             content: (setDialogState) {
  //               return Text(
  //                 CommonUtils.txt("kthycd"),
  //                 style: TextStyle(
  //                     color: Color.fromRGBO(30, 30, 30, 1),
  //                     fontSize: ScreenUtil().setSp(14),
  //                     decoration: TextDecoration.none),
  //               );
  //             },
  //             cancelText: CommonUtils.txt("qx"),
  //             btnText: CommonUtils.txt("ljkt"),
  //             callBack: () {
  //               context.push('/${Routes.vip}');
  //             },
  //           );
  //         }
  //       } else {
  //         _itemAlertBottom();
  //       }
  //     },
  //     child: Container(
  //       width: ScreenUtil().setWidth(84),
  //       height: ScreenUtil().setWidth(34),
  //       decoration: BoxDecoration(
  //           color: value == watchLog.toString()
  //               ? Color.fromRGBO(255, 77, 11, 1.0)
  //               : Color.fromRGBO(25, 25, 25, 1.0),
  //           borderRadius: BorderRadius.circular(ScreenUtil().setWidth(2.5))),
  //       child: Center(
  //         child: Text(value, style: GQStyle.white234_15_M),
  //       ),
  //     ),
  //   );
  // }

  Widget _btnItem({String icon, String name}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LImage(icon,
            width: ScreenUtil().setWidth(25),
            height: ScreenUtil().setWidth(25)),
        SizedBox(
          width: ScreenUtil().setWidth(7),
        ),
        Text(
          name,
          style: TextStyle(
              color: Color(0xffffffff), fontSize: ScreenUtil().setSp(11)),
        )
      ],
    );
  }

  BackButtonBehavior backButtonBehavior = BackButtonBehavior.none;

  swichComic(int episode) {
    dynamic e =
        AppGlobal.blues.where((element) => element["episode"] == episode).first;

    if (e["is_pay"] == 1 || e["is_free"] == 0) {
      context.push(CommonUtils.getRealHash(
          'comicReader/${widget.id}/$episode/${Uri.encodeComponent(data.title)}'));
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel > 0) {
      context.push(CommonUtils.getRealHash(
          'comicReader/${widget.id}/$episode/${Uri.encodeComponent(data.title)}'));
      return;
    }
    if (e["is_free"] == 1 && AppGlobal.vipLevel < 1) {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt("ts"),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt("kthycd"),
            style: GQStyle.graya3a2a2_13,
          );
        },
        cancelText: CommonUtils.txt("qx"),
        btnText: CommonUtils.txt("ljkt"),
        callBack: () {
          context.push('/${Routes.vip}');
        },
      );
      return;
    }
    if (e["is_free"] == 2) {
      //扣币
      WidgetsBinding.instance.addPostFrameCallback((_) {
        int money =
            Provider.of<HomeConfig>(context, listen: false).member.money;
        bool isInsufficient = money < e["view_money"];
        YyShowDialog.showdialog(context,
            title:
                isInsufficient ? CommonUtils.txt("jbbz") : e["episode_title"],
            btnText: isInsufficient
                ? CommonUtils.txt("qwcz")
                : CommonUtils.txt("gmbzj"), callBack: () {
          if (isInsufficient) {
            context.push('/${Routes.coinRecharge}');
          } else {
            _byComicChapter(episode, e);
          }
        }, content: (setDialogState) {
          return DefaultTextStyle(
              style: GQStyle.graya3a2a2_13,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                      TextSpan(text: CommonUtils.txt("bzjxhf"), children: [
                    TextSpan(
                        text: '${e["view_money"]}${CommonUtils.txt("jb")}',
                        style: GQStyle.jellyCyan_13_M)
                  ]))
                ],
              ));
        });
      });
      setState(() {});
    }
  }

  _byComicChapter(int episode, dynamic e) async {
    await comicChapterBy(book_id: data.dataId, episode: episode).then((value) {
      if (value.status == 1) {
        e["is_pay"] = 1;
        context.push(CommonUtils.getRealHash(
            'comicReader/${widget.id}/$episode/${Uri.encodeComponent(data.title)}'));
      } else {
        CommonUtils.showText(value.msg);
      }
    });
  }

  _downloadChapter() {
    context.push(CommonUtils.getRealHash('comicChooseDownload'));
  }

  @override
  void onCreate() {
    // TODO: implement onCreate

    _pageController = PageController();
    getPageData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy

    _pageController.dispose();
    AppGlobal.blues = [];
    AppGlobal.isAutoBy = false;
  }

  @override
  Widget appbar() {
    return Container();
  }

  Widget _infoPage() {
    Color color = Colors.white;

    bool overLines = false;
    if (descFold) {
      // 如果折叠 计算一下简介的高度
      String yourText =
          '${CommonUtils.txt("jj")}：${data.description ?? "loading"}';

      TextStyle yourStyle = TextStyle(
          color: Color(0xffffffff),
          fontSize: ScreenUtil().setSp(13),
          overflow: TextOverflow.ellipsis,
          decoration: TextDecoration.none);
      final span = TextSpan(text: yourText, style: yourStyle);
      final tp = TextPainter(
          text: span, maxLines: 3, textDirection: TextDirection.ltr);

      double maxWidth = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;

      try {
        tp.layout(maxWidth: maxWidth);
      } catch (e) {
        print(e);
      }

      if (tp.didExceedMaxLines) {
        color = Colors.deepOrange;
        overLines = true;
        var str = span.text;
        print(str);
        // The text has more than three lines.
        // TODO: display the prompt message
        // return Container(color: Colors.red);
      } else {
        // return Text(yourText, style: yourStyle);
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              padding: EdgeInsets.all(GQStyle.pagePadding),
              decoration: BoxDecoration(
                  color: Color(0xFF26313b),
                  borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, ScreenUtil().setWidth(1)),
                        blurRadius: ScreenUtil().setWidth(5))
                  ]),
              child: Column(children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: ScreenUtil().setWidth(50),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(right: GQStyle.pagePadding),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data.title,
                                        style: GQStyle.jellyCyan_18_M),
                                    Text(
                                        '${data.categories.replaceAll(',', ' ')} ${AppGlobal.blues.length}' +
                                            CommonUtils.txt('hua'),
                                        style: GQStyle.graya3a2a2_15),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: ScreenUtil().setWidth(50),
                              color: Color(0xff706e6d),
                            ),
                            Container(
                              constraints: BoxConstraints(
                                minWidth: ScreenUtil().setWidth(80),
                                maxWidth: ScreenUtil().setWidth(80),
                              ),
                              margin: EdgeInsets.only(
                                left: GQStyle.pagePadding,
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(3),
                                    bottom: ScreenUtil().setWidth(3)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: ScreenUtil().setWidth(20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(CommonUtils.txt('llan'),
                                              style: GQStyle.graya3a2a2_11),
                                          // SizedBox(
                                          //     width: ScreenUtil().setWidth(10)),
                                          Text(
                                              '${CommonUtils.renderNumber(data.viewsCount)}',
                                              style: GQStyle.jellyCyan_11),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: ScreenUtil().setWidth(20),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(CommonUtils.txt('sc'),
                                              style: GQStyle.graya3a2a2_11),
                                          // SizedBox(
                                          //     width: ScreenUtil().setWidth(10)),
                                          Text(
                                              '${CommonUtils.renderNumber(data.likesCount)}',
                                              style: GQStyle.jellyCyan_11),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(12)),
                      Text(
                          '${CommonUtils.txt("jj")}：${data.description ?? "loading"}' *
                              1,
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: ScreenUtil().setSp(13),
                              overflow: descFold && overLines
                                  ? TextOverflow.ellipsis
                                  : TextOverflow.visible,
                              decoration: TextDecoration.none),
                          maxLines: descFold && overLines ? 3 : null),
                      descFold && overLines
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  descFold = false;
                                  setState(() {});
                                },
                                child: Text(
                                  CommonUtils.txt('qb'),
                                  style: GQStyle.jellyCyan_13,
                                ),
                              ),
                            )
                          : Container()
                    ])
              ])),
          data.ads.length == 0 || data.ads == null
              ? Container()
              : Padding(
                  padding: EdgeInsets.only(
                      right: GQStyle.pagePadding,
                      left: GQStyle.pagePadding,
                      top: ScreenUtil().setWidth(10)),
                  child: GeneralBanner(
                    data: data.ads,
                    height: 161,
                    // height: (ScreenUtil().setWidth(350) * 300 / 700).ceil(),
                    bottom: 0,
                    radius: 5.0,
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            child: SizedBox(
              height: ScreenUtil().setWidth(50),
              child: Center(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    CommonUtils.txt("wntj"),
                    style: GQStyle.white255_18_M,
                  ),
                ),
              ),
            ),
          ),
          Builder(builder: (context) {
            double _w = (ScreenUtil().screenWidth -
                    GQStyle.pagePadding * 2 -
                    ScreenUtil().setWidth(20)) /
                3;
            return GridView.count(
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: ScreenUtil().setWidth(5),
              crossAxisSpacing: ScreenUtil().setWidth(8.5),
              childAspectRatio: 111 / 202,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              children: recommendList
                  .map((e) => AcgCard(
                        data: Map.from(e)..['content_type'] = 2,
                        replace: true,
                      ))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _episodePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: GQStyle.pagePadding,
              right: GQStyle.pagePadding,
            ),
            height: ScreenUtil().setWidth(40),
            color: Color(0xff26313b),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      (data.status == 1
                              ? CommonUtils.txt("ywj")
                              : CommonUtils.txt("lz")) +
                          '·' +
                          '${CommonUtils.txt("gxz")}$newestSeriesNum${CommonUtils.txt("hua")}',
                      style: GQStyle.white255_15_M,
                    ),
                  ],
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    ascend = !ascend;
                    setState(() {});
                  },
                  child: Container(
                    // color: Colors.red,

                    height: double.infinity,
                    child: Row(
                      children: [
                        Text(
                          CommonUtils.txt("zxu"),
                          style: GQStyle.jellyCyan_11,
                        ),
                        Container(
                          color: GQStyle.cyanColor00edfd,
                          width: 1,
                          height: ScreenUtil().setWidth(7),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(7)),
                        ),
                        Text(
                          CommonUtils.txt("dxu"),
                          style: GQStyle.jellyCyan_11,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          _episdItem(sortAscend: ascend),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(covariant HomeComicInfoPage oldWidget) {
    // if (data.watchLog == 0) {
    //   getPageData();
    // }

    if (AppGlobal.comicData.dataId == data.dataId) {
      data = AppGlobal.comicData;
      isFavorites = data.userFavorites == 1;

      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget pageBody(BuildContext context) {
    double top = MediaQuery.of(context).padding.top;
    // TODO: implement pageBody
    List tags = data == null ? [] : data.tags.split(',');
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: loading || data == null
                      ? PageStatus.loading(mounted)
                      :
                      // CustomScrollView(
                      //     slivers: [
                      //       SliverAppBar(
                      //         leading: Container(),
                      //         expandedHeight: ScreenUtil().setWidth(200),
                      //         collapsedHeight: GQStyle.navbarHegiht + top,
                      //         flexibleSpace: FlexibleSpaceBar(
                      //           background: PlatformAwareNetworkImage(
                      //             url: data.thumb,
                      //           ),
                      //           stretchModes: [
                      //             StretchMode.zoomBackground,
                      //             // StretchMode.blurBackground
                      //           ],
                      //         ),
                      //         stretch: true,
                      //       ),
                      //     ],
                      //   ),
                      NestedScrollView(
                          headerSliverBuilder: (context, res) {
                            return [
                              // SliverToBoxAdapter(
                              //   child: SizedBox(
                              //     width: ScreenUtil().screenWidth,
                              //     height: ScreenUtil().setWidth(300),
                              //     child: PlatformAwareNetworkImage(
                              //       url: data.thumb,
                              //     ),
                              //   ),
                              // ),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: CustomHeaderDelegate(
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                                child: Container(
                                              color: GQStyle.bgColor,
                                            )),
                                            Positioned.fill(
                                              bottom: 2,
                                              child: PlatformAwareNetworkImage(
                                                url: data.thumb,
                                              ),
                                            ),
                                            Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: LImage(
                                                  '',
                                                  color: GQStyle.bgColor,
                                                )),
                                            Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                height: GQStyle.navbarHegiht,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black,
                                                      Color.fromRGBO(
                                                          0, 0, 0, 0.6),
                                                      Colors.transparent
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  )),
                                                ))
                                          ],
                                        ),
                                      ),
                                      minHeight: GQStyle.navbarHegiht + top,
                                      maxHeight: ScreenUtil().setWidth(300))),
                              SliverPersistentHeader(
                                  pinned: true,
                                  delegate: CustomHeaderDelegate(
                                    Container(
                                      color: GQStyle.bgColor,
                                      child: FljSliderBar(
                                        selectStyle: GQStyle.jellyCyan_18_M,
                                        defaultStyle: GQStyle.white255_18_M,
                                        pageController: _pageController,
                                        titles: [
                                          CommonUtils.txt('zp'),
                                          CommonUtils.txt('ml')
                                        ],
                                      ),
                                    ),
                                    minHeight: ScreenUtil().setWidth(53),
                                    maxHeight: ScreenUtil().setWidth(53),
                                  ))
                            ];
                          },
                          body: PageView(
                            controller: _pageController,
                            children: [_infoPage(), _episodePage()],
                          ))),
              loading || data == null
                  ? Container()
                  : Container(
                      color: Color(0xff23262f),
                      margin: EdgeInsets.only(
                          bottom: kIsWeb ? 0 : ScreenUtil().bottomBarHeight),
                      height: ScreenUtil().setWidth(64),
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      userFavorites(type: 2, id: data.dataId)
                                          .then((res) {
                                        if (res != null && res.status != 0) {
                                          isFavorites = !isFavorites;
                                          data.userFavorites =
                                              isFavorites ? 1 : 0;

                                          setState(() {});
                                        } else {
                                          CommonUtils.showText(res.msg);
                                        }
                                      });
                                    },
                                    child: _btnItem(
                                      icon: isFavorites
                                          ? 'comic_collect_s'
                                          : 'comic_collect_n',
                                      name: CommonUtils.txt(
                                        "sc",
                                      ),
                                    ),
                                  ),
                                  // GestureDetector(
                                  //   onTap: () {
                                  //     _downloadChapter();
                                  //   },
                                  //   child: _btnItem(
                                  //       icon: 'comic_download',
                                  //       name: CommonUtils.txt("xz")),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      context.push(CommonUtils.getRealHash(
                                          Routes.kwantsharetousers));
                                    },
                                    child: _btnItem(
                                        icon: 'comic_share_c',
                                        name: CommonUtils.txt('fx')),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              swichComic(
                                  data.watchLog == 0 ? 1 : data.watchLog);
                            },
                            child: Stack(
                              children: [
                                // ClipRRect(
                                //   borderRadius: BorderRadius.circular(
                                //       ScreenUtil().setWidth(5)),
                                //   child: LImage(
                                //     'comic_read_bg',
                                //   ),
                                // ),
                                Positioned.fill(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(5)),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            gradient: GQStyle
                                                .btnGradient_ff00edfd_ffbbe954),
                                      )),
                                ),
                                Container(
                                  width: ScreenUtil().setWidth(190),
                                  child: Center(
                                    child: Text(
                                      data.watchLog == 0
                                          ? CommonUtils.txt("ksyd")
                                          : '${CommonUtils.txt("jxyd")} ${CommonUtils.txt("di")}${data.watchLog}${CommonUtils.txt("hua")}',
                                      style: GQStyle.white255_15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
            height: GQStyle.navbarHegiht,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  child: SizedBox(
                    height: double.infinity,
                    child: LImage(
                      "nav_back_n",
                      width: ScreenUtil().setWidth(25),
                      height: ScreenUtil().setWidth(25),
                    ),
                  ),
                  onTap: () {
                    finish();
                  },
                ),
                // GestureDetector(
                //   child: SizedBox(
                //     height: double.infinity,
                //     child: LImage(
                //       "comic_share",
                //       width: ScreenUtil().setWidth(25),
                //       height: ScreenUtil().setWidth(26),
                //     ),
                //   ),
                //   onTap: () {
                //     context.push(
                //         CommonUtils.getRealHash(Routes.kwantsharetousers));
                //   },
                // ),
              ],
            ),
          )
        ],
      ),
      color: GQStyle.bgColor,
    );
  }
}

class CustomHeaderDelegate extends SliverPersistentHeaderDelegate {
  CustomHeaderDelegate(this.child, {this.minHeight = 50, this.maxHeight = 50});

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
