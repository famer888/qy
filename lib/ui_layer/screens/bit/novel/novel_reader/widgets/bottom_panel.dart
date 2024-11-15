import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../router/routes.dart';
import '../../../../common_widgets/localization_text.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../../di/notifier.dart';
import '../../sheets/chapters_sheet.dart';
import '../screen.dart';

class BottomPanel extends StatefulWidget {
  const BottomPanel({
    super.key,
    required this.animationController,
    required this.onTapChapterIndex,
    required this.onNextChapter,
    required this.onPrevChapter,
  });

  final AnimationController animationController;
  final ValueChanged<int> onTapChapterIndex;
  final VoidCallback onNextChapter;
  final VoidCallback onPrevChapter;

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel>
    with TickerProviderStateMixin {
  late final novelChangeNotifier = context.read<NovelChangeNotifier>();

  bool _isSelected = false;

  void showChaptersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return NovelChaptersSheetView(
          onTapChapterIndex: widget.onTapChapterIndex,
        );
      },
    );
  }

  void showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return _SettingBottomSheetView();
        });
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Selector<NovelChangeNotifier, bool>(
                        builder: (_, canPrev, __) {
                          if (canPrev) {
                            return GestureDetector(
                              onTap: widget.onPrevChapter,
                              child: Container(
                                alignment: Alignment.center,
                                height: 36.w,
                                width: 90.w,
                                decoration: BoxDecoration(
                                  color: MyTheme.blackColor07,
                                  borderRadius: BorderRadius.circular(18.w),
                                ),
                                child: Text(
                                  'syzng'.tr(context: context),
                                  style: MyTheme.white14,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        selector: (_, notifier) =>
                            notifier.currentChapterIndex != 0,
                      ),
                      Selector<NovelChangeNotifier, bool>(
                        builder: (_, canPrev, __) {
                          if (canPrev) {
                            return GestureDetector(
                              onTap: widget.onNextChapter,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 36.w,
                                  width: 90.w,
                                  decoration: BoxDecoration(
                                    color: MyTheme.blackColor07,
                                    borderRadius: BorderRadius.circular(18.w),
                                  ),
                                  child: Text('xyzng'.tr(context: context),
                                      style: MyTheme.white14)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                        selector: (_, notifier) =>
                            notifier.currentChapterIndex !=
                            notifier.currentNovel.chapters.length - 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.w),
                Container(
                  color: MyTheme.blackColor07,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _BottomPanelItem(
                            title: 'ml',
                            child: const MyImage.asset(
                              MyImagePaths.appReaderMenu,
                            ),
                            onTap: () {
                              showChaptersBottomSheet(context);
                            },
                          ),
                          Selector<NovelChangeNotifier, bool>(
                            builder: (_, isFavorite, __) {
                              return _BottomPanelItem(
                                title: isFavorite ? 'ysc' : 'sc',
                                child: MyImage.asset(
                                  isFavorite
                                      ? MyImagePaths.appNovelCollectOn
                                      : MyImagePaths.appNovelCollectOff,
                                ),
                                onTap: () {
                                  novelChangeNotifier.toggleFavorite();
                                },
                              );
                            },
                            selector: (_, notifier) =>
                                notifier.currentNovel.isFavorite == 1,
                          ),
                          _BottomPanelItem(
                            title: 'fx',
                            child: const MyImage.asset(
                              MyImagePaths.appNavShare,
                            ),
                            onTap: () {
                              const MineShareToUserRoute().push(context);
                            },
                          ),
                          _BottomPanelItem(
                            title: 'sz',
                            child:
                                const MyImage.asset(MyImagePaths.appNovelSet),
                            onTap: () {
                              showSettingsBottomSheet(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
      child: SizedBox(
        width: 50.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 25.w,
              height: 25.w,
              child: child,
            ),
            SizedBox(height: 1.w),
            LocalizationText(
              title,
              style: MyTheme.white11,
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingBottomSheetView extends StatelessWidget {
  const _SettingBottomSheetView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.w,
      padding: EdgeInsets.all(MyTheme.pagePadding),
      decoration: BoxDecoration(
        color: const Color(0xff272727),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.w),
          topRight: Radius.circular(10.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('字号', style: MyTheme.white14),
          SizedBox(height: 5.w),
          SizedBox(
            width: 1.sw,
            height: 30.w,
            child: Row(children: [
              MyImage.asset(MyImagePaths.appNovelFontsize0, width: 22.w),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    thumbColor: Colors.white,
                    trackHeight: 2.w,
                    showValueIndicator: ShowValueIndicator.never,
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.1),
                    overlayColor: Colors.transparent,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Selector<NovelChangeNotifier, double>(
                    selector: (_, notifier) => notifier.fontSize,
                    builder: (_, size, __) {
                      return Slider(
                          value: size,
                          min: 12,
                          max: 22,
                          divisions: 10,
                          onChanged: (size) {
                            context
                                .read<NovelChangeNotifier>()
                                .setFontSize(size);
                          });
                    },
                  ),
                ),
              ),
              MyImage.asset(MyImagePaths.appNovelFontsize1, width: 22.w),
            ]),
          ),
          SizedBox(height: 5.w),
          Text('背景', style: MyTheme.white14),
          SizedBox(height: 5.w),
          SizedBox(
            height: 30.w,
            child: Row(
              children: [
                for (int i = 0; i < NovelReaderScreen.bgColors.length; i++) ...[
                  if (i != 0)
                    SizedBox(
                      width: 10.w,
                    ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<NovelChangeNotifier>().setBgColorIndex(i);
                      },
                      child: Selector<NovelChangeNotifier, int>(
                        selector: (_, notifier) => notifier.bgColorIndex,
                        builder: (_, bgIndex, __) {
                          return Container(
                            decoration: BoxDecoration(
                              color: NovelReaderScreen.bgColors[i],
                              borderRadius: BorderRadius.circular(5.w),
                              border: Border.all(
                                color: bgIndex == i
                                    ? Colors.white
                                    : Colors.transparent, // 设置边框颜色
                                width: 1.5, // 设置边框宽度
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
