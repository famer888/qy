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
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/model/basic.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/page/kwantsharetousers.dart';
import 'package:qypj/pages/mine/agent/mine_agent_apply_page.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/common.dart';

class WelfareAgentPage extends BaseWidget {
  WelfareAgentPage({Key key}) : super(key: key);

  @override
  _WelfareAgentPageState cState() => _WelfareAgentPageState();
}

class _WelfareAgentPageState extends BaseWidgetState<WelfareAgentPage> {
  GlobalKey rootWidgetKey = GlobalKey();

  bool networkErr = false;
  bool isHud = true;

  dynamic _proxy_money; //余额
  dynamic _data;

  bool isSaving = false;
  Config config;
  Member member;
  int userInviteNumber; // 用户邀请数量

  bool showApplePage = false; // 是否显示申请页面

  _loadUserAgentData() async {
    member = Provider.of<HomeConfig>(context, listen: false).member;

    // 先判断用户是不是 代理self
    if (member.channel != 'self') {
      showApplePage = true;
      isHud = false;
      networkErr = false;
      setState(() {});
      return;
    }

    try {
      Basic res = await getProxyDetail({});
      if (res.status != 1) {
        if (res.msg.contains('请先申请成为代理')) {
          showApplePage = true;
          isHud = false;
          networkErr = false;
        } else {
          CommonUtils.showText(res.msg);
          isHud = false;
          networkErr = true;
        }
      } else {
        _data = res.data;
        _proxy_money = res.data['proxy_money'];
        userInviteNumber = res.data['direct_proxy_num'];

        showApplePage = false;
        isHud = false;
        networkErr = false;
      }
      setState(() {});
    } catch (e) {
      isHud = false;
      networkErr = true;
      setState(() {});
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

  @override
  void onCreate() {
    // TODO: implement onCreate
    config = Provider.of<HomeConfig>(context, listen: false).config;
    setAppTitle(bgColor: Colors.transparent);
    // member = Provider.of<HomeConfig>(context, listen: false).member;

    _loadUserAgentData();
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
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

  // void foo() {
  //   var text = '1234567890';

  //   var keys = ['4', '2', '8'];

  //   List list = [];
  //   var l = textsWithMiddleKey(text: text, key: keys.first);

  //   for (var i = 1; i < keys.length; i++) {
  //     l = textsWithList(l, keys[i]);
  //   }

  //   print(l);
  // }

  @override
  Widget pageBody(BuildContext context) {
    member = Provider.of<HomeConfig>(context, listen: false).member;
    return networkErr
        ? PageStatus.noNetWork(onTap: () {
            _loadUserAgentData();
          })
        : isHud
            ? PageStatus.loading(mounted)
            : showApplePage
                ? MineAgentApplyPage(
                    applySuccess: () {
                      isHud = true;
                      setState(() {});
                      _loadUserAgentData();
                    },
                  )
                : Stack(
                    children: [
                      Container(
                        // color: GQStyle.bgColor,
                        child: PullRefreshList(
                          onRefresh: _loadUserAgentData,
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                                horizontal: ScreenUtil().setWidth(17.5)),
                            children: [
                              // SizedBox(height: ScreenUtil().setWidth(15)),
                              // Container(
                              //   // color: Colors.red,
                              //   child: LImage(
                              //     'dlzs',
                              //     // width: ScreenUtil().setWidth(327),
                              //     // height: ScreenUtil().setWidth(67.5),
                              //   ),
                              // ),
                              SizedBox(height: ScreenUtil().setWidth(15)),
                              Container(
                                height: ScreenUtil().setWidth(157),
                                child: Stack(
                                  children: [
                                    // ClipPath(
                                    //   clipper: MyClipper(),
                                    //   child:
                                    Positioned.fill(
                                        child: LImage(
                                      'dl_penal',
                                      fit: BoxFit.cover,
                                    )),
                                    Container(
                                      height: ScreenUtil().setWidth(157),
                                      decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.all(
                                          //     Radius.circular(ScreenUtil().setWidth(5))),
                                          // gradient: LinearGradient(
                                          //     begin: Alignment.topCenter,
                                          //     end: Alignment.bottomCenter,
                                          //     colors: [
                                          //       Color(0xfff3e8d8),
                                          //       Color(0xffe7cdb6),
                                          //     ]),
                                          ),
                                    ),
                                    // ),
                                    SizedBox(
                                        height: ScreenUtil().setWidth(11.5)),
                                    Container(
                                      height: ScreenUtil().setWidth(53),
                                      margin: EdgeInsets.all(
                                          ScreenUtil().setWidth(16.5)),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                              clipBehavior: Clip.hardEdge,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                ScreenUtil().setWidth(53 / 2.0),
                                              ),
                                              child: Container(
                                                width:
                                                    ScreenUtil().setWidth(53),
                                                height:
                                                    ScreenUtil().setWidth(53),
                                                child:
                                                    PlatformAwareNetworkImage(
                                                  url: member.thumb,
                                                ),
                                              )),
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
                                                      Text(
                                                          '${_data['proxy_level_str']}',
                                                          style: GQStyle
                                                              .brown916044_14medium),
                                                      Expanded(
                                                          child: Container()),
                                                      Text(
                                                          CommonUtils.txt(
                                                              'ktxje'),
                                                          style: GQStyle
                                                              .brown916044_12semibold),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          CommonUtils.txt(
                                                              'yhysj'),
                                                          style: GQStyle
                                                              .brown916044_12medium),
                                                      Expanded(
                                                          child: Container()),
                                                      Text('$_proxy_money',
                                                          style: GQStyle
                                                              .brown916044_24semibold)
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Positioned.fill(
                                        // top: ScreenUtil().setWidth(97),
                                        // bottom: ScreenUtil().setWidth(73),
                                        child: Column(
                                      children: [
                                        Expanded(flex: 97, child: Container()),
                                        SizedBox(
                                            height: ScreenUtil().setWidth(46)),
                                        Container(
                                          // width: double.infinity,
                                          // color: Colors.red,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 42,
                                                child: Container(),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                      '/mineAgentToCashPage/1');
                                                },
                                                child: Container(
                                                  // color: Colors.deepOrange,
                                                  width: ScreenUtil()
                                                      .setWidth(115),
                                                  height:
                                                      ScreenUtil().setWidth(35),
                                                  // alignment: Alignment.center,
                                                  child: Stack(
                                                    children: [
                                                      LImage(
                                                        'proxy_btn_bg',
                                                        fit: BoxFit.cover,
                                                        width: ScreenUtil()
                                                            .setWidth(115),
                                                        height: ScreenUtil()
                                                            .setWidth(35),
                                                      ),
                                                      Positioned(
                                                        top: ScreenUtil()
                                                            .setWidth(5.5),
                                                        child: Container(
                                                          width: ScreenUtil()
                                                              .setWidth(115),
                                                          height: ScreenUtil()
                                                              .setWidth(20),
                                                          // color: Colors.cyan,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            CommonUtils.txt(
                                                                'ljtx'),
                                                            style: GQStyle
                                                                .brown_1378860_14_M,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 54,
                                                child: Container(),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                      '/${Routes.mineAgentPromoteDataPage}');
                                                },
                                                child: Container(
                                                  width: ScreenUtil()
                                                      .setWidth(115),
                                                  height:
                                                      ScreenUtil().setWidth(35),
                                                  alignment: Alignment.center,
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                          child: LImage(
                                                        'proxy_btn_bg',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                      )),
                                                      Positioned(
                                                        top: ScreenUtil()
                                                            .setWidth(5.5),
                                                        child: Container(
                                                          width: ScreenUtil()
                                                              .setWidth(115),
                                                          height: ScreenUtil()
                                                              .setWidth(20),
                                                          // color: Colors.cyan,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            CommonUtils.txt(
                                                                'tgsj'),
                                                            style: GQStyle
                                                                .brown_1378860_14_M,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 42,
                                                child: Container(),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(flex: 73, child: Container())
                                      ],
                                    )),
                                  ],
                                ),
                              ),
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
                                    color: Color.fromRGBO(210, 163, 127, 1),
                                    fontSize: ScreenUtil().setSp(13),
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.ellipsis,
                                    decoration: TextDecoration.none);

                                var text = '${_data['tips'] ?? ''}';
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

                                for (var i = 1; i < keys.length; i++) {
                                  list = textsWithList(list, keys[i]);
                                }

                                return RichText(
                                    text: TextSpan(
                                        children: list
                                            .map((e) => TextSpan(
                                                text: e['word'],
                                                style: e['type'] == 1
                                                    ? highlightStyle
                                                    : GQStyle.white255_13))
                                            .toList()));

                                // return Column(
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     RichText(
                                //       text: TextSpan(
                                //           text: '1.邀请',
                                //           style: GQStyle.white_13,
                                //           children: [
                                //             TextSpan(
                                //               text: '1名好友',
                                //               style: highlightStyle,
                                //             ),
                                //             TextSpan(
                                //               text: '成功注册即可获得',
                                //               style: GQStyle.white255_12,
                                //             ),
                                //             TextSpan(
                                //               text: '3天VIP',
                                //               style: highlightStyle,
                                //             )
                                //           ]),
                                //     ),
                                //     RichText(
                                //       text: TextSpan(
                                //           text: '2.邀请好友产生充值可获',
                                //           style: GQStyle.white_13,
                                //           children: [
                                //             TextSpan(
                                //               text: '充值100%返利收益',
                                //               style: highlightStyle,
                                //             ),
                                //             TextSpan(
                                //               text: '\n如：邀请好友A，A充值',
                                //               style: GQStyle.white255_12,
                                //             ),
                                //             TextSpan(
                                //               text: '100元年卡',
                                //               style: highlightStyle,
                                //             ),
                                //             TextSpan(
                                //               text: 'VIP，即可获得',
                                //               style: GQStyle.white255_12,
                                //             ),
                                //             TextSpan(
                                //               text: '100元收益,可提现！',
                                //               style: highlightStyle,
                                //             ),
                                //           ]),
                                //     ),
                                //     Text(
                                //       '3.邀请说明：点击【保存二维码】或【复制推广连接】，获取专属推广链接，推荐分享给他其他人下载即可',
                                //       style: TextStyle(
                                //           color: Color.fromRGBO(255, 255, 255, 1),
                                //           fontSize: ScreenUtil().setSp(12),
                                //           overflow: TextOverflow.visible,
                                //           decoration: TextDecoration.none),
                                //       // maxLines: 3,
                                //     ),
                                //   ],
                                // );
                              }),
                              // Text(
                              //   '${_data['tips'] ?? ''}',
                              //   style: TextStyle(
                              //       color: Color.fromRGBO(255, 255, 255, 1),
                              //       fontSize: ScreenUtil().setSp(12),
                              //       overflow: TextOverflow.visible,
                              //       decoration: TextDecoration.none),
                              //   // maxLines: 3,
                              // ),
                              SizedBox(
                                height: ScreenUtil().setWidth(25),
                              ),
                              Container(
                                // width: ScreenUtil().setWidth(325),
                                height: ScreenUtil().setWidth(354),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: LImage(
                                        'jelly_share_qr_bg',
                                        width: ScreenUtil().setWidth(325),
                                        height: ScreenUtil().setWidth(354),
                                        fit: BoxFit.fill,
                                      ),
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
                                                    height: ScreenUtil()
                                                        .setWidth(45),
                                                    child:
                                                        userInviteNumber == null
                                                            ? Container()
                                                            : Center(
                                                                child: RichText(
                                                                    text: TextSpan(
                                                                        children: [
                                                                      TextSpan(
                                                                          text: CommonUtils.txt('ljyq') +
                                                                              ' ',
                                                                          style:
                                                                              GQStyle.white9255_15),
                                                                      TextSpan(
                                                                          text: '$userInviteNumber' +
                                                                              CommonUtils.txt(
                                                                                  'ren'),
                                                                          style:
                                                                              GQStyle.jellyCyan_15)
                                                                    ])),
                                                              ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Expanded(
                                          flex: 415,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    ScreenUtil().setWidth(15)),
                                            // color: Colors.green,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // SizedBox(
                                                //     height: ScreenUtil().setWidth(10)),
                                                Container(
                                                  color: Colors.white,
                                                  // width: ScreenUtil().setWidth(134),
                                                  // height: ScreenUtil().setWidth(134),
                                                  child: QrImage(
                                                    data:
                                                        '${member.share.affUrl}',
                                                    version: 3,
                                                    size: ScreenUtil()
                                                        .setWidth(134),
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                      text: CommonUtils.txt(
                                                          'wdggm'),
                                                      style:
                                                          GQStyle.white9255_15,
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
                              SizedBox(height: ScreenUtil().setWidth(31)),
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ActionShareButton(
                                      text: CommonUtils.txt('fztglj'),
                                      onTap: _copyLinkShare,
                                      isLoadding: false,
                                    ),
                                    SizedBox(width: ScreenUtil().setWidth(15)),
                                    ActionShareButton(
                                      text: CommonUtils.txt('ljyqt'),
                                      onTap: () {
                                        context.push(
                                            '/${Routes.kwantsharetousers}');
                                      },
                                      isLoadding: false,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: ScreenUtil().setWidth(30)),
                              Center(
                                  child: Text(CommonUtils.txt('yqbz'),
                                      style: GQStyle.white255_24_B)),
                              // Padding(
                              //   padding: EdgeInsets.symmetric(vertical: ScreenUtil().setWidth(10)),
                              //   child: LImage('share_arrow_down',
                              //       width: ScreenUtil().setWidth(34),
                              //       height: ScreenUtil().setWidth(21)),
                              // ),
                              SizedBox(height: ScreenUtil().setWidth(10)),
                              Center(
                                  child: Text(
                                      config.tips_share_text ?? "loading",
                                      style: GQStyle.white255_15)),
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
                                                context.push(
                                                    '/' + Routes.mineAgentPage);
                                              },
                                            ),
                                          ))
                                    ],
                                  ))
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setWidth(50)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
  }
}
