import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
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

class VideoCommentPage extends StatefulWidget {
  VideoCommentPage({Key key, this.id}) : super(key: key);
  final int id;
  @override
  State<VideoCommentPage> createState() => _VideoCommentPageState();
}

class _VideoCommentPageState extends State<VideoCommentPage> {
  int page = 1;
  bool noMore = false;
  bool networkErr = false;
  bool isHud = true;
  String last_ix = "";
  List<dynamic> _comentsList = [];
  final FocusNode focusNode = FocusNode();
  final FocusNode xcfocusNode = FocusNode();
  String tip = CommonUtils.txt("wyddxf");
  String postid = "0";
  String commid = "0";
  bool isReplay = false;

  int refreashCount = 0;

  _resetXcfocusNode() {
    isReplay = false;
    tip = CommonUtils.txt("wyddxf");
    xcfocusNode.unfocus();
    // focusNode.unfocus();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  // @override
  // void didUpdateWidget(covariant VideoCommentPage oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   super.didUpdateWidget(oldWidget);
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (MediaQuery.of(context).viewInsets.bottom == 0) {
  //       _resetXcfocusNode();
  //       // focusNode.unfocus();
  //     } else {}
  //   });
  // }

  _getData() {
    cartoonListCommentMv(id: widget.id, last_ix: last_ix, page: page)
        .then((res) {
      if (res.data == null) {
        networkErr = true;
        setState(() {});
        return;
      }
      List st = res.data["list"];
      last_ix = res.data["last_ix"] == null ? "" : res.data["last_ix"];
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
    refreashCount += 1;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        focusNode.unfocus();
      },
      child: InputCommentBox(
        focusNode: focusNode,
        labelText: CommonUtils.txt("wyddxf"),
        onEditingCompleteText: (value) {
          _inputTxt(value);
        },
        child: networkErr
            ? PageStatus.noNetWork(onTap: () {
                networkErr = false;
                _getData();
              })
            : isHud
                ? PageStatus.loading(mounted)
                : _comentsList.length == 0
                    ? Container(
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Stack(
                            children: [
                              Positioned(
                                  // top: (constraints.maxHeight -
                                  //         ScreenUtil().setWidth(200)) /
                                  //     2,
                                  top: GQStyle.pagePadding,
                                  child: SizedBox(
                                      // width: ScreenUtil().setWidth(200),
                                      width: ScreenUtil().screenWidth,
                                      height: ScreenUtil().setWidth(200),
                                      child:
                                          Center(child: PageStatus.noData())))
                            ],
                          );
                        }),
                      )
                    : PullRefreshList(
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
                              return _reviewWidget(_comentsList[index]);
                            }),
                      ),
      ),
    );
  }

  //加载动画
  void initLoadGIF({String tip = "发布中"}) {
    BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(54, 54, 54, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: ScreenUtil().setWidth(110),
        width: ScreenUtil().setWidth(110),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // LImage("ref_data_n",
            //     width: ScreenUtil().setWidth(40),
            //     height: ScreenUtil().setWidth(40),
            //     ext: ".gif"),
            Column(
              children: [
                Container(
                  width: ScreenUtil().setWidth(40),
                  height: ScreenUtil().setWidth(40),
                  child: CircularProgressIndicator(
                    color: GQStyle.jellyCyanColor103224185,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(12),
            ),
            Text(tip, style: GQStyle.white255_14)
          ],
        ),
      );
    });
  }

  _inputTxt(String value) {
    if (AppGlobal.vipLevel > 0 || true) {
      if (value == null) return;
      if (value.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsrnr"));
        return;
      }
      CommonUtils.startLoadGIF(tip: CommonUtils.txt("fbioz"));
      cartoonCreateCommentMv(id: widget.id, content: value).then((res) {
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

  Widget _reviewWidget(dynamic data) {
    double w = 0;
    if (data != null) {
      w = CommonUtils.boundingTextSize(
              context, data["member"]["nickname"] ?? "", GQStyle.white23_12)
          .width;
    }
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  onTap: () {
                    context.push('/mineUserCenter/${data["member"]["aff"]}');
                  },
                  child: PlatformAwareNetworkImage(
                    url: data["member"]["thumb"] ?? "",
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
                              data["member"]["nickname"] ?? "",
                              style: GQStyle.white23_12,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          data["member"]['agent'] == 1
                              ? Icon(Icons.verified_sharp,
                                  size: 11.w,
                                  color: Color.fromRGBO(247, 208, 93, 1))
                              : Container(),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setWidth(4)),
                      Row(
                        children: [
                          CommonUtils.memberVip(
                            data["member"]["vip_str"],
                            h: 14,
                            fontsize: 7,
                            margin: 5,
                          ),
                          Text(
                            "${RelativeDateFormat.format(DateTime.parse(data["created_at"] ?? ""))}",
                            style: GQStyle.gray163_11,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  cartoonCommentMvLike(id: data["id"]).then((res) {
                    if (res.status == 1) {
                      data["is_like"] = data["is_like"] == 1 ? 0 : 1;
                      data["like_count"] = data["is_like"] == 1
                          ? data["like_count"] + 1
                          : data["like_count"] - 1;
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
                        data["is_like"] == 1
                            ? "comm_review_h"
                            : "comm_review_n",
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(20),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(1)),
                      Text(
                        CommonUtils.renderFixedNumber(data["like_count"] ?? 0),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
              child: Text(
                data["content"] != null
                    ? CommonUtils.convertEmojiAndHtml(data["content"])
                    : "",
                style: GQStyle.gray208_13,
                textAlign: TextAlign.left,
                maxLines: AppGlobal.maxLines,
              ),
            ),
          ],
        ),
        SizedBox(height: ScreenUtil().setWidth(15)),
        Container(
          height: ScreenUtil().setWidth(0.5),
          color: Color(0xFF15152a),
        )
      ]),
    );
  }
}
