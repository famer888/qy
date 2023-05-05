import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/general_banner.dart';

class HomeCommunity extends StatefulWidget {
  HomeCommunity({Key key, this.isShow}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeCommunityState();
  }
}

class _HomeCommunityState extends State<HomeCommunity>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  bool _isHud = true;
  List<dynamic> banners = [];
  List<dynamic> topics = [];
  List<Map> issues = [
    {"title": CommonUtils.txt("tp"), "png": "issue_png_n"},
    {"title": CommonUtils.txt("sping"), "png": "issue_vdio_n"},
    {"title": CommonUtils.txt("twen"), "png": "issue_pngtxt_n"}
  ];

  @override
  void didUpdateWidget(covariant HomeCommunity oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && _isHud) {
      _isHud = false;
    }
  }

  _showIssueAlert() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              decoration: BoxDecoration(
                color: Color(0xFF23262f),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                  topRight: Radius.circular(ScreenUtil().setWidth(20)),
                ),
              ),
              child: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(
                          CommonUtils.txt('xzfblx'),
                          style: GQStyle.white255_18_M,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: LImage(
                            "issue_close_n",
                            width: ScreenUtil().setWidth(11),
                            height: ScreenUtil().setWidth(11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: issues
                        .map((e) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                context.pop();
                                if (e["png"] == "issue_png_n") {
                                  //图片
                                  context.push("/communityissue/0");
                                } else if (e["png"] == "issue_vdio_n") {
                                  //视频
                                  context.push("/communityissue/1");
                                } else {
                                  //图文
                                  context.push("/communityissue/2");
                                }
                              },
                              child: Column(
                                children: [
                                  LImage(
                                    e["png"],
                                    width: ScreenUtil().setWidth(50),
                                    height: ScreenUtil().setWidth(52.7),
                                  ),
                                  Text(
                                    e["title"],
                                    style: GQStyle.gray163_15,
                                  )
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(42.5),
                  )
                ],
              )),
            );
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Expanded(
            child: Stack(
              children: [
                YyqDiamondNav(
                  isCenter: true,
                  titles: [CommonUtils.txt('tjan'), CommonUtils.txt('huat')],
                  pages: [
                    recomdWidget(),
                    TopicsWidget(),
                  ],
                  navColor: Colors.transparent,
                  type: YyqDiamondNavEnum.line,
                  defaultStyle: TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontSize: ScreenUtil().setSp(18),
                      overflow: TextOverflow.visible,
                      decoration: TextDecoration.none),
                  selectStyle: TextStyle(
                      color: GQStyle.jellyCyanColor103224185,
                      fontSize: ScreenUtil().setSp(18),
                      // fontWeight: FontWeight.w500,
                      overflow: TextOverflow.visible,
                      decoration: TextDecoration.none),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: GQStyle.navbarHegiht,
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.push('/${Routes.search}');
                                },
                                child: LImage(
                                  "search_n_gray",
                                  width: ScreenUtil().setWidth(17),
                                  height: ScreenUtil().setWidth(17),
                                ),
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _showIssueAlert();
                                },
                                child: Text(CommonUtils.txt('fb'),
                                    style: GQStyle.white15),
                              )
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
        ],
      ),
    );
  }

  //推荐数据
  Widget recomdWidget() {
    return _isHud
        ? PageStatus.noData()
        : NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      children: [
                        banners != null && banners.length > 0
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: GQStyle.pagePadding),
                                child: GeneralBanner(
                                  data: banners,
                                  height: 150,
                                  pad: 0,
                                  bottom: 0,
                                  radius: 5,
                                ),
                              )
                            : Container(),
                        SizedBox(height: ScreenUtil().setWidth(10)),
                        GridView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding),
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //横轴三个子widget
                            childAspectRatio: 2.2, //宽高比为1时，子widget
                            mainAxisSpacing: ScreenUtil().setWidth(10),
                            crossAxisSpacing: ScreenUtil().setWidth(10),
                          ),
                          children: topics
                              .map((e) => Container(
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        context.push(
                                            "/communitytagdetail/${e["id"]}");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(90, 90, 90, 1.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(5))),
                                        ),
                                        child: Stack(
                                          children: [
                                            // PlatformAwareNetworkImage(
                                            //   url: e["bg_thumb"] ?? "",
                                            //   nofigure: true,
                                            //   borderRadius: BorderRadius.all(
                                            //       Radius.circular(ScreenUtil()
                                            //           .setWidth(5))),
                                            // ),
                                            Positioned.fill(
                                                child: Container(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    color: Color(0xff262631))),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    e["name"] ?? "",
                                                    style: GQStyle
                                                        .white255_15_semibold,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: ScreenUtil()
                                                        .setWidth(2)),
                                                Center(
                                                    child: Text(
                                                  "${e["post_num"] ?? "0"}${CommonUtils.txt("tiez")}",
                                                  style: GQStyle.white255_11,
                                                ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(5)),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomHeaderDelegate(
                    Container(
                      color: GQStyle.bgColor,
                      child: FljSliderBar(
                        selectStyle: GQStyle.green85_15,
                        defaultStyle: GQStyle.gray232_15,
                        pageController: _pageController,
                        titles: topics.isEmpty
                            ? ['', '', '']
                            : [
                                CommonUtils.txt("zxpx"),
                                CommonUtils.txt("jhua"),
                                CommonUtils.txt("sping")
                              ],
                      ),
                    ),
                    minHeight: GQStyle.navbarHegiht,
                    maxHeight: GQStyle.navbarHegiht,
                  ),
                )
              ];
            },
            body: PageView(
              controller: _pageController,
              children: [
                CommunityNew(
                  call: (data) {
                    banners = List.from(data["banner"]);
                    topics = List.from(data["topics"]);
                    setState(() {});
                  },
                ),
                CommunityNew(cate: "choice"),
                CommunityNew(cate: "video"),
              ],
            ),
          );
  }
}

