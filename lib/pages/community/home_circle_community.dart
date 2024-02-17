import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_circle_new.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/general_banner.dart';

class HomeCircleCommunity extends StatefulWidget {
  HomeCircleCommunity({Key key, this.isShow}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeCommunityState();
  }
}

class _HomeCommunityState extends State<HomeCircleCommunity>
    with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  bool _isHud = true;
  bool _netError = false;
  List<dynamic> navs = [];
  List<Map> issues = [
    {"title": CommonUtils.txt("tp"), "png": "issue_png_n"},
    {"title": CommonUtils.txt("sping"), "png": "issue_vdio_n"},
    {"title": CommonUtils.txt("twen"), "png": "issue_pngtxt_n"}
  ];

  _getData() {
    reqGetCircleNav().then((value) {
      if (value.status == 1) {
        navs = List.from(value?.data ?? []);
        _isHud = false;
      } else {
        _netError = true;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  void didUpdateWidget(covariant HomeCircleCommunity oldWidget) {
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
                                  context.push("/communityissue/0/1");
                                } else if (e["png"] == "issue_vdio_n") {
                                  //视频
                                  context.push("/communityissue/1/1");
                                } else {
                                  //图文
                                  context.push("/communityissue/2/1");
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      floatingActionButton: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _showIssueAlert();
        },
        child: LImage("comm_issue_n", width: 50.w, height: 50.w),
      ),
      body: Column(
        children: [
          SizedBox(
              height: kIsWeb
                  ? ScreenUtil().setWidth(15)
                  : MediaQuery.of(context).padding.top),
          Expanded(
            child: _netError
                ? PageStatus.noNetWork(onTap: () {
                    _netError = false;
                    _getData();
                  })
                : _isHud
                    ? PageStatus.loading(mounted)
                    : YyqDiamondNav(
                        titles:
                            navs.map<String>((e) => e["name"] ?? "").toList(),
                        pages: navs.map<Widget>((e) {
                          return CommunityChildPage(
                              id: e["id"], mask: e["mask"]);
                        }).toList(),
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
          ),
        ],
      ),
    );
  }
}

class CommunityChildPage extends StatefulWidget {
  CommunityChildPage({Key key, this.id = 0, this.mask}) : super(key: key);
  final int id;
  final int mask;

  @override
  State<CommunityChildPage> createState() => _CommunityChildPageState();
}

class _CommunityChildPageState extends State<CommunityChildPage> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> banners = [];

  @override
  Widget build(BuildContext context) {
    List tps = Provider.of<HomeConfig>(context, listen: false).config.forum_nav;
    List<String> vip_level_str = Provider.of<HomeConfig>(context, listen: false)
        .config
        .vip_level_awq_str;
    String vip_name_str =
        Provider.of<HomeConfig>(context, listen: false).config.vip_name_awq_str;
    Member user = Provider.of<HomeConfig>(context, listen: false).member;

    // CommonUtils.debugPrint(((vip_level_str.isNotEmpty &&
    //             vip_level_str.contains(user.vip_str) == false) ||
    //         user.agent == 0) &&
    //     widget.mask == 1);
    // CommonUtils.debugPrint(
    //     "=====${vip_level_str.contains(user.vip_str) == false}");
    return Stack(
      children: [
        NestedScrollView(
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
                      labelPadding: 5,
                      selectStyle: GQStyle.green85_15,
                      defaultStyle: GQStyle.gray232_15,
                      pageController: _pageController,
                      titles: tps.map<String>((e) => e["title"] ?? "").toList(),
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
            children: tps
                .map<Widget>((e) => CommunityCircleNew(
                      id: widget.id,
                      sort: e["type"],
                      call: (data) {
                        banners = List.from(data["banner"]);
                        setState(() {});
                      },
                    ))
                .toList(),
          ),
        ),
        (((vip_level_str.isNotEmpty &&
                            vip_level_str.contains(user.vip_str) == true) ||
                        user.agent == 1) &&
                    widget.mask == 1) ||
                widget.mask == 0
            ? Container()
            : ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12.w, sigmaY: 12.w),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.push("/vip");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: vip_name_str.split("#").map((e) {
                          if (e.contains("卡")) {
                            return Text(e, style: GQStyle.blue80_15);
                          }
                          return Text(e, style: GQStyle.white15);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
