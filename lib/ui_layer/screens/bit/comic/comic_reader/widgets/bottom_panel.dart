import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common_widgets/localization_text.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../../di/notifier.dart';
import '../../sheets/comic_chapters_sheet.dart';
import '../controller/chapter_reader_controller.dart';
import 'my_thumb.dart';

const _animationDuration = Duration(milliseconds: 150);

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    super.key,
    required this.animationController,
    required this.chapterController,
    required this.onTapChapterIndex,
    required this.onNextChapter,
    required this.onPrevChapter,
  });

  final AnimationController animationController;
  final ChapterReaderController chapterController;
  final ValueChanged<int> onTapChapterIndex;
  final VoidCallback onNextChapter;
  final VoidCallback onPrevChapter;

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel>
    with TickerProviderStateMixin {
  bool _isSelected = false;

  ChapterReaderController get chapterController => widget.chapterController;

  ValueNotifier<(int, int)> get progressNotifier =>
      chapterController.progressNotifier;

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ComicChaptersSheetView(
          chapters: context.read<ComicChangeNotifier>().currentComic.chapters,
          onTapChapterIndex: widget.onTapChapterIndex,
        );
      },
    );
  }

  void toggleProgressBar() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_isSelected)
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: toggleProgressBar,
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: const Offset(0.0, 0.0),
            ).animate(CurvedAnimation(
              parent: widget.animationController,
              curve: Curves.ease,
            )),
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSize(
                      duration: _animationDuration,
                      curve: Curves.ease,
                      child: SizedBox(
                        height: _isSelected ? 40.w : 0.0,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Row(
                              children: [
                                Selector<ComicChangeNotifier, bool>(
                                  builder: (_, canPrev, __) {
                                    if (canPrev) {
                                      return GestureDetector(
                                        onTap: widget.onPrevChapter,
                                        child: MyImage.asset(
                                          MyImagePaths.appPrevIcon,
                                          width: 25.w,
                                          height: 25.w,
                                        ),
                                      );
                                    }
                                    return ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.2),
                                          BlendMode.srcIn),
                                      child: MyImage.asset(
                                        MyImagePaths.appPrevIcon,
                                        width: 25.w,
                                        height: 25.w,
                                      ),
                                    );
                                  },
                                  selector: (_, notifier) =>
                                      notifier.currentChapterIndex != 0,
                                ),
                                Expanded(
                                  child: _isSelected
                                      ? SliderTheme(
                                          data: SliderThemeData(
                                            thumbColor: Colors.white,
                                            trackHeight: 2.w,
                                            showValueIndicator:
                                                ShowValueIndicator.never,
                                            activeTrackColor: Colors.white,
                                            inactiveTrackColor:
                                                Colors.white.withOpacity(0.1),
                                            // thumbShape: RoundSliderThumbShape(),
                                            thumbShape: MyThumb(
                                              progressNotifier:
                                                  progressNotifier,
                                            ),
                                          ),
                                          child: ValueListenableBuilder(
                                            valueListenable: progressNotifier,
                                            builder: (_, value, __) {
                                              if (value.$2 == 0) {
                                                return const SizedBox();
                                              }
                                              return Slider(
                                                  min: 1,
                                                  value: value.$1.toDouble(),
                                                  max: value.$2.toDouble(),
                                                  onChanged: (newValue) {
                                                    chapterController.jumpToPic(
                                                        newValue.toInt());
                                                  });
                                            },
                                          ),
                                        )
                                      : const SizedBox(),
                                ),
                                Selector<ComicChangeNotifier, bool>(
                                  builder: (_, canPrev, __) {
                                    if (canPrev) {
                                      return GestureDetector(
                                        onTap: widget.onNextChapter,
                                        child: MyImage.asset(
                                          MyImagePaths.appNextIcon,
                                          width: 25.w,
                                          height: 25.w,
                                        ),
                                      );
                                    }
                                    return ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.2),
                                          BlendMode.srcIn),
                                      child: MyImage.asset(
                                        MyImagePaths.appNextIcon,
                                        width: 25.w,
                                        height: 25.w,
                                      ),
                                    );
                                  },
                                  selector: (_, notifier) =>
                                      notifier.currentChapterIndex !=
                                      notifier.currentComic.chapters.length - 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomPanelItem(
                            title: 'ml',
                            child: const Padding(
                              padding: EdgeInsets.all(3),
                              child: MyImage.asset(
                                MyImagePaths.appReaderMenu,
                              ),
                            ),
                            onTap: () {
                              showBottomSheet(context);
                            },
                          ),
                          _BottomPanelItem(
                            title: 'jd',
                            onTap: toggleProgressBar,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: ValueListenableBuilder(
                                valueListenable: progressNotifier,
                                builder: (_, value, __) {
                                  final progress =
                                      value.$2 == 0 ? 0.0 : value.$1 / value.$2;
                                  return CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    backgroundColor: Colors.white,
                                    value: progress,
                                  );
                                },
                              ),
                            ),
                          ),
                          _BottomPanelItem(
                            title: 'zdbf',
                            child: ValueListenableBuilder(
                              valueListenable:
                                  widget.chapterController.isPlayingNotifier,
                              builder: (_, isPlaying, __) {
                                return Icon(
                                  isPlaying
                                      ? Icons.pause_circle_outline
                                      : Icons.play_circle_outline_sharp,
                                  color: Colors.white,
                                  size: 28.w,
                                );
                              },
                            ),
                            onTap: () {
                              if (!widget.chapterController.isInit) return;
                              final isPlaying = widget
                                  .chapterController.isPlayingNotifier.value;
                              if (isPlaying) {
                                widget.chapterController.pause();
                              } else {
                                if (widget.chapterController.checkIsEnded())
                                  return;
                                widget.chapterController.play();
                                widget.animationController.reverse();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BottomPanelItem extends StatelessWidget {
  const _BottomPanelItem({
    required this.title,
    this.onTap,
    required this.child,
  });
  final String title;
  final VoidCallback? onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30.w,
            height: 30.w,
            child: child,
          ),
          SizedBox(height: 1.w),
          LocalizationText(
            title,
            style: MyTheme.white11,
          ),
        ],
      ),
    );
  }
}
