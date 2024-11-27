import 'dart:io';

import 'package:android_dynamic_icon/android_dynamic_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/type_def.dart';
import '../../../domain/enum.dart';
import '../../../domain/model/member_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../common_widgets/dialog/my_dialog.dart';
import '../common_widgets/dialog/widgets/png_dialog.dart';
import '../common_widgets/localization_text.dart';
import '../common_widgets/member_vip.dart';
import '../common_widgets/my_avatar.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/screen_background.dart';
import '../image_paths.dart';
import '../theme.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // SizedBox(
            //   height: 1.sw * 228 / 380,
            //   child: const MyImage.asset(
            //     MyImagePaths.appWdTopbgN,
            //     fit: BoxFit.fill,
            //     height: double.infinity,
            //     width: double.infinity,
            //   ),
            // ),
            Column(
              children: [
                const _FixedTopArea(),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: [
                      MyIndicator(onRefresh: () async {
                        await context.read<UserNotifier>().init();
                      }),
                      const SliverToBoxAdapter(
                        child: _Body(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class _FixedTopArea extends StatelessWidget {
  const _FixedTopArea();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: MyTheme.pagePadding, bottom: 11.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _SystemNoticeIcon(),
          SizedBox(width: 20.w),
          GestureDetector(
            onTap: () => const MineSetupRoute().push(context),
            child: MyImage.asset(
              MyImagePaths.appMineSetting,
              width: 25.w,
              fit: BoxFit.fitWidth,
            ),
          )
        ],
      ),
    );
  }
}

class _SystemNoticeIcon extends StatelessWidget {
  const _SystemNoticeIcon();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        const MessageCenterRoute().push(context);
      },
      child: Selector<UserNotifier, bool>(
          selector: (_, notifier) => (notifier.systemNotice != null &&
              (notifier.systemNotice?.systemNoticeCount != 0 ||
                  notifier.systemNotice?.feedCount != 0)),
          builder: (context, value, _) {
            return value
                ? MyImage.asset(
                    MyImagePaths.appMineMessageHighlight,
                    width: 25.w,
                    fit: BoxFit.fitWidth,
                  )
                : MyImage.asset(
                    MyImagePaths.appMineMessage,
                    width: 25.w,
                    fit: BoxFit.fitWidth,
                  );
          }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _HeaderInfo(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Column(
            children: [
              SizedBox(height: 20.w),
              const _VIPCenter(),
              SizedBox(height: 15.w),
              const _FirstMenu(),
              (kIsWeb || !Platform.isAndroid)
                  ? SizedBox(
                      height: 15.w,
                    )
                  : const _ChangeAppIconView(),
              const _SecondMenu(),
              SizedBox(height: 15.w),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, Member>(
      selector: (_, config) => config.member,
      builder: (context, member, child) => Padding(
        padding: EdgeInsets.only(left: MyTheme.pagePadding),
        child: Row(
          children: [
            MyAvatar(
              thumb: member.thumb,
              margin: 2,
              size: 56.w,
            ),
            SizedBox(width: 5.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      member.nickname,
                      style: MyTheme.white18bold,
                    ),
                    SizedBox(height: 2.w),
                    if (member.agent == 1)
                      Icon(
                        Icons.verified_sharp,
                        size: 17.w,
                        color: const Color.fromRGBO(247, 208, 93, 1),
                      ),
                    if (member.vipUpgrade == 1)
                      Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: GestureDetector(
                          onTap: () {
                            const VipUpgradeRoute().push(context);
                          },
                          child: const MyImage.asset(MyImagePaths.appVipUpgrade,
                              width: 65, height: 22),
                        ),
                      )
                  ],
                ),
                SizedBox(height: 9.5.w),
                Row(
                  children: [
                    if (member.vipLevel.isVip())
                      Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: MemberVipWidget(
                          showText: member.vipStr,
                        ),
                      ),
                    Text(
                      'ID: ${member.aff ?? '0000000'}',
                      style: MyTheme.gray95_12,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Selector<UserNotifier, MyTokenStatus?>(
              selector: (_, userNotifier) => userNotifier.tokenStatus,
              builder: (context, tokenStatus, child) => tokenStatus ==
                      MyTokenStatus.valid
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () => const LoginRoute().push(context),
                      child: Container(
                        width: 70.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(35, 38, 46, 1),
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
                                tr('dl'),
                                style: TextStyle(
                                  color: const Color.fromRGBO(250, 207, 135, 1),
                                  fontSize: 14.w,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14.w,
                                color: const Color.fromRGBO(250, 207, 135, 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class _VIPCenter extends StatefulWidget {
  const _VIPCenter();

  @override
  State<_VIPCenter> createState() => _VIPCenterState();
}

class _VIPCenterState extends State<_VIPCenter> {
  late final config = context.read<HomeConfigNotifier>().config;

  /// 当前日期
  String time = DateFormat('yyyy-MM-dd').format(DateTime.now());

  /// 取得副标题
  String getSubTitle({String? expiredAt, required bool isVIP}) {
    if (isVIP) {
      String expiredDate = expiredAt?.split(' ')[0] ?? '';
      if (expiredDate.isEmpty) {
        return tr('fhy');
      } else {
        return (expiredDate == time) ? tr('fhy') : expiredDate + tr('dq');
      }
    } else {
      return tr('fhy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.w,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => const VipCenterRoute().push(context),
        child: Stack(
          children: [
            const Positioned.fill(
              child: MyImage.asset(
                MyImagePaths.appVipBannerBackground,
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: Selector<UserNotifier, Member>(
                  selector: (_, userNotifier) => userNotifier.member,
                  builder: (context, member, child) {
                    final subTitle = getSubTitle(
                        expiredAt: member.expiredAt,
                        isVIP: member.vipLevel.isVip());

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.tipsShareText ??
                              'cgyqsqt'.tr(context: context),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.w),
                        Row(
                          children: [
                            Text(
                              member.vipStr,
                              style: TextStyle(
                                color: const Color.fromRGBO(246, 203, 163, 1.0),
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                            ),
                            Text(
                              subTitle,
                              style: TextStyle(
                                color: const Color.fromRGBO(246, 203, 163, 1.0),
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              "${'syxzcs'.tr(context: context)}${member.videoDownloadValue}",
                              style: TextStyle(
                                color: const Color.fromRGBO(246, 203, 163, 1.0),
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FirstMenu extends StatelessWidget {
  const _FirstMenu();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 10.w,
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: false,
      children: [
        Selector<UserNotifier, int>(
            selector: (_, config) => config.member.money,
            builder: (context, money, child) {
              return _FirstMenuCard(
                backgroundImg: MyImagePaths.appMineCoinChargeBackground,
                title: 'jbcz'.tr(context: context),
                subTitle: "${'dqye'.tr(context: context)} $money",
                onTap: () => const CoinRechargeRoute().push(context),
              );
            }),
        _FirstMenuCard(
          backgroundImg: MyImagePaths.appMineShareBackground,
          title: 'fxyqlhb'.tr(context: context),
          subTitle: 'yqhydvp'.tr(context: context),
          onTap: () => const MineShareToUserRoute().push(context),
        ),
        _FirstMenuCard(
          backgroundImg: MyImagePaths.appMineWelfareBackground,
          title: 'jbgm'.tr(context: context),
          subTitle: 'ye'.tr(context: context),
          onTap: () => const MineWelfareRoute().push(context),
        ),
      ],
    );
  }
}

class _FirstMenuCard extends StatelessWidget {
  const _FirstMenuCard({
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.backgroundImg,
  });
  final VoidCallback onTap;
  final String title;
  final String subTitle;
  final String backgroundImg;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Stack(
        children: [
          MyImage.asset(
            backgroundImg,
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
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: 5.w),
                Text(
                  subTitle,
                  style: TextStyle(
                    color: const Color.fromRGBO(246, 203, 163, 1),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SecondMenu extends StatelessWidget {
  const _SecondMenu();

  @override
  Widget build(BuildContext context) {
    final menu = [
      (
        title: 'wdtz'.tr(context: context),
        iconName: MyImagePaths.appMinePost,
        onTap: () => const MinePostRoute().push(context),
      ),
      (
        title: 'wdsc'.tr(context: context),
        iconName: MyImagePaths.appMineCollect,
        onTap: () => const MineCollectionRoute().push(context),
      ),
      (
        title: 'wdgz'.tr(context: context),
        iconName: MyImagePaths.appMineFansFollow,
        onTap: () => const MineFollowingRoute().push(context),
      ),
      (
        title: 'ycrz'.tr(context: context),
        iconName: MyImagePaths.appMineOriginalEnter,
        onTap: () => const OriginalEnterRoute().push(context),
      ),
      (
        title: 'wdgm'.tr(context: context),
        iconName: MyImagePaths.appMineBuy,
        onTap: () => const MineBuyRoute().push(context),
      ),
      (
        title: 'wdqy'.tr(context: context),
        iconName: MyImagePaths.appMineAi,
        onTap: () => const MineAIRecordRoute().push(context),
      ),
      (
        title: 'zxhc'.tr(context: context),
        iconName: MyImagePaths.appMineDownload,
        onTap: () => const MineDownloadRoute().push(context),
      ),
      (
        title: 'txyqm'.tr(context: context),
        iconName: MyImagePaths.appMineInvitedCode,
        onTap: () =>
            MineFillCodeRoute('yqm'.tr(context: context)).push(context),
      ),
      (
        title: 'txdhm'.tr(context: context),
        iconName: MyImagePaths.appMineRedeemCode,
        onTap: () =>
            MineFillCodeRoute('dhm'.tr(context: context)).push(context),
      ),
      (
        title: 'cjwt'.tr(context: context),
        iconName: MyImagePaths.appMineHelp,
        onTap: () => const MineHelpRoute().push(context),
      ),
      (
        title: 'gfjlq'.tr(context: context),
        iconName: MyImagePaths.appMineGroup,
        onTap: () => const MineOfficialGroupRoute().push(context),
      ),
    ];

    return Container(
        decoration: const BoxDecoration(
          color: MyTheme.white008Color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13 / 2),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          childAspectRatio: 1,
          children: [
            for (final data in menu)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: data.onTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyImage.asset(
                      data.iconName,
                      width: 25.w,
                      height: 25.w,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.title,
                      style: const TextStyle(
                        fontSize: 12,
                        color: MyTheme.white07Color,
                      ),
                    )
                  ],
                ),
              )
          ],
        ));
  }
}

class _ChangeAppIconView extends StatefulWidget {
  const _ChangeAppIconView({super.key});

  @override
  State<_ChangeAppIconView> createState() => _ChangeAppIconViewState();
}

class _ChangeAppIconViewState extends State<_ChangeAppIconView> {
  final icons = [
    'default',
    'wesee',
    'tiktok',
    'tieba',
    'taobao',
    'rednote',
    'meituan',
    'iqiyi'
  ];
  final _androidDynamicIconPlugin = AndroidDynamicIcon();

  @override
  void initState() {
    AndroidDynamicIcon.initialize(classNames: icons);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MyTheme.white008Color,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      margin: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Text(
                '设置桌面图标',
                style: MyTheme.white15,
              ),
            ),
            SizedBox(
              height: 8.w,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final name in icons)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        MyDialog.showDialog(
                          context: context,
                          child: PNGDialog(
                              title: 'ts'.tr(context: context),
                              buttonText: 'qr'.tr(context: context),
                              cancelText: 'qx'.tr(context: context),
                              confirmOnTap: () {
                                _androidDynamicIconPlugin
                                    .changeIcon(classNames: [name, '']);
                              },
                              content: DefaultTextStyle(
                                style: MyTheme.white233_14,
                                child: Column(
                                  children: [
                                    Text(
                                      'ggsxxdsm'.tr(
                                        context: context,
                                      ),
                                    ),
                                    Text(
                                      'qrggtb'.tr(context: context, namedArgs: {
                                        'name':
                                            (name == 'default' ? 'yybt' : name)
                                                .tr(context: context)
                                      }),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MyTheme.pagePadding),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/app_icons/$name.png',
                              width: 45.w,
                              height: 45.w,
                            ),
                            SizedBox(height: 5.w),
                            LocalizationText(
                              name == 'default' ? 'yybt' : name,
                              style: MyTheme.white14,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
