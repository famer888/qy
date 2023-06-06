import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/systemnoticelist.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';

class NoticeMessage extends StatefulWidget {
  final Map args;

  NoticeMessage({Key key, this.args}) : super(key: key);

  @override
  _MessageCenterState createState() => _MessageCenterState();
}

class _MessageCenterState extends State<NoticeMessage> {
  int page = 1;
  int limit = 15;
  bool netError = false;
  bool noMore = false;
  List<Datum> messageList = [];

  @override
  void initState() {
    super.initState();
    initMessageList();
  }

  void initMessageList() async {
    // messageList = [
    //   new Datum(
    //       title: "[审核消息]",
    //       content: "您上传的视频《漂亮的模特》已通过审核，点击”我的-作品“中查看",
    //       createdAt: "7-23  16:56"),
    //   new Datum(
    //       title: "[公告]",
    //       content: "公告详情展示完整公告详情展示完整公告详情展示完整公告详情完整公告详情展示完整",
    //       createdAt: "7-23  16:56"),
    // ];
    // setState(() {});
    // return;
    SystemNoticeList result =
        await getSystemNoticeList(page: page, limit: limit);
    if (result.data == null) {
      netError = true;
      setState(() {});
      return;
    }
    if (result?.status == 1) {
      if (page == 1) {
        noMore = false;
        messageList = result.data;
      } else if (result.data.length > 0) {
        messageList.addAll(result.data);
      } else {
        noMore = true;
      }
      setState(() {});
    } else {
      CommonUtils.showText(result.msg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GQStyle.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            PageTitleBar(title: widget.args["title"]),
            netError
                ? Expanded(
                    child: PageStatus.noNetWork(onTap: () {
                      initMessageList();
                    }),
                  )
                : (messageList.length == 0)
                    ? Expanded(
                        child: PageStatus.noData(),
                      )
                    : Expanded(
                        child: PullRefreshList(
                          isAll: noMore,
                          onRefresh: () {
                            page = 1;
                            initMessageList();
                          },
                          onLoading: () {
                            page += 1;
                            initMessageList();
                          },
                          child: ListView.builder(
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                return NoticeItem(data: messageList[index]);
                              }),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}

class NoticeItem extends StatelessWidget {
  final Datum data;
  const NoticeItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setWidth(12.5),
          right: ScreenUtil().setWidth(12.5),
          top: ScreenUtil().setWidth(20)),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (data.type == 1) {
            context.push("/communitypostdetail/${data.related_id}");
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
          decoration: BoxDecoration(
              color: Color.fromRGBO(21, 21, 42, 1),
              borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              data.title,
              style: GQStyle.white255_18_M,
              maxLines: 100,
            ),
            SizedBox(height: ScreenUtil().setWidth(10)),
            Text(
              data.content,
              style: GQStyle.gray199_13,
              maxLines: 100,
            ),
            SizedBox(height: ScreenUtil().setWidth(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.createdAt, style: GQStyle.hexa3a2a2_11),
                data.type == 1
                    ? Text(CommonUtils.txt('ckxq'), style: GQStyle.blue80_11)
                    : Container()
              ],
            )
          ]),
        ),
      ),
    );
  }
}
