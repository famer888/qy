import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/comic/recommend_comic_model.dart';
import '../../../../../domain/model/part_nav_model.dart';
import '../../../../../domain/model/tip_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/marquee.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/recommend_comic_ad_card.dart';
import '../card/recommend_comic_item_card.dart';

class ComicRecommendContent extends StatefulWidget {
  const ComicRecommendContent({super.key, required this.id});

  final int id;

  @override
  State<ComicRecommendContent> createState() => _ComicRecommendContentState();
}

class _ComicRecommendContentState extends State<ComicRecommendContent> {
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _tipsNotifier = ValueNotifier<List<TipModel>>([]);
  final _partNotifier = ValueNotifier<List<PartModel>>([]);
  late final _domain = context.read<ComicDomain>();
  bool isInit = false;

  Future<List<RecommendComicModel>?> _getData(int page, int pageSize) async {
    final result = await _domain.comicRecommend(
      id: widget.id,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banner case final data?
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      if (result.data?.tips case final data?
          when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        _tipsNotifier.value = data;
      }
      if (result.data?.nav case final data?
          when data.isNotEmpty && _partNotifier.value.isEmpty) {
        _partNotifier.value = data;
      }

      return result.data?.comics;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyListView.list(
        contentPadding: MyTheme.pagePadding,
        padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
        header: _Header(
          bannersNotifier: _bannersNotifier,
          tipsNotifier: _tipsNotifier,
          partNotifier: _partNotifier,
        ),
        itemBuilder: (_, item, __) => item.map(
          ad: (data) => RecommendComicAdCard(data: data),
          comic: (data) => RecommendComicItemCard(data: data),
        ),
        onFetchingMore: _getData,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
    required this.partNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralAppsListVidget(data: banners),
            );
          },
        ),
        SizedBox(height: 5.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (_, tips, __) => MyMarqueeTipsWidget(tips: tips),
        ),
        ValueListenableBuilder(
          valueListenable: partNotifier,
          builder: (context, parts, child) {
            if (parts.isEmpty) return const SizedBox.shrink();
            return GridView.builder(
              shrinkWrap: true,
              addRepaintBoundaries: false,
              addAutomaticKeepAlives: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parts.length,
              padding: EdgeInsets.all(MyTheme.pagePadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 80.w / 70.w,
                mainAxisSpacing: 10.w,
                crossAxisSpacing: 10.w,
              ),
              itemBuilder: (context, index) {
                final partsItem = parts[index];
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    //漫画分类，最新，完结，排行榜点击
                    CommonUtils.openRoute(context, partsItem.toJson());
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45.w,
                        child: MyImage.network(
                          partsItem.icon,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Center(
                        child: Text(
                          partsItem.title,
                          style: MyTheme.white13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
