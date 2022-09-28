import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_focus.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/pages/community/community_recommend.dart';
import 'package:qypj/pages/mine/mine_user_center_post.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';

class FansFollowIndex extends StatefulWidget {
  FansFollowIndex({Key key}) : super(key: key);

  @override
  State<FansFollowIndex> createState() => _FansFollowIndexState();
}

class _FansFollowIndexState extends State<FansFollowIndex> {
  List<String> labels = [
    CommonUtils.txt("yhu"),
    CommonUtils.txt("htt"),
    CommonUtils.txt("fbdtz"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: Stack(children: [
        Column(
          children: [
            SizedBox(
                height: kIsWeb
                    ? ScreenUtil().setWidth(10)
                    : MediaQuery.of(context).padding.top),
            Container(
              height: GQStyle.navbarHegiht,
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: LImage(
                          "nav_back_n",
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(20),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Text(
                      CommonUtils.txt("wdgz"),
                      style: GQStyle.white255_18_B,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: YyqDiamondNav(
                labelPadding: GQStyle.pagePadding,
                titles: labels,
                pages: [
                  FansListPage(),
                  FollowedListPage(),
                  MineUserCenterPost(),
                ],
                defaultStyle: GQStyle.white255_15_M,
                selectStyle: GQStyle.blue80_15_M,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class FansListPage extends StatefulWidget {
  FansListPage({Key key}) : super(key: key);

  @override
  State<FansListPage> createState() => _FansListPageState();
}

class _FansListPageState extends State<FansListPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];
  String last_ix = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() {
    userListFollow(page: page, last_ix: last_ix).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data["list"]);
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
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
            : data.length == 0
                ? PageStatus.noData()
                : PullRefreshList(
                    onRefresh: () {
                      page = 1;
                      last_ix = "";
                      _getData();
                    },
                    onLoading: () {
                      page++;
                      _getData();
                    },
                    isAll: noMore,
                    child: ListView(
                      padding: EdgeInsets.all(GQStyle.pagePadding),
                      children: data.map((e) {
                        return _fansItem(e);
                      }).toList(),
                    ),
                  );
  }

  Widget _fansItem(dynamic e) {
    return Container(
      padding: EdgeInsets.only(top: ScreenUtil().setWidth(10)),
      child: Column(children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.push('/mineUserCenter/${e["aff"]}');
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  child: PlatformAwareNetworkImage(
                    url: e["thumb"] ?? "",
                    borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(25)),
                    ),
                  ),
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setWidth(50)),
              SizedBox(width: ScreenUtil().setWidth(9.5)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e["nickname"]}', style: GQStyle.white255_15_M),
                    Text(
                      '${e["exp"] ?? 0}${CommonUtils.txt("jfen")}',
                      style: TextStyle(
                        color: Color(0xFFc6c7d9),
                        fontSize: ScreenUtil().setSp(14),
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {
                    communityFollowUser(aff: e["aff"].toString()).then((res) {
                      if (res.status == 1) {
                        data.remove(e);
                        setState(() {});
                      } else {
                        CommonUtils.showText(res.msg);
                      }
                    });
                  },
                  child: e["is_follow"] == 1
                      ? Container(
                          width: ScreenUtil().setWidth(65),
                          height: ScreenUtil().setWidth(25),
                          decoration: BoxDecoration(
                              color: GQStyle.cyanColor00edfd,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(12.5))),
                          child: Center(
                              child: Text(CommonUtils.txt("qxgz"),
                                  style: GQStyle.white11)),
                        )
                      : Container(
                          width: ScreenUtil().setWidth(65),
                          height: ScreenUtil().setWidth(25),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: GQStyle.cyanColor00edfd,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(12.5))),
                          child: Center(
                              child: Text(CommonUtils.txt("jgz"),
                                  style: GQStyle.jellyCyan_11)),
                        ))
            ],
          ),
        ),
        SizedBox(height: ScreenUtil().setWidth(10)),
        Container(
          color: Color.fromARGB(25, 255, 255, 255),
          height: 0.5,
        )
      ]),
    );
  }
}

class FollowedListPage extends StatefulWidget {
  FollowedListPage({Key key}) : super(key: key);

  @override
  State<FollowedListPage> createState() => _FollowedListPageState();
}

class _FollowedListPageState extends State<FollowedListPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> data = [];
  String last_ix = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  _getData() {
    focusTops(page: page, last_ix: last_ix).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = List.from(res.data);
      // last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
      if (page == 1) {
        noMore = false;
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
            : data.length == 0
                ? PageStatus.noData()
                : PullRefreshList(
                    onRefresh: () {
                      page = 1;
                      last_ix = "";
                      _getData();
                    },
                    onLoading: () {
                      page++;
                      _getData();
                    },
                    isAll: noMore,
                    child: GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding,
                            vertical: ScreenUtil().setWidth(10)),
                        itemCount: data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: ScreenUtil().setWidth(10),
                          crossAxisSpacing: ScreenUtil().setWidth(20),
                          childAspectRatio: 204 / 148,
                        ),
                        itemBuilder: (context, index) {
                          var e = data[index];
                          return _followItem(e);
                        }),
                  );
  }

  Widget _followItem(dynamic e) {
    double _w = (ScreenUtil().screenWidth -
            GQStyle.pagePadding * 2 -
            ScreenUtil().setWidth(10)) /
        2;
    return Container(
      width: _w,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              context.push("/communitytagdetail/${e["id"]}");
            },
            child: Container(
              height: _w / 170 * 85,
              child: Stack(
                children: [
                  PlatformAwareNetworkImage(
                    url: e["bg_thumb"] ?? "",
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(5))),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.black38,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(5))),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          e["name"] ?? "",
                          style: GQStyle.white18semibold,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(2)),
                      Center(
                        child: Text(
                          "${e["post_num"] ?? 0}${CommonUtils.txt("tiez")}",
                          style: GQStyle.white_13,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(8.5)),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              //话题关注/取消关注
              communityFollowTopic(topic_id: e["id"].toString()).then((res) {
                if (res.status == 1) {
                  data.remove(e);
                  setState(() {});
                } else {
                  CommonUtils.showText(res.msg);
                }
              });
            },
            child: Container(
              width: ScreenUtil().setWidth(75),
              height: ScreenUtil().setWidth(25),
              decoration: BoxDecoration(
                  color: e["is_follow"] == 1
                      ? Color(0xFF67e0b9)
                      : Colors.transparent,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(25 / 2))),
                  border: Border.all(
                      color: e["is_follow"] == 1
                          ? Colors.transparent
                          : Color(0xFF60B2DC),
                      width: ScreenUtil().setWidth(0.5))),
              child: Center(
                child: Text(
                  e["is_follow"] == 1
                      ? CommonUtils.txt("qxgz")
                      : "+ ${CommonUtils.txt("gz")}",
                  style:
                      e["is_follow"] == 1 ? GQStyle.white11 : GQStyle.blue80_11,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
