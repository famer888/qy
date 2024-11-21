import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/async_value.dart';
import '../../../../../../domain/model/comic/comic_model.dart';
import '../../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../common_widgets/localization_text.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/status/loading.dart';
import '../../../../common_widgets/status/network_error.dart';
import '../../../../theme.dart';
import '../controller/chapter_reader_controller.dart';

class ChapterReader extends StatefulWidget {
  const ChapterReader({
    super.key,
    required this.chapter,
    required this.onTogglePanelVisibility,
    required this.animationController,
    required this.chapterController,
    required this.onNextChapter,
    required this.isLatest,
    required this.isFirst,
  });
  final ComicChapterModel chapter;
  final VoidCallback onTogglePanelVisibility;
  final AnimationController animationController;
  final ChapterReaderController chapterController;
  final VoidCallback onNextChapter;
  final bool isLatest;
  final bool isFirst;

  @override
  State<ChapterReader> createState() => _ChapterReaderState();
}

class _ChapterReaderState extends State<ChapterReader> {
  late final _domain = context.read<ComicDomain>();
  AsyncValue<List<ComicChapterPicModel>> _asyncValue = const AsyncInit();
  bool isScrolling = false;
  ChapterReaderController get chapterController => widget.chapterController;

  late final headerWidgetHeight =
      widget.isFirst ? ScreenUtil().statusBarHeight + 80.w : 0.0;

  late final footerWidgetHeight =
      widget.isLatest ? ScreenUtil().bottomBarHeight + 100.w : 0.0;

  late final scrollController = ScrollController(
    initialScrollOffset: headerWidgetHeight,
  );

  double get picsHeight => chapterController.picsHeight;

  ValueNotifier<(int, int)> get progressNotifier =>
      chapterController.progressNotifier;

  ValueNotifier<bool> get isPlayingNotifier =>
      chapterController.isPlayingNotifier;

  List<int> _picHeights = [];

  @override
  void initState() {
    widget.chapterController.setScrollController(scrollController);
    _getData();
    super.initState();
  }

  _getData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      chapterController.progressNotifier.value = (0, 0);
    });

    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    List<ComicChapterPicModel>? chapterPics;

    if (widget.chapter.pics == null) {
      final result =
          await _domain.comicChapterDetail(id: widget.chapter.id ?? 0);
      chapterPics = result.data?.pics;
      widget.chapter.pics = chapterPics;
    } else {
      chapterPics = widget.chapter.pics;
    }

    if (chapterPics case final pics?) {
      double maxH = 0;
      List<int> picHeights = [];

      for (final pic in pics) {
        final picH = (1.sw / (pic.thumbW / pic.thumbH)).toInt();
        picHeights.add(picH);
        maxH += picH;
      }
      final picsHeight = maxH - 1.sh + headerWidgetHeight + footerWidgetHeight;

      chapterController.setPicsHeight(picsHeight);
      chapterController.setPicHeight(picsHeight / (pics.length - 1));
      _picHeights = picHeights;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        progressNotifier.value = (1, pics.length);
      });
      _asyncValue = AsyncData(pics);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Timer? scrollEndTimer;

  final menuController = MenuController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      orElse: () => const LoadingView(),
      error: (_, __) => NetworkErrorView(onTap: _getData),
      data: (pics) {
        return Stack(
          fit: StackFit.expand,
          children: [
            buildReader(pics),
            buildControlPanel(),
            buildSpeedPanel(),
          ],
        );
      },
    );
  }

  Widget buildReader(List<ComicChapterPicModel> pics) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        switch (scrollInfo.runtimeType) {
          case const (ScrollStartNotification):
            isScrolling = true;
            scrollEndTimer?.cancel();
            break;
          case const (ScrollUpdateNotification):
            chapterController.updateProgress();
            break;
          case const (ScrollEndNotification):
            if (isPlayingNotifier.value) {
              widget.onTogglePanelVisibility();
              isPlayingNotifier.value = false;
            }
            scrollEndTimer = Timer(const Duration(milliseconds: 250), () {
              isScrolling = false;
            });
        }
        return true;
      },
      child: CustomScrollView(
        controller: scrollController,
        cacheExtent: 2.sh,
        slivers: [
          if (widget.isFirst)
            SliverToBoxAdapter(
              child: Container(
                height: headerWidgetHeight,
                color: Colors.black,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 10.w),
                child: LocalizationText(
                  'qmmyl',
                  style: MyTheme.white16bold,
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: _picHeights.length,
              (_, i) {
                final pic = pics[i];
                return SizedBox(
                  height: _picHeights[i].toDouble(),
                  child: MyImage.network(pic.thumb),
                );
              },
            ),
          ),
          if (widget.isLatest)
            SliverToBoxAdapter(
              child: Container(
                height: footerWidgetHeight,
                color: Colors.black,
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(top: 10.w),
                child: LocalizationText(
                  'nyjdw',
                  style: MyTheme.white16bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildControlPanel() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (!isScrolling) {
                chapterController.tapPrev();
              }
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(onTap: () {
            if (!isScrolling) {
              widget.onTogglePanelVisibility();
            }
          }),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (!isScrolling) {
                if (chapterController.checkIsEnded()) {
                  widget.onNextChapter();
                } else {
                  chapterController.tapNext();
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildSpeedPanel() {
    return ValueListenableBuilder(
      valueListenable: isPlayingNotifier,
      builder: (context, isPlaying, _) {
        final speeds = chapterController.speeds;
        final currentSpeedIndexNotifier =
            chapterController.currentSpeedIndexNotifier;

        if (!isPlaying) {
          return const SizedBox();
        }
        return Align(
          alignment: const Alignment(0.0, 0.8),
          child: MenuAnchor(
            alignmentOffset: Offset(70.w, 5.w),
            controller: menuController,
            style: MenuStyle(
              backgroundColor:
                  WidgetStatePropertyAll(Colors.black.withOpacity(0.7)),
            ),
            menuChildren: [
              Center(
                child: LocalizationText(
                  'sd',
                  style: MyTheme.white12,
                ),
              ),
              for (var i = 0; i < speeds.length; i++)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    currentSpeedIndexNotifier.value = i;
                    chapterController.play();
                    menuController.close();
                  },
                  child: Container(
                    width: 70.w,
                    padding: EdgeInsets.all(5.w),
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                        valueListenable: currentSpeedIndexNotifier,
                        builder: (_, index, __) {
                          return Row(
                            children: [
                              Text(
                                '${speeds[i]}x',
                                style: MyTheme.white12,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              if (index == i)
                                Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                  size: 18.w,
                                ),
                            ],
                          );
                        }),
                  ),
                ),
            ],
            builder: (_, MenuController controller, Widget? child) {
              return GestureDetector(
                onTap: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: ValueListenableBuilder(
                      valueListenable: currentSpeedIndexNotifier,
                      builder: (context, index, _) {
                        return Text(
                          '${'zdydz'.tr()}  ${speeds[index]}x',
                          style: MyTheme.white14,
                        );
                      }),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
