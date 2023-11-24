import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/base/input_container.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/mixin/imchat_api.dart';
import 'package:qypj/mixin/imchatmanager_io.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/imchat_model.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class IMToChatPage extends BaseWidget {
  IMToChatPage({Key key, this.touid = "", this.nick = "", this.thumb = ""})
      : super(key: key);
  final String touid;
  final String nick;
  final String thumb;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _HomeIMToChatPageState();
  }
}

class _HomeIMToChatPageState extends BaseWidgetState<IMToChatPage> {
  bool isOnline = false;
  List<ChatMessage> msgList = [];
  Member user =
      Provider.of<HomeConfig>(AppGlobal.appContext, listen: false).member;
  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();
  ImagePicker picker = ImagePicker();
  RegExp regExp = RegExp(
    r"(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?",
    multiLine: true,
  );

  //特殊字符处理
  Widget characterDeal(String msg) {
    var isPath = regExp.hasMatch(msg);
    var pathMsg = msg.replaceAll('http', '[hjsq]http');
    var pathList = pathMsg.split('[hjsq]');
    var textList = [];
    for (var i = 0; i < pathList.length; i++) {
      if (regExp.hasMatch(pathList[i])) {
        var newMsg = regExp.stringMatch(pathList[i]) == null
            ? pathList[i]
            : pathList[i].replaceAll(regExp.stringMatch(pathList[i]) ?? "",
                '[hjsq]${regExp.stringMatch(pathList[i])}[hjsq]');
        textList.addAll(newMsg.split('[hjsq]'));
      } else {
        textList.add(pathList[i]);
      }
    }
    return isPath
        ? Text.rich(TextSpan(
            children: textList
                .map((e) => TextSpan(
                      text: e,
                      style: TextStyle(
                        fontSize: 15.w,
                        color: regExp.hasMatch(e)
                            ? const Color.fromRGBO(25, 103, 210, 1)
                            : const Color.fromRGBO(255, 255, 255, .8),
                        decoration: regExp.hasMatch(e)
                            ? TextDecoration.underline
                            : null,
                        height: 1.7,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          CommonUtils.launchURL(e);
                        },
                    ))
                .toList()))
        : Text(
            msg,
            style: TextStyle(
              fontSize: 15.w,
              color: const Color.fromRGBO(255, 255, 255, .8),
              height: 1.7,
            ),
            softWrap: true,
          );
  }

