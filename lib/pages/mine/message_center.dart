import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';
import 'package:intl/intl.dart';

class MessageCenter extends BaseWidget {
  MessageCenter({Key key}) : super(key: key);

  @override
  _MessageCenterState cState() => _MessageCenterState();
}

class _MessageCenterState extends BaseWidgetState<MessageCenter> {
  @override
  void onCreate() {
    CommonUtils.updateSystemNotice(context);
    setAppTitle(title: CommonUtils.txt("xxzx"));
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [MessageOfSystem(), MessageOfNotice()],
        ));
  }
}

/// 系统公告
class MessageOfSystem extends StatelessWidget {
  const MessageOfSystem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConfig>(builder: (ctx, state, child) {
      var times;
      var messages = CommonUtils.txt('zwxx');
      var noticeCount = 0;
      if (state.systemnotice.data.systemNotice != null) {
        times = state.systemnotice.data.systemNotice.createdAt;
        messages = state.systemnotice.data.systemNotice.question ??
            CommonUtils.txt('zwxx');
        noticeCount = state.systemnotice.data.systemNoticeCount ?? 0;
      }

      return MessageActionItem(
        title: CommonUtils.txt('tzxx'),
        message: '$messages',
        icon: 'wd_tzxx_n',
        time: times != null ? '$times' : ' ',
        number: '$noticeCount',
        onTap: () {
          context.push(CommonUtils.getRealHash('noticemessage'),
              extra: {'title': CommonUtils.txt('tzxx'), 'type': 1});
        },
      );
    });
  }
}

/// 官方客服
class MessageOfNotice extends StatelessWidget {
  const MessageOfNotice({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConfig>(builder: (ctx, state, child) {
      var times;
      var messages = CommonUtils.txt('zwxx');
      var noticeCount = 0;
      if (state.systemnotice.data.feed != null) {
        times = state.systemnotice.data.feed.createdAt is String
            ? state.systemnotice.data.feed.createdAt
            : CommonUtils.getHMTime(
                int.parse(state.systemnotice.data.feed.createdAt));
        messages = state.systemnotice.data.feed.question;
        noticeCount = state.systemnotice.data.feedCount;
      }

      return MessageActionItem(
        title: CommonUtils.txt('gfkf'),
        message:
            messages.contains("/new/") ? CommonUtils.txt('tp') : '$messages',
        icon: 'wd_servs_n',
        time: times != null ? '$times' : ' ',
        number: '$noticeCount',
        onTap: () {
          context.push(CommonUtils.getRealHash('customerService'));
        },
      );
    });
  }
}

class MessageActionItem extends StatelessWidget {
  final String title;
  final String icon;
  final String message;
  final String time;
  final String number;
  final Function onTap;
  const MessageActionItem(
      {Key key,
      this.title,
      this.icon,
      this.message,
      this.time,
      this.number,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var newTimeString = time;
    if (!time.isEmpty && time != ' ') {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

      DateTime dateTime = dateFormat.parse(time);

      DateFormat dateFormat2 = DateFormat("HH:mm");

      newTimeString = dateFormat2.format(dateTime);
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LImage(
                icon,
                width: ScreenUtil().setWidth(50),
                height: ScreenUtil().setWidth(50),
              ),
              SizedBox(
                width: ScreenUtil().setWidth(15),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GQStyle.white244_15_M,
                    ),
                    SizedBox(
                      height: ScreenUtil().setWidth(9),
                    ),
                    Text(
                      '$message',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GQStyle.gray180_13,
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Opacity(
                    opacity: (number == '0') ? 0 : 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(1),
                          horizontal: ScreenUtil().setWidth(8)),
                      decoration: BoxDecoration(
                          color: Color(0xff67e0b9),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(9))),
                      child: Text(
                        number,
                        style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontSize: ScreenUtil().setSp(12)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setWidth(15),
                  ),
                  SizedBox(
                    width: ScreenUtil().setWidth(40),
                    child: Text(
                      newTimeString,
                      textAlign: TextAlign.right,
                      style: GQStyle.hexa3a2a2_11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
