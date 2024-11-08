import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/comic/comic_item_model.dart';
import '../../../../../domain/model/comic/comic_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/expandable_text.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/localization_text.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../card/comic_item_card.dart';
import '../mixin/route_to_reader.dart';
import '../widgets/di/notifier.dart';
import '../widgets/sheets/comic_chapters_sheet.dart';
import '../widgets/sheets/comic_comment_sheet.dart';

///漫画详情界面
class ComicDetailScreen extends StatefulWidget {
  const ComicDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<ComicDetailScreen> createState() => _ComicDetailScreenState();
}

class _ComicDetailScreenState extends State<ComicDetailScreen> {
  late final _domain = context.read<ComicDomain>();
  late final _comicChangeNotifier = context.read<ComicChangeNotifier>();

  AsyncValue<ComicDetailWithBannersModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  _getData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await _domain.comicDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
      if (mounted) {
        _comicChangeNotifier.setCurrentComic(data.detail);
      }
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MyAppBar(
        rightWidget: GestureDetector(
          onTap: () {
            const MineShareToUserRoute().push(context);
          },
          child: MyImage.asset(
            MyImagePaths.appNavShare,
            width: 25.w,
            height: 25.w,
          ),
        ),
      ),
      body: _asyncValue.maybeWhen(
        orElse: () => const LoadingView(),
        error: (_, __) => NetworkErrorView(onTap: _getData),
        data: configContentView,
      ),
    );
  }

  Widget configContentView(ComicDetailWithBannersModel data) {
    final detail = data.detail;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _Header(
          title: detail.title,
          cover: detail.cover,
          commentCt: detail.commentCt,
          favoriteCt: detail.favoriteFct,
          viewCt: detail.viewCt,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.w),
              _TagsView(tags: data.detail.tag),
              SizedBox(height: 18.w),
              ExpandableText(
                data.detail.intro ?? '',
                style: MyTheme.white07_14,
                trimLines: 3,
              ),
              SizedBox(height: 15.w),
              _ChaptersView(
                isEnd: detail.isEnd == 1,
                chapters: detail.chapters ?? [],
              ),
              SizedBox(height: 15.w),
              _CommentView(
                id: detail.id ?? 0,
                totalCt: detail.commentCt ?? 0,
              ),
              SizedBox(height: 15.w),
              GeneralBanner(
                data: data.banner,
                aspectRatio: 7 / 2,
              ),
              SizedBox(height: 10.w),
              _RecommendView(
                recommends: data.recommend,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.cover,
    required this.viewCt,
    required this.commentCt,
    required this.favoriteCt,
  });
  final String? title;
  final String? cover;
  final int? viewCt;
  final int? commentCt;
  final int? favoriteCt;

  @override
  Widget build(BuildContext context) {
    final viewCtStr =
        '${CommonUtils.renderFixedNumber(viewCt ?? 0)}${'rd'.tr()}';
    final favoriteCtStr =
        '${CommonUtils.renderFixedNumber(favoriteCt ?? 0)}${'sc'.tr()}';
    final commentCtStr =
        '${CommonUtils.renderFixedNumber(commentCt ?? 0)}${'pl'.tr()}';

    return AspectRatio(
      aspectRatio: 375 / 193,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MyImage.network(cover ?? ''),
          Positioned(
            left: MyTheme.pagePadding,
            bottom: 5.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: MyTheme.white18bold,
                ),
                SizedBox(height: 5.w),
                Text(
                  '$viewCtStr  |  $favoriteCtStr  |  $commentCtStr',
                  style: MyTheme.white12,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _TagsView extends StatelessWidget {
  const _TagsView({required this.tags});
  final String? tags;
  @override
  Widget build(BuildContext context) {
    if (tags?.trim() case final tags? when tags.isNotEmpty) {
      final tagList = tags.split(',');
      final newTagList = tagList.sublist(0, min(tagList.length, 3));
      return Wrap(
        runSpacing: 10.w,
        spacing: 10.w,
        children: [
          for (final tag in newTagList)
            InkWell(
              onTap: () {
                ///TODO
                // Utils.navTo(context, "/homesearchpage?searchStr=$tag&index=7");
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 2.w),
                decoration: BoxDecoration(
                  color: MyTheme.white02Color,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Text(tag, style: MyTheme.white09_10),
              ),
            ),
        ],
      );
    }

    return const SizedBox();
  }
}

class _ChaptersView extends StatelessWidget with RouteToReaderMixin {
  const _ChaptersView({
    required this.isEnd,
    required this.chapters,
  });

  final bool isEnd;
  final List<ComicChapterModel> chapters;

  Future<T?> showChaptersBottomSheet<T>(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ComicChaptersSheetView(chapters: chapters);
      },
    );
  }

  int getFreeCount() {
    int freeCount = 0;
    for (final chapter in chapters) {
      if (chapter.type == 1) {
        break;
      }
      freeCount++;
    }
    return freeCount;
  }

  @override
  Widget build(BuildContext context) {
    final isEndStr = isEnd ? '${'ywj'.tr()}  |  ' : '';
    final chaptersUpdateStr =
        '${'gxz'.tr()}${chapters.length}${'hua'.tr()}  |  ';

    final freeChaptersStr = '${'mfyd'.tr()}${getFreeCount()}${'hua'.tr()}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LocalizationText(
          'mhxj',
          style: MyTheme.white16bold,
        ),
        SizedBox(height: 5.w),
        Text(
          '$isEndStr$chaptersUpdateStr$freeChaptersStr',
          style: MyTheme.white10,
        ),
        SizedBox(height: 5.w),
        SizedBox(
          height: 115.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: chapters.length,
            itemBuilder: (_, index) {
              final chapter = chapters[index];
              return GestureDetector(
                onTap: () {
                  routeToReader(context, index);
                },
                child: SizedBox(
                  width: 160.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 90.w,
                        child: MyImage.network(
                          chapter.cover ?? '',
                          borderRadius: 10.w,
                        ),
                      ),
                      Text(
                        chapter.title ?? '',
                        style: MyTheme.white14,
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) {
              return SizedBox(width: 10.w);
            },
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            showChaptersBottomSheet(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LocalizationText(
                'zkml',
                style: MyTheme.white04_12,
              ),
              SizedBox(
                width: 20.w,
                height: 30.w,
                child: const FittedBox(
                  fit: BoxFit.cover,
                  child: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentView extends StatelessWidget {
  const _CommentView({super.key, required this.id, required this.totalCt});
  final int id;
  final int totalCt;
  Future<T?> showChaptersBottomSheet<T>(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ComicCommentSheetView(
          id: id,
          totalCt: totalCt,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('pl'.tr(context: context), style: MyTheme.white16bold),

        ///TODO
        const SizedBox(height: 100),
        MyButton.highEmphasis(
          color: MyTheme.white008Color,
          borderRadius: 15.w,
          minimumSize: Size.fromHeight(30.w),
          child: LocalizationText('ckgd', style: MyTheme.white12),
          onPressed: () {
            showChaptersBottomSheet(context);
          },
        ),
      ],
    );
  }
}

class _RecommendView extends StatelessWidget {
  const _RecommendView({required this.recommends});
  final List<ComicItemsModel> recommends;

  @override
  Widget build(BuildContext context) {
    if (recommends.isEmpty) return SizedBox(height: 30.w);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('xgtj'.tr(context: context), style: MyTheme.white16bold),
        SizedBox(height: 10.w),
        GridView.builder(
          shrinkWrap: true,
          addRepaintBoundaries: false,
          addAutomaticKeepAlives: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommends.length,
          padding: EdgeInsets.only(bottom: 30.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: ComicItemCard.aspectRatio,
            mainAxisSpacing: 10.w,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (context, index) {
            final item = recommends[index];
            return ComicItemCard(data: item);
          },
        )
      ],
    );
  }
}
