import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/components/yy_dialog.dart';
import 'package:qypj/global.dart';
import 'package:qypj/pages/community/xfile_progresstoast.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/networkImage.dart';

class MineCreaterIssue extends BaseWidget {
  MineCreaterIssue({Key key, this.id}) : super(key: key);
  final String id;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterIssueState();
  }
}

class _MineCreaterIssueState extends BaseWidgetState<MineCreaterIssue> {
  String imgurl = "";
  String videourl = "";
  bool isHud = true;
  dynamic data;
  List<String> selTags = [];
  List<String> tempTags = [];
  bool isReadRule = false;
  final FocusNode focusNode = FocusNode();
  final FocusNode xfocusNode = FocusNode();
  final txtcontroller = TextEditingController();
  final xtxtcontroller = TextEditingController();

  _getData() {
    topicUploadInfo().then((res) {
      if (res.status == 1) {
        isHud = false;
        data = res.data;
        AppGlobal.rules = res.data["rule"];
        setState(() {});
        CommonUtils.debugPrint("${data["limit_msg"]} -- ${data["limit"]}");
        if (data["limit_msg"].toString().length > 0) {
          YyShowDialog.showdialog(
            context,
            title: CommonUtils.txt("ts"),
            content: (setDialogState) {
              return Text(
                data["limit_msg"] ?? "",
                style: GQStyle.graya3a2a2_13,
              );
            },
            btnText: CommonUtils.txt("qr"),
          );
        }
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
    setAppTitle(title: CommonUtils.txt("fb"));
    _getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    AppGlobal.rules = "";
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : SingleChildScrollView(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                focusNode.unfocus();
                xfocusNode.unfocus();
              },
              child: Column(
                children: [
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (videourl.length > 0) return;
                                  imagePickerVideoAssets();
                                },
                                child: Container(
                                  height: ScreenUtil().setWidth(100),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF23262f),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(5))),
                                  ),
                                  child: Stack(
                                    children: [
                                      videourl.length == 0
                                          ? Center(
                                              child:
                                                  Text.rich(TextSpan(children: [
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setWidth(2)),
                                                    child: LImage(
                                                      "create_add_n",
                                                      width: ScreenUtil()
                                                          .setWidth(12),
                                                      height: ScreenUtil()
                                                          .setWidth(12),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        CommonUtils.txt("tjsp"),
                                                    style: GQStyle.gray163_14_M)
                                              ])),
                                            )
                                          : Center(
                                              child: Stack(
                                                children: [
                                                  PlatformAwareNetworkImage(
                                                    url: "",
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            ScreenUtil()
                                                                .setWidth(5))),
                                                  ),
                                                  Center(
                                                    child: GestureDetector(
                                                      behavior: HitTestBehavior
                                                          .translucent,
                                                      onTap: () {
                                                        videourl = "";
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: ScreenUtil()
                                                            .setWidth(26),
                                                        width: ScreenUtil()
                                                            .setWidth(50),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              35, 38, 47, 1.0),
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          2))),
                                                          border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      240,
                                                                      128,
                                                                      128,
                                                                      1.0),
                                                              width:
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          1.0)),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            CommonUtils.txt(
                                                                "shanc"),
                                                            style: GQStyle
                                                                .red255_13_M,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(8)),
                              Text(CommonUtils.txt("qxzbmbv"),
                                  style: GQStyle.gray163_11),
                            ],
                          ),
                        ),
                        SizedBox(width: ScreenUtil().setWidth(10)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: imagePickerAssets,
                                child: Container(
                                  height: ScreenUtil().setWidth(100),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF23262f),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(5))),
                                  ),
                                  child: Stack(
                                    children: [
                                      imgurl.length == 0
                                          ? Center(
                                              child:
                                                  Text.rich(TextSpan(children: [
                                                WidgetSpan(
                                                  alignment:
                                                      PlaceholderAlignment
                                                          .middle,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: ScreenUtil()
                                                            .setWidth(2)),
                                                    child: LImage(
                                                      "create_add_n",
                                                      width: ScreenUtil()
                                                          .setWidth(12),
                                                      height: ScreenUtil()
                                                          .setWidth(12),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                    text:
                                                        CommonUtils.txt("tjfm"),
                                                    style: GQStyle.gray163_14_M)
                                              ])),
                                            )
                                          : PlatformAwareNetworkImage(
                                              fit: BoxFit.contain,
                                              url: imgurl,
                                              background: Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(5))),
                                            ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(8)),
                              Text(CommonUtils.txt("qxzbkbp"),
                                  style: GQStyle.gray163_11),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  Container(
                      height: ScreenUtil().setWidth(5),
                      color: Color(0xFF23262f)),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(CommonUtils.txt("txbt"),
                                style: GQStyle.white255_15),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            Expanded(
                              child: TextField(
                                focusNode: focusNode,
                                autofocus: false,
                                controller: txtcontroller,
                                style: GQStyle.white255_15,
                                cursorColor: Colors.white,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: CommonUtils.txt('btgsnr'),
                                  hintStyle: TextStyle(
                                    color: Color(0xffffffff),
                                    fontFamily: GQStyle.hanyi,
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
                                          color: Colors.transparent, width: 0)),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setWidth(0.5),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        Row(
                          children: [
                            Text(CommonUtils.txt("szjg"),
                                style: GQStyle.white255_15),
                            SizedBox(width: ScreenUtil().setWidth(20)),
                            Expanded(
                              child: TextField(
                                focusNode: xfocusNode,
                                autofocus: false,
                                enabled: data["limit"] > 0,
                                controller: xtxtcontroller,
                                style: GQStyle.white255_15,
                                cursorColor: Colors.white,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: InputDecoration(
                                  hoverColor: Colors.white,
                                  hintText: data["limit"] > 0
                                      ? CommonUtils.txt('zgkszbs').replaceAll(
                                          RegExp(r'50'),
                                          data["price"].toString())
                                      : CommonUtils.txt('dqwmfsp'),
                                  hintStyle: TextStyle(
                                    color: Color(0xffffffff),
                                    fontFamily: GQStyle.hanyi,
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
                                          color: Colors.transparent, width: 0)),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setWidth(0.5),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(CommonUtils.txt("xzbq"),
                                style: GQStyle.white255_15),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                _showLabelsAlert();
                              },
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                    text: CommonUtils.txt("zdxzsg"),
                                    style: GQStyle.gray163_13),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: LImage(
                                    "issue_arrow_n",
                                    width: ScreenUtil().setWidth(10),
                                    height: ScreenUtil().setWidth(10),
                                  ),
                                )
                              ])),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: ScreenUtil().setWidth(20)),
                          height: ScreenUtil().setWidth(0.5),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          runSpacing: GQStyle.pagePadding,
                          spacing: GQStyle.pagePadding,
                          children: selTags
                              .map(
                                (e) => Container(
                                  height: ScreenUtil().setWidth(30),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Color(0xffffffff),
                                      width: ScreenUtil().setWidth(0.5),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(15)),
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: GQStyle.pagePadding),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text.rich(TextSpan(children: [
                                        TextSpan(
                                            text: e, style: GQStyle.gray163_11)
                                      ]))
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(125)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                isReadRule = !isReadRule;
                                setState(() {});
                              },
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(4)),
                                        child: LImage(
                                          isReadRule
                                              ? "wd_radiosel_n"
                                              : "wd_radio_n",
                                          width: ScreenUtil().setWidth(12),
                                          height: ScreenUtil().setWidth(12),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                        text: CommonUtils.txt("tybzs"),
                                        style: GQStyle.gray163_12),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                context.push(CommonUtils.getRealHash(
                                    "minecreaterissuerule"));
                              },
                              child: Text(CommonUtils.txt("fljscxz"),
                                  style: GQStyle.blue80_12),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil().setWidth(15)),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _upData();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                              borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(5)),
                              ),
                            ),
                            height: ScreenUtil().setWidth(40),
                            child: Center(
                              child: Text(
                                CommonUtils.txt("fb"),
                                style: GQStyle.white255_15_M,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  _upData() {
    if (videourl.length == 0) {
      CommonUtils.showText(CommonUtils.txt("q") + CommonUtils.txt("tjsp"));
      return;
    }
    if (imgurl.length == 0) {
      CommonUtils.showText(CommonUtils.txt("q") + CommonUtils.txt("tjfm"));
      return;
    }
    if (txtcontroller.text.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsbtxx"));
      return;
    }
    String ts = "";
    selTags.forEach((x) {
      if (ts == "")
        ts = x;
      else
        ts = "$ts,$x";
    });
    if (ts.length == 0) {
      CommonUtils.showText(CommonUtils.txt("q") + CommonUtils.txt("xzbq"));
      return;
    }
    if (!isReadRule) {
      CommonUtils.showText(CommonUtils.txt("q") +
          CommonUtils.txt("tybzs") +
          CommonUtils.txt("fljscxz"));
      return;
    }
    initLoadGIF();
    topicCreateVideo(
      title: txtcontroller.text,
      thumb: imgurl.replaceAll(AppGlobal.imgBase, ""),
      topic_id: widget.id,
      tags: ts,
      source_240: videourl,
      coins: xtxtcontroller.text.length == 0
          ? "0"
          : xtxtcontroller.text.toString(),
    ).then((res) {
      BotToast.closeAllLoading();
      if (res.status == 1) {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      } else {
        CommonUtils.showText(res.msg);
      }
    });
  }

  _showLabelsAlert() {
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
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setWidth(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Text(
                          CommonUtils.txt('xzbq'),
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
                  Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    runSpacing: GQStyle.pagePadding,
                    spacing: GQStyle.pagePadding,
                    children: List.from(data["tags"])
                        .map((e) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (tempTags.contains(e.toString())) {
                                  tempTags.remove(e);
                                } else {
                                  tempTags.add(e);
                                }
                                setBottomSheetState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: ScreenUtil().setWidth(10)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(10)),
                                height: ScreenUtil().setWidth(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(12.5))),
                                  border: Border.all(
                                      color: tempTags.contains(e.toString())
                                          ? Color(0xFF00edfd)
                                          : Color(0xffffffff),
                                      width: ScreenUtil().setWidth(0.5)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "#$e",
                                      style: tempTags.contains(e.toString())
                                          ? GQStyle.blue80_11
                                          : GQStyle.gray163_11,
                                    )
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(30)),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (tempTags.length > 3) {
                        CommonUtils.showText(CommonUtils.txt("zdxzsg"));
                        return;
                      }
                      selTags = tempTags;
                      context.pop();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: GQStyle.btnGradient_ff00edfd_ffbbe954,
                        borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(5)),
                        ),
                      ),
                      height: ScreenUtil().setWidth(40),
                      child: Center(
                        child: Text(
                          CommonUtils.txt("qr"),
                          style: GQStyle.white255_15_M,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                ],
              )),
            );
          });
        });
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> imagePickerAssets() async {
    final XFile file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.pngLimitSize(file);
      if (flag) return;
      CommonUtils.debugPrint("${file.path}---${file.name}");
      uploadFileImg(file);
    }
  }

  void uploadFileImg(XFile file) async {
    initLoadGIF(tip: CommonUtils.txt('scz'));
    var res;
    if (kIsWeb) {
      res = await PlatformAwareHttp.xfileHtmlUploadImage(
          file: file, position: 'upload');
    } else {
      res = await PlatformAwareHttp.xfileUploadImage(
          file: file, position: 'upload');
    }
    var data = jsonDecode(res);
    BotToast.closeAllLoading();
    if (data['code'] == 1) {
      String url = data['msg'].toString();
      imgurl = AppGlobal.imgBase + url;
      setState(() {});
    } else {
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  Future<void> imagePickerVideoAssets() async {
    final XFile file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.videoLimitSize(file);
      if (flag) return;
      String ext = file.name.split(".").last.toLowerCase();
      if (ext == "mp4" || file.mimeType == 'video/quicktime') {
        uploadFileVideo(file);
      } else {
        CommonUtils.showText(CommonUtils.txt("qxzmpf"));
      }
    }
  }

  void uploadFileVideo(XFile file) {
    BotToast.showCustomLoading(
      toastBuilder: (cancel) => XFileProgressToast(
        file: file,
        response: (data) {
          CommonUtils.debugPrint("===$data");
          BotToast.closeAllLoading();
          if (data['code'] == 1) {
            videourl = data['msg'].toString();
            setState(() {});
          } else {
            CommonUtils.showText(data['msg'] ?? "failed");
          }
        },
      ),
    );
  }
}
