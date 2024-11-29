import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/localization_text.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../di/notifier.dart';
import 'comic_chapters_sheet_card.dart';
import '../mixin/route_to_reader.dart';

class ComicChaptersSheetView extends StatefulWidget {
  const ComicChaptersSheetView({super.key, this.onTapChapterIndex});

  final ValueChanged<int>? onTapChapterIndex;

  @override
  State<ComicChaptersSheetView> createState() => _ComicChaptersSheetViewState();
}

class _ComicChaptersSheetViewState extends State<ComicChaptersSheetView>
    with RouteToReaderMixin {
  late final height = 1.sh - 1.sw * 193 / 375;
  late final comicChangeNotifier = context.read<ComicChangeNotifier>();

  bool isDes = true; //默认正序

  @override
  Widget build(BuildContext context) {
    final chapters = comicChangeNotifier.currentComic.chapters;
    final currentIndex = comicChangeNotifier.currentChapterIndex;

    return Container(
      color: const Color(0xff272727),
      height: height,
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: Column(
                children: [
                  SizedBox(height: 10.w),
                  LocalizationText('ml', style: MyTheme.white18bold),
                  SizedBox(height: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'qbzj'.tr(),
                                  style: MyTheme.white15_M,
                                ),
                                Text(
                                  '(${chapters.length})',
                                  style: MyTheme.white12,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    //正序
                                    if (isDes) {
                                      return;
                                    }
                                    setState(() {
                                      isDes = true;
                                    });
                                  },
                                  child: Text('zxu'.tr(context: context),
                                      style: isDes
                                          ? MyTheme.white14Medium
                                          : MyTheme.white04_14),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                    width: 0.5,
                                    height: 15.w,
                                    color: Colors.white.withOpacity(0.4)),
                                SizedBox(width: 6.w),
                                GestureDetector(
                                  onTap: () {
                                    //倒序
                                    if (!isDes) {
                                      return;
                                    }
                                    setState(() {
                                      isDes = false;
                                    });
                                  },
                                  child: Text('dxu'.tr(context: context),
                                      style: isDes
                                          ? MyTheme.white04_14
                                          : MyTheme.white14Medium),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Expanded(
                          child: ListView.builder(
                            itemCount: chapters.length,
                            itemBuilder: (_, index) {
                              final targetIndex =
                                  isDes ? index : chapters.length - 1 - index;
                              final chapter = chapters[targetIndex];
                              return ComicChaptersSheetCard(
                                data: chapter,
                                isLocation: targetIndex == currentIndex,
                                onTap: () {
                                  context.pop();
                                  if (widget.onTapChapterIndex
                                      case final onTapChapterIndex?) {
                                    onTapChapterIndex(targetIndex);
                                  } else {
                                    routeToReader(context, targetIndex);
                                  }
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () => context.pop(),
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: MyImage.asset(
                    MyImagePaths.appComicClose,
                    height: 25.w,
                    width: 25.w,
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
