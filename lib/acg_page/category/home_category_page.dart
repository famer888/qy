import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/picture_double_colume_card.dart';
import 'package:qypj/views/yyq/cards/video_double_colume_card.dart';

class HomeCategoryPage extends BaseWidget {
  HomeCategoryPage({Key key, this.id}) : super(key: key);
  String id = "0";

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomeCategoryPageState();
  }
}

class _HomeCategoryPageState extends BaseWidgetState<HomeCategoryPage> {
  int page = 1;
  bool isHud = true;
  List<dynamic> values = [];
  bool noMore = false;
  bool netWorkErr = false;
  List<dynamic> selecteds = [];
  String sort = "new";
  String type = "";
  String categories = "";
  int contentType = 1; // 内容类型 1漫画 2动漫 3视频 4色图
  int loadedContentType = 0; // 内容类型 1漫画 2动漫 3视频 4色图

  dynamic contentParam = {};

  @override
  void onCreate() {
    // TODO: implement onCreate
    _getClasses();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  _getClasses() async {
    // Basic t = await filtrateStyle();

    // selecteds = t.data;

    // selecteds.insert(0, {
    //   'value': 'name',
    //   'items': [
    //     {'label': '漫画', 'value': 1},
    //     {'label': '动漫', 'value': 2},
    //     {'label': '视频', 'value': 3},
    //     {'label': '色图', 'value': 4}
    //   ]
    // });
    _getData();
  }

  _getData({bool showHud = false}) async {
    if (showHud) CommonUtils.startLoadGIF(tip: CommonUtils.txt("jzz"));

    Basic t;
    switch (contentType) {
      case 1:
        t = await comcList(param: contentParam, page: page);
        break;
      case 2:
        t = await cartoonList(param: contentParam, page: page);
        break;
      case 3:
        t = await videoList(param: contentParam, page: page);
        break;
      case 4:
        t = await pictureList(param: contentParam, page: page);
        break;
      default:
    }
    if (showHud) BotToast.closeAllLoading();
    if (t.data == null) {
      netWorkErr = true;
      setState(() {});
      return;
    }
    if (page == 1) {
      noMore = false;
      values = t.data["list"];

      if (loadedContentType != contentType) {
        selecteds = t.data['cate'];
        for (var item in selecteds) {
          contentParam[item['value']] = item['items'].first['value'];
        }
        selecteds.insert(0, {
          'value': 'name',
          'items': [
            {'label': '漫画', 'value': 1},
            {'label': '动漫', 'value': 2},
            {'label': '视频', 'value': 3},
            {'label': '色图', 'value': 4}
          ]
        });

        loadedContentType = contentType;
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
  Widget appbar() {
    return Container(
      color: GQStyle.naviColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
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
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                ),
              ),
              onTap: () {
                finish();
              },
            ),
            Text(CommonUtils.txt('fl'), style: GQStyle.white255_18_B),
            GestureDetector(
              child: SizedBox(
                height: double.infinity,
                child: LImage(
                  "search.cyan",
                  width: ScreenUtil().setWidth(20),
                  height: ScreenUtil().setWidth(20),
                ),
              ),
              onTap: () {
                context.push('/' + Routes.search);
              },
            ),
          ],
        ),
      ),
    );
  }

  _comicPage() {
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
      children: values
          .map((e) => GestureDetector(
                onTap: () {
                  // CommonUtils.showText(
                  //     '${e["content_type"]}');

                  context.push(CommonUtils.getRealHash(
                      'comicsdetail/${e["id"] ?? "0"}'));
                  // if (e["content_type"] == 2) {
                  //   context.push(CommonUtils.getRealHash(
                  //       'comicsdetail/${e["id"] ?? "0"}'));
                  // } else if (e["content_type"] == 6) {
                  //   context.push(CommonUtils.getRealHash(
                  //       'atlasDetail/${e["id"] ?? "0"}'));
                  // } else if (e["content_type"] == 3) {
                  //   context.push(CommonUtils.getRealHash(
                  //       'novelDetail/${e["id"] ?? "0"}'));
                  // }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: _w / 111 * 152,
                      child: Stack(
                        children: [
                          PlatformAwareNetworkImage(
                              url: clipImageUrl(CommonUtils.getThumb(e),
                                  inputWidth: ScreenUtil().setWidth(128)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          // Positioned(
                          //     left: ScreenUtil()
                          //         .setWidth(7.5),
                          //     bottom: ScreenUtil()
                          //         .setWidth(7.5),
                          //     child: CommonUtils.identifyWidget(
                          //         e,
                          //         isHideCoin:
                          //             e["content_type"] ==
                          //                     2 ||
                          //                 e["content_type"] ==
                          //                     6))
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  e["title"] ?? "loading",
                                  style: GQStyle.white13,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      LImage('ll_zb',
                                          width: 12, color: Color(0xffffffff)),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(3.5)),
                                      Text(
                                        CommonUtils.renderNumber(
                                            e['favorites']),
                                        style: GQStyle.graya3a2a2_10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      LImage('comic_eye',
                                          width: 13,
                                          height: 12,
                                          color: Color(0xffffffff)),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(3.5)),
                                      Text(
                                        CommonUtils.renderNumber(
                                            e['views_count']),
                                        style: GQStyle.graya3a2a2_10,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  _videoPage() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: ScreenUtil().setWidth(4.5),
      crossAxisSpacing: ScreenUtil().setWidth(8),
      childAspectRatio: 171 / 131.5,
      scrollDirection: Axis.vertical,
      children: values.map((e) => VideoDoubleColumeCard(data: e)).toList(),
    );
  }

  _picPage() {
    return GridView.count(
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: ScreenUtil().setWidth(4.5),
      crossAxisSpacing: ScreenUtil().setWidth(10),
      childAspectRatio: 171 / 264.5,
      scrollDirection: Axis.vertical,
      children: values.map((e) => PictureDoubleColumeCard(data: e)).toList(),
    );
  }

  _subPage() {
    switch (loadedContentType) {
      case 1:
        return _comicPage();
        break;
      case 2:
        return _videoPage();
        break;
      case 3:
        return _videoPage();
        break;
      case 4:
        return _picPage();
        break;
      default:
    }
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody

    return netWorkErr
        ? PageStatus.noNetWork(onTap: () {
            netWorkErr = false;
            setState(() {});
            _getData();
          })
        : (isHud
            ? PageStatus.loading(mounted)
            : Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(10)),
                    child: Column(
                      children: selecteds.map((e) {
                        List<dynamic> items = e["items"];
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(18),
                              ),
                              height: ScreenUtil().setWidth(33.5),
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: items.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    var flag = false;
                                    if (e["value"] == "name") {
                                      flag =
                                          contentType == items[index]["value"];
                                    } else {
                                      flag = contentParam[e['value']] ==
                                          items[index]["value"];
                                    }

                                    // if (e["value"] == "sort") {
                                    //   flag = sort == items[index]["value"];
                                    // } else if (e["value"] == "type") {
                                    //   flag = type == items[index]["value"];
                                    // } else if (e["value"] == "name") {
                                    //   flag =
                                    //       contentType == items[index]["value"];
                                    // } else {
                                    //   flag =
                                    //       categories == items[index]["value"];
                                    // }
                                    return Row(children: [
                                      GestureDetector(
                                        onTap: () {
                                          var result = items[index]["value"];
                                          if (e["value"] == "name") {
                                            contentType = result;
                                          } else {
                                            contentParam[e['value']] = result;

                                            // categories = result;
                                          }
                                          page = 1;
                                          _getData(showHud: true);
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                "${items[index]["label"] ?? "loading"}",
                                                style: flag
                                                    ? TextStyle(
                                                        color:
                                                            Color(0xff00edfd),
                                                        fontSize: ScreenUtil()
                                                            .setSp(13),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        decoration:
                                                            TextDecoration.none)
                                                    : TextStyle(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontSize: ScreenUtil()
                                                            .setSp(13),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        overflow: TextOverflow
                                                            .visible,
                                                        decoration:
                                                            TextDecoration
                                                                .none)),
                                            SizedBox(
                                                width:
                                                    ScreenUtil().setWidth(13),
                                                height:
                                                    ScreenUtil().setWidth(3),
                                                child: flag
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                        color:
                                                            Color(0xfffffc3a),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        1.5)),
                                                      ))
                                                    : Container())
                                          ],
                                        ),
                                      ),
                                      index == items.length - 1
                                          ? Container()
                                          : SizedBox(
                                              width: ScreenUtil().setWidth(25))
                                    ]);
                                  }),
                            ),
                            // SizedBox(height: ScreenUtil().setWidth(15))
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: values.length == 0
                        ? PageStatus.noData()
                        : PullRefreshList(
                            isAll: noMore,
                            onRefresh: () {
                              page = 1;
                              _getData();
                            },
                            onLoading: () {
                              page += 1;
                              _getData();
                            },
                            child: _subPage()),
                  )
                ],
              ));
  }
}
