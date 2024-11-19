import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/part_nav_model.dart';
import '../../../../../domain/model/video/recommend_video_model.dart';
import '../../../../../domain/remote_domain/domains/index.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../theme.dart';
import '../../general_banner.dart';
import '../../my_image.dart';
import '../../my_list_view.dart';
import 'card/recommed_video_ad_card.dart';
import 'card/recommend_video_item_card.dart';

class RecommendVideoView extends StatefulWidget {
  const RecommendVideoView({super.key, required this.id});

  final int id;

  @override
  State<RecommendVideoView> createState() => _RecommendVideoViewState();
}

class _RecommendVideoViewState extends State<RecommendVideoView> {
  late final _domain = context.read<IndexDomain>();
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _partNotifier = ValueNotifier<List<PartModel>>([]);

  Future<List<RecommendVideoModel>?> _getData(int page, int pageSize) async {
    final result = await _domain.getRecommendVideosWithBanners(
      id: widget.id,
      page: page,
      limit: pageSize,
    );

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      if (result.data?.navs case final data?
          when data.isNotEmpty && _partNotifier.value.isEmpty) {
        _partNotifier.value = data;
      }

      return result.data?.list;
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
          partNotifier: _partNotifier,
        ),
        itemBuilder: (_, item, __) => item.map(
          ad: (data) => RecommendVideoAdCard(data: data),
          video: (data) => RecommendVideoItemCard(data: data),
        ),
        onFetchingMore: _getData,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.partNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<PartModel>> partNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBanner(data: banners),
            );
          },
        ),
        SizedBox(height: 5.w),
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
