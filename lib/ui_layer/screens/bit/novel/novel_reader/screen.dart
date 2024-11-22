import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../crypto.dart';
import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/novel/novel_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../di/notifier.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_panel.dart';
import 'widgets/web_text_empty.dart'
    if (dart.library.html) 'widgets/web_text.dart';

const _animationDuration = Duration(milliseconds: 150);

class NovelReaderScreen extends StatefulWidget {
  static const List<Color> bgColors = [
    Color.fromRGBO(217, 208, 40, 1),
    MyTheme.bgColor,
    Color.fromRGBO(232, 62, 204, 1),
    Color.fromRGBO(62, 116, 232, 1),
    Color.fromRGBO(195, 62, 232, 1),
  ];
  const NovelReaderScreen({super.key});

  @override
  State<NovelReaderScreen> createState() => _NovelReaderScreenState();
}

class _NovelReaderScreenState extends State<NovelReaderScreen>
    with TickerProviderStateMixin {
  late final novelChangeNotifier = context.read<NovelChangeNotifier>();
  late final novelData = novelChangeNotifier.currentNovel;

  late final panelAnimationController = AnimationController(
    duration: _animationDuration,
    value: 1.0,
    vsync: this,
  );

  late final novelPageController = PageController(
    initialPage: novelChangeNotifier.currentChapterIndex ?? 0,
  );

  void onTogglePanelVisibility() {
    if (panelAnimationController.status == AnimationStatus.reverse ||
        panelAnimationController.status == AnimationStatus.dismissed) {
      panelAnimationController.forward();
    } else {
      panelAnimationController.reverse();
    }
  }

  void nextChapter() {
    novelPageController.jumpToPage((novelPageController.page ?? 0).round() + 1);
  }

  void prevChapter() {
    novelPageController.jumpToPage((novelPageController.page ?? 0).round() - 1);
  }

  @override
  Widget build(BuildContext context) {
    final chapters = novelData.chapters;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: NovelAppBar(
        animationController: panelAnimationController,
        child: Selector<NovelChangeNotifier, int>(
          selector: (_, notifier) => notifier.currentChapterIndex ?? 0,
          builder: (_, index, __) {
            return Text(
              chapters[index].title ?? '',
              textAlign: TextAlign.center,
              style: MyTheme.white18mudium,
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: novelPageController,
            itemCount: chapters.length,
            onPageChanged: (index) {
              novelChangeNotifier.setCurrentChapterIndex(index);
            },
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              return chapter.txt.trim().isNotEmpty
                  ? NovelReader(
                      chapter: chapter,
                      onTogglePanelVisibility: onTogglePanelVisibility,
                    )
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTogglePanelVisibility,
                      child: PayView(
                        chapter: chapter,
                        onPaid: (txt) {
                          chapter.txt = txt;
                          setState(() {});
                        },
                      ),
                    );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomPanel(
              animationController: panelAnimationController,
              onNextChapter: nextChapter,
              onPrevChapter: prevChapter,
              onTapChapterIndex: novelPageController.jumpToPage,
            ),
          ),
        ],
      ),
    );
  }
}

class NovelReader extends StatefulWidget {
  const NovelReader(
      {super.key,
      required this.chapter,
      required this.onTogglePanelVisibility});
  final NovelChaptersModel chapter;
  final VoidCallback onTogglePanelVisibility;
  @override
  State<NovelReader> createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  AsyncValue<String> _asyncValue = const AsyncInit();

  late final appDomain = context.read<AppDomain>();
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    if (widget.chapter.text case final text? when text.isNotEmpty) {
      setState(() {
        _asyncValue = AsyncData(text);
      });
      return;
    }

    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final novelData =
        await appDomain.downloadDataByte(urlPath: widget.chapter.txt);
    final utf8Str = utf8.decode(novelData);

    final novelText = await PlatformAwareCrypto.decryptNovel(utf8Str);

