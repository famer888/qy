import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/domain.dart';
import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../../domain/model/novel/novel_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../router/routes.dart';
import '../../../common_widgets/localization_text.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../card/novel_chapter_card.dart';
import '../card/novel_item_card.dart';
import '../di/notifier.dart';
import '../mixin/route_to_reader.dart';
import '../sheets/chapters_sheet.dart';

class NovelIntroContent extends StatefulWidget {
  const NovelIntroContent({super.key, required this.data});

  final NovelDetailWithBannersModel data;

  @override
  State<NovelIntroContent> createState() => _NovelIntroContentState();
}

class _NovelIntroContentState extends State<NovelIntroContent>
    with RouteToReaderMixin {
  NovelDetailModel get data => widget.data.detail;

  Future<T?> showChaptersBottomSheet<T>(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const NovelChaptersSheetView();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chapters = data.chapters;
    final recommends = widget.data.recommend;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (data.intro case final intro?)
                        Padding(
                          padding: EdgeInsets.only(bottom: MyTheme.pagePadding),
                          child: Text(
                            intro,
                            style: MyTheme.white07_14,
                            maxLines: 100,
                          ),
                        ),
                      if (data.tag case final tags? when tags.isNotEmpty)
                        Wrap(runSpacing: 10.w, spacing: 10.w, children: [
                          for (final tag in tags.split(','))
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.5.w, vertical: 2.w),
                              decoration: BoxDecoration(
                                color: MyTheme.white008Color,
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Text(
                                tag,
                                style: MyTheme.white09_10,
                              ),
                            ),
                        ]),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          Text(
                              data.isEnd == 1
                                  ? 'wj'.tr(context: context)
                                  : 'lzz'.tr(context: context),
                              style: MyTheme.white15_M),
                          SizedBox(width: 6.w),
                          Padding(
                            padding: EdgeInsets.only(top: 3.w),
                            child: Text(
                                '${'zjgx'.tr(context: context)}${chapters.length}${'zang'.tr(context: context)}',
                                style: MyTheme.yellow_12),
                          ),
                          const Spacer(),
                          if (chapters.length > 3)
                            GestureDetector(
                              onTap: () {
                                showChaptersBottomSheet(context);
                              },
                              child: Text(
                                'gd'.tr(context: context),
                                style: MyTheme.white04_12,
                              ),
                            )
                        ],
                      ),
                      SizedBox(height: 5.w),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (chapters.length > 3
                                  ? chapters.sublist(0, 3)
                                  : chapters)
                              .asMap()
                              .keys
                              .map((index) {
                            NovelChaptersModel chapter = chapters[index];
                            return NovelChapterCard(
                              data: chapter,
                              onTap: () {
                                routeToReader(context, index);
                              },
                            );
                          }).toList()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          chapters.length >= 4
                              ? SizedBox(
                                  height: 60.w,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        showChaptersBottomSheet(context);
                                      },
                                      child: Container(
                                        height: 30.w,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MyTheme.pagePadding),
                                        decoration: BoxDecoration(
                                            color: MyTheme.white008Color,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.w))),
                                        alignment: Alignment.center,
                                        child: Row(children: [
                                          MyImage.asset(
                                              MyImagePaths.appNovelAllCatelog,
                                              width: 12.w,
                                              height: 12.w),
                                          SizedBox(width: 5.w),
                                          Text(
                                            'ckqbzj'.tr(context: context),
                                            style: MyTheme.white07_12,
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ),
                recommends.isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MyTheme.pagePadding),
                        child: Column(
                          children: [
                            Container(
                              height: 27.w,
                              margin: EdgeInsets.symmetric(vertical: 10.w),
                              alignment: Alignment.centerLeft,
                              child: Text('klyk'.tr(context: context),
                                  style: MyTheme.white15_M),
                            ),
                            GridView.builder(
                                shrinkWrap: true,
                                addRepaintBoundaries: false,
                                addAutomaticKeepAlives: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: recommends.length,
                                padding: EdgeInsets.only(bottom: 30.w),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: NovelItemCard.aspectRatio,
                                  mainAxisSpacing: 10.w,
                                  crossAxisSpacing: 10.w,
                                ),
                                itemBuilder: (context, index) {
                                  final item = recommends[index];
                                  return NovelItemCard(data: item);
                                })
                          ],
                        ),
                      )
                    : Container(height: 30.w)
              ],
            ),
          ),
        ),
        const _Footer()
      ],
    );
  }
}

class _Footer extends StatelessWidget with RouteToReaderMixin {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final novelChangeNotifier = context.read<NovelChangeNotifier>();
    final detail = novelChangeNotifier.currentNovel;
    return Container(
      color: const Color(0xff111127),
      child: SafeArea(
        top: false,
        child: Selector<NovelChangeNotifier, int?>(
          builder: (_, lastReadIndex, __) {
            final index = lastReadIndex ?? 0;
            return Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      detail.chapters[index].title ?? '',
                      style: MyTheme.white14,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Selector<NovelChangeNotifier, bool>(
                        builder: (_, isFavorite, __) {
                          return SizedBox(
                            width: 50.w,
                            child: GestureDetector(
                              onTap: () {
                                novelChangeNotifier.toggleFavorite();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MyImage.asset(
                                    isFavorite
                                        ? MyImagePaths.appCollectOn
                                        : MyImagePaths.appCollectOff,
                                    width: 18.7.w,
                                    height: 18.7.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    isFavorite
                                        ? 'ysc'.tr(context: context)
                                        : 'sc'.tr(context: context),
                                    style: MyTheme.gray190_12,
                                  ),
                                  SizedBox(width: 15.w),
                                ],
                              ),
                            ),
                          );
                        },
                        selector: (_, notifier) =>
                            notifier.currentNovel.isFavorite == 1,
                      ),
                      MyButton.highEmphasis(
                        color: MyTheme.jellyCyanColor103224185,
                        onPressed: () {
                          routeToReader(context, index);
                        },
                        borderRadius: 30.w,
                        child: LocalizationText(
                          lastReadIndex == null ? 'ksyd' : 'jxyd',
                          style: MyTheme.white14Medium,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
          selector: (_, notifier) => notifier.currentChapterIndex,
        ),
      ),
    );
  }
}
