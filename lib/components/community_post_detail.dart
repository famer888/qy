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
  @override
  Widget appbar() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top,
          color: Colors.transparent,
        ),
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          height: GQStyle.navbarHegiht,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: SizedBox(
                  height: double.infinity,
                  child: LImage(
                    "nav_back_n",
                    width: ScreenUtil().setWidth(20),
                    height: ScreenUtil().setWidth(20),
                  ),
                ),
                onTap: () {
                  finish();
                },
              ),
              SizedBox(width: 10.w),
              Expanded(
                  child: detailData == null
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                context.push(
                                    '/mineUserCenter/${detailData["user"]["aff"]}');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: ScreenUtil().setWidth(30),
                                    width: ScreenUtil().setWidth(30),
                                    child: PlatformAwareNetworkImage(
                                      imageName: "flj_logo_icon",
                                      url: detailData["user"]["thumb"] ?? "",
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              ScreenUtil().setWidth(15))),
                                      background: Color(0xFF26313b),
                                    ),
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    detailData["user"]["nickname"] ?? "",
                                    style: GQStyle.white255_15_M,
                                  ),
                                  SizedBox(width: 2.w),
                                  detailData["user"]['agent'] == 1
                                      ? Icon(Icons.verified_sharp,
                                          size: 14.w,
                                          color:
                                              Color.fromRGBO(247, 208, 93, 1))
                                      : Container(),
                                ],
                              ),
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
                        ))
            ],
          ),
        )
      ],
    );
  }

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
                      SizedBox(height: 15.w),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Text(
                          CommonUtils.convertEmojiAndHtml(
                              detailData["title"] ?? ""),
                          style: GQStyle.white18semibold,
                          maxLines: AppGlobal.maxLines,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${CommonUtils.renderFixedNumber(detailData["view_num"] ?? 0)}${CommonUtils.txt("llan")}",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12.sp)),
                            Text(
                                "发布时间：${RelativeDateFormat.format(DateTime.parse(detailData["created_at"] ?? ""))}",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12.sp))
                          ],
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        height: ScreenUtil().setWidth(0.5),
                        color: Color(0xFF2a2a33),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: GQStyle.pagePadding,
                            right: GQStyle.pagePadding,
                            top: 10.w),
                        child: (detailData["content"] ?? "").isEmpty
                            ? Container()
                            : RichText(
                                text: TextSpan(
                                  text: detailData["content"] ?? "",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 14.sp),
                                ),
                              ),
                      ),
                      Builder(builder: (cx) {
                        List tps = List.from(detailData['medias']);
                        return tps.isEmpty
                            ? Container()
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: GQStyle.pagePadding,
                                    vertical: 10.w),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: tps.length,
                                itemBuilder: (ctx, index) {
                                  dynamic e = tps[index];
                                  if (e['type'] == 2) {
                                    e["unlock_coins"] =
                                        detailData["unlock_coins"];
                                  }
                                  CommonUtils.debugPrint(e);
                                  double width = ScreenUtil().screenWidth -
                                      GQStyle.pagePadding * 2;
                                  double w = (e["thumb_width"] == 0 ||
                                              e["thumb_width"] == null
                                          ? width
                                          : e["thumb_width"])
                                      .toDouble();
                                  double h = (e["thumb_height"] == 0 ||
                                              e["thumb_height"] == null
                                          ? width / 2
                                          : e["thumb_height"])
                                      .toDouble();
                                  width = w > width ? width : w;
                                  return e['type'] == 1
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: width,
                                            height: width / w * h,
                                            child: GestureDetector(
                                              behavior:
                                                  HitTestBehavior.translucent,
                                              onTap: () {
                                                AppGlobal.picMap = {
                                                  'resources': tps,
                                                  'index': index
                                                };
                                                context.push('/picview');
                                              },
                                              child: PlatformAwareNetworkImage(
                                                  background:
                                                      Colors.transparent,
                                                  fit: BoxFit.contain,
                                                  noVisibilityDetector: true,
                                                  url: CommonUtils.getThumb(
                                                      tps[index])),
                                            ),
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 10.w),
                                            RichText(
                                                text: TextSpan(children: [
                                              (detailData['unlock_coins'] ??
                                                          0) >
                                                      0
                                                  ? TextSpan(
                                                      text:
                                                          "${detailData['unlock_coins']}${CommonUtils.txt('jbjsgk')}:",
                                                      style: TextStyle(
                                                          color: GQStyle
                                                              .cyanColor00edfd,
                                                          fontSize: 14.sp))
                                                  : TextSpan(
                                                      text: CommonUtils.txt(
                                                              'sping') +
                                                          ":",
                                                      style: TextStyle(
                                                          color: Colors.white70,
                                                          fontSize: 14.sp))
                                            ])),
                                            SizedBox(height: 5.w),
                                            SizedBox(
                                              width: ScreenUtil().screenWidth -
                                                  GQStyle.pagePadding * 2,
                                              height: (ScreenUtil()
                                                          .screenWidth -
                                                      GQStyle.pagePadding * 2) /
                                                  16 *
                                                  9,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  AppGlobal.picMap = {
                                                    'resources': tps,
                                                    'index': index
                                                  };
                                                  context.push('/picview');
                                                },
                                                child: Stack(
                                                  children: [
                                                    PlatformAwareNetworkImage(
                                                      background:
                                                          Colors.transparent,
                                                      url: e["cover"],
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Center(
                                                        child: LImage(
                                                            'v_play_n',
                                                            width: 40,
                                                            height: 40))
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                });
                      }),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding, vertical: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
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
                            SizedBox(width: 20.w),
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
                            SizedBox(width: 20.w),
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
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: GQStyle.pagePadding),
                        height: ScreenUtil().setWidth(0.5),
                        color: Color(0xFF2a2a33),
                      ),
                      SizedBox(height: 20.w),
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
