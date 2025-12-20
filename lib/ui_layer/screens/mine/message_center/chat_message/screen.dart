import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/domain.dart';
import '../../../../notifiers/chat_notifier.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_avatar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/empty_data.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

import '../../../../../report/ui_layer/report_gesture_detector.dart';

class ChatMessageScreen extends StatefulWidget {
  const ChatMessageScreen({
    super.key,
    required this.toUuid,
    required this.nickName,
    required this.thumb,
  });

  final String toUuid;
  final String nickName;
  final String thumb;

  @override
  State<ChatMessageScreen> createState() => _ChatMessageScreenState();
}

class _ChatMessageScreenState extends State<ChatMessageScreen> {
  bool isOnline = false;
  late final _homeConfigNotifier = context.read<HomeConfigNotifier>();

  late final _imCoins = _homeConfigNotifier.config.imCoins;

  late final _userDomain = context.read<UserDomain>();

  final textEditingController = TextEditingController();
  final focusNode = FocusNode();

  final List<ChatMessage> data = [];

  @override
  void initState() {
    context.read<ChatNotifier>().queryOnline(widget.toUuid).then((value) {
      final sub = value['online_time'] - value['query_time'];
      //一分钟内有效
      if (sub.abs() < 61) {
        setState(() {
          isOnline = true;
        });
      }
    });

    super.initState();
  }

  Future _imagePickerAssets() async {
    if (await CommonUtils.pickImage() case final xFile?) {
      MyToast.showLoading(text: 'scz'.tr());
      final uploadImageRes = await _homeConfigNotifier.uploadImage(xFile);

      if (uploadImageRes != null && uploadImageRes['code'] == 1) {
        final url =
            "${_homeConfigNotifier.config.imgBase}${uploadImageRes['msg']}";
        final localImage = Image.network(url);

        localImage.image
            .resolve(const ImageConfiguration())
            .addListener(ImageStreamListener((info, _) {
          String newUrl = '$url??${info.image.width}_${info.image.height}';

// 发图片
          _sendImg(newUrl);
        }));
      } else {
        MyToast.showText(text: uploadImageRes?['msg'] ?? 'failed');
        MyToast.closeAllLoading();
      }
    }
  }

  Future _sendImg(String url) async {
    var result = await _userDomain.imSend(text: '[图片]');
    if (result.isValid) {
      _reduceUserImValue();
    } else {
      MyToast.showText(text: result.msg ?? '');
      MyToast.closeAllLoading();
      return;
    }
    MyToast.closeAllLoading();

    //发送图片
    context.read<ChatNotifier>().sendMessage(
          ChatUser(
              nickname: widget.nickName,
              avatar: widget.thumb,
              uuid: widget.toUuid),
          url,
          'photos',
        );
  }

  Future _sendMsg() async {
    final text = textEditingController.text.trim();

    textEditingController.clear();
    if (text.isNotEmpty) {
      var result = await _userDomain.imSend(text: text);
      if (result.isValid) {
        // userNotifier.setInviteBy(inviteBy: value);
        _reduceUserImValue();
      } else {
        MyToast.showText(text: result.msg ?? '');
        return;
      }

      context.read<ChatNotifier>().sendMessage(
            ChatUser(
                nickname: widget.nickName,
                avatar: widget.thumb,
                uuid: widget.toUuid),
            text,
            'txt',
          );
    }
  }

  _reduceUserImValue() {
    final userNotifier = context.read<UserNotifier>();

    int imValue = userNotifier.member.imValue;
    if (imValue > 0) {
      userNotifier.setImValue(imValue: imValue - 1);
    } else {
      int money = userNotifier.member.money;
      userNotifier.setMoney(money: max(money - _imCoins, 0));
    }
    setState(() {});
  }

