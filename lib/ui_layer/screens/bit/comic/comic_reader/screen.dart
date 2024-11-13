import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/model/comic/comic_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../di/notifier.dart';
import 'controller/chapter_reader_controller.dart';
import 'widgets/app_bar.dart';
import 'widgets/bottom_panel.dart';
import 'widgets/reader.dart';

const _animationDuration = Duration(milliseconds: 150);

///漫画阅读界面
class ComicReaderScreen extends StatefulWidget {
  const ComicReaderScreen({
    super.key,
  });

  @override
  State<ComicReaderScreen> createState() => _ComicReaderScreenState();
}

class _ComicReaderScreenState extends State<ComicReaderScreen>
    with TickerProviderStateMixin {
  late final comicChangeNotifier = context.read<ComicChangeNotifier>();
  late final comicData = comicChangeNotifier.currentComic;
  late final panelAnimationController = AnimationController(
    duration: _animationDuration,
    value: 1.0,
    vsync: this,
  );

  late final comicPageController = PageController(
    initialPage: comicChangeNotifier.currentChapterIndex,
  );

  final chapterController = ChapterReaderController();

  void onTogglePanelVisibility() {
    if (panelAnimationController.status == AnimationStatus.reverse ||
        panelAnimationController.status == AnimationStatus.dismissed) {
      panelAnimationController.forward();
    } else {
      panelAnimationController.reverse();
    }
  }

  void nextChapter() {
    comicPageController.nextPage(
      duration: _animationDuration,
      curve: Curves.linear,
    );
  }

  void prevChapter() {
    comicPageController.previousPage(
      duration: _animationDuration,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapters = comicData.chapters;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ComicAppBar(
        animationController: panelAnimationController,
        child: Row(
          children: [
            Selector<ComicChangeNotifier, int>(
              selector: (_, notifier) => notifier.currentChapterIndex,
              builder: (_, index, __) {
                return Flexible(
                  child: Text(
                    chapters[index].title ?? '',
                    style: MyTheme.white18mudium,
                  ),
                );
              },
            ),
            SizedBox(width: 5.w),
            ValueListenableBuilder(
              valueListenable: chapterController.progressNotifier,
              builder: (_, value, __) {
                if (value.$2 == 0) {
                  return const SizedBox();
                }
                return Text(
                  '${value.$1}/${value.$2}',
                  style: MyTheme.white07_12,
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: comicPageController,
            itemCount: chapters.length,
            onPageChanged: (index) {
              chapterController.progressNotifier.value = (0, 0);
              comicChangeNotifier.setCurrentChapterIndex(index);
            },
            itemBuilder: (context, index) {
              final chapter = chapters[index];
              final isPay = chapter.isPay == 1;
              if (!isPay) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onTogglePanelVisibility,
                  child: PayView(
                    chapter: chapter,
                    chapterIndex: index,
                    onPaid: () {
                      chapter.isPay = 1;
                      setState(() {});
                    },
                  ),
                );
              }

              final isFirst = index == 0;
              final isLatest = index == chapters.length - 1;
              return ChapterReader(
                animationController: panelAnimationController,
                id: chapter.id ?? 0,
                onTogglePanelVisibility: onTogglePanelVisibility,
                chapterController: chapterController,
                isFirst: isFirst,
                isLatest: isLatest,
                onNextChapter: () {
                  if (isLatest) return;
                  nextChapter();
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomPanel(
              animationController: panelAnimationController,
              chapterController: chapterController,
              onTapChapterIndex: comicPageController.jumpToPage,
              onNextChapter: nextChapter,
              onPrevChapter: prevChapter,
            ),
          ),
        ],
      ),
    );
  }
}

class PayView extends StatelessWidget {
  const PayView({
    super.key,
    required this.chapter,
    required this.chapterIndex,
    required this.onPaid,
  });

  final ComicChapterModel chapter;
  final int chapterIndex;
  final VoidCallback onPaid;

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
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
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
                      'dqtjxhfajb'
                          .tr(namedArgs: {'amount': '1'}, context: context),
                      style: MyTheme.white16medium,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.w),
                    Text(
                      "${'ktvpzk'.tr(context: context)}：$money",
                      style: MyTheme.white16medium,
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
                            final comicDomain = context.read<ComicDomain>();
                            final res =
                                await comicDomain.comicBuy(id: chapter.id ?? 0);
                            MyToast.closeAllLoading();
                            if (res.isValid) {
                              userNotifier.setMoney(money: money);
                              onPaid();
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
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding * 2),
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
                style: MyTheme.white16medium,
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
