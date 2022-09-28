import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/acg_page/home/home_comic_info_page.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/page/flj_slider_nav.dart';
import 'package:qypj/pages/mine/mine_creater_collect_detail_status.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';

class MineCreaterCollectDetail extends BaseWidget {
  MineCreaterCollectDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterCollectDetailState();
  }
}

class _MineCreaterCollectDetailState
    extends BaseWidgetState<MineCreaterCollectDetail> {
  dynamic topic;
  PageController _pageController = PageController();
  List<String> labels = [
    CommonUtils.txt("ysh"),
    CommonUtils.txt("hdz"),
    CommonUtils.txt("dsh"),
    CommonUtils.txt("shsb")
  ];

  _getData() {
    topicCollectForDetail(id: widget.id).then((res) {
      if (res.status == 1) {
        topic = res.data;
        setState(() {});
      } else {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      }
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("jjxq"), navColor: Colors.transparent);
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return topic == null
        ? Container()
        : Stack(
            children: [
              NestedScrollView(
                headerSliverBuilder: (context, res) {
                  return [
                    SliverToBoxAdapter(
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: ScreenUtil().setWidth(111),
                                    height: ScreenUtil().setWidth(137),
                                    child: Stack(
                                      children: [
                                        PlatformAwareNetworkImage(
                                          url: topic["thumb"],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(5))),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(topic["title"],
                                          style: GQStyle.white255_15),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(14)),
                                      Text(
                                          "${CommonUtils.renderNumber(topic["views_count"])}${CommonUtils.txt("cbf")} ｜ ${CommonUtils.renderNumber(topic["likes_count"])}${CommonUtils.txt("dz")}",
                                          style: GQStyle.gray163_11),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(14)),
                                      Text(
                                          "${CommonUtils.txt("go")}${topic["mv_count"]}${CommonUtils.txt("jishu")}",
                                          style: GQStyle.gray163_11),
                                      SizedBox(
                                          height: ScreenUtil().setWidth(20)),
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: "${CommonUtils.txt("zsy")}：",
                                            style: GQStyle.gray163_13),
                                        TextSpan(
                                            text:
                                                "${topic["income_money"] ?? ""}",
                                            style: GQStyle.blue80_13_M),
                                      ])),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            Container(
                              height: ScreenUtil().setWidth(5),
                              color: Color(0xFF23262f),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(20)),
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
                            selectStyle: GQStyle.blue80_15_M,
                            defaultStyle: GQStyle.white255_15_M,
                            pageController: _pageController,
                            titles: labels,
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
                    MineCreaterCollectDetailStatus(status: "3", id: widget.id),
                    MineCreaterCollectDetailStatus(status: "1", id: widget.id),
                    MineCreaterCollectDetailStatus(status: "0", id: widget.id),
                    MineCreaterCollectDetailStatus(status: "2", id: widget.id),
                  ],
                ),
              ),
              Positioned(
                bottom: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.push(CommonUtils.getRealHash(
                        "minecreaterissue/${widget.id}"));
                  },
                  child: LImage("create_issue_n",
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setWidth(50)),
                ),
              )
            ],
          );
  }
}
