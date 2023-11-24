import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:video_player/video_player.dart';
import 'package:qypj/base/baseWidget.dart';
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
import 'package:image/image.dart' as imgLib;

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

  VideoPlayerController _controller;
  Future _initializeVideoPlayerFuture;
  var discrip;
  String title = '';
  String content = '';
  String coins = '0';

  int picLimit = 9;
  int videoLimit = 1;
  List<Map> upList = [];
  Map video = {};

  int money =
      Provider.of<HomeConfig>(AppGlobal.appContext, listen: false).member.money;
  int aipay = Provider.of<HomeConfig>(AppGlobal.appContext, listen: false)
      .config
      .pay_ai;
  int isOpen = 1;

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

    discrip = UtilEventbus().on<UtilEventbusClass>().listen((event) {
      if (event.arg["name"] == 'tagsall') {
        setLabel = event.arg["data"];
        CommonUtils.debugPrint(event.arg);
        setState(() {});
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    discrip.cancel();
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> imagePickerVideoAssets() async {
    final XFile file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.videoLimitSize(file);
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
            video = {
              "media_url": url,
              "thumb_width": 1600,
              "thumb_height": 900,
            };
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
      var image = imgLib.decodeImage(await file.readAsBytes());
      upList.add({
        "media_url": url,
        "url": AppGlobal.imgBase + url,
        "thumb_width": image.width,
        "thumb_height": image.height,
      });
      setState(() {});
    } else {
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  _upData() {
    if (setLabel.length == 0) {
      CommonUtils.showText(CommonUtils.txt("q") + CommonUtils.txt("xzht"));
      return;
    }
    if (title.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsbtxx"));
      return;
    }
    if (widget.type == 0) {
      if (upList.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsctp"));
        return;
      }
    }
    if (widget.type == 1) {
      if (upList.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsctp"));
        return;
      }
      if (video.length == 0 && setLabel['is_ai'] != 1) {
        CommonUtils.showText(CommonUtils.txt("qscsp"));
        return;
      }
      //设置默认第一张图为封面
      int index = upList.indexWhere((el) => el['media_url'].contains('.mp4'));
      if (index == -1 && video.isNotEmpty) {
        video["cover"] = upList.first["media_url"];
        video["url"] = upList.first["url"];
        upList.removeAt(0);
        upList.add(video);
      }
    }
    if (widget.type == 2) {
      if (content.length == 0) {
        CommonUtils.showText(CommonUtils.txt("qsnrxx"));
        return;
      }
    }
    // CommonUtils.debugPrint(
    //     "topic_id: ${setLabel["id"].toString()}, title: $title content: $content, medias: ${json.encode(upList)}, coins: $coins");
    // return;
    initLoadGIF();
    communityPost(
      topic_id: setLabel["id"].toString(),
      title: title,
      content: content,
      medias: json.encode(upList),
      coins: coins,
      is_public: isOpen,
      context: context,
      money: money - aipay,
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

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
            vertical: ScreenUtil().setWidth(20),
            horizontal: GQStyle.pagePadding),
        child: Column(
          children: [
            setLabel['is_ai'] == 1
                ? Padding(
                    padding: EdgeInsets.only(bottom: 20.w),
                    child: Text(
                      CommonUtils.txt('mtxq')
                          .replaceAll("00", setLabel['name'])
                          .replaceAll("11", "$aipay"),
                      style: GQStyle.red14,
                      maxLines: 3,
                    ),
                  )
                : Container(),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (widget.type == 1) {
                  context.push("/communityseltagpage/${setLabel['id'] ?? 0}/0");
                } else {
                  context.push("/communityseltagpage/${setLabel['id'] ?? 0}/1");
                }
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
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
                  autofocus: false,
                  onChanged: (value) {
                    title = value;
                  },
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
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0)),
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setWidth(20)),
            widget.type == 1
                ? Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(150),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFaaaaaa), width: .5),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(5))),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            minLines: 1,
                            autofocus: false,
                            onChanged: (value) {
                              content = value;
                            },
                            style: GQStyle.white255_15,
                            cursorColor: Color.fromRGBO(255, 255, 255, 1),
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: ScreenUtil().setWidth(8)),
                              hoverColor: Colors.white,
                              hintText: "[${CommonUtils.txt('xutie')}]" +
                                  CommonUtils.txt('runr'),
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
                      ),
                      SizedBox(height: 20.w),
                      setLabel['is_ai'] == 1
                          ? SizedBox(
                              height: ScreenUtil().setWidth(40),
                              child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xFFaaaaaa), width: .5),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setWidth(5))),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        CommonUtils.txt('sffbmzxx') + "：",
                                        style: TextStyle(
                                          color: Color(0xffa1a2a9),
                                          fontFamily: GQStyle.hanyi,
                                          fontSize: ScreenUtil().setSp(15),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          isOpen = 1;
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              CommonUtils.txt('qwmzxx'),
                                              style: TextStyle(
                                                color: Color(0xffa1a2a9),
                                                fontFamily: GQStyle.hanyi,
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Icon(
                                              isOpen == 1
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              size: 16.w,
                                              color: isOpen == 1
                                                  ? Color.fromRGBO(
                                                      103, 224, 185, 1)
                                                  : Color(0xffa1a2a9),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          isOpen = 0;
                                          setState(() {});
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              CommonUtils.txt('qwmzsm'),
                                              style: TextStyle(
                                                color: Color(0xffa1a2a9),
                                                fontFamily: GQStyle.hanyi,
                                                fontSize:
                                                    ScreenUtil().setSp(15),
                                              ),
                                            ),
                                            SizedBox(width: 2.w),
                                            Icon(
                                              isOpen == 0
                                                  ? Icons.check_circle
                                                  : Icons.circle_outlined,
                                              size: 16.w,
                                              color: isOpen == 0
                                                  ? Color.fromRGBO(
                                                      103, 224, 185, 1)
                                                  : Color(0xffa1a2a9),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )))
                          : SizedBox(
                              height: ScreenUtil().setWidth(40),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFFaaaaaa), width: .5),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setWidth(5))),
                                ),
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter(RegExp("[0-9]"),
                                        allow: true),
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  autofocus: false,
                                  style: GQStyle.white255_15,
                                  cursorColor: Color.fromRGBO(255, 255, 255, 1),
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value) {
                                    coins = value.isEmpty ? '0' : value;
                                  },
                                  decoration: InputDecoration(
                                    hoverColor: Colors.white,
                                    hintText: CommonUtils.txt('szspjg'),
                                    hintStyle: TextStyle(
                                      color: Color(0xffa1a2a9),
                                      fontFamily: GQStyle.hanyi,
                                      fontSize: ScreenUtil().setSp(15),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: ScreenUtil().setWidth(8)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0)),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 0)),
                                  ),
                                ),
                              ),
                            )
                    ],
                  )
                : widget.type == 2
                    ? SizedBox(
                        height: ScreenUtil().setWidth(150),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xFFaaaaaa), width: .5),
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setWidth(5))),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            minLines: 1,
                            autofocus: false,
                            onChanged: (value) {
                              content = value;
                            },
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
            widget.type == 1
                ? Column(
                    children: [
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      RichText(
                          maxLines: 2,
                          text: TextSpan(
                              text: "[${CommonUtils.txt('spfm')}]",
                              style: GQStyle.red15bold,
                              children: [
                                TextSpan(
                                    text: CommonUtils.txt("sctp"),
                                    style: GQStyle.white255_15_M),
                                TextSpan(
                                    text: " " + CommonUtils.txt("zdjzbkb"),
                                    style: GQStyle.gray208_13)
                              ])),
                      SizedBox(height: 10.w),
                      GridView.count(
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
                            upList.length == picLimit
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
                      ),
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      Row(
                        children: [
                          Text(
                            CommonUtils.txt("scsp"),
                            style: GQStyle.white255_15_M,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Text(
                            CommonUtils.txt("zdybm"),
                            style: GQStyle.gray208_13,
                          )
                        ],
                      ),
                      SizedBox(height: 10.w),
                      GridView.count(
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
                                      child: video.length > 0
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
                                                        video["thumb_width"] =
                                                            _controller.value
                                                                .size.width
                                                                .round();
                                                        video["thumb_height"] =
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
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      video = {};
                                                      upList.removeWhere((el) =>
                                                          el['media_url']
                                                              .contains(
                                                                  '.mp4'));
                                                      if (mounted)
                                                        setState(() {});
                                                    },
                                                    child: LImage(
                                                      "report_del_n",
                                                      width: ScreenUtil()
                                                          .setWidth(18),
                                                      height: ScreenUtil()
                                                          .setWidth(18),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          : GestureDetector(
                                              onTap: imagePickerVideoAssets,
                                              child: LImage('issue_add_n'),
                                            )),
                                ],
                              ),
                            )
                          ]),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(height: ScreenUtil().setWidth(20)),
                      Row(
                        children: [
                          Text(
                            CommonUtils.txt("sctp"),
                            style: GQStyle.white255_15_M,
                          ),
                          SizedBox(width: ScreenUtil().setWidth(10)),
                          Text(
                            CommonUtils.txt("zdjzbkb"),
                            style: GQStyle.gray208_13,
                          )
                        ],
                      ),
                      SizedBox(height: 10.w),
                      GridView.count(
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
                            upList.length == picLimit
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
                  )
          ],
        ),
      ),
    );
  }
}
