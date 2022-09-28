import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/page/yyq_diamond_nav.dart';
import 'package:qypj/pages/community/community_focus.dart';
import 'package:qypj/pages/community/community_new.dart';
import 'package:qypj/pages/community/community_recommend.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class CommunityIndex extends StatefulWidget {
  CommunityIndex({Key key, this.isShow = false}) : super(key: key);
  bool isShow;

  @override
  State<CommunityIndex> createState() => _CommunityIndexState();
}

class _CommunityIndexState extends State<CommunityIndex> {
  bool isHud = true;
  List<String> labels = [
    CommonUtils.txt("zx"),
    CommonUtils.txt("tjan"),
    CommonUtils.txt("gz")
  ];
  List<Map> issues = [
    {"title": CommonUtils.txt("tp"), "png": "issue_png_n"},
    {"title": CommonUtils.txt("sping"), "png": "issue_vdio_n"},
    {"title": CommonUtils.txt("twen"), "png": "issue_pngtxt_n"}
  ];

  @override
  void didUpdateWidget(covariant CommunityIndex oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
      isHud = false;
      setState(() {});
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 26, 31, 1),
      body: Column(
        children: [
          Container(
            height: kIsWeb
                ? ScreenUtil().setWidth(10)
                : MediaQuery.of(context).padding.top,
            color: Color(0xFF23262f),
          ),
          Expanded(
              child: !isHud
                  ? Stack(
                      children: [
                        YyqDiamondNav(
                          isCenter: true,
                          titles: labels,
                          pages: [
                            CommunityNew(),
                            CommunityRecommend(),
                            CommunityFocus()
                          ],
                          defaultStyle: GQStyle.white255_18,
                          selectStyle: GQStyle.blue80_18,
                          navColor: Color(0xFF23262f),
                        ),
                        Positioned(
                          right: GQStyle.pagePadding,
                          top: ScreenUtil().setWidth(5),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              context.push("/search");
                            },
                            child: LImage(
                              "search.cyan",
                              width: ScreenUtil().setWidth(20),
                              height: ScreenUtil().setWidth(20),
                            ),
                          ),
                        ),
                        Positioned(
                          right: ScreenUtil().setWidth(20),
                          bottom: ScreenUtil().setWidth(30),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (AppGlobal.vipLevel > 0) {
                                _showIssueAlert();
                              } else {
                                YyShowDialog.showdPNGDiaog(
                                  context,
                                  title: CommonUtils.txt("ts"),
                                  content: (setDialogState) {
                                    return Text(
                                      CommonUtils.txt("ktvpft"),
                                      style: GQStyle.gray203_13,
                                    );
                                  },
                                  cancelText: CommonUtils.txt("qx"),
                                  btnText: CommonUtils.txt("ljkt"),
                                  callBack: () {
                                    context.push('/${Routes.vip}');
                                  },
                                );
                              }
                            },
                            child: LImage(
                              "comm_issue_n",
                              width: ScreenUtil().setWidth(50),
                              height: ScreenUtil().setWidth(50),
                            ),
                          ),
                        )
                      ],
                    )
                  : Container())
        ],
      ),
    );
  }
}
