import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/video/video_model.dart';
import '../../../../domain/remote_domain/domains/index.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/video/card/video_card.dart';
import '../../theme.dart';

class MoreRecommendVideoScreen extends StatefulWidget {
  const MoreRecommendVideoScreen({
    super.key,
    required this.name,
    required this.id,
    required this.type,
  });

  final String name;
  final int id;
  final int type;

  @override
  State<MoreRecommendVideoScreen> createState() =>
      _MoreRecommendVideoScreenState();
}

class _MoreRecommendVideoScreenState extends State<MoreRecommendVideoScreen> {
  late final navs =
      context.read<HomeConfigNotifier>().homeData.config.mvSecondSortNav;
  @override
  Widget build(BuildContext context) {
    if (widget.type == 1) {
      return ScreenBackground(
        child: Scaffold(
          appBar: MyAppBar(
            title: widget.name,
          ),
          body: _VideoView(
            sort: '',
            id: widget.id,
            type: widget.type,
          ),
        ),
      );
    }

    return ScreenBackground(
        child: Scaffold(
      appBar: MyAppBar(
        title: widget.name,
      ),
      body: TabBarWithView.fillColor(
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
              id: widget.id,
              type: widget.type,
            ),
        ],
      ),
    ));
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.sort, required this.id, required this.type});
  final String sort;
  final int id;
  final int type;
  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final mvDomain = context.read<IndexDomain>();

  Future<List<VideoCardModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = widget.type == 1
        ? await mvDomain.getMoreRecommendVideosBySort(
            page: page,
            limit: pageSize,
            id: widget.id,
          )
        : await mvDomain.getMoreRecommendVideosByPart(
            page: page,
            limit: pageSize,
            sort: widget.sort,
            id: widget.id,
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
