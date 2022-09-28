import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'dart:ui' as ui;

import 'package:qypj/utils/networkImage.dart';

class HomeSignPage extends BaseWidget {
  HomeSignPage({Key key}) : super(key: key);

  @override
  BaseWidgetState<HomeSignPage> cState() => _HomeSignPageState();
}

class _HomeSignPageState extends BaseWidgetState<HomeSignPage> {
  GlobalKey rootWidgetKey = GlobalKey();
  bool networkErr = false;
  bool isHud = true;
  List signData;
  dynamic needSignData; // 需要签到的天 data
  int signDayCount = 0; // 签到天数
  bool todaySigned = false; // 今天已经签到过了

  dynamic signTaskData;

  /// 任务列表数据
  bool isSaving = false;
  Config config;
  Member member;

  /// 新用户倒计时
  bool showNewGuyTip;

  int userInviteNumber; // 用户邀请数量

  _loadUserAgentData() async {
    Basic res = await getProxyDetail({});
    if (res.status == 1) {
      userInviteNumber = res.data['direct_proxy_num'];
      if (mounted) setState(() {});
    } else {
      // userInviteNumber = 0;
      // setState(() {});
    }
  }

  ///签到数据
  _loadSignData() async {
    Basic res;
    try {
      res = await getSignData();
    } catch (e) {
      isHud = false;
      networkErr = true;
      if (mounted) setState(() {});
      return;
    }

    if (res.status == 1) {
      isHud = false;
      networkErr = false;
      signData = List.from(res.data);

      signDayCount = 0;

      var now = DateTime.now();
      // now.toUtc();
      String todayString =
          '${now.year}-${now.month < 10 ? "0${now.month}" : now.month}-${now.day < 10 ? "0${now.day}" : now.day}';

      for (var item in signData) {
        if (!todaySigned) {
          try {
            String signDate = item['sign_at']['date'];
            todaySigned = signDate.startsWith(todayString);
          } catch (e) {}
        }
        if (todaySigned) {
          break;
        }
      }

      for (var item in signData) {
        if (item['is_sign'] == 0) {
          if (!todaySigned) {
            // 今日没有签到的情况下 搞一个准备签到的状态
            item['need_sign'] = 1;
            needSignData = item;
          }

          break;
        } else {
          signDayCount++;
        }
      }
      if (mounted) setState(() {});
    } else {
      isHud = false;
      networkErr = true;
      if (mounted) setState(() {});
      return;
    }
  }

  /// 签到
  _signAct() async {
    Basic res;
    try {
      Map param = {'id': needSignData['id']};
      res = await userSign(param);
    } catch (e) {
      return;
    }

    if (res.status == 1) {
      CommonUtils.showText(res.msg);
      _loadSignData();
    } else {
      CommonUtils.showText(res.msg);
      return;
    }
  }

  ///新人福利
  _loadNewGuyData() async {
    Basic res;
    try {
      res = await signLiskTask();
    } catch (e) {
      return;
    }

    if (res.status == 1) {
      // CommonUtils.showText(res.msg);

      signTaskData = res.data;
      _countDown();
    } else {
      CommonUtils.showText(res.msg);
      return;
    }
  }

  _saveImgShare() async {
    if (kIsWeb) {
      CommonUtils.showText(CommonUtils.txt('zxjt'));
      setState(() {
        isSaving = false;
      });
    } else {
      PermissionStatus storageStatus = await Permission.camera.status;
      if (storageStatus == PermissionStatus.denied) {
        storageStatus = await Permission.camera.request();
        if (storageStatus == PermissionStatus.denied ||
            storageStatus == PermissionStatus.permanentlyDenied) {
          CommonUtils.showText(
            CommonUtils.txt('qdkqx'),
          );
          setState(() {
            isSaving = false;
          });
        } else {
          localStorageImage();
        }
        return;
      } else if (storageStatus == PermissionStatus.permanentlyDenied) {
        CommonUtils.showText(
          CommonUtils.txt('wfbc'),
        );
        setState(() {
          isSaving = false;
        });
        return;
      }
      localStorageImage();
    }
  }

  localStorageImage() async {
    RenderRepaintBoundary boundary =
        rootWidgetKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    final result = await ImageGallerySaver.saveImage(pngBytes); //这个是核心的保存图片的插件
    if (result['isSuccess']) {
      CommonUtils.showText(
        CommonUtils.txt('xxcgwd'),
      );
    } else if (Platform.isAndroid) {
      if (result.length > 0) {
        CommonUtils.showText(
          CommonUtils.txt('xxcgwd'),
        );
      }
    }
    setState(() {
      isSaving = false;
    });
  }

