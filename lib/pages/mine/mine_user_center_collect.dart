import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class MineUserCenterCollect extends StatefulWidget {
  MineUserCenterCollect({Key key}) : super(key: key);

  @override
  State<MineUserCenterCollect> createState() => _MineUserCenterCollectState();
}

class _MineUserCenterCollectState extends State<MineUserCenterCollect> {
  List<Map> labels = [
    {'id': 11, 'name': CommonUtils.txt('ssmj')},
    {'id': 1, 'name': CommonUtils.txt('sping')},
    {'id': 2, 'name': CommonUtils.txt('ll')},
    {'id': 6, 'name': CommonUtils.txt('mt')},
    // {'id': 7, 'name': CommonUtils.txt('tiez')},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GQStyle.bgColor,
      child: YyqDiamondNav(
        type: YyqDiamondNavEnum.cover,
        titles: labels.map<String>((e) => e["name"]).toList(),
        pages: labels
            .map(
              (e) => MineUserCenterCollectChild(
                type: e["id"],
              ),
            )
            .toList(),
      ),
    );
  }
}

class MineUserCenterCollectChild extends StatefulWidget {
  final int type;

  MineUserCenterCollectChild({Key key, this.type}) : super(key: key);
  @override
  State createState() => _MineUserCenterCollectChildState();
}

class _MineUserCenterCollectChildState
    extends State<MineUserCenterCollectChild> {
  List<dynamic> dataList;
  bool isHud = true;
  int page = 1;
  bool netError = false;
  bool noMore = false;
  String last_ix = "";

  _getData() async {
    var result =
        await getUserFavor(page: page, type: widget.type, last_ix: last_ix);
    if (result == null) {
      netError = true;
      setState(() {});
    }
    List<dynamic> st = result['data']["list"];
    last_ix =
        result['data']["last_ix"] == null ? "" : result['data']["last_ix"];
    if (page == 1) {
      noMore = false;
      dataList = st;
    } else if (st.length > 0) {
      dataList.addAll(st);
    } else {
      noMore = true;
    }
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
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              CommonUtils.debugPrint(t);
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

  _mvList() {
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
              mainAxisSpacing: 25,
              crossAxisSpacing: 19,
              childAspectRatio: 219 / 420,
            ),
            itemBuilder: (context, index) {
              var t = dataList[index];
              return GestureDetector(
                onTap: () {
                  context.push(CommonUtils.getRealHash(
                      'comicsdetail/${t["id"] ?? "0"}'));
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
                      ],
                    ),
                  ],
                ),
              );
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

  Widget _tieZList() {
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
        return _tieZList();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return netError
        ? PageStatus.noNetWork(onTap: () {
            netError = false;
            _getData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : (dataList.length > 0 ? getListWidget() : PageStatus.noData());
  }
}
