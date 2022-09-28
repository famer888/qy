import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/components/common/pagetitlebar.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';

class KWantShareToUsers extends BaseWidget {
  KWantShareToUsers({Key key}) : super(key: key);

  @override
  _KWantShareToUsersState cState() => _KWantShareToUsersState();
}

class _KWantShareToUsersState extends BaseWidgetState<KWantShareToUsers> {
  GlobalKey rootWidgetKey = GlobalKey();
  bool isSaving = false;
  Config config;
  Member member;
  int userInviteNumber; // 用户邀请数量
  dynamic _data;

  _loadUserAgentData() async {
    Basic res = await getProxyDetail({});
    if (res.status == 1) {
      userInviteNumber = res.data['direct_proxy_num'];
      _data = res.data;

      if (mounted) {
        setState(() {});
      }
    } else {
      // userInviteNumber = 0;
      // setState(() {});
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

  @override
  Widget appbar() {
    // TODO: implement appbar
    return Container();
  }

  @override
  void onCreate() {
    // TODO: implement initState
    config = Provider.of<HomeConfig>(context, listen: false).config;
    member = Provider.of<HomeConfig>(context, listen: false).member;

    _loadUserAgentData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
  }

  //复制链接分享
  void _copyLinkShare() {
    Clipboard.setData(ClipboardData(text: '${member.share.affUrlCopy.url}'));
    CommonUtils.showText(
      CommonUtils.txt('fzcg'),
    );
  }

  List textsWithMiddleKey({String text, String key}) {
    var results = text.split(key);
    List list = [];
    for (var i = 0; i < results.length; i++) {
      list.add({'type': 0, 'word': results[i]});
      if (i != results.length - 1) {
        list.add({'type': 1, 'word': key});
      }
    }
    return list;
  }

  List textsWithList(List inputList, String key) {
    List list = [];
    for (var item in inputList) {
      if (item['type'] == 1) {
        list.add(item);
      } else {
        list.addAll(textsWithMiddleKey(text: item['word'], key: key));
      }
    }
    return list;
  }

  @override
  Widget pageBody(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().setWidth(667),
          child: RepaintBoundary(
            key: rootWidgetKey,
            child: Stack(
              children: [
                Container(
                  color: GQStyle.bgColor,
                ),
                // Positioned(
                //   top: 0,
                //   child: LImage(
                //     'share_bg',
                //     width: ScreenUtil().screenWidth,
                //     height: ScreenUtil().screenWidth / 375 * 524,
                //   ),
                // ),
                Positioned(
                  left: GQStyle.pagePadding,
                  right: GQStyle.pagePadding,
                  // bottom: ScreenUtil().setWidth(30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setWidth(30),
                      ),
                      // SizedBox(
                      //   height: ScreenUtil().setWidth(65),
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.max,
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         '国产华语AV第一品牌',
                      //         style: TextStyle(
                      //             color: Color.fromRGBO(253, 163, 58, 1),
                      //             fontSize: ScreenUtil().setSp(24),
                      //             fontWeight: FontWeight.w500,
                      //             overflow: TextOverflow.ellipsis,
                      //             decoration: TextDecoration.none),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        width: ScreenUtil().setWidth(344),
                        height: ScreenUtil().setWidth(428 + 39),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: ScreenUtil().setWidth(344),
                                height: ScreenUtil().setWidth(428),
                                decoration: BoxDecoration(
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10)),
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
                                    SizedBox(
                                        height:
                                            ScreenUtil().setWidth(105 - 15)),
                                    Container(
                                      // color: Colors.red,
                                      height: ScreenUtil().setWidth(45),
                                      child: Center(
                                        child: Text(
                                          'Hey bro，我在妻友，来免费看人妻视频',
                                          style: GQStyle.black13,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: ScreenUtil().setWidth(198),
                                      height: ScreenUtil().setWidth(198),
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                              child: LImage('qrcode_bg')),
                                          Center(
                                            child: Container(
                                              // color: Colors.white,
                                              width: ScreenUtil().setWidth(154),
                                              height:
                                                  ScreenUtil().setWidth(154),
                                              child: QrImage(
                                                data: '${member.share.affUrl}',
                                                version: 3,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(26.5)),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(22.5)),
                                      child: Container(
                                        width: ScreenUtil().setWidth(185),
                                        height: ScreenUtil().setWidth(45),
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                          Color.fromRGBO(0, 210, 190, 1),
                                          Color.fromRGBO(100, 150, 252, 1)
                                        ])),
                                        child: Center(
                                          child: RichText(
                                            text: TextSpan(
                                                text: CommonUtils.txt('tgm') +
                                                    ':',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      ScreenUtil().setSp(17),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(text: '  '),
                                                  TextSpan(
                                                      text:
                                                          '${member.share.affCode}',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: ScreenUtil()
                                                              .setSp(17),
                                                          fontWeight:
                                                              FontWeight.w600))
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: LImage('jelly_share_icon_title',
                                  width: ScreenUtil().setWidth(95),
                                  height: ScreenUtil().setWidth(118)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil().setWidth(20)),
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
        Visibility(
          visible: true,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            // appBar: PreferredSize(child: Container(), preferredSize: Size.zero),
            body: Stack(
              children: [
                // LImage('share_up_bg'),
                Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: ClampingScrollPhysics(),
                        child: Container(
                          // width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Center(child: LImage('share_up_bg')),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: GQStyle.navbarHegiht +
                                                (kIsWeb
                                                    ? 10
                                                    : MediaQuery.of(context)
                                                        .padding
                                                        .top) +
                                                20),
                                        // // SizedBox(height: ScreenUtil().setWidth(34)),
                                        // LImage('share_title',
                                        //     width: ScreenUtil().setWidth(325)),
                                        // SizedBox(
                                        //     height: ScreenUtil().setWidth(15)),
                                        Center(
                                          child: SizedBox(
                                            width: ScreenUtil().setWidth(325),
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
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              Spacer(),
                                                              SizedBox(
                                                                height:
                                                                    ScreenUtil()
                                                                        .setWidth(
                                                                            45),
                                                                child: userInviteNumber ==
                                                                        null
                                                                    ? Container()
                                                                    : Center(
                                                                        child: RichText(
                                                                            text: TextSpan(children: [
                                                                          TextSpan(
                                                                              text: CommonUtils.txt('ljyq') + ' ',
                                                                              style: GQStyle.white9255_15),
                                                                          TextSpan(
                                                                              text: '$userInviteNumber' + CommonUtils.txt('ren'),
                                                                              style: GQStyle.jellyCyan_15)
                                                                        ])),
                                                                      ),
                                                              ),
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
                                                                  style: GQStyle.white9255_15,
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
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setWidth(31)),
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
                                                SchedulerBinding.instance
                                                    .addPostFrameCallback((_) {
                                                  _saveImgShare();
                                                });
                                              },
                                        isLoadding: isSaving,
                                      ),
                                      SizedBox(
                                          width: ScreenUtil().setWidth(15)),
                                      ActionShareButton(
                                        text: CommonUtils.txt('fztglj'),
                                        onTap: _copyLinkShare,
                                        isLoadding: false,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setWidth(20)),
                                _data == null
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setWidth(16.5)),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: ScreenUtil().setWidth(40),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                CommonUtils.txt('gzsm'),
                                                style: GQStyle.white255_18_M,
                                              ),
                                            ),
                                            Builder(builder: (context) {
                                              var highlightStyle = TextStyle(
                                                  color: Color.fromRGBO(
                                                      253, 160, 9, 1),
                                                  fontSize:
                                                      ScreenUtil().setSp(13),
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  decoration:
                                                      TextDecoration.none);

                                              var text =
                                                  '${_data['tips'] ?? ''}';
                                              var keys = _data['color_key'];

                                              // var keys = [
                                              //   '1名好友',
                                              //   '3天VIP',
                                              //   '100%返利收益',
                                              //   '100元年卡',
                                              //   '100元收益,可提现！',
                                              // ];

                                              var list = textsWithMiddleKey(
                                                  text: text, key: keys.first);

                                              for (var i = 1;
                                                  i < keys.length;
                                                  i++) {
                                                list = textsWithList(
                                                    list, keys[i]);
                                              }

                                              return RichText(
                                                  text: TextSpan(
                                                      children: list
                                                          .map((e) => TextSpan(
                                                              text: e['word'],
                                                              style: e['type'] ==
                                                                      1
                                                                  ? highlightStyle
                                                                  : GQStyle
                                                                      .white255_13))
                                                          .toList()));
                                            }),
                                          ],
                                        ),
                                      ),
                                SizedBox(height: ScreenUtil().setWidth(30)),
                                Text(CommonUtils.txt('yqbz'),
                                    style: GQStyle.white255_24_B),
                                // Padding(
                                //   padding: EdgeInsets.symmetric(
                                //       vertical: ScreenUtil().setWidth(10)),
                                //   child: LImage('share_arrow_down',
                                //       width: ScreenUtil().setWidth(34),
                                //       height: ScreenUtil().setWidth(21)),
                                // ),
                                SizedBox(height: ScreenUtil().setWidth(10)),
                                Text(config.tips_share_text ?? "loading",
                                    style: GQStyle.white255_15),
                                SizedBox(height: ScreenUtil().setWidth(50)),
                                Stack(
                                  children: [
                                    LImage(
                                      "wd_fxbotmbg_n",
                                      width: double.infinity,
                                      height: ScreenUtil().setWidth(500),
                                    ),
                                    Positioned.fill(
                                        child: Column(
                                      children: [
                                        Spacer(flex: 970),
                                        Expanded(
                                            flex: 40,
                                            child: Container(
                                              // color: Colors.red,
                                              child: GestureDetector(
                                                behavior:
                                                    HitTestBehavior.translucent,
                                                onTap: () {
                                                  context.push('/' +
                                                      Routes.mineAgentPage);
                                                },
                                              ),
                                            ))
                                      ],
                                    ))
                                  ],
                                ),
                                SizedBox(height: ScreenUtil().setWidth(50)),
                              ]),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
                    height: GQStyle.navbarHegiht,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                context.pop();
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push(
                                    '/' + Routes.mineAgentInviteRecordPage);
                              },
                              child: Text(
                                CommonUtils.txt('yqjl'),
                                style: GQStyle.graya3a2a2_15,
                              ),
                            )
                          ],
                        ),
                        Center(
                          child: Text("分享推广", style: GQStyle.white255_18_B),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: GQStyle.bgColor,
          ),
        ),
      ],
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
                    Color.fromRGBO(0, 210, 190, 1),
                    Color.fromRGBO(100, 150, 252, 1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              )
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
                  style: GQStyle.white255_15_semibold,
                ),
        ),
      ),
    );
  }
}