  //复制链接分享
  void _copyLinkShare() {
    Clipboard.setData(ClipboardData(text: '${member.share.affUrlCopy.url}'));
    CommonUtils.showText(
      CommonUtils.txt('fzcg'),
    );
  }

  int _seconds = 0;
  Timer _timer;
  _countDown() {
    // var now = DateTime.now();
    // var diff = DateTime.parse(
    //     "${now.year}-${now.month < 10 ? "0${now.month}" : now.month}-${now.day < 10 ? "0${now.day}" : now.day} 24:00:00");
    // var twoHours = diff.difference(now);
    // _seconds = twoHours.inSeconds;

    var now = DateTime.now();
    int nowTimeStamp = (now.millisecondsSinceEpoch ~/ 1000.0).toInt();
    int expireAt = signTaskData['expired_at'];
    _seconds = expireAt - nowTimeStamp;
    _startTimer();
  }

  String _dealTimeHourToString() {
    int hour = _seconds ~/ 3600;
    return "${hour < 10 ? "0$hour" : hour}";
  }

  String _dealTimeMinuteToString() {
    int minute = _seconds % 3600 ~/ 60;
    return "${minute < 10 ? "0$minute" : minute}";
  }

  String _dealTimeSecondToString() {
    int second = _seconds % 60;
    return "${second < 10 ? "0$second" : second}";
  }

  _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds--;
      if (_seconds <= 0) {
        _cancelTimer();
        showNewGuyTip = false;
        _loadUserAgentData();
      } else {
        showNewGuyTip = true;
      }
      if (mounted) setState(() {});
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    setAppTitle(title: '');

    config = Provider.of<HomeConfig>(context, listen: false).config;
    member = Provider.of<HomeConfig>(context, listen: false).member;

