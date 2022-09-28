import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class CommunityRecommend extends StatefulWidget {
  CommunityRecommend({Key key}) : super(key: key);

  @override
  State<CommunityRecommend> createState() => _CommunityRecommendState();
}

class _CommunityRecommendState extends State<CommunityRecommend> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];
  List<dynamic> topics = [];
  int setIndex = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  _getData({bool show = false}) {
    if (show) CommonUtils.startLoadGIF();
    var topic_id = topics.length == 0 ? "0" : topics[setIndex]["id"].toString();
    communityList(cate: "recommend", page: page, topic_id: topic_id)
        .then((res) {
      if (show) BotToast.closeAllLoading();
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data["posts"];
      if (page == 1) {
        noMore = false;
        topics = res.data["topics"];
        data = st;
      } else if (st.length > 0) {
        data.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            networkErr = false;
            _getData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : Column(
                children: [
                  SizedBox(
                    height: ScreenUtil().setWidth(15),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(50),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: GQStyle.pagePadding,
                          vertical: ScreenUtil().setWidth(15),
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: topics.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setIndex = index;
                              page = 1;
                              _getData(show: true);
                            },
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(10)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(13)),
                              height: ScreenUtil().setWidth(30),
                              decoration: BoxDecoration(
                                gradient: setIndex == index
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFF00baef),
                                          Color(0xFF00edfa)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      )
                                    : null,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(15))),
                                border: setIndex == index
                                    ? null
                                    : Border.all(
                                        color: Color(0xffffffff),
                                        width: ScreenUtil().setWidth(0.5)),
                              ),
                              child: Center(
                                child: Text(
                                  topics[index]["name"] ?? "",
                                  style: setIndex == index
                                      ? GQStyle.white255_13
                                      : GQStyle.gray163_13,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                    child: PullRefreshList(
                      onRefresh: () {
                        page = 1;
                        _getData();
                      },
                      onLoading: () {
                        page++;
                        _getData();
                      },
                      isAll: noMore,
                      child: MasonryGridView.builder(
                        padding: EdgeInsets.only(
                          left: GQStyle.pagePadding,
                          right: GQStyle.pagePadding,
                          bottom: GQStyle.pagePadding,
                        ),
                        gridDelegate:
                            SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        mainAxisSpacing: ScreenUtil().setWidth(15),
                        crossAxisSpacing: ScreenUtil().setWidth(8),
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          List medias = data[index]["medias"] ?? [];
                          dynamic ft = medias.length > 0 ? medias.first : null;
                          double h = 0;
                          double w = (ScreenUtil().screenWidth -
                                  GQStyle.pagePadding * 2 -
                                  ScreenUtil().setWidth(8)) /
                              2;
                          if (ft != null) {
                            double widt =
                                double.parse(ft["thumb_width"].toString()) ??
                                    100;
                            double hidt =
                                double.parse(ft["thumb_height"].toString()) ??
                                    100;
                            h = w / widt * hidt;
                          }
                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context.push(
                                  "/communitypostdetail/${data[index]["id"]}");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF23262f),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(5)),
                                ),
                              ),
                              child: Column(
                                children: [
                                  ft == null
                                      ? Container()
                                      : SizedBox(
                                          height: h,
                                          child: Stack(
                                            children: [
                                              PlatformAwareNetworkImage(
                                                url: ft["type"] == 2
                                                    ? ft["cover"] ?? ""
                                                    : ft["media_url"] ?? "",
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(
                                                        ScreenUtil()
                                                            .setWidth(5)),
                                                    topRight: Radius.circular(
                                                        ScreenUtil()
                                                            .setWidth(5))),
                                              ),
                                              ft["type"] == 2
                                                  ? Center(
                                                      child: LImage("v_play_n",
                                                          width: ScreenUtil()
                                                              .setWidth(30),
                                                          height: ScreenUtil()
                                                              .setWidth(30)),
                                                    )
                                                  : Container(),
                                              Positioned(
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: ScreenUtil()
                                                        .setWidth(10),
                                                    top: ScreenUtil()
                                                        .setWidth(15),
                                                  ),
                                                  height:
                                                      ScreenUtil().setWidth(40),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            0, 0, 0, 0),
                                                        Color.fromRGBO(
                                                            0, 0, 0, 0.7)
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      context.push(
                                                          "/communitytagdetail/${data[index]["topic"]["id"]}");
                                                    },
                                                    child: Text(
                                                      "#${data[index]["topic"]["name"] ?? ""}",
                                                      style:
                                                          GQStyle.blue80_13_M,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: ScreenUtil().setWidth(10),
                                      right: ScreenUtil().setWidth(10),
                                      top: ScreenUtil().setWidth(12),
                                      bottom: ScreenUtil().setWidth(15),
                                    ),
                                    child: Container(
                                      child: Text(
                                        data[index]["title"] ?? "",
                                        style: GQStyle.white255_13,
                                        maxLines: 100,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: ScreenUtil().setWidth(18),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(10)),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        context.push(
                                            '/mineUserCenter/${data[index]["user"]["aff"]}');
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: ScreenUtil().setWidth(18),
                                            child: PlatformAwareNetworkImage(
                                              background: GQStyle.bgColor,
                                              url: data[index]["user"]
                                                      ["thumb"] ??
                                                  "",
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(9))),
                                            ),
                                          ),
                                          SizedBox(
                                              width: ScreenUtil().setWidth(4)),
                                          Expanded(
                                            child: Text(
                                              data[index]["user"]["nickname"] ??
                                                  "",
                                              style: GQStyle.gray203_12,
                                              maxLines: 1,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(11))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              );
  }
}
