import 'package:flutter/material.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_bit_post.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/utils/pageviewmixin.dart';

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
    {'id': 14, 'name': CommonUtils.txt('tiezt')},
    {'id': 15, 'name': CommonUtils.txt('zhoz')},
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
            child: YyqDiamondNav(
              titles: tabList.map<String>((e) => e["name"]).toList(),
              pages: tabList
                  .map((e) => PageViewMixin(
                        child: BuyList(
                          type: e['id'],
                        ),
                      ))
                  .toList(),
              defaultStyle: GQStyle.white255_15_M,
              selectStyle: GQStyle.blue80_15_M,
              navColor: GQStyle.bgColor,
              inedxFunc: (index) {
                currentTab = index;
                setState(() {});
              },
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
            padding: EdgeInsets.symmetric(
                horizontal: GQStyle.pagePadding, vertical: 10.w),
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
                                "${CommonUtils.renderFixedNumber(t["play_ct"] ?? 0)}${CommonUtils.txt("cbf")}",
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

  Widget _postList() {
    return PullRefreshList(
      isAll: noMore,
      onRefresh: () {
        page = 1;
        _getData();
      },
      onLoading: () {
        page++;
        _getData();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          dynamic e = dataList[index];
          List medias = e["medias"] ?? [];
          List tmp = medias.length > 3 ? medias.sublist(0, 3) : medias;
          return Container(
            margin: EdgeInsets.only(
                left: GQStyle.pagePadding, right: GQStyle.pagePadding),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (e["status"] == 1) {
                  context.push("/communitypostdetail/${e["id"]}");
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${RelativeDateFormat.format(DateTime.parse(e["created_at"] ?? ""))}",
                      style: GQStyle.gray102_14),
                  Offstage(
                    offstage: false,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setWidth(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(10),
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                            color: Color(0xFF60B2DC),
                            width: ScreenUtil().setWidth(2),
                          )),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            Text.rich(TextSpan(children: [
                              e["is_best"] == 1
                                  ? WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(2)),
                                        child: Container(
                                          height: ScreenUtil().setWidth(16),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  ScreenUtil().setWidth(5)),
                                          child: Text(
                                            CommonUtils.txt("jhua"),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(11),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          decoration: BoxDecoration(
                                              gradient: GQStyle
                                                  .btnGradient_e4b191_f6dec7,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(2)))),
                                        ),
                                      ))
                                  : TextSpan(),
                              TextSpan(
                                  text: e["title"] ?? "",
                                  style: GQStyle.white255_15)
                            ])),
                            tmp.length > 0
                                ? GridView.count(
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setWidth(12)),
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: ScreenUtil().setWidth(7),
                                    crossAxisSpacing: ScreenUtil().setWidth(7),
                                    childAspectRatio: 1.0,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: tmp
                                        .asMap()
                                        .keys
                                        .map((x) => Stack(
                                              children: [
                                                PlatformAwareNetworkImage(
                                                  url: tmp[x]["type"] == 2
                                                      ? tmp[x]["cover"] ?? ""
                                                      : tmp[x]["media_url"] ??
                                                          "",
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          ScreenUtil()
                                                              .setWidth(5))),
                                                ),
                                                tmp[x]["type"] == 2
                                                    ? Center(
                                                        child: LImage(
                                                            "v_play_n",
                                                            width: ScreenUtil()
                                                                .setWidth(30),
                                                            height: ScreenUtil()
                                                                .setWidth(30)),
                                                      )
                                                    : Container(),
                                                //大于3张图并且最后一图显示剩余多少张
                                                x == 2 && medias.length > 3
                                                    ? Positioned(
                                                        right: ScreenUtil()
                                                            .setWidth(6),
                                                        bottom: ScreenUtil()
                                                            .setWidth(6),
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          5)),
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0.5),
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            2))),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              "+${medias.length - 3}",
                                                              style: GQStyle
                                                                  .white255_12,
                                                            ),
                                                          ),
                                                        ))
                                                    : Container()
                                              ],
                                            ))
                                        .toList(),
                                  )
                                : Container(),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      context.push(
                                          "/communitytagdetail/${e["topic"]["id"]}");
                                    },
                                    child: Text(
                                      "#${e["topic"]["name"] ?? ""}",
                                      style: GQStyle.blue96_13_M,
                                    ),
                                  ),
                                  Text(
                                    "${CommonUtils.renderFixedNumber(e["comment_num"] ?? 0)}${CommonUtils.txt("tpl")} ｜ ${CommonUtils.renderFixedNumber(e["view_num"] ?? 0)}${CommonUtils.txt("llan")} ｜ ${CommonUtils.renderFixedNumber(e["like_num"] ?? 0)}${CommonUtils.txt("dz")}",
                                    style: GQStyle.gray163_11,
                                  )
                                ]),
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            e["status"] == 2
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setWidth(10)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(CommonUtils.txt("bjyy") + "：",
                                            style: GQStyle.red255_11),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(5)),
                                        Text(
                                          e["refuse_reason"],
                                          style: GQStyle.red255_11,
                                          maxLines: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                : (e["status"] == 0
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            bottom: ScreenUtil().setWidth(10)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                CommonUtils.txt("shzt") +
                                                    "：" +
                                                    CommonUtils.txt('dsh'),
                                                style: GQStyle.red255_11),
                                          ],
                                        ),
                                      )
                                    : Container())
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _postBitList() {
    return PullRefreshList(
      isAll: noMore,
      onRefresh: () {
        page = 1;
        _getData();
      },
      onLoading: () {
        page++;
        _getData();
      },
      child: ListView.builder(
          itemCount: 1, //标签+帖子
          itemBuilder: (context, index) {
            return CommunityBitPost(data: dataList, showHead: false);
          }),
    );
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
      case 14:
        return _postList();
      case 15:
        return _postBitList();
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