    _loadSignData();
    _loadNewGuyData();
  }

  @override
  Widget backGroundView() {
    return Stack(
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setWidth(667),
          child: RepaintBoundary(
            key: rootWidgetKey,
            child: Stack(
              children: [
                LImage(
                  'share_bg',
                  width: double.infinity,
                  height: double.infinity,
                  // fit: BoxFit.fitHeight,
                ),
                Positioned(
                  left: GQStyle.pagePadding,
                  right: GQStyle.pagePadding,
                  bottom: ScreenUtil().setWidth(30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(242),
                      ),
                      Container(
                        width: ScreenUtil().setWidth(225),
                        height: ScreenUtil().setWidth(275),
                        decoration: BoxDecoration(
                          color: Color(0x9923262f),
                          borderRadius:
                              BorderRadius.circular(ScreenUtil().setWidth(10)),
                          boxShadow: [
                            //阴影
                            // BoxShadow(
                            //     color: Color.fromRGBO(49, 19, 122, 0.2),
                            //     offset: Offset(0, 0),
                            //     blurRadius: ScreenUtil().setWidth(16))
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: ScreenUtil().setWidth(15)),
                            SizedBox(
                              height: ScreenUtil().setWidth(51),
                              child: RichText(
                                text: TextSpan(
                                    text: CommonUtils.txt('wdggm'),
                                    style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: ScreenUtil().setSp(16.5),
                                        // fontWeight: FontWeight.bold,
                                        fontFamily: GQStyle.hanyi),
                                    children: <TextSpan>[
                                      TextSpan(text: '  '),
                                      TextSpan(
                                          text: '${member.share.affCode}',
                                          style: TextStyle(
                                              color: Color(0xff50edff),
                                              fontSize:
                                                  ScreenUtil().setSp(25.3),
                                              fontWeight: FontWeight.w600))
                                    ]),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              width: ScreenUtil().setWidth(189.5),
                              height: ScreenUtil().setWidth(189.5),
                              child: QrImage(
                                data: '${member.share.affUrl}',
                                version: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(44)),
                      Text(
                        CommonUtils.txt('gwdz') + '：${config.officeSite}',
                        style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.none,
                            fontSize: ScreenUtil().setSp(19),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(11)),
                      Text(
                        CommonUtils.txt('qwsy'),
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          height: 1.4,
                          fontWeight: FontWeight.normal,
                          fontSize: ScreenUtil().setSp(13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: double.infinity,
          color: GQStyle.bgColor,
          // child: Align(alignment: Alignment.topCenter, child: LImage('')),
        )
      ],
    );
    // return LImage('sign_bg');
  }

  @override
  Widget appbar() {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      height: GQStyle.navbarHegiht,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            child: SizedBox(
              height: double.infinity,
              child: LImage(
                "nav_back_n",
                width: ScreenUtil().setWidth(20),
                height: ScreenUtil().setWidth(20),
              ),
            ),
            onTap: () {
              finish();
            },
          ),
        ],
      ),
    );
  }

  @override
  void onDestroy() {
    _cancelTimer();
  }

  @override
  Widget pageBody(BuildContext context) {
    Member member = Provider.of<HomeConfig>(context, listen: false).member;

    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            _loadSignData();
            _loadNewGuyData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                  child: Column(
                    children: [
                      SizedBox(height: ScreenUtil().setWidth(26)),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          CommonUtils.txt('qdlbs'),
                          style: GQStyle.white255_18_M,
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(9.5)),
                      Container(
                        height: ScreenUtil().setWidth(350),
                        // color: Colors.deepOrange,
                        child: Stack(
                          children: [
                            LImage('sign_day_bg'),
                            Column(
                              children: [
                                SizedBox(
                                  height: ScreenUtil().setWidth(13.5 + 20 * 2),
                                  child: Center(
                                    child: Text(
                                      CommonUtils.txt('lxu') +
                                          CommonUtils.txt('qiandao') +
                                          '$signDayCount' +
                                          CommonUtils.txt('tian') +
                                          '，'
                                              '${todaySigned ? CommonUtils.txt('mtzl') : CommonUtils.txt('kdqd')}',
                                      style: GQStyle.white255_13_M,
                                    ),
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(7)),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: ScreenUtil().setWidth(13),
                                  runSpacing: ScreenUtil().setWidth(13),
                                  children: signData.map((e) {
                                    return SizedBox(
                                        width: ScreenUtil().setWidth(70),
                                        height: ScreenUtil().setWidth(83.5),
                                        child: SignDayWidget(
                                          data: e,
                                        ));
                                  }).toList(),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setWidth(25)),
                                  child: Center(
                                      child: GestureDetector(
                                    onTap: () {
                                      if (!todaySigned) {
                                        _signAct();
                                      }
                                      // CommonUtils.showText('text');
                                    },
                                    child: Stack(
                                      children: [
                                        LImage('sign_btn_bg'),
                                        Positioned.fill(
                                            child: Center(
                                          child: Text(
                                            todaySigned
                                                ? CommonUtils.txt('jryqd')
                                                : CommonUtils.txt('ljqd'),
                                            style: GQStyle.white255_15_M,
                                          ),
                                        ))
                                      ],
                                    ),
                                  )),
                                ))
                              ],
                            )
                          ],
                        ),
                      ),
                      showNewGuyTip == null
                          ? Container()
                          : Column(
                              children: [
                                Offstage(
                                  // 老用户 分享码
                                  offstage: showNewGuyTip,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenUtil().setWidth(17)),
                                          child: LImage(
                                            '',
                                            width: ScreenUtil().setWidth(265),
                                            height: ScreenUtil().setWidth(33),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setWidth(306),
                                          height: ScreenUtil().setWidth(354),
                                          child: Stack(
                                            children: [
                                              LImage(
                                                'jelly_share_qr_bg',
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.fill,
                                              ),
                                              Column(
                                                children: [
                                                  Expanded(
                                                      flex: 294,
                                                      child:
                                                          userInviteNumber ==
                                                                  null
                                                              ? Container()
                                                              : Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Spacer(),
                                                                      SizedBox(
                                                                        height:
                                                                            ScreenUtil().setWidth(45),
                                                                        child:
                                                                            Center(
                                                                          child: RichText(
                                                                              text: TextSpan(children: [
                                                                            TextSpan(
                                                                                text: CommonUtils.txt('ljyq') + ' ',
                                                                                style: GQStyle.white255_15),
                                                                            TextSpan(
                                                                                text: '$userInviteNumber' + CommonUtils.txt('ren'),
                                                                                style: GQStyle.jellyCyan_15)
                                                                          ])),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )),
                                                  Expanded(
                                                      flex: 415,
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            15)),
                                                        // color: Colors.green,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            // SizedBox(
                                                            //     height: ScreenUtil().setWidth(10)),
                                                            Container(
                                                              color:
                                                                  Colors.white,
                                                              // width: ScreenUtil().setWidth(134),
                                                              // height: ScreenUtil().setWidth(134),
                                                              child: QrImage(
                                                                data:
                                                                    '${member.share.affUrl}',
                                                                version: 3,
                                                                size: ScreenUtil()
                                                                    .setWidth(
                                                                        134),
                                                              ),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  text: CommonUtils
                                                                      .txt('wdggm'),
                                                                  style: GQStyle.graya3a2a2_13,
                                                                  children: <TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            '${member.share.affCode}',
                                                                        style: GQStyle
                                                                            .jellyCyan_25_semi)
                                                                  ]),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(31)),
                                        Center(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ActionShareButton(
                                                text: CommonUtils.txt('bctp'),
                                                onTap: isSaving
                                                    ? null
                                                    : () {
                                                        isSaving = true;
                                                        setState(() {});
                                                        SchedulerBinding
                                                            .instance
                                                            .addPostFrameCallback(
                                                                (_) {
                                                          _saveImgShare();
                                                        });
                                                      },
                                                isLoadding: isSaving,
                                              ),
                                              SizedBox(
                                                  width: ScreenUtil()
                                                      .setWidth(15)),
                                              ActionShareButton(
                                                text: CommonUtils.txt('fztglj'),
                                                onTap: _copyLinkShare,
                                                isLoadding: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Offstage(
                                  // 新用户 倒计时
                                  offstage: !showNewGuyTip,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: ScreenUtil().setWidth(57),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${signTaskData['title']}',
                                                style: GQStyle.white255_18_M,
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    CommonUtils.txt('djs'),
                                                    style: GQStyle.jellyCyan_11,
                                                  ),
                                                  Container(
                                                    height: ScreenUtil()
                                                        .setWidth(16),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        5)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        2)),
                                                    color:
                                                        GQStyle.cyanColor00edfd,
                                                    child: Center(
                                                      child: Text(
                                                        _dealTimeHourToString(),
                                                        style: GQStyle
                                                            .black0d141f_11_M,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    CommonUtils.txt('xshi'),
                                                    style:
                                                        GQStyle.white11medium,
                                                  ),
                                                  Container(
                                                    height: ScreenUtil()
                                                        .setWidth(16),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        5)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        2)),
                                                    color:
                                                        GQStyle.cyanColor00edfd,
                                                    child: Center(
                                                      child: Text(
                                                        _dealTimeMinuteToString(),
                                                        style: GQStyle
                                                            .black0d141f_11_M,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    CommonUtils.txt('fenz'),
                                                    style:
                                                        GQStyle.white11medium,
                                                  ),
                                                  Container(
                                                    height: ScreenUtil()
                                                        .setWidth(16),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        5)),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        2)),
                                                    color:
                                                        GQStyle.cyanColor00edfd,
                                                    child: Center(
                                                      child: Text(
                                                        _dealTimeSecondToString(),
                                                        style: GQStyle
                                                            .black0d141f_11_M,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    CommonUtils.txt('miao'),
                                                    style:
                                                        GQStyle.white11medium,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Wrap(
                                          runSpacing: ScreenUtil().setWidth(20),
                                          children:
                                              List.from(signTaskData['list'])
                                                  .map((e) {
                                            int state = e[
                                                'progress_status']; // 0 = 未开始，1 = 未完成 ，2 = 待领取奖励， 3 = 已经领取
                                            if (state == 0) {
                                              state = 1;
                                            }
                                            return GestureDetector(
                                              onTap: () async {
                                                if (state == 2) {
                                                  // 领取
                                                  Map param = {
                                                    'task_id': e['id']
                                                  };
                                                  try {
                                                    Basic res =
                                                        await signLiskTaskAccept(
                                                            param);
                                                    if (res.status == 1) {
                                                      _loadNewGuyData();
                                                    } else {
                                                      CommonUtils.showText(
                                                          res.msg);
                                                    }
                                                  } catch (e) {}
                                                }
                                              },
                                              child: Container(
                                                height:
                                                    ScreenUtil().setWidth(70),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setWidth(16),
                                                    vertical:
                                                        GQStyle.pagePadding),
                                                decoration: BoxDecoration(
                                                    color: Color(0xff23262f),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .setWidth(5))),
                                                child: Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(ScreenUtil()
                                                              .setWidth(22.5)),
                                                      child: Container(
                                                          width: ScreenUtil()
                                                              .setWidth(45),
                                                          height: ScreenUtil()
                                                              .setWidth(45),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xff0d141f),
                                                          ),
                                                          child: Center(
                                                              child: PlatformAwareNetworkImage(
                                                                  url: e[
                                                                      'icon']))),
                                                    ),
                                                    SizedBox(
                                                        width: ScreenUtil()
                                                            .setWidth(10)),
                                                    Expanded(
                                                        child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(e['title'],
                                                            style: GQStyle
                                                                .white255_15_M),
                                                        Text(
                                                          e['sub_title'],
                                                          style: GQStyle
                                                              .graya3a2a2_13,
                                                        )
                                                      ],
                                                    )),
                                                    ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(ScreenUtil()
                                                              .setWidth(12.5)),
                                                      child: Container(
                                                        width: ScreenUtil()
                                                            .setWidth(55),
                                                        height: ScreenUtil()
                                                            .setWidth(25),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: state ==
                                                                        2
                                                                    ? GQStyle
                                                                        .cyanColor00edfd
                                                                    : state == 1
                                                                        ? Colors
                                                                            .transparent
                                                                        : Color.fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0.15),
                                                                borderRadius: BorderRadius.circular(
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            12.5)),
                                                                border: state ==
                                                                        1
                                                                    ? Border.all(
                                                                        color: GQStyle
                                                                            .cyanColor00edfd,
                                                                        width:
                                                                            1)
                                                                    : null),
                                                        child: Center(
                                                          child: Text(
                                                            state == 2
                                                                ? '领取'
                                                                : state == 1
                                                                    ? '未完成'
                                                                    : state == 3
                                                                        ? '已领取'
                                                                        : '未开始',
                                                            style: state == 2
                                                                ? GQStyle
                                                                    .black0d141f_11
                                                                : state == 1
                                                                    ? GQStyle
                                                                        .jellyCyan_11
                                                                    : state == 3
                                                                        ? GQStyle
                                                                            .graya3a2a2_11
                                                                        : GQStyle
                                                                            .graya3a2a2_11,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                        height: max(MediaQuery.of(context).padding.bottom,
                            ScreenUtil().setWidth(20)),
                      )
                    ],
                  ),
                ),
              );
  }
}

