import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:qypj/utils/util_eventbus_class.dart';
import 'package:provider/provider.dart';
import 'package:qypj/components/common/pullrefreshlist.dart';
import 'package:qypj/components/page_status.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/routers.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/index.dart';
import 'package:qypj/utils/networkImage.dart';
import 'package:qypj/components/yy_dialog.dart';

class Wode extends BaseWidget {
  Wode({Key key, this.isShow = false}) : super(key: key);
  final bool isShow;

  @override
  State<StatefulWidget> cState() {
    // TODO: implement cState
    return _WodeState();
  }
}

class _WodeState extends BaseWidgetState<Wode> {
  bool isHud = true;
  // int mvNum = 0; // 视频长片数量
  // int smvNum = 0; // 视频短片
  // int mhNum = 0; // 漫画
  // int storyNum = 0; // 小说
  // int picNum = 0; // 色图
  // int girlNum = 0; // 上门美女
  String vipName = ''; // vip名称
  String vipStatusText = ''; // vip状态
  bool networkErr = false;
  bool redShow = false;

  @override
  void didUpdateWidget(covariant Wode oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.isShow && isHud) {
      initInfo();
    } else {}
  }

  void initInfo() async {
    await getUserInfo(context);
    await CommonUtils.updateSystemNotice(context);
    isHud = false;
    setState(() {});
  }

  Widget _textRow({String title, String text}) {
    List<String> tempList = title.split('');
    List<Widget> tempWidgetList = [];
    for (var item in tempList) {
      tempWidgetList.add(
        new Container(
          width: ScreenUtil().setWidth(15),
          child: Text(
            item,
            style: GQStyle.lgray13,
          ),
        ),
      );
    }
    return Row(
      children: [
        Container(
          width: ScreenUtil().setWidth(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: tempWidgetList,
          ),
        ),
        SizedBox(
          width: ScreenUtil().setWidth(10),
        ),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GQStyle.black13,
          ),
        ),
      ],
    );
  }

  List mainMenuList = [
    {
      'icon': 'wdgz',
      'name': CommonUtils.txt('wdgz'),
      'router': '/${Routes.fansfollow}'
    },
    {
      'icon': 'wd_sc_n',
      'name': CommonUtils.txt('wdsc'),
      'router': '/${Routes.collect}'
    },
    {
      'icon': 'txyqm',
      'name': CommonUtils.txt('sr') + CommonUtils.txt('yqm'),
      'router': 'fillcode'
    },
    {
      'icon': 'wdyqm',
      'name': CommonUtils.txt('sr') + CommonUtils.txt('dhm'),
      'router': 'fillcodedh'
    },
    {
      'icon': 'wdyy',
      'name': CommonUtils.txt('zxhc'),
      'router': '/${Routes.down}'
    },
    {
      'icon': 'wdwt',
      'name': CommonUtils.txt('cjwt'),
      'router': '/${Routes.onlineService}'
    },
    {
      'icon': 'wdgfq',
      'name': CommonUtils.txt('gfjlq'),
      'router': '/${Routes.contactOfficial}'
    },
  ];

  Widget memberVip(dynamic value) {
    var type = "";
    switch (value) {
      case 0:
        return Container();
        break;
      case 1:
        type = CommonUtils.txt('lsk');
        break;
      case 2:
        type = CommonUtils.txt('zk');
        break;
      case 3:
        type = CommonUtils.txt('yk');
        break;
      case 4:
        type = CommonUtils.txt('jk');
        break;
      case 5:
        type = CommonUtils.txt('bnk');
        break;
      case 6:
        type = CommonUtils.txt('nk');
        break;
      case 7:
        type = CommonUtils.txt('lnk');
        break;
      case 8:
        type = CommonUtils.txt('yjk');
        break;
    }
    return Container(
      width: ScreenUtil().setWidth(40),
      height: ScreenUtil().setWidth(16),
      decoration: kIsWeb
          ? BoxDecoration(
              color: Color(0xFFf4d4b5),
              borderRadius: BorderRadius.all(Radius.circular(7.5)))
          : BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFf5e0d1),
                Color(0xFFfbeadd),
                Color(0xFFf4d4b5)
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Center(
          child: Text(type,
              style: TextStyle(
                  color: Color(0xFF89583c), fontSize: ScreenUtil().setSp(10)))),
    );
  }

  /// 头部状态信息
  Widget setHeadInfo(isLogin, members) {
    if (isLogin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            members?.nickname ?? CommonUtils.txt('kkyh'),
            style: GQStyle.white18bold,
          ),
          SizedBox(
            height: ScreenUtil().setWidth(9.5),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              members?.vipLevel != 0 && members?.vipLevel != null
                  ? memberVip(members?.vipLevel)
                  : SizedBox(),
              SizedBox(
                width: members?.vipLevel != 0 && members?.vipLevel != null
                    ? ScreenUtil().setWidth(12)
                    : 0,
              ),
              Text(
                'ID:${members?.aff ?? '0000000'}',
                style: GQStyle.gray95_12,
              ),
            ],
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: () {
        context.push('/login/0');
      },
      child: Container(
        width: ScreenUtil().setWidth(75),
        height: ScreenUtil().setWidth(35),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            ScreenUtil().setWidth(37.5),
          ),
          border: Border.all(
            width: 0.5,
            color: Color.fromRGBO(103, 224, 185, 1),
          ),
        ),
        child: Center(
          child: Text(
            CommonUtils.txt('dl'),
            style: TextStyle(color: Color.fromRGBO(103, 224, 185, 1)),
          ),
        ),
      ),
    );
  }

  /// 操作列表
  Widget setHandleList() {
    Member members = Provider.of<HomeConfig>(context, listen: true).member;
    List<Widget> tempList = [];
    for (var i = 0; i < mainMenuList.length; i++) {
      var item = mainMenuList[i];
      tempList.add(
        new GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (item['router'] != null) {
              if (item['router'] == "fillcode") {
                context.push(CommonUtils.getRealHash('fillcode'),
                    extra: {'title': CommonUtils.txt('yqm')});
              } else if (item['router'] == "fillcodedh") {
                context.push(CommonUtils.getRealHash('fillcode'),
                    extra: {'title': CommonUtils.txt('dhm')});
              } else {
                context.push(item['router']);
              }
            }
          },
          child: Container(
            height: ScreenUtil().setWidth(44),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LImage('qy_newyear_' + item['icon'],
                        width: ScreenUtil().setWidth(30),
                        height: ScreenUtil().setWidth(30)),
                    SizedBox(
                      width: ScreenUtil().setWidth(9.5),
                    ),
                    Text(
                      item['name'],
                      overflow: TextOverflow.ellipsis,
                      style: GQStyle.gray240_14,
                    ),
                  ],
                ),
                LImage(
                  "wd_lmarrow_n",
                  width: ScreenUtil().setWidth(10),
                  height: ScreenUtil().setWidth(10),
                )
              ],
            ),
            // decoration: BoxDecoration(
            //   border: Border(
            //       bottom: i == mainMenuList.length - 1
            //           ? BorderSide.none
            //           : BorderSide(
            //               color: Color.fromRGBO(255, 255, 255, 0.1), width: 1)),
            // ),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(11, 11, 33, 1),
              Color.fromRGBO(21, 21, 42, 1)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))),
      margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      padding:
          EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40 - 12.5)),
      child: Wrap(
        spacing: ScreenUtil().setWidth(0),
        runSpacing: ScreenUtil().setWidth(0),
        children:
            tempList.asMap().keys.map((index) => tempList[index]).toList(),
      ),
    );
  }

  /// 卡片 type类型{1: vip,2: gold}
  Widget setCard(int type, Member members) {
    String bgImg = '';
    String title = '';
    String subTitle = '';
    String btnText = '';
    String routeString = '';
    if (type == 1) {
      bgImg = 'wd_vbg_n';
      title = CommonUtils.txt('hyzx');
      DateTime nowTime = new DateTime.now();
      String nowString = '${nowTime.year}-${nowTime.month}-${nowTime.day}';
      // if (members?.expiredAt != null) {
      if (members?.vipLevel != null && members.vipLevel > 0) {
        String tempTime = members?.expiredAt.toString().split(' ')[0];
        if (tempTime == nowString) {
          subTitle = CommonUtils.txt('fhy');
        } else {
          subTitle = '$tempTime' + CommonUtils.txt('dq');
        }
      } else {
        subTitle = CommonUtils.txt('fhy');
      }

      btnText = CommonUtils.txt('ljcz');
      routeString = '/${Routes.vip}';
    }
    if (type == 2) {
      bgImg = 'wd_jbg_n';
      title = CommonUtils.txt('jbgm');
      subTitle = CommonUtils.txt('ye');
      btnText = CommonUtils.txt('ljgm');
      routeString = '/${Routes.coinRecharge}';
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (routeString.contains("coinRecharge")) {
          UtilEventbus().fire(
            UtilEventbusClass({
              "name": "openwf",
              "data": {"index": 1},
            }),
          );
        } else {
          context.push(routeString);
        }
      },
      child: Container(
        // width: ScreenUtil().setWidth(163),
        // height: ScreenUtil().setWidth(80),
        child: Stack(
          children: [
            LImage(
              bgImg,
              fit: BoxFit.fill,
              width: double.infinity,
              height: double.infinity,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xff845c48),
                      fontSize: ScreenUtil().setSp(15),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: ScreenUtil().setWidth(2),
                      bottom: ScreenUtil().setWidth(5),
                    ),
                    child: Text(
                      subTitle,
                      style: TextStyle(
                        color: Color(0xff845c48),
                        fontSize: ScreenUtil().setSp(11),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(5)),
                        height: ScreenUtil().setWidth(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xff845c48),
                            width: ScreenUtil().setWidth(0.5),
                          ),
                          borderRadius: BorderRadius.circular(
                            ScreenUtil().setWidth(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            btnText,
                            style: TextStyle(
                              color: Color(0xff845c48),
                              fontSize: ScreenUtil().setSp(10),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox())
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    EventBus().on('need-update-login-state', (args) {
      if (args == 'login') {
        setState(() {});
      } else if (args == 'quit') {
        getUserInfo(context);
      }
    });
  }

  @override
  void onDestroy() {
    // TODO: implement onDestroy
    EventBus().off('need-update-login-state');
  }

  @override
  Widget backGroundView() {
    // TODO: implement topBackground
    return Container(
      height: ScreenUtil().screenWidth * 228 / 380,
      child: LImage(
        "wd_topbg_n",
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  @override
  Widget pageBody(BuildContext context) {
    // TODO: implement pageBodys
    Member members = Provider.of<HomeConfig>(context, listen: true).member;
    Config config = Provider.of<HomeConfig>(context, listen: false).config;
    bool isLogin = false;
    if (['', null, false].contains(AppGlobal.apiToken)) {
      isLogin = false;
    } else {
      isLogin = true;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isHud
            ? Container()
            : Padding(
                padding: EdgeInsets.only(
                    right: GQStyle.pagePadding,
                    top: ScreenUtil().setWidth(35),
                    bottom: ScreenUtil().setWidth(11)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SystemNoticeIcon(imShow: redShow),
                    SizedBox(
                      width: ScreenUtil().setWidth(13),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/${Routes.setup}');
                      },
                      child: LImage(
                        'wd_setup_n',
                        width: ScreenUtil().setWidth(25),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  ],
                ),
              ),
        Expanded(
          child: PullRefreshList(
            onRefresh: () {
              if (networkErr) {
                networkErr = false;
                setState(() {});
              }
              initInfo();
            },
            child: networkErr
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setWidth(23),
                        ),
                        child: setHandleList(),
                      ),
                      Center(
                        child: Text(
                          CommonUtils.txt('jcwlxl'),
                          style: GQStyle.red14,
                        ),
                      )
                    ],
                  )
                : isHud && widget.isShow
                    ? PageStatus.loading(mounted)
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: GQStyle.pagePadding),
                                    child: ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(39)),
                                      child: Container(
                                        height: ScreenUtil().setWidth(78),
                                        width: ScreenUtil().setWidth(78),
                                        color: Colors.white.withAlpha(30),
                                        child: Center(
                                            child: ClipRRect(
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setWidth(39)),
                                          child: Container(
                                            width: ScreenUtil().setWidth(73),
                                            height: ScreenUtil().setWidth(73),
                                            child: UserAvatar(),
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(5)),
                                setHeadInfo(isLogin, members)
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil().setWidth(10),
                                bottom: ScreenUtil().setWidth(10),
                                left: GQStyle.pagePadding,
                                right: GQStyle.pagePadding,
                              ),
                              child: GridView.count(
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                crossAxisSpacing: ScreenUtil().setWidth(10),
                                childAspectRatio: 163 / 80.0,
                                children: [
                                  setCard(1, members),
                                  setCard(2, members),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // UtilEventbus().fire(
                                  //   UtilEventbusClass({
                                  //     "name": "openwf",
                                  //     "data": {"index": 0},
                                  //   }),
                                  // );
                                },
                                child: Container(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: GQStyle.pagePadding),
                                  height: ScreenUtil().setWidth(70),
                                  // decoration: BoxDecoration(
                                  //   gradient: LinearGradient(
                                  //     colors: [
                                  //       Color.fromRGBO(84, 87, 99, 1.0),
                                  //       // Color.fromRGBO(245, 228, 212, 1.0),
                                  //       Color.fromRGBO(62, 65, 79, 1.0)
                                  //     ],
                                  //     begin: Alignment.topLeft,
                                  //     end: Alignment.bottomRight,
                                  //   ),
                                  //   borderRadius:
                                  //       BorderRadius.all(Radius.circular(5)),
                                  // ),
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      context.push(CommonUtils.getRealHash(
                                          Routes.kwantsharetousers));
                                    },
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                            child: LImage(
                                          'qy_newyear_mine_vvp_bg',
                                          fit: BoxFit.fill,
                                        )),
                                        Positioned.fill(
                                          child: Column(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    SizedBox(
                                                      height: 8.w,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 65.w),
                                                      child: Text(
                                                          CommonUtils.txt(
                                                              "mflqhy"),
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    170,
                                                                    36,
                                                                    59,
                                                                    1.0),
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(14),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // child: Text.rich(
                                              //   TextSpan(children: [
                                              //     WidgetSpan(
                                              //       alignment:
                                              //           PlaceholderAlignment
                                              //               .middle,
                                              //       child: Padding(
                                              //           padding: EdgeInsets.only(
                                              //               right:
                                              //                   ScreenUtil()
                                              //                       .setWidth(
                                              //                           5)),
                                              //           child: SizedBox(
                                              //             width: 65.w,
                                              //           )),
                                              //     ),
                                              //     TextSpan(
                                              //         text: CommonUtils.txt(
                                              //             "mflqhy"),
                                              //         style: TextStyle(
                                              //           color: Color.fromRGBO(
                                              //               170, 36, 59, 1.0),
                                              //           fontSize: ScreenUtil()
                                              //               .setSp(14),
                                              //           fontWeight:
                                              //               FontWeight.bold,
                                              //         )),
                                              //   ]),
                                              // ),
                                              // ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 23.5.w),
                                                  child: Text(
                                                    config.tips_share_text ??
                                                        CommonUtils.txt(
                                                            "cgyqsqt"),
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          170, 36, 59, 1.0),
                                                      fontSize: ScreenUtil()
                                                          .setSp(14),
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setWidth(10)),
                            setHandleList(),
                            SizedBox(height: ScreenUtil().setWidth(15))
                          ],
                        ),
                      ),
          ),
        )
      ],
    );
  }
}

class UserAvatar extends StatefulWidget {
  const UserAvatar({Key key}) : super(key: key);

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConfig>(builder: (ctx, state, child) {
      return state.member?.thumb == null || state.member?.thumb.length == 0
          ? LImage(
              'flj_logo_icon',
              width: double.infinity,
              fit: BoxFit.fitHeight,
            )
          : PlatformAwareNetworkImage(
              fit: BoxFit.cover,
              url: '${state.member.thumb}',
            );
    });
  }
}

class SystemNoticeIcon extends StatelessWidget {
  const SystemNoticeIcon({
    Key key,
    this.imShow = false,
  }) : super(key: key);
  final imShow;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeConfig>(
      builder: (ctx, state, child) => GestureDetector(
        onTap: () {
          context.push('/${Routes.messagecenter}');
        },
        child: LImage(
          ((state.systemnotice?.data ?? false) != null &&
                      (state.systemnotice.data.systemNoticeCount != 0 ||
                          state.systemnotice.data.feedCount != 0)) ||
                  imShow
              ? 'wd_mesgnew_n'
              : 'wd_mesg_n',
          width: ScreenUtil().setWidth(25),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
