import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:qypj/model/homedata.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';

class CertificateModel {
  static void showCertificate(BackButtonBehavior backButtonBehavior,
      {VoidCallback cancel,
      VoidCallback confirm,
      String id = 'undefine',
      String code = 'undefine',
      String url = 'undefine',
      String officeurl = "undefine"}) {
    GlobalKey certificateWidgetKey = GlobalKey();

    localStorageImage() async {
      RenderRepaintBoundary boundary =
          certificateWidgetKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final result =
          await ImageGallerySaver.saveImage(pngBytes); //这个是核心的保存图片的插件
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
    }

    _saveImgShare() async {
      if (kIsWeb) {
        // RenderRepaintBoundary boundary =
        //     certificateWidgetKey.currentContext.findRenderObject();
        // ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        // ByteData byteData =
        //     await image.toByteData(format: ui.ImageByteFormat.png);
        // final base64Data = base64Encode(byteData.buffer.asUint8List());
        // final downElement =
        //     html.AnchorElement(href: 'data:image/png;base64,$base64Data');
        // downElement.download = 'download.png';
        // downElement.click();
        // downElement.remove();
        CommonUtils.showText(CommonUtils.txt('zxjt'));
      } else {
        BotToast.showLoading();
        PermissionStatus storageStatus = await Permission.camera.status;
        if (storageStatus == PermissionStatus.denied) {
          storageStatus = await Permission.camera.request();
          if (storageStatus == PermissionStatus.denied ||
              storageStatus == PermissionStatus.permanentlyDenied) {
            CommonUtils.showText(
              CommonUtils.txt('qdkqx'),
            );
          } else {
            localStorageImage();
          }
          BotToast.closeAllLoading();
          return;
        } else if (storageStatus == PermissionStatus.permanentlyDenied) {
          BotToast.closeAllLoading();
          CommonUtils.showText(
            CommonUtils.txt('wfbc'),
          );
          return;
        }
        localStorageImage();
        BotToast.closeAllLoading();
      }
    }

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
                      decoration: BoxDecoration(color: Colors.black54),
                    ),
                  ),
                  Positioned(
                    child: Center(
                      child: Container(
                        width: ScreenUtil().setWidth(280),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                cancelFunc();
                                cancel?.call();
                              },
                              child: SizedBox(
                                width: ScreenUtil().setWidth(43),
                                height: ScreenUtil().setWidth(43),
                                child: Image.asset(
                                    'assets/images/icon_close2.png',
                                    width: double.infinity,
                                    height: double.infinity),
                              ),
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(10),
                            ),
                            Stack(
                              children: [
                                Positioned(
                                  child: RepaintBoundary(
                                    key: certificateWidgetKey,
                                    child: Container(
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                ScreenUtil().setWidth(15)),
                                            child: Image.asset(
                                              'assets/images/certificate_bg.png',
                                              width: ScreenUtil().setWidth(300),
                                              height:
                                                  ScreenUtil().setWidth(360),
                                              fit: BoxFit.cover,
                                              alignment: Alignment.topCenter,
                                            ),
                                          ),
                                          Positioned(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    ScreenUtil().setWidth(17)),
                                                child: Image.asset(
                                                  'assets/images/logo_label.png',
                                                  width: ScreenUtil()
                                                      .setWidth(143),
                                                  height:
                                                      ScreenUtil().setWidth(54),
                                                ),
                                              ),
                                              Center(
                                                child: Image.asset(
                                                    "assets/images/cer_pz.png",
                                                    width: ScreenUtil()
                                                        .setWidth(135),
                                                    height: ScreenUtil()
                                                        .setWidth(34)),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(10),
                                              ),
                                              Center(
                                                child: Container(
                                                  width: ScreenUtil()
                                                      .setWidth(129),
                                                  height: ScreenUtil()
                                                      .setWidth(129),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      //阴影
                                                      BoxShadow(
                                                          color: Color.fromRGBO(
                                                              72, 46, 0, 0.54),
                                                          offset: Offset(0, 0),
                                                          blurRadius:
                                                              ScreenUtil()
                                                                  .setWidth(20))
                                                    ],
                                                  ),
                                                  child: QrImage(
                                                    data: '$url',
                                                    version: 3,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: ScreenUtil()
                                                      .setWidth(20)),
                                              Center(
                                                  child: Text(
                                                CommonUtils.txt('gw') +
                                                    "：${officeurl}",
                                                style: TextStyle(
                                                    color: Color(0xFFf04b3e),
                                                    fontSize: ScreenUtil()
                                                        .setWidth(17),
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )),
                                              SizedBox(
                                                  height: ScreenUtil()
                                                      .setWidth(18)),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      CommonUtils.txt(
                                                              'kkyhid') +
                                                          '：$id',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF222222),
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: ScreenUtil()
                                                              .setSp(14)),
                                                    ),
                                                    Text(
                                                      CommonUtils.txt('yqm') +
                                                          '：$code',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF222222),
                                                          decoration:
                                                              TextDecoration
                                                                  .none,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: ScreenUtil()
                                                              .setSp(14)),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(30),
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    child: Stack(
                                      children: [
                                        Image.asset(
                                          'assets/images/certificate_bg.png',
                                        ),
                                        Positioned(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left:
                                                      ScreenUtil().setWidth(15),
                                                  top: ScreenUtil()
                                                      .setWidth(10)),
                                              child: Image.asset(
                                                'assets/images/logo_label.png',
                                                width:
                                                    ScreenUtil().setWidth(143),
                                                height:
                                                    ScreenUtil().setWidth(54),
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(14),
                                            ),
                                            Center(
                                              child: Image.asset(
                                                  "assets/images/cer_pz.png",
                                                  width: ScreenUtil()
                                                      .setWidth(135),
                                                  height: ScreenUtil()
                                                      .setWidth(34)),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(10),
                                            ),
                                            Center(
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(129),
                                                height:
                                                    ScreenUtil().setWidth(129),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    //阴影
                                                    BoxShadow(
                                                        color: Color.fromRGBO(
                                                            72, 46, 0, 0.54),
                                                        offset: Offset(0, 0),
                                                        blurRadius: ScreenUtil()
                                                            .setWidth(20))
                                                  ],
                                                ),
                                                child: QrImage(
                                                  data: '$url',
                                                  version: 3,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(20)),
                                            Center(
                                                child: Text(
                                              CommonUtils.txt('gw') +
                                                  "：${officeurl}",
                                              style: TextStyle(
                                                  color: Color(0xFFf04b3e),
                                                  fontSize:
                                                      ScreenUtil().setWidth(17),
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontWeight:
                                                      FontWeight.normal),
                                            )),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setWidth(18)),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    CommonUtils.txt('kkyhid') +
                                                        '：$id',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF222222),
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14)),
                                                  ),
                                                  Text(
                                                    CommonUtils.txt('yqm') +
                                                        '：$code',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF222222),
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: ScreenUtil()
                                                            .setSp(14)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: ScreenUtil().setWidth(16),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left:
                                                      ScreenUtil().setWidth(10),
                                                  right:
                                                      ScreenUtil().setWidth(10),
                                                  bottom: ScreenUtil()
                                                      .setWidth(10)),
                                              child: Text(
                                                "${CommonUtils.txt('zhpzy')}\n${CommonUtils.txt('zhpze')}\n${CommonUtils.txt('zhpzs')}",
                                                style: TextStyle(
                                                    color: Color(0xFF666666),
                                                    decoration:
                                                        TextDecoration.none,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: 1.75,
                                                    fontSize:
                                                        ScreenUtil().setSp(12)),
                                              ),
                                            )
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: ScreenUtil().setWidth(15),
                            ),
                            GestureDetector(
                              onTap: () {
                                _saveImgShare();
                              },
                              child: Container(
                                width: ScreenUtil().setWidth(162),
                                height: ScreenUtil().setWidth(38.5),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/details/share_wx.png"))),
                                child: Center(
                                  child: Text(
                                    CommonUtils.txt('ljbc'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal,
                                        fontSize: ScreenUtil().setSp(15)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}
