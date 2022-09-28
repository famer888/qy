import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/global.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/networkImage.dart';

class MineCreaterCollect extends BaseWidget {
  MineCreaterCollect({Key key}) : super(key: key);

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _MineCreaterCollectState();
  }
}

class _MineCreaterCollectState extends BaseWidgetState<MineCreaterCollect> {
  String imgurl = "";
  final txtcontroller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: CommonUtils.txt("cjhj"));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        focusNode.unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
        child: Column(
          children: [
            SizedBox(
              height: ScreenUtil().setWidth(20),
            ),
            Row(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    imagePickerAssets();
                  },
                  child: Container(
                    height: ScreenUtil().setWidth(137),
                    width: ScreenUtil().setWidth(111),
                    decoration: BoxDecoration(
                      color: Color(0xFF23262f),
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenUtil().setWidth(5))),
                    ),
                    child: Stack(
                      children: [
                        imgurl.length > 0
                            ? PlatformAwareNetworkImage(
                                url: imgurl,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenUtil().setWidth(5)),
                                ),
                              )
                            : Container(),
                        imgurl.length > 0
                            ? Container()
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      CommonUtils.txt("jjfm"),
                                      style: GQStyle.gray163_14_M,
                                    ),
                                    SizedBox(height: ScreenUtil().setWidth(5)),
                                    LImage(
                                      "create_add_n",
                                      width: ScreenUtil().setWidth(12),
                                      height: ScreenUtil().setWidth(12),
                                    )
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(15)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        focusNode: focusNode,
                        autofocus: false,
                        controller: txtcontroller,
                        style: GQStyle.white255_15_M,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hoverColor: Colors.white,
                          hintText: CommonUtils.txt('qsrjjmc'),
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
                      Container(
                        margin: EdgeInsets.only(
                          top: ScreenUtil().setWidth(10),
                          bottom: ScreenUtil().setWidth(5),
                        ),
                        color: Color(0xFF28282c),
                        height: ScreenUtil().setWidth(0.5),
                      ),
                      Text(CommonUtils.txt("mcyscxh"),
                          style: GQStyle.gray163_11)
                    ],
                  ),
                )
              ],
            ),
            SizedBox(height: ScreenUtil().setWidth(50)),
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
                    CommonUtils.txt("qr"),
                    style: GQStyle.white255_15_M,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _upData() {
    if (txtcontroller.text.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsrjjmc"));
      return;
    }
    if (imgurl.length == 0) {
      CommonUtils.showText(CommonUtils.txt("qsc") + CommonUtils.txt("jjfm"));
      return;
    }
    initLoadGIF();
    topicCreateTopic(title: txtcontroller.text, thumb: imgurl).then((res) {
      BotToast.closeAllLoading();
      if (res.status == 1) {
        CommonUtils.showText(res.msg, call: () {
          context.pop();
        });
      } else {
        CommonUtils.showText(res.msg ?? "failed");
      }
    });
  }

  final ImagePicker _picker = ImagePicker();
  Future<void> imagePickerAssets() async {
    final XFile file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      bool flag = await CommonUtils.pngLimitSize(file);
      if (flag) return;
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
    CommonUtils.debugPrint(res);
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
}
