import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../theme.dart';
import '../widgets/di/notifier.dart';
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
            onPageChanged: comicChangeNotifier.setCurrentChapterIndex,
            itemBuilder: (_, index) {
              final chapter = comicData.chapters[index];
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
