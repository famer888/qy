import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/gen_custom_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_bit_new.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/views/general_banner.dart';
import 'package:qypj/views/yyq/search_element_widget.dart';
import 'package:provider/provider.dart';

class HomeBitCommunity extends StatefulWidget {
  HomeBitCommunity({Key key, this.isShow}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeBitCommunityState();
  }
}

class _HomeBitCommunityState extends State<HomeBitCommunity>
    with SingleTickerProviderStateMixin {
  bool _isHud = true;
  bool _netError = false;
  List<dynamic> navs = [];

  _getData() {
    reqGetPostBit().then((value) {
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
  }

  @override
  void didUpdateWidget(covariant HomeBitCommunity oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && _isHud) {
      _getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> seed_vip =
        Provider.of<HomeConfig>(context, listen: false).config.seed_vip;
    int seed_mask =
        Provider.of<HomeConfig>(context, listen: false).config.seed_mask;
    String seed_tip =
        Provider.of<HomeConfig>(context, listen: false).config.seed_tip;
    Member user = Provider.of<HomeConfig>(context, listen: false).member;
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: GQStyle.topHeight),
              Expanded(
                  child: _netError
                      ? PageStatus.noNetWork(onTap: () {
                          _netError = false;
                          _getData();
                        })
                      : _isHud
                          ? PageStatus.loading(mounted)
                          : YyqDiamondNav(
                              titles: navs
                                  .map<String>((e) => e["name"] ?? "")
                                  .toList(),
                              pages: navs.map<Widget>((e) {
                                return CommunityBitChildPage(id: e["id"]);
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
                            ))
            ],
          ),
          seed_vip.isNotEmpty &&
                  seed_mask == 1 &&
                  seed_vip.contains(user.vip_str) == false &&
                  widget.isShow
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6.w, sigmaY: 6.w),
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
                        children: seed_tip.split("#").map((e) {
                          if (e.contains("卡")) {
                            return Text(e, style: GQStyle.blue80_15);
                          }
                          return Text(e, style: GQStyle.white15);
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class CommunityBitChildPage extends StatefulWidget {
  CommunityBitChildPage({Key key, this.id = 0}) : super(key: key);
  final int id;

  @override
  State<CommunityBitChildPage> createState() => _CommunityBitChildPageState();
}

class _CommunityBitChildPageState extends State<CommunityBitChildPage> {
  PageController _pageController = PageController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> banners = [];

  @override
  Widget build(BuildContext context) {
    List tps = Provider.of<HomeConfig>(context, listen: false).config.seed_nav;
    return NestedScrollView(
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
            .map<Widget>((e) => CommunityBitNew(
                  id: widget.id,
                  sort: e["type"],
                  call: (data) {
                    banners = List.from(data["banners"] ?? []);
                    setState(() {});
                  },
                ))
            .toList(),
      ),
    );
  }
}