class SignDayWidget extends StatelessWidget {
  SignDayWidget({Key key, this.data}) : super(key: key);

  dynamic data;
  @override
  Widget build(BuildContext context) {
    int state = 2; // 0未签到 1准备签到  2已经签到

    state = data['is_sign'] == 1 ? 2 : 0;

    if (data['need_sign'] != null && data['need_sign'] == 1) {
      state = 1;
    }

    return Container(
      // height: ScreenUtil().setWidth(83.5),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff23444f),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(ScreenUtil().setWidth(5)),
                    topRight: Radius.circular(ScreenUtil().setWidth(5)))),
            child: Stack(
              children: [
                Opacity(
                    opacity: state == 1 ? 1 : 0,
                    child: LImage('sign_day_up_bg')),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(8.5)),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${data['title']}',
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: ScreenUtil().setSp(11),
                                height: 1,
                                overflow: TextOverflow.ellipsis,
                                decoration: TextDecoration.none),
                          ),
                          Visibility(
                            visible: state != 2,
                            child: LImage(
                              'sign_day_diamond',
                              width: ScreenUtil().setWidth(30),
                              // scale: 2,
                            ),
                          ),
                          Visibility(
                            visible: state == 2,
                            child: LImage(
                              'sign_day_signed',
                              width: ScreenUtil().setWidth(30),
                              // scale: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Stack(
            children: [
              LImage('sign_day_bottom_bg'),
              Center(
                child: Text(
                  '${data['sub_title']}',
                  style: GQStyle.jellyCyan_13,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ActionShareButton extends StatelessWidget {
  final String text;
  final GestureTapCallback onTap;
  final bool isLoadding;
  final AssetImage image;
  const ActionShareButton(
      {Key key, this.text, this.onTap, this.isLoadding, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ScreenUtil().setWidth(150),
        height: ScreenUtil().setWidth(38.5),
        decoration: image == null
            ? BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ScreenUtil().setWidth(19.25)),
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(70, 234, 238, 1),
                    Color.fromRGBO(54, 170, 234, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ))
            : BoxDecoration(image: DecorationImage(image: image)),
        child: Center(
          child: isLoadding
              ? SizedBox(
                  width: ScreenUtil().setWidth(23),
                  height: ScreenUtil().setWidth(23),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ))
              : Text(
                  text,
                  style: GQStyle.white255_15_M,
                ),
        ),
      ),
    );
  }
}
