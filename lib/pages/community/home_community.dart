import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
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

  @override
  void didUpdateWidget(covariant HomeCommunity oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && _isHud) {
      _isHud = false;
    }
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
      floatingActionButton: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.push("/communityissue/2");
        },
        child: LImage(
          "comm_issue_n",
          width: ScreenUtil().setWidth(50),
          height: ScreenUtil().setWidth(50),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
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
                        context.push('/${Routes.search}');
                      },
                      child: LImage(
                        "search_n_gray",
                        width: ScreenUtil().setWidth(17),
                        height: ScreenUtil().setWidth(17),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Text(
                    CommonUtils.txt("ym"),
                    style: GQStyle.white255_18_B,
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: _isHud
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
                                      mainAxisSpacing:
                                          ScreenUtil().setWidth(10),
                                      crossAxisSpacing:
                                          ScreenUtil().setWidth(10),
                                    ),
                                    children: topics
                                        .map((e) => Container(
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  context.push(
                                                      "/communitytagdetail/${e["id"]}");
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        90, 90, 90, 1.0),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            ScreenUtil()
                                                                .setWidth(5))),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      PlatformAwareNetworkImage(
                                                        url:
                                                            e["bg_thumb"] ?? "",
                                                        nofigure: true,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            5))),
                                                      ),
                                                      // Container(
                                                      //   decoration:
                                                      //       BoxDecoration(
                                                      //     color: Colors.black54,
                                                      //     borderRadius: BorderRadius
                                                      //         .all(Radius.circular(
                                                      //             ScreenUtil()
                                                      //                 .setWidth(
                                                      //                     5))),
                                                      //   ),
                                                      // ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Center(
                                                            child: Text(
                                                              e["name"] ?? "",
                                                              style: GQStyle
                                                                  .white255_15_semibold,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          2)),
                                                          Center(
                                                              child: Text(
                                                            "${e["post_num"] ?? "0"}${CommonUtils.txt("tiez")}",
                                                            style: GQStyle
                                                                .white255_11,
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
                                  // SizedBox(
                                  //   height: ScreenUtil().setWidth(65),
                                  //   child: ListView.builder(
                                  //     physics: BouncingScrollPhysics(),
                                  //     itemCount: topics.length,
                                  //     shrinkWrap: true,
                                  //     scrollDirection: Axis.horizontal,
                                  //     itemBuilder: (context, index) {
                                  //       return Row(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.center,
                                  //         children: [
                                  //           SizedBox(
                                  //               width: GQStyle.pagePadding),
                                  //           GestureDetector(
                                  //             behavior:
                                  //                 HitTestBehavior.translucent,
                                  //             onTap: () {
                                  //               context.push(
                                  //                   "/communitytagdetail/${topics[index]["id"]}");
                                  //             },
                                  //             child: Container(
                                  //               width:
                                  //                   ScreenUtil().setWidth(135),
                                  //               child: Stack(
                                  //                 children: [
                                  //                   PlatformAwareNetworkImage(
                                  //                     url: topics[index]
                                  //                             ["bg_thumb"] ??
                                  //                         "",
                                  //                     borderRadius:
                                  //                         BorderRadius.all(
                                  //                             Radius.circular(
                                  //                                 ScreenUtil()
                                  //                                     .setWidth(
                                  //                                         5))),
                                  //                   ),
                                  //                   Container(
                                  //                     decoration: BoxDecoration(
                                  //                       color: Colors.black38,
                                  //                       borderRadius:
                                  //                           BorderRadius.all(
                                  //                               Radius.circular(
                                  //                                   ScreenUtil()
                                  //                                       .setWidth(
                                  //                                           5))),
                                  //                     ),
                                  //                   ),
                                  //                   Column(
                                  //                     mainAxisAlignment:
                                  //                         MainAxisAlignment
                                  //                             .center,
                                  //                     children: [
                                  //                       Center(
                                  //                         child: Text(
                                  //                           topics[index]
                                  //                                   ["name"] ??
                                  //                               "",
                                  //                           style: GQStyle
                                  //                               .white255_18_B,
                                  //                         ),
                                  //                       ),
                                  //                       SizedBox(
                                  //                           height: ScreenUtil()
                                  //                               .setWidth(2)),
                                  //                       Center(
                                  //                           child: Text(
                                  //                         "${topics[index]["post_num"] ?? "0"}${CommonUtils.txt("tiez")}",
                                  //                         style: GQStyle
                                  //                             .white255_13,
                                  //                       ))
                                  //                     ],
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           )
                                  //         ],
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
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
                                  titles: [
                                    CommonUtils.txt("zxpx"),
                                    CommonUtils.txt("jhua")
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
                          CommunityNew(cate: "choice")
                        ],
                      ),
                    ))
        ],
      ),
    );
  }
}