class TopicsWidget extends StatefulWidget {
  TopicsWidget({Key key}) : super(key: key);

  @override
  State<TopicsWidget> createState() => _TopicsWidgetState();
}

class _TopicsWidgetState extends State<TopicsWidget> {
  bool isHud = true;
  bool netError = false;
  bool noMore = false;
  List tops = [];
  int page = 1;

  void getTopsData() {
    communityTopics(page: page).then((value) {
      if (value.data == null) {
        netError = true;
        setState(() {});
        return;
      }
      List tp = List.from(value.data);
      if (page == 1) {
        noMore = false;
        tops = tp;
      } else if (tp.isNotEmpty) {
        tops.addAll(tp);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTopsData();
  }

  @override
  Widget build(BuildContext context) {
    return isHud
        ? PageStatus.loading(mounted)
        : tops.isEmpty
            ? PageStatus.noData()
            : PullRefreshList(
                isAll: noMore,
                onRefresh: () {
                  page = 1;
                  getTopsData();
                },
                onLoading: () {
                  page++;
                  getTopsData();
                },
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: GQStyle.pagePadding, vertical: 0.w),
                    itemCount: tops.length,
                    itemBuilder: (cx, index) {
                      dynamic e = tops[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          context.push("/communitytagdetail/${e["id"]}");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          margin: EdgeInsets.only(bottom: 10.w),
                          height: 70.w,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(32, 35, 44, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.w)),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 46.w,
                                height: 46.w,
                                child: PlatformAwareNetworkImage(
                                  url: CommonUtils.getThumb(e),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(23.w)),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('#${e['name']}',
                                        style: GQStyle.white15bold),
                                    SizedBox(height: 5.w),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["post_num"])}${CommonUtils.txt("tiez")}",
                                          style: GQStyle.white12,
                                        ),
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["view_num"])}${CommonUtils.txt("llan")}",
                                          style: GQStyle.white12,
                                        ),
                                        Text(
                                          "${CommonUtils.renderFixedNumber(e["follow_num"])}${CommonUtils.txt("gz")}",
                                          style: GQStyle.white12,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: 10.w),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  //话题关注/取消关注
                                  communityFollowTopic(
                                          topic_id: e["id"].toString())
                                      .then((res) {
                                    if (res.status == 1) {
                                      e["is_follow"] =
                                          e["is_follow"] == 1 ? 0 : 1;
                                      setState(() {});
                                    } else {
                                      CommonUtils.showText(res.msg);
                                    }
                                  });
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(55),
                                  height: ScreenUtil().setWidth(25),
                                  decoration: BoxDecoration(
                                      color: e["is_follow"] == 1
                                          ? Color(0xFF60b2dc)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(25 / 2))),
                                      border: Border.all(
                                          color: e["is_follow"] == 1
                                              ? Colors.transparent
                                              : Color(0xFF60b2dc),
                                          width: ScreenUtil().setWidth(0.5))),
                                  child: Center(
                                    child: Text(
                                      e["is_follow"] == 1
                                          ? CommonUtils.txt("ygz")
                                          : "+ ${CommonUtils.txt("gz")}",
                                      style: e["is_follow"] == 1
                                          ? GQStyle.white11
                                          : GQStyle.blue80_11,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              );
  }
}
