import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/nakedchat_page.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/pages/community/community_post.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/yyq/cards/acg_card.dart';
import 'package:qypj/views/yyq/cards/acg_double_colume_card.dart';

class SearchList extends StatefulWidget {
  SearchList({Key key, this.type, this.value}) : super(key: key);
  String value;
  int type;
  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool isHud = true;
  int page = 1;
  int limit = 18;
  List searchData = [];
  bool isAll = false;
  bool netError = false;
  @override
  void initState() {
    super.initState();
    getSearchList();
  }

  getSearchList() async {
    var res;
    switch (widget.type) {
      case 0:
        res = await manjSearch(page: page, limit: limit, word: widget.value);
        break;
      case 1:
        res = await videoSearch(page: page, limit: limit, word: widget.value);
        break;
      case 2:
        res = await videoSearch(
            page: page, limit: limit, word: widget.value, type: 2);
        break;
      case 3:
        res = await comicsSearch(page: page, limit: limit, word: widget.value);
        break;
      case 4:
        res = await novelSearch(page: page, limit: limit, word: widget.value);
        break;
      case 5:
        res = await searchPhoto(page: page, limit: limit, word: widget.value);
        break;
      case 6:
        res = await searchSisters(page: page, limit: limit, word: widget.value);
        break;
      case 7:
        res =
            await searchCommunity(page: page, limit: limit, word: widget.value);
        break;
      default:
        res = await searchChats(page: page, limit: limit, word: widget.value);
        break;
    }
    if (res["data"] == null && searchData.length == 0) {
      netError = true;
      setState(() {});
      return;
    }
    if (res['status'] != 0) {
      List resdata = res['data'] == null ? [] : res['data'];
      if (page == 1) {
        searchData = resdata;
      } else if (resdata.length > 0) {
        searchData.addAll(resdata);
      } else {
        isAll = true;
      }
      isHud = false;
      if (mounted) {
        setState(() {});
      }
    } else {
      CommonUtils.showText(res['msg']);
    }
  }

