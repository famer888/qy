import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_tag_detail_child.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class CommunityTagDetail extends BaseWidget {
  CommunityTagDetail({Key key, this.topic_id, this.offsetBack})
      : super(key: key);
  final String topic_id;
  final Function(double) offsetBack;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunityTagDetailState();
  }
}

class _CommunityTagDetailState extends BaseWidgetState<CommunityTagDetail> {
  dynamic topic;
  List<String> labels = [
    CommonUtils.txt("zxpx"),
    CommonUtils.txt("zxjx"),
    CommonUtils.txt("sping"),
  ];
  PageController _pageController = PageController();
  ScrollController _controller = ScrollController();
  GlobalKey _anchorKey = GlobalKey();
  Color setColor;

  @override
  void onCreate() {
    // TODO: implement onCreate

    _getTopDetail();
  }

  _getTopDetail() {
    communityTopicsDetail(topic_id: widget.topic_id).then((res) {
      if (res.status == 1) {
        topic = res.data;
        setAppTitle(title: topic["name"] ?? "");
        setState(() {});
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _pageController.dispose();
    _controller.dispose();
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return topic == null
        ? Container()
        : NestedScrollView(
            headerSliverBuilder: (context, res) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().setWidth(15)),
                        Row(
                          children: [
                            SizedBox(
                              width: ScreenUtil().setWidth(90),
                              height: ScreenUtil().setWidth(90),
                              child: PlatformAwareNetworkImage(
                                url: topic["thumb"] ?? "",
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(5)),
                                ),
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(6.5)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic["intro"] ?? "",
                                    style: GQStyle.gray234_14,
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: ScreenUtil().setWidth(10)),
                                  Text(
                                    "${CommonUtils.renderFixedNumber(topic["post_num"] ?? 0)}${CommonUtils.txt("tiez")}    ${CommonUtils.renderFixedNumber(topic["view_num"] ?? 0)}${CommonUtils.txt("llan")}",
                                    style: GQStyle.gray208_13,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(6.5)),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                //话题关注/取消关注
                                communityFollowTopic(
                                        topic_id: topic["id"].toString())
                                    .then((res) {
                                  if (res.status == 1) {
                                    topic["is_follow"] =
                                        topic["is_follow"] == 1 ? 0 : 1;
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
                                    color: topic["is_follow"] == 1
                                        ? Color(0xFF60b2dc)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(25 / 2))),
                                    border: Border.all(
                                        color: topic["is_follow"] == 1
                                            ? Colors.transparent
                                            : Color(0xFF60b2dc),
                                        width: ScreenUtil().setWidth(0.5))),
                                child: Center(
                                  child: Text(
                                    topic["is_follow"] == 1
                                        ? CommonUtils.txt("ygz")
                                        : "+ ${CommonUtils.txt("gz")}",
                                    style: topic["is_follow"] == 1
                                        ? GQStyle.white11
                                        : GQStyle.blue80_11,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setWidth(10)),
                      ],
                    ),
                  ),
                ),
                SliverPersistentHeader(
                    pinned: true,
                    delegate: CustomHeaderDelegate(
                      Container(
                        key: _anchorKey,
                        color: GQStyle.naviColor,
                        child: FljSliderBar(
                          selectStyle: GQStyle.white13medium,
                          defaultStyle: GQStyle.white255_13,
                          pageController: _pageController,
                          titles: labels,
                        ),
                      ),
                      minHeight: GQStyle.navbarHegiht,
                      maxHeight: GQStyle.navbarHegiht,
                    ))
              ];
            },
            body: PageView(
              controller: _pageController,
              children: [
                CommunityTagDetailChild(
                  topic_id: widget.topic_id,
                  cate: "new",
                ),
                CommunityTagDetailChild(
                  topic_id: widget.topic_id,
                  cate: "choice",
                ),
                CommunityTagDetailChild(
                  topic_id: widget.topic_id,
                  cate: "video",
                )
              ],
            ),
            controller: _controller,
          );
  }
}
