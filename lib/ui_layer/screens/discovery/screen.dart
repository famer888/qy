import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/video/video_model.dart';
import '../../../domain/remote_domain/domains/mv.dart';
import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/video/card/video_card.dart';
import '../theme.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  late final navs =
      context.read<HomeConfigNotifier>().homeData.config.mvDiscoverSortNav;
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: 'fxjc'.tr(context: context),
      ),
      body: TabBarWithView.fillColor(
        tabPadding: EdgeInsets.symmetric(horizontal: 5.w),
        tabBarPadding: EdgeInsets.symmetric(
          vertical: 6.w,
          horizontal: MyTheme.pagePadding,
        ),
        tabBarHeight: 32.w,
        isScrollable: true,
        titles: [for (final nav in navs) nav.title],
        views: [
          for (final nav in navs)
            _VideoView(
              sort: nav.type,
            ),
        ],
      ),
    ));
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.sort});
  final String sort;
  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final mvDomain = context.read<MvDomain>();

  Future<List<VideoCardModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await mvDomain.getDiscoverVideoList(
      page: page,
      limit: pageSize,
      sort: widget.sort,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: VideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, __) => VideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
