import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/comic/comic_item_model.dart';
import '../../../../../domain/model/tip_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/marquee.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/my_tab_bar.dart';
import '../../../theme.dart';
import '../card/comic_item_card.dart';

class ComicContent extends StatefulWidget {
  const ComicContent({super.key, required this.id});

  final int id;

  @override
  State<ComicContent> createState() => _ComicContentState();
}

class _ComicContentState extends State<ComicContent> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final titles = _homeConfig.config.comicSortNav;
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _tipsNotifier = ValueNotifier<List<TipModel>>([]);
  late final _domain = context.read<ComicDomain>();
  bool isInit = false;

  Future<List<ComicItemModel>?> _getData(
      {required String sort, required int page, required int pageSize}) async {
    final result = await _domain.comicThemeList(
      id: widget.id,
      sort: sort,
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

      return result.data?.comics;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(
            child: _Header(
              bannersNotifier: _bannersNotifier,
              tipsNotifier: _tipsNotifier,
            ),
          ),
        ],
        body: TabBarWithView.fillColor(
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 6.w,
            horizontal: MyTheme.pagePadding,
          ),
          isScrollable: true,
          tabBarHeight: 32.w,
          labelStyle: MyTheme.white14Medium,
          unselectedLabelStyle: MyTheme.white07_14,
          titles: isInit ? [for (final title in titles) title.title] : [],
          views: [
            for (final nav in titles)
              MyListView.grid(
                childAspectRatio: ComicItemCard.aspectRatio,
                crossAxisCount: 3,
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                itemBuilder: (_, item, __) => ComicItemCard(data: item),
                onFetchingMore: (currentPage, pageSize) => _getData(
                  sort: nav.sort,
                  page: currentPage,
                  pageSize: pageSize,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

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
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (_, tips, __) => MyMarqueeTipsWidget(tips: tips),
        ),
      ],
    );
  }
}
