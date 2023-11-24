import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/mixin/imchatmanager_io.dart';
import 'package:qypj/model/imchat_model.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:provider/provider.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';
import 'package:intl/intl.dart';
import 'package:qypj/utils/networkImage.dart';

class MessageIMCenter extends BaseWidget {
  MessageIMCenter({Key key, this.isShow}) : super(key: key);
  final bool isShow;

  @override
  _MessageIMCenterState cState() => _MessageIMCenterState();
}

class _MessageIMCenterState extends BaseWidgetState<MessageIMCenter> {
  List<ChatList> chats = [];
  bool isHud = true;

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  //获取IM消息数据
  void getData() {
    chats = IMChatManagerIO.instance().getChats();
    if (mounted) setState(() {});
  }

  @override
  void onCreate() {
    IMChatManagerIO.instance().msgCall = () {
      getData();
    };
    CommonUtils.updateSystemNotice(context);
    getData();
  }

  @override
  void didUpdateWidget(covariant MessageIMCenter oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    IMChatManagerIO.instance().msgCall = null;
  }

  @override
  Widget pageBody(BuildContext context) {
    return Column(
      children: [
        CommonUtils.createNav(
            title: Text(CommonUtils.txt('xxzx'), style: GQStyle.white255_18_B)),
        Expanded(
            child: ListView(
          children: [
            MessageOfSystem(),
            MessageOfNotice(),
            chats.isNotEmpty
                ? Container(
                    child: Text(CommonUtils.txt('jsltxx'),
                        style: GQStyle.white15bold),
                    padding: EdgeInsets.only(
                      top: 20.w,
                      bottom: 5.w,
                      left: GQStyle.pagePadding,
                      right: GQStyle.pagePadding,
                    ),
                  )
                : Container(),
            Column(
              children: chats.map((e) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          IMChatManagerIO.instance()
                              .removeChat(e.touser?.uuid ?? "");
                          getData();
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: CommonUtils.txt("sch"),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.push(
                          '/imtochatpage/${e.touser?.uuid}/${e.touser?.nickname ?? ""}/${e.touser?.avatar ?? " "}');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.white10, width: 0.5)),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 50.w,
                              height: 50.w,
                              child: PlatformAwareNetworkImage(
                                url:
                                    Uri.decodeComponent(e.touser?.avatar ?? ""),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.w)),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Uri.decodeComponent(
                                        e.touser?.nickname ?? ""),
                                    style: GQStyle.white13medium,
                                  ),
                                  SizedBox(height: 9.w),
                                  Text(
                                    e.list.last.content_type == 0
                                        ? e.list.last.content ?? ""
                                        : "[${CommonUtils.txt('tp')}]",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GQStyle.gray153_13,
                                  )
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateUtil.formatDateMs(
                                      int.parse(e.list.last.time ?? "0"),
                                      format: "HH:mm"),
                                  style: GQStyle.gray153_11,
                                ),
                                SizedBox(height: 15.w),
                                Opacity(
                                  opacity: e.count == 0 ? 0 : 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 1.w, horizontal: 8.w),
                                    decoration: BoxDecoration(
                                        color: const Color(0xFFFE4A49),
                                        borderRadius:
                                            BorderRadius.circular(7.5.w)),
                                    child: Text(
                                      e.count.toString(),
                                      style: GQStyle.white10,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ))
      ],
    );
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
      if (state.systemnotice?.data?.systemNotice != null) {
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
      if (state.systemnotice?.data?.feed != null) {
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
                          color: Color(0xff5197F1),
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
