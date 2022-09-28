import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/global.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/feedback.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/networkImage.dart';

class CustomerService extends StatefulWidget {
  CustomerService({Key key}) : super(key: key);

  @override
  _CustomerServiceState createState() => _CustomerServiceState();
}

class _CustomerServiceState extends State<CustomerService> {
  bool isInit = true;

  bool networkErr = false;
  bool isHud = true;
  RegExp regExp = new RegExp(
    r"(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?",
    multiLine: true,
  );
  int page = 1;
  TextEditingController editingController = TextEditingController();
  ScrollController scrollControllerFalse = ScrollController();
  List helpList = [];
  List msgList = [];
  bool isAll = false;
  final FocusNode focusNode = FocusNode();
  getMsgPath(String msg, int status) {
    var isPath = regExp.hasMatch(msg);
    var pathMsg = msg.replaceAll('http', '[qypj]http');
    var pathList = pathMsg.split('[qypj]');
    var textList = [];
    for (var i = 0; i < pathList.length; i++) {
      if (regExp.hasMatch(pathList[i])) {
        var newMsg = regExp.stringMatch(pathList[i]) == null
            ? pathList[i]
            : pathList[i].replaceAll(regExp.stringMatch(pathList[i]),
                '[qypj]${regExp.stringMatch(pathList[i])}[qypj]');
        textList.addAll(newMsg.split('[qypj]'));
      } else {
        textList.add(pathList[i]);
      }
    }

    return isPath
        ? Text.rich(TextSpan(
            children: textList
                .asMap()
                .keys
                .map((e) => TextSpan(
                      text: textList[e],
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(15),
                        color: regExp.hasMatch(textList[e])
                            ? Color(0xff1967D2)
                            : status == 1
                                ? Color.fromRGBO(180, 180, 180, 1)
                                : Color(0xff1967D2),
                        decoration: regExp.hasMatch(textList[e])
                            ? TextDecoration.underline
                            : null,
                        height: 1.7,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          CommonUtils.launchURL(textList[e]);
                        },
                    ))
                .toList()))
        : Text(
            msg,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(15),
              color: Color.fromRGBO(180, 180, 180, 1),
              height: 1.7,
            ),
            softWrap: true,
          );
  }

  //拉取消息列表
  getFeedback() async {
    if (isAll) return;
    var feedback = await getFeedbackList(page: page);
    if (feedback.data == null) {
      networkErr = false;
      setState(() {});
    }
    if (page == 1) {
      isAll = false;
      msgList = feedback.data;
    } else if (feedback.data.length > 0) {
      msgList.addAll(feedback.data);
    } else {
      isAll = true;
    }
    isHud = false;
    setState(() {});
    page++;
  }

  //发送消息
  _sendMsg() async {
    var text = editingController.text?.trim() ?? "";
    editingController.text = '';
    setState(() {});
    if (text.isNotEmpty) {
      var msg = await sendFeeding(text, 1, 0);
      if (msg != null && msg.status != 0) {
        Datum msgResult = Datum.fromJson({
          "messageType": 1,
          "status": 1,
          "createdAt": null,
          "message": text,
        });
        msgList.insert(0, msgResult);
        setState(() {});
      } else {
        CommonUtils.showText(CommonUtils.txt('wlbjcs'));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getFeedback();
  }

  @override
  void didUpdateWidget(CustomerService oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        focusNode.unfocus();
      } else {}
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
    CommonUtils.startLoadGIF(tip: CommonUtils.txt('scz'));
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
    if (data['code'] == 1) {
      String url = data['msg'].toString();
      sendFeeding(url, 2, 0).then((data) {
        BotToast.closeAllLoading();
        if (data.status == 1) {
          if (!mounted) return;
          Datum msgResult = Datum.fromJson({
            "messageType": 2,
            "status": 1,
            "createdAt": null,
            "message": AppGlobal.imgBase + url,
          });
          msgList.insert(0, msgResult);
          setState(() {});
        } else {
          CommonUtils.showText(CommonUtils.txt('tpsbcs'));
        }
      });
    } else {
      BotToast.closeAllLoading();
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  _serviceDialog(item, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: item.createdAt != null
              ? Text(
                  item.createdAt,
                  style: TextStyle(
                      color: Color(0xffb4b4b4),
                      fontSize: ScreenUtil().setSp(11)),
                )
              : Container(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LImage(
                'wd_servs_n',
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setWidth(36),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(9.5),
              ),
              Flexible(
                  child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff15152a),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(15.5),
                    vertical: ScreenUtil().setWidth(14.5)),
                child: item.messageType == 1
                    ? getMsgPath(item.message, 0)
                    : (item.isLocal != null
                        ? kIsWeb
                            ? Image.memory(
                                base64.decode(item.message.split(',')[1]),
                                fit: BoxFit.contain,
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(150),
                                gaplessPlayback: true,
                              )
                            : Image.file(
                                File(item.message),
                                fit: BoxFit.contain,
                                width: ScreenUtil().setWidth(150),
                                height: ScreenUtil().setWidth(150),
                              )
                        : Container(
                            width: ScreenUtil().setWidth(150),
                            height: ScreenUtil().setWidth(150),
                            child: PlatformAwareNetworkImage(url: item.message),
                          )),
              ))
            ],
          ),
        )
      ],
    );
  }

  _useDialog(item, index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: item.createdAt != null
              ? Text(
                  item.createdAt,
                  style: TextStyle(
                      color: Color(0xffb4b4b4),
                      fontSize: ScreenUtil().setSp(11)),
                )
              : Container(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff15152a),
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil().setWidth(15.5),
                          vertical: ScreenUtil().setWidth(14.5)),
                      child: item.messageType == 1
                          ? getMsgPath(item.message, item.status)
                          : (item.isLocal != null
                              ? kIsWeb
                                  ? Image.memory(
                                      base64.decode(item.message.split(',')[1]),
                                      fit: BoxFit.contain,
                                      width: ScreenUtil().setWidth(150),
                                      height: ScreenUtil().setWidth(150),
                                      gaplessPlayback: true,
                                    )
                                  : Image.file(
                                      File(item.message),
                                      fit: BoxFit.contain,
                                      width: ScreenUtil().setWidth(150),
                                      height: ScreenUtil().setWidth(150),
                                    )
                              : Container(
                                  width: ScreenUtil().setWidth(150),
                                  height: ScreenUtil().setWidth(150),
                                  child: PlatformAwareNetworkImage(
                                      url: item.message),
                                )))),
              SizedBox(
                width: ScreenUtil().setWidth(9.5),
              ),
              LImage(
                'wd_servme_n',
                width: ScreenUtil().setWidth(36),
                height: ScreenUtil().setWidth(36),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          focusNode.unfocus();
        },
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageTitleBar(
              title: CommonUtils.txt('zxkf'),
            ),
            Container(
              height: ScreenUtil().setWidth(30),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Color(0xff15152a), Color(0xff15152a)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )),
              child: Center(
                child: Text(CommonUtils.txt("zxkfts"),
                    textAlign: TextAlign.center, style: GQStyle.green11),
              ),
            ),
            isHud
                ? Expanded(
                    child: PageStatus.loading(mounted),
                  )
                : msgList.length == 0
                    ? Expanded(
                        child: PageStatus.noData(),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: msgList.length,
                            reverse: true,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                                horizontal: GQStyle.pagePadding,
                                vertical: ScreenUtil().setWidth(30)),
                            itemBuilder: (BuildContext context, int index) {
                              return msgList[index].status == 1
                                  ? _useDialog(msgList[index], index)
                                  : _serviceDialog(msgList[index], index);
                            }),
                      ),
            Column(
              children: [
                Container(
                    height: ScreenUtil().setWidth(0.5),
                    color: Color(0xff272727)),
                Container(
                  padding: EdgeInsets.only(left: GQStyle.pagePadding),
                  height: ScreenUtil().setWidth(50),
                  color: Color.fromRGBO(17, 17, 39, 1),
                  child: Row(
                    children: [
                      Container(
                          width: ScreenUtil().setWidth(310),
                          height: ScreenUtil().setWidth(36),
                          decoration: BoxDecoration(
                            color: Color(0xff2f2f42),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setWidth(18)),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(16)),
                          child: Row(
                            children: [
                              Container(
                                width: ScreenUtil().setWidth(17.5),
                                height: ScreenUtil().setWidth(17),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: imagePickerAssets,
                                      child: LImage(
                                        'customer_service_select_img',
                                        width: ScreenUtil().setWidth(17.5),
                                        height: ScreenUtil().setWidth(17),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(5)),
                                  child: TextField(
                                      focusNode: focusNode,
                                      autofocus: true,
                                      controller: editingController,
                                      style: GQStyle.white255_14,
                                      cursorColor: GQStyle.cyanColor00edfd,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          hintText: CommonUtils.txt('srhf'),
                                          hintStyle: GQStyle.gray180_15_M,
                                          contentPadding: EdgeInsets.zero,
                                          disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0)))),
                                ),
                                // ),
                              ),
                            ],
                          )),
                      SizedBox(width: ScreenUtil().setWidth(7)),
                      GestureDetector(
                        onTap: _sendMsg,
                        child: Container(
                            width: ScreenUtil().setWidth(44),
                            height: ScreenUtil().setWidth(44),
                            // margin: EdgeInsets.all(10),
                            child: Center(
                                child: SizedBox(
                                    width: ScreenUtil().setWidth(24),
                                    height: ScreenUtil().setWidth(24),
                                    child: LImage("btn_send_msg")))),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
