import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/base/baseWidget.dart';
import 'package:qypj/mixin/imchatmanager_io.dart';
import 'package:qypj/model/imchat_model.dart';
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
    } else {
      dealRedShow();
    }
  }

  void dealRedShow() {
    List<ChatList> chats = IMChatManagerIO.instance().getChats();
    if (chats.isEmpty) redShow = false;
    for (var item in chats) {
      if (item.count > 0) {
        redShow = true;
        break;
      } else {
        redShow = false;
      }
    }
    if (mounted) setState(() {});
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
      'icon': 'wd_tz_n',
      'name': CommonUtils.txt('wdtz'),
      'router': '/${Routes.minepostpage}'
    },
    {
      'icon': 'wd_sc_n',
      'name': CommonUtils.txt('wdsc'),
      'router': '/${Routes.collect}'
    },
    {
      'icon': 'wd_gz_n',
      'name': CommonUtils.txt('wdgz'),
      'router': '/${Routes.fansfollow}'
    },
    {
      'icon': 'wd_cz_n',
      'name': CommonUtils.txt('ycrz'),
      'router': '/${Routes.originalenter}'
    },
  ];

  List footerList = [
    {
      'icon': 'wd_gm_n',
      'name': CommonUtils.txt('wdgm'),
      'router': '/${Routes.buy}'
    },
    {
      'icon': 'wd_hc_n',
      'name': CommonUtils.txt('zxhc'),
      'router': '/${Routes.down}'
    },
    {
      'icon': 'txyqm',
      'name': CommonUtils.txt('txyqm'),
      'router': 'fillcode',
    },
    {
      'icon': 'wdyqm',
      'name': CommonUtils.txt('txdhm'),
      'router': 'fillcodedh',
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

  //头部状态信息
  Widget setHeadInfo(isLogin, members) {
    if (isLogin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                members?.nickname ?? CommonUtils.txt('kkyh'),
                style: GQStyle.white18bold,
              ),
              SizedBox(width: 2.w),
              members.agent == 1
                  ? Icon(Icons.verified_sharp,
                      size: 17.w, color: Color.fromRGBO(247, 208, 93, 1))
                  : Container()
            ],
          ),
          SizedBox(
            height: ScreenUtil().setWidth(9.5),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              members?.vipLevel != 0 && members?.vipLevel != null
                  ? CommonUtils.memberVip(members?.vip_str)
                  : SizedBox(),
              SizedBox(
                width: members?.vipLevel != 0 && members?.vipLevel != null
                    ? ScreenUtil().setWidth(12)
                    : 0,
              ),
              Text(
                'ID: ${members?.aff ?? '0000000'}',
                style: GQStyle.gray95_12,
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  members?.nickname ?? CommonUtils.txt('kkyh'),
                  style: GQStyle.white18bold,
                ),
                SizedBox(width: 2.w),
                members.agent == 1
                    ? Icon(Icons.verified_sharp,
                        size: 17.w, color: Color.fromRGBO(247, 208, 93, 1))
                    : Container()
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(9.5),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                members?.vipLevel != 0 && members?.vipLevel != null
                    ? CommonUtils.memberVip(members?.vip_str)
                    : SizedBox(),
                SizedBox(
                  width: members?.vipLevel != 0 && members?.vipLevel != null
                      ? ScreenUtil().setWidth(12)
                      : 0,
                ),
                Text(
                  'ID: ${members?.aff ?? '0000000'}',
                  style: GQStyle.gray95_12,
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            context.push('/login/0');
          },
          child: Container(
            width: ScreenUtil().setWidth(70),
            height: ScreenUtil().setWidth(32),
            decoration: BoxDecoration(
              color: Color.fromRGBO(35, 38, 46, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.w),
                bottomLeft: Radius.circular(16.w),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CommonUtils.txt('dl'),
                    style: TextStyle(
                        color: Color.fromRGBO(250, 207, 135, 1),
                        fontSize: ScreenUtil().setSp(14)),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.w,
                    color: Color.fromRGBO(250, 207, 135, 1),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  /// 操作列表
  Widget setHandleList() {
    Member members = Provider.of<HomeConfig>(context, listen: true).member;
    List<Widget> tempList = [];
    for (var i = 0; i < footerList.length; i++) {
      var item = footerList[i];
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
                    LImage(item['icon'],
                        width: ScreenUtil().setWidth(20),
                        height: ScreenUtil().setWidth(20)),
                    SizedBox(
                      width: ScreenUtil().setWidth(9.5),
                    ),
                    Text(
                      item['name'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
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
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(21, 21, 42, 1),
              Color.fromRGBO(11, 11, 33, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(5))),
      margin: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
      padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(40 - 12.5), vertical: 10.w),
      child: Wrap(
        spacing: 0.w,
        runSpacing: 0.w,
        children:
            tempList.asMap().keys.map((index) => tempList[index]).toList(),
      ),
    );
  }

  /// 卡片 type类型{1: 金币充值,2: 分享邀请 3: }
  Widget setCard(int type, Member members) {
    String bgImg = '';
    String title = '';
    String subTitle = '';
    String routeString = '';
    if (type == 1) {
      bgImg = 'wd_jbcz_n';
      title = CommonUtils.txt('jbcz');
      subTitle = CommonUtils.txt('dqye') + " ${members.money}";
      routeString = '/${Routes.coinRecharge}';
    }
    if (type == 2) {
      bgImg = 'wd_fxyq_n';
      title = CommonUtils.txt('fxyqlhb');
      subTitle = CommonUtils.txt('yqhydvp');
      routeString = '/${Routes.kwantsharetousers}';
    }
    if (type == 3) {
      bgImg = 'wd_jbg_n';
      title = CommonUtils.txt('jbgm');
      subTitle = CommonUtils.txt('ye');
      routeString = '/${Routes.mineAgentPage}';
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.push(routeString);
      },
      child: Stack(
        children: [
          LImage(
            bgImg,
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 10.w,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    subTitle,
                    style: TextStyle(
                      color: Color.fromRGBO(246, 203, 163, 1),
                      fontSize: ScreenUtil().setSp(12),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  void onCreate() {
    // TODO: implement onCreate
    EventBus().on('need-update-login-state', (args) {
      if (args == 'login') {
        if (mounted) setState(() {});
        Member user = Provider.of<HomeConfig>(context, listen: false).member;
        if (user?.username?.isNotEmpty == true) {
          //开启IM
          IMChatManagerIO.instance().openSocket();
        }
      } else if (args == 'quit') {
        //关闭IM
        IMChatManagerIO.instance().activeClose();
      }
    });
    IMChatManagerIO.instance().wodeCall = () {
      dealRedShow();
    };
    dealRedShow();
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
                    top: kIsWeb
                        ? 10.w
                        : MediaQuery.of(context).padding.top + 5.w,
                    bottom: 10.w),
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
                                Expanded(child: setHeadInfo(isLogin, members)),
                              ],
                            ),
                            SizedBox(height: 10.w),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              child: Container(
                                height: ScreenUtil().setWidth(65),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    context.push(
                                        CommonUtils.getRealHash(Routes.vip));
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                          child: LImage(
                                        'qy_newyear_mine_vvp_bg',
                                        fit: BoxFit.fill,
                                      )),
                                      Positioned.fill(
                                        child: Builder(builder: (cx) {
                                          var subTitle = '';
                                          DateTime nowTime = new DateTime.now();
                                          String nowString =
                                              '${nowTime.year}-${nowTime.month}-${nowTime.day}';
                                          if (members?.vipLevel != null &&
                                              members.vipLevel > 0) {
                                            String tempTime = members?.expiredAt
                                                .toString()
                                                .split(' ')[0];
                                            if (tempTime == nowString) {
                                              subTitle = CommonUtils.txt('fhy');
                                            } else {
                                              subTitle = '$tempTime' +
                                                  CommonUtils.txt('dq');
                                            }
                                          } else {
                                            subTitle = CommonUtils.txt('fhy');
                                          }
                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    GQStyle.pagePadding),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    config.tips_share_text ??
                                                        CommonUtils.txt(
                                                            "cgyqsqt"),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                    )),
                                                SizedBox(height: 5.w),
                                                Row(
                                                  children: [
                                                    Text(
                                                      members.vip_str,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            246, 203, 163, 1.0),
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    Text(
                                                      subTitle,
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            246, 203, 163, 1.0),
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                    SizedBox(width: 5.w),
                                                    Text(
                                                      "${CommonUtils.txt('syxzcs')}${members.video_download_value}",
                                                      style: TextStyle(
                                                        color: Color.fromRGBO(
                                                            246, 203, 163, 1.0),
                                                        fontSize: ScreenUtil()
                                                            .setSp(12),
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                crossAxisCount: 3,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                crossAxisSpacing: ScreenUtil().setWidth(10),
                                childAspectRatio: 110 / 115,
                                children: [
                                  setCard(1, members),
                                  setCard(2, members),
                                  setCard(3, members),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.w),
                            Container(
                              height: 72.w,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(21, 21, 42, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.w))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              margin: EdgeInsets.symmetric(
                                  horizontal: GQStyle.pagePadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: mainMenuList.map((e) {
                                  return GestureDetector(
                                    onTap: () {
                                      context.push(e['router']);
                                    },
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          LImage(e['icon'],
                                              width: 30.w, height: 26.w),
                                          SizedBox(height: 6.w),
                                          Text(e['name'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14.sp))
                                        ]),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 10.w),
                            setHandleList(),
                            SizedBox(height: 15.w),
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
