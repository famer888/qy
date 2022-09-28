import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/input_box_comment.dart';
import 'package:qypj/utils/networkImage.dart';

class CommunityPostReview extends StatefulWidget {
  CommunityPostReview({
    Key key,
    this.data,
    this.isSecond = false,
    this.replyCall,
    this.resetCall,
  }) : super(key: key);
  final dynamic data;
  final bool isSecond;
  final Function(String tip, String postid, String commid) replyCall;
  final Function() resetCall;

  @override
  State<CommunityPostReview> createState() => _CommunityPostReviewState();
}

class _CommunityPostReviewState extends State<CommunityPostReview> {
  dynamic _data;
  List<dynamic> _comments = [];
  List<dynamic> _tcoments = [];
  int max = 5;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
    _comments = _data["comments"] == null ? [] : List.from(_data["comments"]);
    //回复超过5条就显示更多评论
    _tcoments = _comments.length > max ? _comments.sublist(0, max) : _comments;
  }

  @override
  void didUpdateWidget(covariant CommunityPostReview oldWidget) {
    _data = widget.data;
    _comments = _data["comments"] == null ? [] : List.from(_data["comments"]);
    //回复超过5条就显示更多评论
    _tcoments = _comments.length > max ? _comments.sublist(0, max) : _comments;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    double w = 0;
    if (_data != null) {
      w = CommonUtils.boundingTextSize(
              context, _data["user"]["nickname"] ?? "", GQStyle.white23_12)
          .width;
    }
    return Container(
      child: Column(
        children: [
          SizedBox(height: ScreenUtil().setWidth(15)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setWidth(30),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: PlatformAwareNetworkImage(
                      url: _data["user"]["thumb"] ?? "",
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(30 / 2))),
                    ),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(10)),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: w > ScreenUtil().setWidth(180)
                                  ? ScreenUtil().setWidth(180)
                                  : w,
                              child: Text(
                                _data["user"]["nickname"] ?? "",
                                style: GQStyle.white23_12,
                              ),
                            ),
                            SizedBox(width: ScreenUtil().setWidth(10)),
                            _data["user"]["vip_level"] > 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(7)),
                                    height: ScreenUtil().setWidth(14),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(7))),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFf5e0d1),
                                            Color(0xFFfbeadd),
                                            Color(0xFFf4d4b5)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )),
                                    child: Center(
                                      child: Text(
                                        CommonUtils.txt("vvp"),
                                        style: GQStyle.brown137_8,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                                width: ScreenUtil().setWidth(
                                    _data["user"]["vip_level"] > 0 ? 8 : 0)),
                            _data["user"]["auth_status"] == 1
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(7)),
                                    height: ScreenUtil().setWidth(13),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(6.5))),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFffca43),
                                            Color(0xFFff7d3e)
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        )),
                                    child: Center(
                                      child: Text(
                                        CommonUtils.txt("cuangz"),
                                        style: GQStyle.white255_8,
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setWidth(4)),
                        Text(
                          "${_data["cityname"] ?? CommonUtils.txt("csxq")}·${RelativeDateFormat.format(DateTime.parse(_data["created_at"] ?? ""))}",
                          style: GQStyle.gray163_11,
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    communityTopicLike(
                            type: "comment", id: _data["id"].toString())
                        .then((res) {
                      if (res.status == 1) {
                        _data["is_like"] = _data["is_like"] == 1 ? 0 : 1;
                        _data["like_num"] = _data["is_like"] == 1
                            ? _data["like_num"] + 1
                            : _data["like_num"] - 1;
                        setState(() {});
                      } else {
                        CommonUtils.showText(res.msg);
                      }
                    });
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(40),
                    child: Column(
                      children: [
                        LImage(
                          _data["is_like"] == 1
                              ? "comm_review_h"
                              : "comm_review_n",
                          width: ScreenUtil().setWidth(20),
                          height: ScreenUtil().setWidth(20),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(1)),
                        Text(
                          CommonUtils.renderFixedNumber(_data["like_num"] ?? 0),
                          style: GQStyle.gray203_12,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setWidth(13)),
          widget.isSecond
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                      child: Text(
                        _data["comment"] != null
                            ? CommonUtils.convertEmojiAndHtml(_data["comment"])
                            : "",
                        style: GQStyle.gray208_13,
                        textAlign: TextAlign.left,
                        maxLines: AppGlobal.maxLines,
                      ),
                    ),
                  ],
                )
              : GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.replyCall(
                        CommonUtils.txt("hf") +
                            "@${_data["user"]["nickname"] ?? ""}",
                        "0",
                        _data["id"].toString());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        child: Text(
                          _data["comment"] != null
                              ? CommonUtils.convertEmojiAndHtml(
                                  _data["comment"])
                              : "",
                          style: GQStyle.gray208_13,
                          textAlign: TextAlign.left,
                          maxLines: AppGlobal.maxLines,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LImage(
                            "comm_pldh_n",
                            width: ScreenUtil().setWidth(18),
                            height: ScreenUtil().setWidth(18),
                          ),
                          SizedBox(width: ScreenUtil().setWidth(6)),
                          Text(
                            CommonUtils.txt("hf"),
                            style: GQStyle.gray203_13,
                          )
                        ],
                      )
                    ],
                  ),
                ),
          _tcoments.length == 0 || widget.isSecond
              ? SizedBox(height: ScreenUtil().setWidth(15))
              : Container(
                  margin:
                      EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _tcoments.asMap().keys.map((x) {
                      return Container(
                        margin:
                            EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                        padding: EdgeInsets.only(
                          left: ScreenUtil().setWidth(10),
                          right: ScreenUtil().setWidth(10),
                          top: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil()
                              .setWidth(x == _tcoments.length - 1 ? 10 : 0),
                        ),
                        width: double.infinity,
                        color: Color(0xFFf2f2f2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(TextSpan(children: [
                              _tcoments[x]["is_landlord"] == 1
                                  ? WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(6)),
                                        child: Container(
                                          height: ScreenUtil().setWidth(16),
                                          width: ScreenUtil().setWidth(40),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFdf6b04),
                                                Color(0xFFdd952f)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setWidth(8))),
                                          ),
                                          child: Center(
                                            child: Text("楼主",
                                                style: GQStyle.white255_11),
                                          ),
                                        ),
                                      ),
                                    )
                                  : TextSpan(),
                              TextSpan(
                                text:
                                    "${_tcoments[x]["user"]["nickname"] ?? ""} ${CommonUtils.txt("hf")}：",
                                style: GQStyle.greent113_12,
                              )
                            ])),
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            Text(
                              _tcoments[x]["comment"] != null
                                  ? CommonUtils.convertEmojiAndHtml(
                                      _tcoments[x]["comment"])
                                  : "",
                              style: GQStyle.gray208_13,
                              maxLines: AppGlobal.maxLines,
                            ),
                            x == _tcoments.length - 1 && _comments.length > max
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      if (widget.resetCall != null) {
                                        widget.resetCall();
                                      }
                                      _showMoreReview();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: ScreenUtil().setWidth(10)),
                                      child: Container(
                                        height: ScreenUtil().setWidth(30),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF464952),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  ScreenUtil().setWidth(2))),
                                        ),
                                        child: Center(
                                          child: Text(
                                            CommonUtils.txt("gdhf"),
                                            style: GQStyle.white255_12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
          Container(
            height: ScreenUtil().setWidth(0.5),
            color: Color(0xFF15152a),
          )
        ],
      ),
    );
  }

  _showMoreReview() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setBottomSheetState) {
            return CommunityPostReviewSecond(
              comment: _data,
            );
          });
        });
  }
}

