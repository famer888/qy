import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
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
import 'package:qypj/utils/util_eventbus_class.dart';

class CommunityIssue extends BaseWidget {
  CommunityIssue({Key key, this.type}) : super(key: key);
  final int type; //0发布图片 1发布视频 2发布图文

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _CommunityIssueState();
  }
}

class _CommunityIssueState extends BaseWidgetState<CommunityIssue> {
  Map setLabel = {};
  List<dynamic> labels = [];
  final txtcontroller = TextEditingController();
  final tkcontroller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode focusNodeTxt = FocusNode();
  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  var discrip;

  int limit = 0;
  List<Map> upList = [];
  bool isHud = true;

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(
      title: CommonUtils.txt("fbtz"),
      rightW: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _upData();
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00d2be), Color(0xFF6496fc)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(14))),
          ),
          height: ScreenUtil().setWidth(28),
          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
          child: Center(
            child: Text(
              CommonUtils.txt("fb"),
              style: GQStyle.white255_14_B,
            ),
          ),
        ),
      ),
    );
    limit = widget.type == 1 ? 1 : 9;
    _getData();
    discrip = UtilEventbus().on<UtilEventbusClass>().listen((event) {
      if (event.arg["name"] == 'tagsall') {
        setLabel = event.arg["data"];
        CommonUtils.debugPrint(event.arg);
        setState(() {});
      }
    });
  }

  _getData() {
    communityTopics().then((value) {
      if (value.status == 1) {
        labels = value.data;
        isHud = false;
        setState(() {});
      } else {
        CommonUtils.showText(value.msg);
        context.pop();
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    focusNode.dispose();
    focusNodeTxt.dispose();
    discrip.cancel();
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> imagePickerVideoAssets() async {
    final XFile file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.videoLimitSize(file, size: 40);
      if (flag) return;
      String ext = file.name.split(".").last.toLowerCase();
      if (ext == "mp4" || file.mimeType == 'video/quicktime') {
        uploadVideo(file);
      } else {
        CommonUtils.showText(CommonUtils.txt("qxzmpf"));
      }
    }
  }

  void uploadVideo(XFile file) {
    BotToast.showCustomLoading(
      toastBuilder: (cancel) => XFileProgressToast(
        file: file,
        response: (data) {
          CommonUtils.debugPrint("===$data");
          BotToast.closeAllLoading();
          if (data['code'] == 1) {
            String url = data['msg'].toString();
            if (kIsWeb) {
              _controller = VideoPlayerController.network(file.path);
            } else {
              _controller = VideoPlayerController.file(File(file.path));
            }
            _initializeVideoPlayerFuture = _controller.initialize();
            upList = [
              {
                "media_url": url,
                "thumb_width": 1600,
                "thumb_height": 900,
              }
            ];
            setState(() {});
          } else {
            CommonUtils.showText(data['msg'] ?? "failed");
          }
        },
      ),
    );
  }

  Future<void> imagePickerAssets() async {
    final XFile file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.pngLimitSize(file);
      if (flag) return;
      CommonUtils.debugPrint("${file.path}---${file.name}");
      uploadPNG(file);
    }
  }

  void uploadPNG(XFile file) async {
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
      Image localImage;
      if (kIsWeb) {
        localImage = Image.network(file.path);
      } else {
        localImage = Image.file(File.fromUri(Uri.parse(file.path)));
      }
      localImage.image
          .resolve(ImageConfiguration())
          .addListener(ImageStreamListener((info, _) {
        upList.add({
          "media_url": url,
          "url": AppGlobal.imgBase + url,
          "thumb_width": info.image.width,
          "thumb_height": info.image.height,
        });
        setState(() {});
      }));
    } else {
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  _upData() {
    if (setLabel.length == 0) {
      CommonUtils.showText(CommonUtils.txt("q") + CommonUtils.txt("xzht"));
      return;
    }
    if (txtcontroller.text.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsbtxx"));
      return;
    }
    if (tkcontroller.text.length == 0 && upList.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsnrxx"));
      return;
    }
    initLoadGIF();
    communityPost(
      topic_id: setLabel["id"].toString(),
      title: txtcontroller.text,
      content: tkcontroller.text ?? "",
      medias: json.encode(upList),
    ).then((res) {
      BotToast.closeAllLoading();
      if (res.status == 1) {
        YyShowDialog.showdialog(
          context,
          title: CommonUtils.txt('fbcg'),
          btnText: CommonUtils.txt('qd'),
          prohibitClose: false,
          callBack: () {
            context.pop();
          },
          content: (setDialogState) {
            return DefaultTextStyle(
                style: GQStyle.gray203_13,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CommonUtils.txt("fbcgdsh"),
                      style: GQStyle.gray203_13,
                      maxLines: 3,
                    ),
                  ],
                ));
          },
        );
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
                color: Color(0xFF23262e),
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
                          CommonUtils.txt('xzht'),
                          style: GQStyle.white255_18_M,
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.pop();
                          },
                          child: LImage(
                            "alert_close_n",
                            width: ScreenUtil().setWidth(15),
                            height: ScreenUtil().setWidth(15),
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
                    children: labels
                        .map((e) => GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                context.pop();
                                setLabel = e;
                                setState(() {});
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
                                      color: setLabel["name"] == e["name"]
                                          ? Color(0xFF60B2DC)
                                          : Color(0xffffffff),
                                      width: ScreenUtil().setWidth(0.5)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "#${e["name"] ?? ""}",
                                      style: setLabel["name"] == e["name"]
                                          ? GQStyle.blue80_11
                                          : GQStyle.gray163_11,
                                    )
                                  ],
                                ),
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
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return isHud
        ? PageStatus.loading(mounted)
        : GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              focusNode.unfocus();
              focusNodeTxt.unfocus();
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setWidth(20),
                  horizontal: GQStyle.pagePadding),
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _showLabelsAlert();
                      // context.push("/communitytagsall/1");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(10)),
                      height: ScreenUtil().setWidth(50),
                      decoration: BoxDecoration(
                        color: Color(0xFF2f2f42),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(5))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              setLabel.length == 0
                                  ? "#${CommonUtils.txt("xzht")}"
                                  : "#${setLabel["name"]}",
                              style: GQStyle.gray143_15),
                          LImage(
                            "issue_arrow_n",
                            width: ScreenUtil().setWidth(6),
                            height: ScreenUtil().setWidth(10),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(30)),
                  SizedBox(
                    height: ScreenUtil().setWidth(40),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFaaaaaa), width: .5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenUtil().setWidth(5))),
                      ),
                      child: TextField(
                        focusNode: focusNode,
                        autofocus: false,
                        controller: txtcontroller,
                        style: GQStyle.white255_15,
                        cursorColor: Color.fromRGBO(255, 255, 255, 1),
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hoverColor: Colors.white,
                          hintText: CommonUtils.txt('tbtxx'),
                          hintStyle: TextStyle(
                            color: Color(0xffa1a2a9),
                            fontFamily: GQStyle.hanyi,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(8)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(
                                  color: Colors.transparent, width: 0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setWidth(17)),
                  widget.type == 2
                      ? SizedBox(
                          height: ScreenUtil().setWidth(150),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFaaaaaa), width: .5),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(5))),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              minLines: 1,
                              focusNode: focusNodeTxt,
                              autofocus: false,
                              controller: tkcontroller,
                              style: GQStyle.white255_15,
                              cursorColor: Color.fromRGBO(255, 255, 255, 1),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: ScreenUtil().setWidth(8)),
                                hoverColor: Colors.white,
                                hintText: CommonUtils.txt('runr'),
                                hintStyle: TextStyle(
                                  color: Color(0xffa1a2a9),
                                  fontFamily: GQStyle.hanyi,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0)),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(height: ScreenUtil().setWidth(27)),
                  Row(
                    children: [
                      Text(
                        widget.type == 1
                            ? CommonUtils.txt("scsp")
                            : CommonUtils.txt("sctp"),
                        style: GQStyle.white255_15_M,
                      ),
                      SizedBox(width: ScreenUtil().setWidth(10)),
                      Text(
                        widget.type == 1
                            ? (kIsWeb
                                ? CommonUtils.txt("zdybm")
                                    .replaceAll("100", "40")
                                : CommonUtils.txt("zdybm"))
                            : CommonUtils.txt("zdjzbkb"),
                        style: GQStyle.gray208_13,
                      )
                    ],
                  ),
                  SizedBox(height: ScreenUtil().setWidth(20)),
                  widget.type == 1
                      ? GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: ScreenUtil().setWidth(10),
                          crossAxisSpacing: ScreenUtil().setWidth(10),
                          children: [
                              Container(
                                color: Colors.transparent,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: upList.length > 0
                                          ? Stack(
                                              children: [
                                                Center(
                                                  child: FutureBuilder(
                                                    //显示缩略图
                                                    future:
                                                        _initializeVideoPlayerFuture,
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .done) {
                                                        upList.first[
                                                                "thumb_width"] =
                                                            _controller.value
                                                                .size.width
                                                                .round();
                                                        upList.first[
                                                                "thumb_height"] =
                                                            _controller.value
                                                                .size.height
                                                                .round();
                                                        return AspectRatio(
                                                          aspectRatio:
                                                              _controller.value
                                                                  .aspectRatio,
                                                          child: VideoPlayer(
                                                              _controller),
                                                        );
                                                      } else {
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            backgroundColor:
                                                                Colors.white,
                                                          ),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Center(
                                                  child: LImage(
                                                    "v_play_n",
                                                    width: ScreenUtil()
                                                        .setWidth(30),
                                                    height: ScreenUtil()
                                                        .setWidth(30),
                                                  ),
                                                )
                                              ],
                                            )
                                          : LImage('issue_add_n'),
                                    ),
                                    GestureDetector(
                                      onTap: imagePickerVideoAssets,
                                    )
                                  ],
                                ),
                              )
                            ])
                      : GridView.count(
                          padding: EdgeInsets.zero,
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          mainAxisSpacing: ScreenUtil().setWidth(10),
                          crossAxisSpacing: ScreenUtil().setWidth(10),
                          children: upList.map((e) {
                            Widget w = Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setWidth(9),
                                    right: ScreenUtil().setWidth(9),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(5)),
                                    ),
                                    child: PlatformAwareNetworkImage(
                                      fit: BoxFit.contain,
                                      url: e["url"],
                                      background: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      upList.remove(e);
                                      setState(() {});
                                    },
                                    child: LImage(
                                      "report_del_n",
                                      width: ScreenUtil().setWidth(18),
                                      height: ScreenUtil().setWidth(18),
                                    ),
                                  ),
                                )
                              ],
                            );
                            return w;
                          }).toList()
                            ..add(
                              upList.length == limit
                                  ? Container()
                                  : Stack(
                                      children: [
                                        GestureDetector(
                                          onTap: imagePickerAssets,
                                          child: LImage('issue_add_n'),
                                        ),
                                      ],
                                    ),
                            ),
                        )
                ],
              ),
            ),
          );
  }
}