  String _placeholerString() {
    String text = 'srhf'.tr(context: context);
    final userNotifier = context.read<UserNotifier>();
    int imValue = userNotifier.member.imValue;
    int money = userNotifier.member.money;

    text = 'fsxxjbmf'
        .tr(context: context)
        .replaceAll('aa', '$_imCoins')
        .replaceAll('bb', '$imValue');
    // if (imValue > 0) {
    // } else {}

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          titleWidget: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${isOnline ? tr('zxi') : tr('lxi')}・',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: isOnline ? Colors.green : Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(widget.nickName, style: MyTheme.white18mudium)
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: Selector<ChatNotifier, List<ChatMessage>>(
              shouldRebuild: (_, __) => true,
              selector: (_, notifier) {
                try {
                  final target = notifier.chats.firstWhere(
                    (element) =>
                        element.id ==
                        '${notifier.member.uuid}_${widget.toUuid}',
                  );
                  return target.list.reversed.toList();
                } catch (_) {}
                return [];
              },
              builder: (_, data, __) {
                return data.isEmpty
                    ? const PageEmptyDataView()
                    : ListView.builder(
                        itemCount: data.length,
                        reverse: true,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: MyTheme.pagePadding,
                          vertical: 30.w,
                        ),
                        itemBuilder: (BuildContext context, int index) =>
                            data[index].type == 0
                                ? _UserBubble(item: data[index])
                                : _TargetBubble(item: data[index]),
                      );
              },
            )),
            Container(
              padding: EdgeInsets.only(left: MyTheme.pagePadding),
              color: const Color.fromRGBO(17, 17, 39, 1),
              child: SafeArea(
                child: SizedBox(
                  height: 50.w,
                  child: Row(
                    children: [
                      Container(
                        width: 310.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(18.w),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 17.5.w,
                              height: 17.w,
                              child: ReportGestureDetector(
                                onTap: _imagePickerAssets,
                                child: MyImage.asset(
                                  MyImagePaths.appCustomerServiceSelectImg,
                                  width: 17.5.w,
                                  height: 17.w,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: TextField(
                                  focusNode: focusNode,
                                  autofocus: true,
                                  controller: textEditingController,
                                  style: MyTheme.white255_14,
                                  cursorColor: MyTheme.cyanColor00edfd,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    hintText: _placeholerString(),
                                    hintStyle: MyTheme.gray180_15_M,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 7.w),
                      ReportGestureDetector(
                        onTap: _sendMsg,
                        child: SizedBox(
                          width: 44.w,
                          height: 44.w,
                          child: const Center(
                            child: Icon(
                              Icons.send_sharp,
                              size: 30,
                              color: MyTheme.jellyCyanColor103224185,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.item});
  final ChatMessage item;

  @override
  Widget build(BuildContext context) {
    final DateTime targetDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(item.time) * 1000);
    final String formattedDate = DateFormat('MM-dd HH:mm').format(targetDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          formattedDate,
          style: TextStyle(color: const Color(0xffb4b4b4), fontSize: 11.sp),
        )),
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
                    color: const Color.fromRGBO(21, 28, 40, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.5.w,
                    vertical: 14.5.w,
                  ),
                  child: item.content_type == 0
                      ? _RichMessage(msg: item.content, status: 0)
                      : SizedBox(
                          width: 150.w,
                          height: 150.w,
                          child: MyImage.network(item.content),
                        ),
                ),
              ),
              SizedBox(width: 9.5.w),
              MyAvatar(
                thumb: Uri.decodeComponent(item.avatar),
                size: 36.w,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _TargetBubble extends StatelessWidget {
  const _TargetBubble({required this.item});
  final ChatMessage item;

  @override
  Widget build(BuildContext context) {
    final DateTime targetDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(item.time) * 1000);
    final String formattedDate = DateFormat('MM-dd HH:mm').format(targetDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: Text(
          formattedDate,
          style: TextStyle(color: const Color(0xffb4b4b4), fontSize: 11.w),
        )),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyAvatar(
                thumb: Uri.decodeComponent(item.avatar),
                size: 36.w,
              ),
              SizedBox(width: 9.5.w),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(21, 28, 40, 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 15.5.w, vertical: 14.5.w),
                  child: item.content_type == 0
                      ? _RichMessage(msg: item.content, status: 0)
                      : SizedBox(
                          width: 150.w,
                          height: 150.w,
                          child: MyImage.network(
                            item.content,
                          ),
                        ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _RichMessage extends StatelessWidget {
  const _RichMessage({
    required this.msg,
    required this.status,
  });
  static final regExp = RegExp(
    r'(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?',
    multiLine: true,
  );
  final String msg;
  final int status;
  @override
  Widget build(BuildContext context) {
    final isPath = regExp.hasMatch(msg);
    final pathMsg = msg.replaceAll('http', '[wwsj]http');
    final pathList = pathMsg.split('[wwsj]');
    final textList = [];
    for (var i = 0; i < pathList.length; i++) {
      if (regExp.hasMatch(pathList[i])) {
        final subString = regExp.stringMatch(pathList[i]);
        var newMsg = subString == null
            ? pathList[i]
            : pathList[i].replaceAll(subString, '[wwsj]$subString[wwsj]');
        textList.addAll(newMsg.split('[wwsj]'));
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
                        fontSize: 15.sp,
                        color: regExp.hasMatch(textList[e])
                            ? const Color(0xff1967D2)
                            : status == 1
                                ? const Color.fromRGBO(180, 180, 180, 1)
                                : const Color(0xff1967D2),
                        decoration: regExp.hasMatch(textList[e])
                            ? TextDecoration.underline
                            : null,
                        height: 1.7,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          CommonUtils.launchUrl(textList[e]);
                        },
                    ))
                .toList()))
        : Text(
            msg,
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color.fromRGBO(180, 180, 180, 1),
              height: 1.7,
            ),
            softWrap: true,
          );
  }
}
