import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/pages/community/community_post_bit_review.dart';
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

class CommunityPostBitDetail extends BaseWidget {
  CommunityPostBitDetail({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunityPostBitDetailState();
  }
}

class _CommunityPostBitDetailState
    extends BaseWidgetState<CommunityPostBitDetail> {
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
    bitTopicDetail(id: widget.id).then((res) {
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
    bitPostComments(id: widget.id, page: page).then((res) {
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
    setAppTitle(title: CommonUtils.txt("zhxq"));
    _getData();
  }

  @override
  void didUpdateWidget(covariant CommunityPostBitDetail oldWidget) {
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
    Member member = Provider.of<HomeConfig>(context, listen: false).member;
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
                                "${CommonUtils.renderFixedNumber(detailData["fake_view_ct"] ?? 0)}${CommonUtils.txt("llan")}",
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
                        color: Color.fromRGBO(218, 218, 218, 0.05),
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
                                                              'shp') +
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: GQStyle.pagePadding,
                            right: GQStyle.pagePadding,
                            top: 10.w),
                        child: _limitWidget(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: GQStyle.pagePadding,
                          right: GQStyle.pagePadding,
                          top: 30.w,
                          bottom: 10.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _resetXcfocusNode();
                                bitTopicLike(id: detailData["id"].toString())
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
                                bitTopicFavorite(
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
                        color: Color.fromRGBO(218, 218, 218, 0.05),
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
                                  return CommunityPostBitReview(
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

  _limitWidget() {
    if (detailData["link"].isEmpty && detailData["type"] == 1) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.push("/vip");
        },
        child: Text(CommonUtils.txt('ktvpczz'), style: GQStyle.blue80_14_M),
      );
    }
    if (detailData["link"].isEmpty && detailData["type"] == 2) {
      int money = Provider.of<HomeConfig>(context, listen: false).member.money;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          CommonUtils.startLoadGIF(tip: CommonUtils.txt("dhz"));
          buyBit(
                  id: detailData["id"],
                  coins: money - detailData["coins"],
                  context: context)
              .then((res) {
            //关闭加载动画
            BotToast.closeAllLoading();
            if (res.status != 0) {
              detailData["link"] = res.data;
              setState(() {});
            } else {
              CommonUtils.showText(res.msg);
            }
          });
        },
        child: Text("${detailData["coins"] ?? 0}${CommonUtils.txt('jbjsbtzz')}",
            style: GQStyle.blue80_14_M),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (detailData['secret'].isEmpty) return;
            Clipboard.setData(ClipboardData(text: "${detailData['secret']}"));
            CommonUtils.showText(CommonUtils.txt('fzcg'));
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: CommonUtils.txt("jymm"),
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                TextSpan(
                    text: detailData['secret'].isEmpty
                        ? CommonUtils.txt("ptjc")
                        : "${detailData['secret']}",
                    style: TextStyle(
                        color: GQStyle.cyanColor00edfd, fontSize: 14.sp)),
                detailData['secret'].isEmpty
                    ? TextSpan()
                    : TextSpan(
                        text: " [${CommonUtils.txt("dwfz")}]",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp)),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.w),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Clipboard.setData(ClipboardData(text: "${detailData['link']}"));
            CommonUtils.showText(CommonUtils.txt('fzcg'));
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: CommonUtils.txt("xzlj"),
                    style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
                TextSpan(
                    text: "${detailData['link']}".replaceAll(",", "\n"),
                    style: TextStyle(
                        color: GQStyle.cyanColor00edfd, fontSize: 14.sp)),
                TextSpan(
                    text: " [${CommonUtils.txt("dwfz")}]",
                    style: TextStyle(color: Colors.red, fontSize: 14.sp)),
              ],
            ),
          ),
        )
      ],
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
      bitPostComment(post_id: post_id, comment_id: comment_id, content: value)
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
              ? GQStyle.cyanColor00edfd
              : Colors.transparent,
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(25 / 2))),
          border: Border.all(
              color: detailData["user"]["is_follow"] == 1
                  ? Colors.transparent
                  : GQStyle.cyanColor00edfd,
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