  //用户对话
  Widget userDialogue(ChatMessage item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            DateUtil.formatDateMs(int.parse(item.time ?? "0") * 1000,
                format: "MM-dd HH:mm"),
            style: GQStyle.gray102_12,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff15152a),
                      // border: Border.all(
                      //     color: GQStyle.cyanColor00edfd.withAlpha(50),
                      //     width: 0.5.w),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(GQStyle.pagePadding),
                  child: item.content_type == 0
                      ? characterDeal(item.content ?? "")
                      : Builder(builder: (cx) {
                          var actualw = ScreenUtil().screenWidth -
                              GQStyle.pagePadding * 4 -
                              36.w -
                              10.w;
                          var split = item.content
                              ?.toString()
                              ?.replaceAll("&amp;", "?")
                              ?.split("??");
                          var url = split?.first ?? "";
                          var whs = split?.last?.split("_") ?? [];
                          //默认值150
                          var width = 150.0;
                          var height = 150.0;
                          if (whs.length > 1) {
                            width = double.parse(whs.first);
                            height = double.parse(whs.last);
                            double scale = height / width;
                            width = width > actualw ? actualw : width;
                            height = width * scale;
                          }
                          return SizedBox(
                            width: width.w,
                            height: height.w,
                            child: PlatformAwareNetworkImage(url: url),
                          );
                        }),
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 36.w,
                height: 36.w,
                child: PlatformAwareNetworkImage(
                  url: Uri.decodeComponent(item.avatar ?? ""),
                  borderRadius: BorderRadius.all(Radius.circular(18.w)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  //商家对话
  Widget bossDialogue(ChatMessage item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            DateUtil.formatDateMs(int.parse(item.time ?? "0") * 1000,
                format: "MM-dd HH:mm"),
            style: GQStyle.gray102_12,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(20)),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 36.w,
                height: 36.w,
                child: PlatformAwareNetworkImage(
                  url: Uri.decodeComponent(item.avatar ?? ""),
                  borderRadius: BorderRadius.all(Radius.circular(18.w)),
                ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff15152a),
                      // border: Border.all(
                      //     color: GQStyle.cyanColor00edfd.withAlpha(50),
                      //     width: 0.5.w),
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.all(GQStyle.pagePadding),
                  child: item.content_type == 0
                      ? characterDeal(item.content ?? "")
                      : Builder(builder: (cx) {
                          var actualw = ScreenUtil().screenWidth -
                              GQStyle.pagePadding * 4 -
                              36.w -
                              10.w;
                          var split = item.content
                              ?.toString()
                              ?.replaceAll("&amp;", "?")
                              ?.split("??");
                          var url = split?.first ?? "";
                          var whs = split?.last?.split("_") ?? [];
                          //默认值150
                          var width = 150.0;
                          var height = 150.0;
                          if (whs.length > 1) {
                            width = double.parse(whs.first);
                            height = double.parse(whs.last);
                            double scale = height / width;
                            width = width > actualw ? actualw : width;
                            height = width * scale;
                          }
                          return SizedBox(
                            width: width.w,
                            height: height.w,
                            child: PlatformAwareNetworkImage(url: url),
                          );
                        }),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  //发送消息
  void sendContent(String text, {String type = "txt"}) async {
    if (text.isNotEmpty) {
      CommonUtils.startLoadGIF(tip: CommonUtils.txt('fas'));
      reqImMsg(txt: text).then((value) async {
        if (value.status == 1) {
          await IMChatManagerIO.instance().sendMessage(Ichatapi.chat, req: {
            "to_uuid": widget.touid,
            "msgType": type,
            "content": text,
            "nickname": widget.nick,
            "thumb": widget.thumb,
          });
          chatList();
          editingController.text = '';
          BotToast.closeAllLoading();
        } else {
          BotToast.closeAllLoading();
          CommonUtils.showText(value?.msg ?? '');
        }
      });
    } else {
      CommonUtils.showText(CommonUtils.txt("qsrnr"));
    }
  }

  //拉取消息列表
  void chatList() {
    List<ChatList> chats = IMChatManagerIO.instance().getChats();
    if (chats.isEmpty) return;
    ChatList child;
    for (var item in chats) {
      if (item.id == "${user?.uuid}_${widget.touid}") {
        child = item;
        break;
      }
    }
    CommonUtils.debugPrint("======_chatList==$child");
    if (child == null) return;
    msgList = child.list ?? [];
    if (child.count > 0) {
      //清空未读数量
      child.count = 0;
      IMChatManagerIO.instance().saveChats(chats);
    }
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  Future<void> imagePickerAssets() async {
    final XFile file = await picker.pickImage(source: ImageSource.gallery);
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
    BotToast.closeAllLoading();
    var data = jsonDecode(res);
    if (data['code'] == 1) {
      Image localImage;
      if (kIsWeb) {
        localImage = Image.network(file.path);
      } else {
        localImage = Image.file(File.fromUri(Uri.parse(file.path)));
      }
      localImage.image
          .resolve(const ImageConfiguration())
          .addListener(ImageStreamListener((info, _) {
        String url = data['msg'].toString() +
            "??${info.image.width}_${info.image.height}";
        //发送图片
        sendContent(AppGlobal.imgBase + url, type: "photos");
      }));
    } else {
      BotToast.closeAllLoading();
      CommonUtils.showText(data['msg'] ?? "failed");
    }
  }

  //初始化数据
  void setupData() {
    chatList();
    IMChatManagerIO.instance()
        .sendMessage(Ichatapi.queryOnline, req: {"to_uuid": widget.touid});
    IMChatManagerIO.instance().receiveCall = (data) {
      if (data["message_type"] == "queryOnline") {
        int sub = data["online_time"] - data["query_time"];
        isOnline = sub.abs() < 61; //一分钟内有效
        setState(() {});
        return;
      }
      //刷新数据
      chatList();
    };
  }

  @override
  Widget appbar() {
    // TODO: implement appbar
    return CommonUtils.createNav(
      left: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          context.pop();
        },
        child: LImage(
          "nav_back_n",
          width: 20.w,
          height: 20.w,
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (isOnline ? CommonUtils.txt("zxi") : CommonUtils.txt("lxi")) + "・",
            style: TextStyle(
              fontSize: 18.sp,
              color: isOnline ? Colors.green : Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(widget.nick, style: GQStyle.white18mudium)
        ],
      ),
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setupData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    IMChatManagerIO.instance().receiveCall = null;
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBody
    Config config = Provider.of<HomeConfig>(context, listen: false).config;
    return InputContainer(
      onEditingCompleteText: ((value) {
        sendContent(value.toString().trim());
      }),
      onSelectPicComplete: () {
        imagePickerAssets();
      },
      labelText: config.im_msg,
      child: msgList.isEmpty
          ? PageStatus.noData()
          : ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              itemCount: msgList.length,
              itemBuilder: (context, index) {
                ChatMessage e = msgList[index];
                return e.type == 0 ? userDialogue(e) : bossDialogue(e);
              }),
    );
  }
}