    widget.chapter.text = novelText;
    _asyncValue = AsyncData(novelText);

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      orElse: () => const LoadingView(),
      data: (text) => Selector<NovelChangeNotifier, int>(
        builder: (_, bgIndex, __) {
          return ColoredBox(
            color: NovelReaderScreen.bgColors[bgIndex],
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: ScreenUtil().statusBarHeight + 44.w,
                bottom: ScreenUtil().bottomBarHeight + 150.w,
                left: MyTheme.pagePadding,
                right: MyTheme.pagePadding,
              ),
              child: Selector<NovelChangeNotifier, double>(
                builder: (_, fontSize, __) {
                  if (kIsWeb) {
                    return WebText(
                      text: text,
                      fontSize: fontSize.toInt(),
                      onTap: widget.onTogglePanelVisibility,
                    );
                  }
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onTogglePanelVisibility,
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  );
                },
                selector: (_, notifier) => notifier.fontSize,
              ),
            ),
          );
        },
        selector: (_, notifier) => notifier.bgColorIndex,
      ),
      error: (_, __) => NetworkErrorView(
        onTap: _getData,
      ),
    );
  }
}

class PayView extends StatelessWidget {
  const PayView({
    super.key,
    required this.chapter,
    required this.onPaid,
  });

  final NovelChaptersModel chapter;
  final ValueChanged<String> onPaid;

  @override
  Widget build(BuildContext context) {
    final payType = chapter.type;
    final coins = chapter.coins;
    final payTip = chapter.payTip ?? '';

    final userNotifier = context.read<UserNotifier>();
    final user = userNotifier.member;
    final money = user.money;
    final isInsufficient = money < coins;

    if (payType == 2) {
      return Align(
        alignment: const Alignment(0, -0.1),
        child: Container(
          padding: EdgeInsets.only(bottom: MyTheme.pagePadding * 2),
          margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MyImage.asset(
                MyImagePaths.appAlertPngN,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: 30.w),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'dqtjxhfajb'.tr(
                          namedArgs: {'amount': '$coins'}, context: context),
                      style: MyTheme.black16bold,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      "${'ktvpzk'.tr(context: context)}：$money",
                      style: MyTheme.black16bold,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MyButton.highEmphasis(
                        color: Colors.grey,
                        minimumSize: Size.fromHeight(35.w),
                        borderRadius: 40.w,
                        text: 'qx'.tr(context: context),
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: MyButton.gradient(
                        minimumSize: Size.fromHeight(35.w),
                        text: (isInsufficient ? 'qwcz' : 'gmgk')
                            .tr(context: context),
                        borderRadius: 40.w,
                        onPressed: () async {
                          if (isInsufficient) {
                            const CoinRechargeRoute().replace(context);
                          } else {
                            MyToast.showLoading(
                                text: 'gmzz'.tr(context: context));
                            final userNotifier = context.read<UserNotifier>();
                            final novelDomain = context.read<NovelDomain>();
                            final res =
                                await novelDomain.novelBuy(id: chapter.id ?? 0);
                            MyToast.closeAllLoading();
                            if (res.isValid) {
                              userNotifier.setMoney(money: money);
                              onPaid(res.data['txt'] ?? '');
                            } else {
                              MyToast.showText(text: res.msg ?? '');
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: const Alignment(0, -0.1),
      child: Container(
        padding: EdgeInsets.only(bottom: MyTheme.pagePadding * 2),
        margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyImage.asset(
              MyImagePaths.appAlertPngN,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 30.w),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
              child: Text(
                payTip.trim().isEmpty ? 'gmvkwz'.tr(context: context) : payTip,
                style: MyTheme.black16bold,
                maxLines: 10,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30.w),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: MyButton.highEmphasis(
                      color: Colors.grey,
                      minimumSize: Size.fromHeight(35.w),
                      borderRadius: 40.w,
                      text: 'zrwd'.tr(context: context),
                      onPressed: () {
                        const MineWelfareRoute(index: 1).replace(context);
                      },
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: MyButton.gradient(
                      minimumSize: Size.fromHeight(35.w),
                      text: 'cv'.tr(context: context),
                      borderRadius: 40.w,
                      onPressed: () {
                        const VipCenterRoute().replace(context);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
