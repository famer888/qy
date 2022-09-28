import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class WelfareTaskPage extends BaseWidget {
  WelfareTaskPage({Key key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  _WelfareTaskPageState cState() => _WelfareTaskPageState();
}

class _WelfareTaskPageState extends BaseWidgetState<WelfareTaskPage> {
  Config config;
  Member member;

  bool networkErr = false;
  bool isHud = true;

  dynamic signTaskData;

  @override
  void onCreate() {
    // TODO: implement onCreate
    // _loadTaskData();
    setAppTitle(bgColor: Colors.transparent, navColor: Colors.transparent);
  }

  @override
  void didUpdateWidget(covariant WelfareTaskPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (widget.isShow == true) {
      if (signTaskData == null) {
        _loadTaskData();
      }
    }
  }

  _loadTaskData() async {
    Basic res;

    try {
      res = await signLiskTask();
    } catch (e) {
      isHud = false;
      networkErr = true;
      if (mounted) setState(() {});
      return;
    }

    if (res.status == 1) {
      isHud = false;
      networkErr = false;

      signTaskData = res.data;
      Provider.of<HomeConfig>(context, listen: false)
          .setExp(signTaskData['exp']);
    } else {
      isHud = false;
      networkErr = true;

      CommonUtils.showText(res.msg);
      // return;
    }
    if (mounted) setState(() {});
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  @override
  Widget pageBody(BuildContext context) {
    member = Provider.of<HomeConfig>(context, listen: false).member;
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            _loadTaskData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : PullRefreshList(
                onRefresh: () {
                  _loadTaskData();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: ScreenUtil().setWidth(150),
                        // margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                        child: Stack(
                          children: [
                            // ClipPath(
                            //   clipper: MyClipper(),
                            //   child:

                            // Container(
                            //   height: ScreenUtil().setWidth(157),
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.all(
                            //         Radius.circular(ScreenUtil().setWidth(5))),
                            //     gradient: LinearGradient(
                            //         begin: Alignment.topCenter,
                            //         end: Alignment.bottomCenter,
                            //         colors: [
                            //           Color(0xfff3e8d8),
                            //           Color(0xffe7cdb6),
                            //         ]),
                            //   ),
                            // ),
                            // ),
                            Column(
                              children: [
                                SizedBox(height: ScreenUtil().setWidth(11.5)),
                                Container(
                                  // color: Colors.deepOrange,
                                  height: ScreenUtil().setWidth(53),
                                  margin: EdgeInsets.all(
                                      ScreenUtil().setWidth(12.5)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(
                                            ScreenUtil().setWidth(53 / 2.0),
                                          ),
                                          child: Container(
                                              width: ScreenUtil().setWidth(53),
                                              height: ScreenUtil().setWidth(53),
                                              child: PlatformAwareNetworkImage(
                                                url: member.thumb,
                                              ))),
                                      SizedBox(
                                        width: ScreenUtil().setWidth(9),
                                      ),
                                      Expanded(
                                          child: Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  Text(member.nickname,
                                                      style: TextStyle(
                                                          color: Color.fromRGBO(
                                                              255, 255, 255, 1),
                                                          fontSize: ScreenUtil()
                                                              .setSp(14),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          decoration:
                                                              TextDecoration
                                                                  .none)),
                                                  SizedBox(
                                                      width: ScreenUtil()
                                                          .setWidth(9)),
                                                  member.vipLevel > 0
                                                      ? LImage('vip_icon',
                                                          width: ScreenUtil()
                                                              .setWidth(39),
                                                          height: ScreenUtil()
                                                              .setWidth(18))
                                                      : Container(),
                                                  // Expanded(child: Container()),
                                                  // Text(CommonUtils.txt('ktxje'),
                                                  //     style: GQStyle.brown916044_12semibold),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Row(
                                                children: [
                                                  member.vipLevel > 0
                                                      ? Text(
                                                          CommonUtils.txt(
                                                              'vpwxk'),
                                                          style: GQStyle
                                                              .gray127_14)
                                                      : Text(
                                                          CommonUtils.txt(
                                                                  'sygkcs') +
                                                              ':'
                                                                  ' ${signTaskData['free_view_cnt']}/${signTaskData['total_free_view_cnt']}',
                                                          style: GQStyle
                                                              .gray127_14),
                                                  // Expanded(child: Container()),
                                                  // Text('9999',
                                                  //     style: GQStyle.brown916044_24semibold)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  // width: double.infinity,
                                  // color: Colors.red,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push('/vip');
                                    },
                                    child: Container(
                                      width: ScreenUtil().setWidth(300),
                                      height: ScreenUtil().setWidth(40),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadiusDirectional.circular(
                                                  ScreenUtil().setWidth(20)),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: <Color>[
                                              Color.fromRGBO(239, 205, 168, 1),
                                              Color.fromRGBO(252, 231, 207, 1)
                                            ],
                                          )),
                                      child: Text(
                                        member.vipLevel > 0
                                            ? CommonUtils.txt('xfvpbxk')
                                            : CommonUtils.txt('ktvpbxk'),
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(46, 24, 12, 1),
                                            fontSize: ScreenUtil().setSp(13),
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w500,
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(ScreenUtil().setWidth(20)),
                          topRight: Radius.circular(ScreenUtil().setWidth(20)),
                        ),
                        child: Container(
                          color: Colors.white,
                          // width: double.infinity,
                          // height: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: GQStyle.pagePadding),
                          child: Column(
                            children: [
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              Row(
                                children: [
                                  Text(
                                    CommonUtils.txt('flrw'),
                                    style: GQStyle.black26_18_semi,
                                  ),
                                  SizedBox(width: ScreenUtil().setWidth(10)),
                                  Text(
                                    CommonUtils.txt('ts') +
                                        ': ' +
                                        CommonUtils.txt('rwwchsx'),
                                    style: GQStyle.gray13,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(10),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      CommonUtils.txt('yqrs') +
                                          '${signTaskData['invited_num']}人',
                                      style: TextStyle(
                                          color: Color.fromRGBO(26, 26, 26, 1),
                                          fontSize: ScreenUtil().setSp(15),
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none)),
                                  Text(
                                      CommonUtils.txt('wdjf') + '${member.exp}',
                                      style: TextStyle(
                                          color: Color.fromRGBO(26, 26, 26, 1),
                                          fontSize: ScreenUtil().setSp(15),
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.none)),
                                  // Text('福利任务', style: GQStyle.black26_18_semi),
                                  GestureDetector(
                                    onTap: () async {
                                      // text = state != 2 ? '去邀请' : '领取';
                                      context.push('/${Routes.vip}');
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(16)),
                                      child: Container(
                                        width: ScreenUtil().setWidth(75),
                                        height: ScreenUtil().setWidth(32),
                                        decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                250, 217, 163, 1)),
                                        child: Center(
                                            child: Text(
                                          CommonUtils.txt('dhvp'),
                                          style: GQStyle.brown_996619_13_M,
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  dynamic data = signTaskData['list'][index];

                                  int taskType = data['task_type'];
                                  int state = data[
                                      'progress_status']; // 0 = 未开始，1 = 未完成 ，2 = 待领取奖励， 3 = 已经领取
                                  if (state == 0) {
                                    state = 1;
                                  }
                                  return Container(
                                    // height: ScreenUtil().setWidth(76),
                                    constraints: BoxConstraints(
                                        minHeight: ScreenUtil().setWidth(76)),
                                    child: Row(
                                      children: [
                                        SizedBox.square(
                                            dimension:
                                                ScreenUtil().setWidth(42),
                                            child: PlatformAwareNetworkImage(
                                              background: Colors.transparent,
                                              url: data['icon'],
                                            )),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        Expanded(
                                          // color: Colors.deepOrange,
                                          // width: ScreenUtil().setWidth(100),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${data['title']}',
                                                  style: GQStyle.black1534,
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${data['sub_title']}',
                                                  style: GQStyle.gray153_13,
                                                  maxLines: 30,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: ScreenUtil().setWidth(10)),
                                        GestureDetector(
                                          onTap: () async {
                                            if (state == 2) {
                                              BotToast.showLoading();
                                              // 领取
                                              Map param = {
                                                'task_id': data['id']
                                              };
                                              try {
                                                Basic res =
                                                    await signLiskTaskAccept(
                                                        param);
                                                if (res.status == 1) {
                                                  _loadTaskData();
                                                } else {
                                                  CommonUtils.showText(res.msg);
                                                }
                                              } catch (e) {}

                                              BotToast.closeAllLoading();
                                            } else {
                                              //任务类型
// 1 => 每日登陆
// 2 => 评论/回复
// 3 => 下载APP
// 4 => 邀请用户1人
// 5 => 邀请用户3人
// 6 => 邀请用户10人
// 7=> 邀请用户30人
                                              if (taskType == 3) {
                                                if (state != 2) {
                                                  String url = data['app_url'];
                                                  CommonUtils.launchURL(url);
                                                }
                                              } else if (taskType >= 4 &&
                                                  taskType <= 7) {
                                                // text = state != 2 ? '去邀请' : '领取';

                                                context.push(CommonUtils
                                                    .getRealHash(Routes
                                                        .kwantsharetousers));
                                              }
                                            }
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(16)),
                                            child: Container(
                                              width: ScreenUtil().setWidth(75),
                                              height: ScreenUtil().setWidth(32),

                                              decoration: state == 2
                                                  ? BoxDecoration(
                                                      gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(
                                                            235, 86, 82, 1),
                                                        Color.fromRGBO(
                                                            239, 133, 80, 1)
                                                      ],
                                                    ))
                                                  : state == 3
                                                      ? BoxDecoration(
                                                          color: GQStyle
                                                              .grayColor150)
                                                      : BoxDecoration(
                                                          color: Color.fromRGBO(
                                                              250,
                                                              217,
                                                              163,
                                                              1)),

                                              // decoration: BoxDecoration(
                                              //     color: state == 2
                                              //         ? GQStyle.cyanColor00edfd
                                              //         : state == 1
                                              //             ? Colors.transparent
                                              //             : Color.fromRGBO(
                                              //                 0, 0, 0, 0.15),
                                              //     borderRadius: BorderRadius.circular(
                                              //         ScreenUtil().setWidth(12.5)),
                                              //     border: state == 1
                                              //         ? Border.all(
                                              //             color:
                                              //                 GQStyle.cyanColor00edfd,
                                              //             width: 1)
                                              //         : null),
                                              child: Center(
                                                child:
                                                    Builder(builder: (context) {
                                                  String text = '';

                                                  text = state == 2
                                                      ? CommonUtils.txt('lq')
                                                      : state == 1
                                                          ? CommonUtils.txt(
                                                              'wwc')
                                                          : state == 3
                                                              ? CommonUtils.txt(
                                                                  'ylq')
                                                              : CommonUtils.txt(
                                                                  'wks');

//任务类型
// 1 => 每日登陆
// 2 => 评论/回复
// 3 => 下载APP
// 4 => 邀请用户1人
// 5 => 邀请用户3人
// 6 => 邀请用户10人
// 7=> 邀请用户30人
                                                  if (taskType == 3) {
                                                    text = state == 2
                                                        ? CommonUtils.txt('lq')
                                                        : state == 3
                                                            ? CommonUtils.txt(
                                                                'ylq')
                                                            : CommonUtils.txt(
                                                                'ljxz');
                                                  } else if (taskType >= 4 &&
                                                      taskType <= 7) {
                                                    text = state == 2
                                                        ? CommonUtils.txt('lq')
                                                        : state == 3
                                                            ? CommonUtils.txt(
                                                                'ylq')
                                                            : CommonUtils.txt(
                                                                'qyq');
                                                  }
                                                  return Text(
                                                    text,
                                                    style: state == 2
                                                        ? GQStyle.white255_13_M
                                                        : state == 1
                                                            ? GQStyle
                                                                .brown_996619_13_M
                                                            : state == 3
                                                                ? GQStyle
                                                                    .white255_13_M
                                                                : GQStyle
                                                                    .brown_996619_13_M,
                                                  );
                                                }),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                itemCount: signTaskData != null
                                    ? signTaskData['list'].length
                                    : 0,
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