class CommunityPostReviewSecond extends StatefulWidget {
  CommunityPostReviewSecond({Key key, this.comment}) : super(key: key);
  final dynamic comment;

  @override
  State<CommunityPostReviewSecond> createState() =>
      _CommunityPostReviewSecondState();
}

class _CommunityPostReviewSecondState extends State<CommunityPostReviewSecond> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  List<dynamic> _comments = [];
  List<dynamic> _comentsList = [];
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _comments = List.from(widget.comment["comments"]);
    _getData();
  }

  @override
  void didUpdateWidget(covariant CommunityPostReviewSecond oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        focusNode.unfocus();
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getData() {
    communityPostCommentsSecond(
            comment_id: widget.comment["id"].toString(), page: page)
        .then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data;
      if (page == 1) {
        noMore = false;
        _comentsList = st;
      } else if (st.length > 0) {
        _comentsList.addAll(st);
      } else {
        noMore = true;
      }
      isHud = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Container(
          height: ScreenUtil().screenHeight * 0.6,
          decoration: BoxDecoration(
            color: GQStyle.bgColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(ScreenUtil().setWidth(20)),
              topRight: Radius.circular(ScreenUtil().setWidth(20)),
            ),
          ),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusNode.unfocus();
            },
            child: networkErr
                ? PageStatus.noNetWork(onTap: () {
                    networkErr = false;
                    _getData();
                  })
                : isHud
                    ? PageStatus.loading(mounted)
                    : InputCommentBox(
                        focusNode: focusNode,
                        labelText: CommonUtils.txt("hf") +
                            "@${widget.comment["user"]["nickname"] ?? ""}",
                        onEditingCompleteText: (value) {
                          _inputTxt(value);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(20),
                                  top: ScreenUtil().setWidth(20),
                                  bottom: ScreenUtil().setWidth(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
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
                                  Text(
                                    "${_comments.length}${CommonUtils.txt('taoi')}${CommonUtils.txt('hf')}",
                                    style: GQStyle.white255_18_M,
                                  ),
                                  Container(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: PullRefreshList(
                                isAll: noMore,
                                onLoading: () {
                                  page++;
                                  _getData();
                                },
                                child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: GQStyle.pagePadding,
                                    ),
                                    itemCount: _comentsList.length,
                                    itemBuilder: (context, index) {
                                      return CommunityPostReview(
                                        data: _comentsList[index],
                                        isSecond: true,
                                      );
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
          )),
    );
  }

  _inputTxt(String value) {
    if (AppGlobal.vipLevel > 0 || true) {
      if (value == null) return;
      if (value.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsrnr"));
        return;
      }
      CommonUtils.startLoadGIF(tip: CommonUtils.txt("fbioz"));
      communityPostComment(
              post_id: "0",
              comment_id: widget.comment["id"].toString(),
              content: value)
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
}
