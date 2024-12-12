import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;

import '../../app_config.dart';
import '../../domain/domain.dart';
import '../../domain/enum.dart';
import '../../domain/model/home_data_model.dart';
import '../notifiers/home_config_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../router/routes.dart';
import '../utils/common_utils.dart';
import '../utils/my_toast.dart';
import 'common_widgets/dialog/widgets/ad_dialog.dart';
import 'common_widgets/dialog/widgets/announcement_dialog.dart';
import 'common_widgets/dialog/widgets/app_down_center_dialog.dart';
import 'common_widgets/dialog/widgets/download_apk_dialog.dart';
import 'common_widgets/dialog/widgets/update_dialog.dart';
import 'common_widgets/link_text.dart';
import 'common_widgets/my_image.dart';
import 'common_widgets/pop_scope_wrapper.dart';
import 'common_widgets/status/loading.dart';
import 'image_paths.dart';
import 'theme.dart';

import 'package:universal_html/js.dart' as js;

class BottomNaviBar extends StatefulWidget {
  const BottomNaviBar({
    required this.navigationShell,
    super.key = const ValueKey<String>('ScaffoldWithNavBar'),
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNaviBar> createState() => _BottomNaviBarState();
}

class _BottomNaviBarState extends State<BottomNaviBar> {
  late final _userNotifier = context.read<UserNotifier>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final versionMsg = homeConfigNotifier.homeData.versionMsg;
  late final domain = context.read<AppDomain>();
  late final cache = domain.cache;
  MyTokenStatus? currentTokenStatus;

  bool _isInit = false;

  @override
  void initState() {
    _userNotifier.addListener(_userNotifierListener);
    _userNotifier.init();

    super.initState();
  }

  void _userNotifierListener() async {
    final status = _userNotifier.tokenStatus;
    if (currentTokenStatus != status) {
      currentTokenStatus = status;
      if (currentTokenStatus == MyTokenStatus.invalid) {
        MyToast.showText(text: 'dlsx'.tr());
        await _userNotifier.init();
        if (mounted) {
          const LoginRoute().push(context);
        }
      }
    }

    if (!_isInit && _userNotifier.isInit) {
      _isInit = true;
      _appStartCheck();
    }
  }

  Future<void> _appStartCheck() async {
    //打开的时候就清除一下缓存
    cache.clearImageCacheIfNeed();
    //处理剪贴板内容
    _getClipboardText();
    // 显示弹窗
    _showDialog();

    if (!kIsWeb) _initDownloadStatus();
  }

  // 初始化下载状态
  Future<void> _initDownloadStatus() async {
    if (await cache.readDownloadVideoTasks() case final tasks) {
      for (var task in tasks) {
        task['downloading'] = false;
        task['isWaiting'] = false;
      }
      await cache.upsertDownloadVideoTasks(tasks: tasks);
    }
  }

  Future<void> _getClipboardText() async {
    if (kIsWeb) {
      final uri = Uri.parse(html.window.location.href);
      final affCode = uri.queryParameters[BuildConfig.affCodeKey] ?? '';
      if (affCode.isNotEmpty) {
        domain.sendInvitation(affCode: affCode);
      }
    } else {
      final result = await Clipboard.getData(Clipboard.kTextPlain);
      if (result?.text?.split(':') case final clipTextList?
          when clipTextList.length > 1 &&
              clipTextList[0] == BuildConfig.affCodeKey) {
        if (clipTextList[1] case final affCode when affCode.isNotEmpty) {
          domain.sendInvitation(affCode: affCode);
        }
      }
    }
  }

  // 显示弹窗
  void _showDialog({int index = 0}) {
    if (homeConfigNotifier.homeData.popAds case final popAds
        when popAds.length > index) {
      final notice = popAds[index];
      final nextIndex = index + 1;

      ///fix toast cancelFunc bug
      bool isClosed = false;

      BotToast.showWidget(
        toastBuilder: (cancelFunc) => AdDialog(
          cancel: () {
            if (isClosed) return;
            isClosed = true;
            cancelFunc();
            _showDialog(index: nextIndex);
          },
          confirm: () {
            if (isClosed) return;
            isClosed = true;
            cancelFunc();
            _showDialog(index: nextIndex);
            _adOnTap(notice: notice);
          },
          adUrl: notice.imgUrl ?? '',
          adWidth: notice.width,
          adHeight: notice.height,
        ),
      );
    } else {
      _showAppUpdateDialogIfNeed();
    }
  }

  /// 检查更新
  Future<void> _showAppUpdateDialogIfNeed() async {
    bool needUpdate = false;
    if (versionMsg?.version case final targetVersion? when !kIsWeb) {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final currentNumber =
          int.tryParse(currentVersion.replaceAll('.', '')) ?? 0;
      final targetNumber = int.tryParse(targetVersion.replaceAll('.', '')) ?? 0;

      needUpdate = targetNumber > currentNumber;
    }

    if (needUpdate) {
      _showAppUpdateDialog();
    } else {
      _showAppDownCenterDialog();
    }
  }

  /// 更新公告弹窗
  void _showAppUpdateDialog() {
    final config = homeConfigNotifier.config;

    //强制更新
    final mustUpdate = versionMsg?.must == 1;

    BotToast.showWidget(
      toastBuilder: (cancelFunc) => UpdateDialog(
        cancel: mustUpdate
            ? null
            : () {
                cancelFunc();
                _showAppDownCenterDialog();
              },
        confirm: () {
          if (Platform.isAndroid) {
            cancelFunc();
            BotToast.showWidget(
              toastBuilder: (cancelFunc) => DownloadApkDialog(
                version: versionMsg?.version ?? '',
                url: versionMsg?.apk ?? '',
              ),
            );
          } else {
            CommonUtils.launchUrl(versionMsg?.apk ?? '');
          }
        },
        tips: versionMsg?.tips ?? '',
        officialWebUrl: config.officeSite ?? '',
        solution: config.solution ?? '',
      ),
    );
  }

  /// 活动弹窗点击事件
  void _adOnTap({Notice? notice}) {
    if (notice == null) return;
    final json = notice.toJson();
    json['link_url'] = json['url_str'];
    if (json['type'] == 'route') {
      json['redirect_type'] = '1';
    }
    CommonUtils.openRoute(context, json);
  }

  ///推荐app下载列表弹窗
  void _showAppDownCenterDialog() {
    final homeData = homeConfigNotifier.homeData;

    if (homeData.noticeApps?.isNotEmpty ?? false) {
      BotToast.showWidget(
          toastBuilder: (cancelFunc) => AppDownCenterDialog(
                cancel: () {
                  cancelFunc();
                  _showAnnouncementDialogIfNeed(); //app推荐下载弹窗展示完后再展示公告
                },
              ));
    } else {
      _showAnnouncementDialogIfNeed(); //app推荐为空直接展示公告
    }
  }

  /// 系统公告弹窗
  void _showAnnouncementDialogIfNeed() {
    if (versionMsg?.mstatus != 1) {
      return;
    }
    BotToast.showWidget(
      toastBuilder: (cancelFunc) => AnnouncementDialog(
        cancel: () {
          cancelFunc();
        },
        confirm: () {
          cancelFunc();
          const MineAgentRoute().push(context);
        },
        text: versionMsg?.message ?? '',
      ),
    );
  }

  //加载添加到主屏幕功能
  // void _addMainScreen() {
  //   if (!kIsWeb) return;
  //   final bool isInstall =
  //       (js.context.callMethod('getInstallValue') as String) == '1';
  //   final bool isSafari = js.context.callMethod('checkSafari') as bool;
  //   if (!isSafari && !isInstall) {
  //     showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(builder: (context, setBottomSheetState) {
  //           return Container(
  //             padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
  //             decoration: BoxDecoration(
  //               color: MyTheme.blackColor49,
  //               borderRadius: BorderRadius.only(
  //                   topRight: Radius.circular(5.w),
  //                   topLeft: Radius.circular(5.w)),
  //             ),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(height: 20.w),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     SizedBox(width: 20.w, height: 20.w),
  //                     Text(
  //                       'tjwberk'.tr(),
  //                       style: MyTheme.white14,
  //                     ),
  //                     GestureDetector(
  //                       behavior: HitTestBehavior.translucent,
  //                       onTap: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: Icon(
  //                         Icons.close,
  //                         size: 20.w,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 30.w),
  //                 LinkText(
  //                   'tjwbdes'.tr(namedArgs: {
  //                     'url': html.window.location.href,
  //                   }),
  //                   textStyle: MyTheme.red12,
  //                   linkStyle: TextStyle(
  //                     color: const Color.fromRGBO(25, 103, 210, 1),
  //                     fontSize: 12.sp,
  //                   ),
  //                 ),
  //                 SizedBox(height: 20.w),
  //                 GestureDetector(
  //                   behavior: HitTestBehavior.translucent,
  //                   onTap: () {
  //                     final bool isDeferredNotNull =
  //                         js.context.callMethod('isDeferredNotNull') as bool;
  //                     if (isDeferredNotNull) {
  //                       js.context.callMethod('presentAddToHome');
  //                     } else {
  //                       MyToast.showText(text: 'tjpjg'.tr(), time: 2);
  //                     }
  //                   },
  //                   child: Container(
  //                     decoration: BoxDecoration(
  //                         gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
  //                         borderRadius: BorderRadius.all(Radius.circular(3.w))),
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
  //                     height: 32.w,
  //                     alignment: Alignment.center,
  //                     child: Text('tjwbzpm'.tr(), style: MyTheme.white13),
  //                   ),
  //                 ),
  //                 SizedBox(height: 30.w),
  //               ],
  //             ),
  //           );
  //         });
  //       },
  //     );
  //   }
  // }

  @override
  void dispose() {
    _userNotifier.removeListener(_userNotifierListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<UserNotifier, bool>(
      builder: (_, isInit, child) {
        if (!isInit) {
          return const PopScopeWrapper(
            child: Scaffold(
              body: LoadingView(),
            ),
          );
        }
        return child!;
      },
      child: PopScopeWrapper(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: widget.navigationShell,
          bottomNavigationBar: DecoratedBox(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(39, 39, 39, 1),
                    spreadRadius: 0.0,
                    offset: Offset(0.0, -0.5),
                    blurRadius: 0.0),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Selector<UserNotifier, MyTokenStatus?>(
                  selector: (_, userNotifier) => userNotifier.tokenStatus,
                  builder: (context, tokenStatus, child) => tokenStatus ==
                          MyTokenStatus.valid
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () => const LoginRoute().push(context),
                          child: Container(
                            color: const Color(0x66ff0000),
                            padding: EdgeInsets.symmetric(
                              vertical: 5.w,
                              horizontal: 13.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'czts'.tr(context: context),
                                  style: MyTheme.white11medium,
                                ),
                                MyImage.asset(
                                  MyImagePaths.appOriginalArrowRight,
                                  width: 10.w,
                                  height: 10.w,
                                )
                              ],
                            ),
                          ),
                        ),
                ),
                BottomNavigationBar(
                  backgroundColor: MyTheme.bgColor,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 11.sp,
                  unselectedFontSize: 11.sp,
                  unselectedItemColor: const Color.fromRGBO(149, 148, 156, 1),
                  selectedItemColor: Colors.white,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabHomeN),
                      activeIcon: const _Icon(MyImagePaths.appTabHomeS),
                      label: 'sy'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabAreaN),
                      activeIcon: const _Icon(MyImagePaths.appTabAreaS),
                      label: 'jq'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabCircleN),
                      activeIcon: const _Icon(MyImagePaths.appTabCircleS),
                      label: 'qz'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabShequN),
                      activeIcon: const _Icon(MyImagePaths.appTabShequS),
                      label: 'ym'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabDownloadN),
                      activeIcon: const _Icon(MyImagePaths.appTabDownloadS),
                      label: 'xz'.tr(context: context),
                    ),
                    BottomNavigationBarItem(
                      icon: const _Icon(MyImagePaths.appTabWodeN),
                      activeIcon: const _Icon(MyImagePaths.appTabWodeS),
                      label: 'wd'.tr(context: context),
                    ),
                  ],
                  currentIndex: widget.navigationShell.currentIndex,
                  onTap: _goBranch,
                ),
              ],
            ),
          ),
        ),
      ),
      selector: (_, userNotifier) => userNotifier.isInit,
    );
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }
}

class _Icon extends StatelessWidget {
  const _Icon(this.path);

  final String path;
  @override
  Widget build(BuildContext context) {
    final size = 23.w;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: MyImage.asset(
        path,
        width: size,
        height: size,
      ),
    );
  }
}