  _ssMJList() {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(4)) /
        2;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(8),
          childAspectRatio: 171 / 131.5,
        ),
        itemBuilder: (context, index) {
          var e = searchData[index];
          return GestureDetector(
            onTap: () {
              context.push(
                  CommonUtils.getRealHash('topicsmallvideodetail/${e["id"]}'));
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
                                    "${CommonUtils.renderFixedNumber(e["views_count"] ?? 0)}${CommonUtils.txt("cbf")}",
                                    style: GQStyle.white255_11),
                                Spacer(),
                                Text(
                                    CommonUtils.txt('gon') +
                                        "${e["mv_count"] ?? 0}" +
                                        CommonUtils.txt('jishu'),
                                    style: GQStyle.white255_11),
                                SizedBox(width: ScreenUtil().setWidth(5))
                              ],
                            ),
                          ),
                        )
                      ],
                    )),
                    // Positioned(
                    //     left: ScreenUtil().setWidth(7.5),
                    //     top: ScreenUtil().setWidth(7.5),
                    //     child: CommonUtils.identifyWidget(e))
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
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(8),
          childAspectRatio: 171 / 131.5,
        ),
        itemBuilder: (context, index) {
          var e = searchData[index];
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
                                    "${CommonUtils.renderFixedNumber(e["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
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
                    // Positioned(
                    //     left: ScreenUtil().setWidth(7.5),
                    //     top: ScreenUtil().setWidth(7.5),
                    //     child: CommonUtils.identifyWidget(e))
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
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisSpacing: ScreenUtil().setWidth(12),
          childAspectRatio: 110 / 175,
        ),
        itemBuilder: (context, index) {
          var t = searchData[index];
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
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(20)) /
        3;
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(8),
          childAspectRatio: 111 / 202.5,
        ),
        itemBuilder: (context, index) {
          var e = searchData[index];
          return AcgCard(data: Map.from(e)..['content_type'] = 2);
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
            vertical: ScreenUtil().setWidth(10)),
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisSpacing: ScreenUtil().setWidth(12),
          childAspectRatio: 219 / 388,
        ),
        itemBuilder: (context, index) {
          var t = searchData[index];
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
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Text(t["title"] ?? "loading", style: GQStyle.white255_14),
                    SizedBox(height: ScreenUtil().setWidth(3.5)),
                    Text(
                      t["finished"] == 1
                          ? "${CommonUtils.txt("wj")} ${CommonUtils.txt("gng")}${t["series"]}${CommonUtils.txt("hua")}"
                          : "${CommonUtils.txt("gxz")}${t["series"]}${CommonUtils.txt("hua")}",
                      style: GQStyle.gray128_11,
                    )
                  ],
                ),
                Positioned(right: 0, top: 0, child: CommonUtils.identiWget(t))
              ],
            ),
          );
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
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(4.5),
          crossAxisSpacing: ScreenUtil().setWidth(10),
          childAspectRatio: 171 / 264.5,
        ),
        itemBuilder: (context, index) {
          var t = searchData[index];
          return GestureDetector(
              onTap: () {
                context.push(
                    CommonUtils.getRealHash('atlasDetail/${t["id"] ?? "0"}'));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: _w / 171 * 231,
                        child: PlatformAwareNetworkImage(
                            url: clipImageUrl(CommonUtils.getThumb(t),
                                inputWidth: ScreenUtil().setWidth(171)),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      Positioned.fill(
                          child: Column(
                        children: [
                          Spacer(),
                          Container(
                            height: ScreenUtil().setWidth(40),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color.fromRGBO(0, 0, 0, 0.6),
                                  Colors.transparent,
                                ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter)),

                            // child: ,
                          )
                        ],
                      )),
                      Positioned(
                          left: ScreenUtil().setWidth(7.5),
                          bottom: ScreenUtil().setWidth(7.5),
                          child: CommonUtils.identifyWidget(t))
                    ],
                  ),
                  // SizedBox(height: ScreenUtil().setWidth(3.5)),
                  SizedBox(height: ScreenUtil().setWidth(3.5)),

                  Expanded(
                    child: Center(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(t["title"] ?? "loading",
                            style: GQStyle.white255_13),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  _yueMeiList() {
    return GridView.builder(
        cacheExtent: ScreenUtil().screenHeight * 5,
        padding: EdgeInsets.symmetric(
            horizontal: GQStyle.pagePadding,
            vertical: ScreenUtil().setWidth(10)),
        itemCount: searchData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: ScreenUtil().setWidth(12),
          crossAxisSpacing: ScreenUtil().setWidth(12),
          childAspectRatio: 340 / 450,
        ),
        itemBuilder: (context, index) {
          var t = searchData[index];
          return Container();
        });
  }

  _chatMeiList() {
    return GridView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: GQStyle.pagePadding, vertical: ScreenUtil().setWidth(10)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: ScreenUtil().setWidth(12),
        crossAxisSpacing: ScreenUtil().setWidth(12),
        childAspectRatio: 340 / 540,
      ),
      itemBuilder: (BuildContext context, int index) {
        var t = searchData[index];
        return NakedchatItemWidget(
          item: t,
        );
      },
      itemCount: searchData.length,
      shrinkWrap: true,
    );
  }

  _communityList() {
    return ListView.builder(
        itemCount: 1, //标签+帖子
        itemBuilder: (context, index) {
          // if (topics.length > 0 && index == 0) {
          //   return CommunityTags(data: topics);
          // }
          return CommunityPost(
            data: searchData,
            showHead: false,
            noHead: true,
          );
        });
  }

  Widget _getListWidget() {
    switch (widget.type) {
      case 0:
        return _ssMJList();
        break;
      case 1:
        return _videoList();
        break;
      case 2:
        return _mvList();
        break;
      case 3:
        return _comicsList();
        break;
      case 4:
        return _novelList();
        break;
      case 5:
        return _meiPNGList();
        break;
      case 6:
        return _yueMeiList();
        break;
      case 7:
        return _communityList();
        break;
      default:
        return _chatMeiList();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return netError
        ? PageStatus.noNetWork(onTap: () {
            page = 1;
            getSearchList();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : (searchData.length == 0
                ? PageStatus.noData()
                : PullRefreshList(
                    onRefresh: () {
                      page = 1;
                      isAll = false;
                      getSearchList();
                    },
                    onLoading: () {
                      page++;
                      getSearchList();
                    },
                    child: _getListWidget(),
                    isAll: isAll,
                  ));
  }
}
