import 'dart:io';

import 'package:app_installer/app_installer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/http.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:provider/provider.dart';

class UpdateModel {
  static void showAnnouncementDialog(BackButtonBehavior backButtonBehavior,
      {VoidCallback cancel,
      VoidCallback confirm,
      VoidCallback confirmApp,
      String text,
      String type = "2"}) {
    var tipSplit = text.split('#');
    tipWidget(String value) {
      return CommonUtils.getContentSpan(value,
          style: TextStyle(
            color: Color(0xff636363),
            fontSize: ScreenUtil().setSp(15),
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal,
          ),
          lightStyle: TextStyle(
            color: const Color.fromRGBO(25, 103, 210, 1),
            fontSize: ScreenUtil().setSp(15),
            decoration: TextDecoration.none,
            fontWeight: FontWeight.normal,
          ));
      return RichText(
          text: TextSpan(
        text: value,
        style: TextStyle(
          color: Color(0xff636363),
          fontSize: ScreenUtil().setSp(15),
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      ));
    }

    tipsWidget() {
      return tipSplit.map((value) {
        Widget widget = tipWidget(value);
        return widget;
      }).toList();
    }

    List<Widget> newTipsWidget = tipsWidget();
    newTipsWidget.add(Container(
      width: double.infinity,
    ));
    BotToast.showWidget(
        toastBuilder: (cancelFunc) => Container(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      cancelFunc();
                      cancel?.call();
                    },
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black38),
                    ),
                  ),
                  Positioned(
                      child: Center(
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(35)),
                          height: ScreenUtil().setWidth(450),
                          child: Stack(
                            children: [
                              LImage('announcement_up_bg'),
                              Container(
                                margin: EdgeInsets.only(
                                    top: (ScreenUtil().screenWidth -
                                                ScreenUtil().setWidth(70)) /
                                            305 *
                                            117 -
                                        ScreenUtil().setWidth(2)),
                                color: Color(0xFFFCFCFC),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Container(
                                    //   margin: EdgeInsets.only(
                                    //       top: ScreenUtil().setWidth(18)),
                                    //   child: Center(
                                    //     child: Text(CommonUtils.txt('xtgg'),
                                    //         style: TextStyle(
                                    //             decoration:
                                    //                 TextDecoration.none,
                                    //             color: Color(0xFF000000),
                                    //             fontFamily: GQStyle.hanyi,
                                    //             fontWeight: FontWeight.bold,
                                    //             fontSize: ScreenUtil()
                                    //                 .setSp(18))),
                                    //   ),
                                    // ),
                                    SizedBox(height: ScreenUtil().setWidth(10)),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: newTipsWidget,
                                      ),
                                    )),
                                    SizedBox(height: ScreenUtil().setWidth(15)),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: GQStyle.pagePadding,
                                          right: GQStyle.pagePadding,
                                          bottom: ScreenUtil().setWidth(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     cancelFunc();
                                          //     confirm?.call();
                                          //     confirmApp();
                                          //   },
                                          //   child: Container(
                                          //     width: ScreenUtil().setWidth(110),
                                          //     height: ScreenUtil().setWidth(32),
                                          //     decoration: BoxDecoration(
                                          //         color: Color(0xFFf8a53c),
                                          //         borderRadius: BorderRadius.all(
                                          //             Radius.circular(ScreenUtil()
                                          //                 .setWidth(16)))),
                                          //     child: Center(
                                          //       child: Text(
                                          //         '应用推荐',
                                          //         style: GQStyle.white255_14,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              cancelFunc();
                                              confirm?.call();
                                            },
                                            // child: Container(
                                            //   width: ScreenUtil().setWidth(110),
                                            //   height: ScreenUtil().setWidth(32),
                                            //   decoration: BoxDecoration(
                                            //       color: Color(0xFFF2F2F2),
                                            //       borderRadius: BorderRadius.all(
                                            //           Radius.circular(ScreenUtil()
                                            //               .setWidth(16)))),
                                            //   child: Center(
                                            //       child: RichText(
                                            //     text: TextSpan(children: [
                                            //       TextSpan(
                                            //         text: CommonUtils.txt('zbgx'),
                                            //         style: TextStyle(
                                            //             color: Color.fromRGBO(
                                            //                 102, 102, 102, 1),
                                            //             fontSize:
                                            //                 ScreenUtil().setSp(14),
                                            //             // height: 1,
                                            //             overflow:
                                            //                 TextOverflow.visible,
                                            //             decoration:
                                            //                 TextDecoration.none),
                                            //         // textAlign:
                                            //         //     TextAlign.center,
                                            //         // strutStyle: StrutStyle(
                                            //         //     height: 1,
                                            //         //     forceStrutHeight:
                                            //         //         true),
                                            //       ),
                                            //     ]),
                                            //   )),
                                            // ),
                                            child: Container(
                                              width: ScreenUtil().setWidth(110),
                                              height: ScreenUtil().setWidth(32),
                                              decoration: BoxDecoration(
                                                  gradient: GQStyle
                                                      .btnGradient_ff00edfd_ffbbe954,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          ScreenUtil()
                                                              .setWidth(16)))),
                                              child: Center(
                                                  child: RichText(
                                                      text: TextSpan(children: [
                                                TextSpan(
                                                    text:
                                                        CommonUtils.txt('wygq'),
                                                    style:
                                                        GQStyle.white255_14_M),
                                                // TextSpan(
                                                //   text: '??',
                                                //   style: GQStyle.white255_14,
                                                // ),
                                              ]))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: ScreenUtil().setWidth(30),
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: LImage('xtgg',
                                  width: ScreenUtil().setWidth(119),
                                  height: ScreenUtil().setWidth(29)),
                            ))
                      ],
                    ),
                  ))
                ],
              ),
            ));
  }

  static void showUpdateDialog(BackButtonBehavior backButtonBehavior,
      {VoidCallback cancel,
      VoidCallback confirm,
      VoidCallback gowebsite,
      VoidCallback gowebguide,
      String version,
      String text,
      bool mustupdate}) {
    var tipSplit = text.split('#');

    tipWidget(String value) {
      return Text(
        value,
        style: TextStyle(
          color: Color(0xff636363),
          fontSize: ScreenUtil().setSp(15),
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    tipsWidget() {
      return tipSplit.map((value) {
        Widget widget = tipWidget(value);
        return widget;
      }).toList();
    }

    List<Widget> newTipsWidget = tipsWidget();
    newTipsWidget.add(Container(
      width: double.infinity,
    ));

    BotToast.showWidget(
        toastBuilder: (cancelFunc) => Container(
              child: Stack(
                children: [
                  Container(
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.7))),
                  Positioned(
                      child: Center(
                    child: Stack(
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(35)),
                          height: ScreenUtil().setWidth(430),
                          child: Stack(
                            children: [
                              LImage(
                                'update_up_bg',
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: (ScreenUtil().screenWidth -
                                                ScreenUtil().setWidth(70)) /
                                            305 *
                                            147 -
                                        ScreenUtil().setWidth(2)),
                                color: Color(0xFFFCFCFC),
                                child: Column(
                                  children: [
                                    SizedBox(height: ScreenUtil().setWidth(10)),
                                    Expanded(
                                        child: SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ScreenUtil().setWidth(20)),
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: newTipsWidget,
                                        ),
                                      ),
                                    )),
                                    // SizedBox(
                                    //     height: ScreenUtil().setWidth(15)),
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: GQStyle.pagePadding,
                                        right: GQStyle.pagePadding,
                                      ),
                                      child: Column(children: [
                                        Platform.isAndroid
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        GQStyle.pagePadding /
                                                            2),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: GestureDetector(
                                                    behavior: HitTestBehavior
                                                        .translucent,
                                                    onTap: () {
                                                      gowebguide();
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          CommonUtils.txt(
                                                              "bbtl"),
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .none,
                                                              color: Color(
                                                                  0xFF636363),
                                                              fontFamily:
                                                                  GQStyle.hanyi,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14)),
                                                        ),
                                                        Text(
                                                          CommonUtils.txt(
                                                              "gxqbkzn"),
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              color: GQStyle
                                                                  .cyanColor00edfd,
                                                              fontFamily:
                                                                  GQStyle.hanyi,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            mustupdate
                                                ? Container()
                                                : GestureDetector(
                                                    onTap: () {
                                                      if (mustupdate) return;
                                                      cancelFunc();
                                                      cancel?.call();
                                                    },
                                                    child: Container(
                                                      width: ScreenUtil()
                                                          .setWidth(110),
                                                      height: ScreenUtil()
                                                          .setWidth(32),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xFF757575),
                                                          borderRadius: BorderRadius
                                                              .all(Radius.circular(
                                                                  ScreenUtil()
                                                                      .setWidth(
                                                                          16)))),
                                                      child: Center(
                                                          child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                          TextSpan(
                                                            text:
                                                                CommonUtils.txt(
                                                                    'zbgx'),
                                                            style: GQStyle
                                                                .white255_14_M,
                                                          ),
                                                        ]),
                                                      )),
                                                    ),
                                                  ),
                                            mustupdate ? Container() : Spacer(),
                                            GestureDetector(
                                              onTap: () {
                                                if (!mustupdate) {
                                                  cancelFunc();
                                                } else if (mustupdate &&
                                                    Platform.isAndroid) {
                                                  cancelFunc();
                                                }
                                                confirm?.call();
                                              },
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(110),
                                                height:
                                                    ScreenUtil().setWidth(32),
                                                padding: EdgeInsets.zero,
                                                decoration: BoxDecoration(
                                                    gradient: GQStyle
                                                        .btnGradient_ff00edfd_ffbbe954,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                ScreenUtil()
                                                                    .setWidth(
                                                                        16)))),
                                                alignment: Alignment.center,
                                                child: Center(
                                                    child: RichText(
                                                        text:
                                                            TextSpan(children: [
                                                  TextSpan(
                                                      text: CommonUtils.txt(
                                                          'ljgx'),
                                                      style:
                                                          GQStyle.white255_14_M)
                                                ]))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: ScreenUtil().setWidth(15),
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: GestureDetector(
                                              onTap: () {
                                                gowebsite();
                                              },
                                              child: Center(
                                                child: Text(
                                                    CommonUtils.txt('gwgx'),
                                                    style:
                                                        GQStyle.jellyCyan_15),
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            top: ScreenUtil().setWidth(105),
                            left: 0,
                            right: 0,
                            child: Align(
                              alignment: Alignment.center,
                              child: LImage('fxxbb_t',
                                  width: ScreenUtil().setWidth(104),
                                  height: ScreenUtil().setWidth(21)),
                            ))
                      ],
                    ),
                  )),
                ],
              ),
            ));
  }

  static void androidUpdate(BackButtonBehavior backButtonBehavior,
      {VoidCallback cancel, String url, String version}) {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => DownloadApk(
        url: url,
        version: version,
        onTap: () {
          cancelFunc();
          cancel?.call();
        },
      ),
    );
  }

  static void showAvtivetysDialog(BackButtonBehavior backButtonBehavior,
      {VoidCallback cancel, VoidCallback confirm, Notice notice}) {
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => GestureDetector(
        onTap: () {
          cancelFunc();
          cancel?.call();
        },
        child: Container(
          constraints: BoxConstraints(
            maxHeight: ScreenUtil().screenHeight,
          ),
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.only(
              top: kIsWeb ? 0 : ScreenUtil().statusBarHeight,
              bottom: kIsWeb ? 0 : ScreenUtil().bottomBarHeight),
          decoration: BoxDecoration(color: Colors.black38),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancelFunc();
                    confirm?.call();
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(notice.width),
                    height: ScreenUtil().setWidth(notice.height),
                    child: PlatformAwareNetworkImage(
                      url: notice.img_url,
                      nofigure: true,
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setWidth(20)),
                GestureDetector(
                  onTap: () {
                    cancelFunc();
                    cancel?.call();
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(33),
                    height: ScreenUtil().setWidth(33),
                    child: LImage("gub", fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadApk extends StatefulWidget {
  final GestureTapCallback onTap;
  final String url;
  final String version;

  DownloadApk({Key key, this.onTap, this.url, this.version}) : super(key: key);

  @override
  _DownloadApkState createState() => _DownloadApkState();
}

class _DownloadApkState extends State<DownloadApk> {
  int progress = 0;

  Future<Null> _installApk(savePath) async {
    try {
      await CommonUtils.checkRequestInstallPackages();
      await CommonUtils.checkStoragePermission();
      AppInstaller.installApk(savePath)
          .then((result) {})
          .catchError((error) {});
    } on Exception catch (_) {}
  }

  @override
  void initState() {
    super.initState();
    getExternalStorageDirectory().then((documents) {
      String savePath =
          '${documents.path}/qypj.${DateTime.now().millisecondsSinceEpoch}.apk';
      PlatformAwareHttp.download(widget.url, savePath,
          onReceiveProgress: (int count, int total) {
        var tmp = (count / total * 100).toInt();
        if (tmp % 1 == 0) {
          setState(() {
            progress = tmp;
          });
        }
        if (count >= total) {
          _installApk(savePath);
        }
      }).catchError((err) {
        BotToast.cleanAll();
        BotToast.showText(text: CommonUtils.txt('xzsb'));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Stack(
        children: [
          Positioned(
              child: Center(
            child: Container(
              width: ScreenUtil().setWidth(345),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF15152a),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.symmetric(
                        vertical: ScreenUtil().setWidth(15.5),
                        horizontal: ScreenUtil().setWidth(20)),
                    child: Column(
                      children: <Widget>[
                        Text(
                          CommonUtils.txt('zzgx') + " v.${widget.version}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(18),
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(10),
                        ),
                        Text(
                          CommonUtils.txt('sjlts'),
                          style: TextStyle(
                              color: Color(0xffffffff),
                              fontSize: ScreenUtil().setSp(12),
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(25),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(185),
                          height: ScreenUtil().setWidth(4),
                          child: Stack(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(ScreenUtil().setWidth(2))),
                                child: Stack(
                                  children: <Widget>[
                                    Opacity(
                                      opacity: 0.3,
                                      child: Container(
                                        width: ScreenUtil().setWidth(185),
                                        height: ScreenUtil().setWidth(4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF67e0b9),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                ScreenUtil().setWidth(4))),
                                        child: Container(
                                          width: progress /
                                              100 *
                                              ScreenUtil().setWidth(185),
                                          height: ScreenUtil().setWidth(4),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF67e0b9),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setWidth(12),
                        ),
                        Center(
                          child: Text('$progress%',
                              style: TextStyle(
                                  color: Color(0xFF67e0b9),
                                  fontSize: ScreenUtil().setSp(18),
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
