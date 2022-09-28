import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/community/community_post_review.dart';
import 'package:qypj/pages/community/pic_view_page.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/input_box_comment.dart';
import 'package:qypj/utils/networkImage.dart';

class CommunityPostDetail extends BaseWidget {
  CommunityPostDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunityPostDetailState();
  }
}

class _CommunityPostDetailState extends BaseWidgetState<CommunityPostDetail> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> reviewData = [];
  dynamic detailData;
  double ch = 130;
  final txtcontroller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode xcfocusNode = FocusNode();
  String tip = CommonUtils.txt("wyddxf");
  String postid = "0";
  String commid = "0";
  bool isReplay = false;

  ImageSourceMatcher classAndIdMatcher() =>
      (attributes, element) => attributes["src"] != null;

  ImageRender classAndIdRender() => (context, attributes, element) {
        double width = ScreenUtil().screenWidth - GQStyle.pagePadding * 2;
        double w = double.parse(attributes["width"] ?? "${width}");
        double h = double.parse(attributes["height"] ?? "${width / 2}");
        return Container(
          height: width / w * h,
          width: w > width ? width : w,
          child: PlatformAwareNetworkImage(url: attributes["src"] ?? ""),
        );
      };

  _resetXcfocusNode() {
    isReplay = false;
    tip = CommonUtils.txt("wyddxf");
    xcfocusNode.unfocus();
  }

  //加载详情
  _getData() {
    communityTopicDetail(id: widget.id).then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      if (res.status == 1) {
        detailData = res.data;
        setAppTitle(title: "${detailData["topic"]["name"] ?? ""}");
        _getReviewData();
      } else {
        CommonUtils.showText(res.msg);
        context.pop();
      }
    });
  }

  //加载评论
  _getReviewData({bool isShow = false}) {
    communityPostComments(id: widget.id, page: page).then((res) {
      if (isShow) BotToast.closeAllLoading();
      if (res.data == null) {
        CommonUtils.showText(res.msg);
        return;
      }
      List st = res.data;
      if (page == 1) {
        noMore = false;
        reviewData = st;
      } else if (st.length > 0) {
        reviewData.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    _getData();
  }

  @override
  void didUpdateWidget(covariant CommunityPostDetail oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _resetXcfocusNode();
      } else {}
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    _countCollect.dispose();
    _countFocus.dispose();
    _countLike.dispose();
  }

  _showExceptionalAlert() {
    int money = Provider.of<HomeConfig>(context, listen: false).member.money;
    bool isInsufficient = money < 1;
    YyShowDialog.showdialog(
      context,
      title:
          isInsufficient ? CommonUtils.txt('jbbz') : CommonUtils.txt('gxdyds'),
      btnText:
          isInsufficient ? CommonUtils.txt("qwcz") : CommonUtils.txt('ljdsang'),
      callBack: () {
        focusNode.unfocus();
        if (isInsufficient) {
          context.push('/${Routes.coinRecharge}');
        } else {
          if (txtcontroller.text.length == 0) {
            CommonUtils.showText(CommonUtils.txt("srdsbs"));
            return;
          }
          initLoadGIF(tip: CommonUtils.txt("jzz"));
          communityTopicReward(
                  id: detailData["id"].toString(),
                  amount: txtcontroller.text.toString(),
                  context: context,
                  coins: money - int.parse(txtcontroller.text))
              .then((res) {
            BotToast.closeAllLoading();
            if (res.status == 1) {
              CommonUtils.showText(res.msg);
              detailData["reward_amount"] += int.parse(txtcontroller.text);
              setState(() {});
            } else {
              CommonUtils.showText(res.msg);
            }
          });
        }
      },
      cancelText: CommonUtils.txt("qx"),
      prohibitClose: false,
      content: (setDialogState) {
        return DefaultTextStyle(
            style: GQStyle.gray203_13,
            child: Column(
              children: [
                Container(
                  height: ScreenUtil().setWidth(32),
                  decoration: BoxDecoration(
                    color: Color(0xFF0e1420),
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(16))),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20),
                  ),
                  width: ScreenUtil().setWidth(170),
                  child: TextField(
                      autofocus: false,
                      focusNode: focusNode,
                      controller: txtcontroller,
                      style: GQStyle.white255_15_M,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hoverColor: Colors.white,
                          hintText: CommonUtils.txt('srdsbs'),
                          hintStyle: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: GQStyle.hanyi,
                            fontWeight: FontWeight.w500,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                          contentPadding: EdgeInsets.zero,
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)))),
                ),
                SizedBox(height: ScreenUtil().setWidth(15)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        CommonUtils.txt('kyje') +
                            "：$money" +
                            CommonUtils.txt('jb'),
                        style: GQStyle.gray203_13),
                    SizedBox(width: ScreenUtil().setWidth(13.5)),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        focusNode.unfocus();
                        context.pop();
                        context.push('/${Routes.coinRecharge}');
                      },
                      child: Row(
                        children: [
                          Text(CommonUtils.txt('qcz'),
                              style: GQStyle.blue80_13_M),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ));
      },
    );
  }

  _showPNGPreview(int index) {
    AppGlobal.currentReaderRouteExtra = {
      'resources': List.from(detailData["medias"]),
      'index': index,
      'showNav': 0,
    };
    var top = MediaQuery.of(context).padding.top;
    CommonUtils.debugPrint(top);
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return Container(
              height: ScreenUtil().screenHeight - top,
              decoration: BoxDecoration(
                color: GQStyle.bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(ScreenUtil().setWidth(5)),
                  topRight: Radius.circular(ScreenUtil().setWidth(5)),
                ),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setWidth(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _resetXcfocusNode();
                          context.pop();
                        },
                        child: LImage(
                          "issue_close_n",
                          width: ScreenUtil().setWidth(13),
                          height: ScreenUtil().setWidth(13),
                        ),
                      ),
                      Container(),
                    ],
                  ),
                ),
                Expanded(
                  child: PicViewPage(
                    pramas: AppGlobal.currentReaderRouteExtra,
                  ),
                )
              ]),
            );
          });
        });
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : InputCommentBox(
            focusNode: xcfocusNode,
            onEditingCompleteText: (value) {
              if (isReplay) {
                _inputTxt(postid, commid, value);
                isReplay = false;
                tip = CommonUtils.txt("wyddxf");
              } else {
                _inputTxt(detailData["id"].toString(), "0", value);
              }
            },
            labelText: tip,
            child: PullRefreshList(
              isAll: noMore,
              onRefresh: () {
                page = 1;
                _getData();
              },
              onLoading: () {
                page++;
                _getReviewData();
              },
              child: SingleChildScrollView(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _resetXcfocusNode();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ScreenUtil().setWidth(25)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Text(
                          CommonUtils.convertEmojiAndHtml(
                              detailData["title"] ?? ""),
                          style: GQStyle.white255_18_M,
                          maxLines: AppGlobal.maxLines,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(25)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: ScreenUtil().setWidth(50),
                                  width: ScreenUtil().setWidth(50),
                                  child: PlatformAwareNetworkImage(
                                    imageName: "flj_logo_icon",
                                    url: detailData["user"]["thumb"] ?? "",
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(25))),
                                    background: Color(0xFF26313b),
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(10)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      detailData["user"]["nickname"] ?? "",
                                      style: GQStyle.white255_15_M,
                                    ),
                                    Text(
                                      '${detailData["user"]["exp"] ?? 0}${CommonUtils.txt("jfen")}',
                                      style: TextStyle(
                                        color: Color(0xFFc6c7d9),
                                        fontSize: ScreenUtil().setSp(14),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _resetXcfocusNode();
                                communityFollowUser(
                                        aff: detailData["user"]["aff"]
                                            .toString())
                                    .then((res) {
                                  if (res.status == 1) {
                                    detailData["user"]["is_follow"] =
                                        detailData["user"]["is_follow"] == 1
                                            ? 0
                                            : 1;
                                    _countFocus.value =
                                        detailData["user"]["is_follow"];
                                  } else {
                                    CommonUtils.showText(res.msg);
                                  }
                                });
                              },
                              child: ValueListenableBuilder<int>(
                                builder: _buildWithFocus,
                                valueListenable: _countFocus,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: GQStyle.pagePadding),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Html(
                          shrinkWrap: true,
                          data: detailData["content"] ?? "",
                          style: {
                            "*": Style(
                              color: Color(0xffeaeaec),
                              // width: ScreenUtil().screenWidth -
                              //     GQStyle.pagePadding * 2,
                              // padding: EdgeInsets.all(0),
                              margin: EdgeInsets.all(0),
                              // height: ScreenUtil()
                              // fontSize: FontSize(ScreenUtil().setSp(14)),
                              // lineHeight: LineHeight(2.1),
                            ),
                          },
                          customImageRenders: {
                            classAndIdMatcher(): classAndIdRender(),
                          },
                          onLinkTap: (url, context, map, eles) {},
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${RelativeDateFormat.format(DateTime.parse(detailData["created_at"] ?? ""))}      ${CommonUtils.renderFixedNumber(detailData["view_num"] ?? 0)}${CommonUtils.txt("llan")}",
                                style: GQStyle.gray190_12),
                            Spacer(),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _resetXcfocusNode();
                                communityTopicLike(
                                        id: detailData["id"].toString())
                                    .then((res) {
                                  if (res.status == 1) {
                                    detailData["is_like"] =
                                        detailData["is_like"] == 1 ? 0 : 1;
                                    _countLike.value = detailData["is_like"];
                                  } else {
                                    CommonUtils.showText(res.msg);
                                  }
                                });
                              },
                              child: ValueListenableBuilder<int>(
                                builder: _buildWithLike,
                                valueListenable: _countLike,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _resetXcfocusNode();
                                communityTopicFavorite(
                                        id: detailData["id"].toString())
                                    .then((res) {
                                  if (res.status == 1) {
                                    detailData["is_favorite"] =
                                        detailData["is_favorite"] == 1 ? 0 : 1;
                                    _countCollect.value =
                                        detailData["is_favorite"];
                                  } else {
                                    CommonUtils.showText(res.msg);
                                  }
                                });
                              },
                              child: ValueListenableBuilder<int>(
                                builder: _buildWithCollect,
                                valueListenable: _countCollect,
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _resetXcfocusNode();
                                context.push(CommonUtils.getRealHash(
                                    'kwantsharetousers'));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LImage(
                                    "comic_share_c",
                                    width: ScreenUtil().setWidth(18),
                                    height: ScreenUtil().setWidth(18),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(2)),
                                  Text(
                                    CommonUtils.txt("fx"),
                                    style: GQStyle.gray190_12,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        height: ScreenUtil().setWidth(0.5),
                        color: Color(0xFF2a2a33),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Row(
                          children: [
                            Text(CommonUtils.txt("pl"),
                                style: GQStyle.white255_18_M),
                            Text(
                                "（${detailData["comment_num"] ?? 0}${CommonUtils.txt("taoi")}）",
                                style: GQStyle.white255_13),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: reviewData.length == 0
                            ? PageStatus.noData()
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                  vertical: ScreenUtil().setWidth(5),
                                ),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: reviewData.length,
                                itemBuilder: (context, index) {
                                  return CommunityPostReview(
                                    data: reviewData[index],
                                    replyCall: (dp, pid, cmid) {
                                      isReplay = true;
                                      tip = dp;
                                      postid = pid;
                                      commid = cmid;
                                      xcfocusNode.requestFocus();
                                      setState(() {});
                                    },
                                    resetCall: () {
                                      _resetXcfocusNode();
                                    },
                                  );
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  _inputTxt(
    String post_id,
    String comment_id,
    String value,
  ) {
    if (AppGlobal.vipLevel > 0 || true) {
      if (value == null) return;
      if (value.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsrnr"));
        return;
      }
      initLoadGIF(tip: CommonUtils.txt("fbioz"));
      communityPostComment(
              post_id: post_id, comment_id: comment_id, content: value)
          .then((res) {
        BotToast.closeAllLoading();
        if (res.status == 1) {
          CommonUtils.showText(res.msg);
        } else {
          CommonUtils.showText(res.msg);
        }
      });
    } else {
      YyShowDialog.showdPNGDiaog(
        context,
        title: CommonUtils.txt("ts"),
        content: (setDialogState) {
          return Text(
            CommonUtils.txt("ktvpfpl"),
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
  }

  //处理局部刷新
  final ValueNotifier<int> _countLike = ValueNotifier<int>(0);
  Widget _buildWithLike(BuildContext context, int value, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LImage(
          detailData["is_like"] == 1 ? "comic_thunbup_s" : "comic_thunbup_n",
          width: ScreenUtil().setWidth(18),
          height: ScreenUtil().setWidth(18),
        ),
        SizedBox(width: ScreenUtil().setWidth(2)),
        Text(
          detailData["is_like"] == 1
              ? CommonUtils.txt("ydz")
              : CommonUtils.txt("dz"),
          style: GQStyle.gray190_12,
        ),
        SizedBox(width: ScreenUtil().setWidth(15)),
      ],
    );
  }

  final ValueNotifier<int> _countCollect = ValueNotifier<int>(0);
  Widget _buildWithCollect(BuildContext context, int value, Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LImage(
          detailData["is_favorite"] == 1
              ? "comic_collect_s"
              : "comic_collect_n",
          width: ScreenUtil().setWidth(18.7),
          height: ScreenUtil().setWidth(18.7),
        ),
        SizedBox(width: ScreenUtil().setWidth(2)),
        Text(
          detailData["is_favorite"] == 1
              ? CommonUtils.txt("ysc")
              : CommonUtils.txt("sc"),
          style: GQStyle.gray190_12,
        ),
        SizedBox(width: ScreenUtil().setWidth(15)),
      ],
    );
  }

  final ValueNotifier<int> _countFocus = ValueNotifier<int>(0);
  Widget _buildWithFocus(BuildContext context, int value, Widget child) {
    return Container(
      width: ScreenUtil().setWidth(55),
      height: ScreenUtil().setWidth(25),
      decoration: BoxDecoration(
          color: detailData["user"]["is_follow"] == 1
              ? Color(0xFF60b2dc)
              : Colors.transparent,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(25 / 2))),
          border: Border.all(
              color: detailData["user"]["is_follow"] == 1
                  ? Colors.transparent
                  : Color(0xFF60b2dc),
              width: ScreenUtil().setWidth(0.5))),
      child: Center(
        child: Text(
          detailData["user"]["is_follow"] == 1
              ? CommonUtils.txt("ygz")
              : "+ ${CommonUtils.txt("gz")}",
          style: detailData["user"]["is_follow"] == 1
              ? GQStyle.white11
              : GQStyle.blue80_11,
        ),
      ),
    );
  }
}
