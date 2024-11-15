import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/video/video_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../common_widgets/video/card/video_card.dart';
import '../../common_widgets/video/card/widgets/video_view.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/post/card/card.dart';
import '../../common_widgets/screen_background.dart';
import '../../theme.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.title});
  final String title;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'ssjg'.tr(context: context),
        ),
        body: TabBarWithView.fillColor(
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 6.w,
            horizontal: MyTheme.pagePadding,
          ),
          tabBarHeight: 32.w,
          isScrollable: true,
          titles: [
            'shp'.tr(context: context),
            'tiezt'.tr(context: context),
            'zhoz'.tr(context: context),
          ],
          views: [
            KeepAliveWrapper(
              child: _VideoView(word: widget.title),
            ),
            KeepAliveWrapper(
              child: _TieztView(word: widget.title),
            ),
            KeepAliveWrapper(
              child: _ZhozView(word: widget.title),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.word});
  final String word;
  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final mvDomain = context.read<MvDomain>();

  Future<List<VideoCardVideoModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await mvDomain.videoSearch(
        page: page, limit: pageSize, word: widget.word);

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: VideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, __) => VideoCardView(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _TieztView extends StatefulWidget {
  const _TieztView({required this.word});
  final String word;

  @override
  State<_TieztView> createState() => _TieztViewState();
}

class _TieztViewState extends State<_TieztView> {
  late final communityDomain = context.read<CommunityDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await communityDomain.searchCommunity(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ZhozView extends StatefulWidget {
  const _ZhozView({required this.word});
  final String word;

  @override
  State<_ZhozView> createState() => _ZhozViewState();
}

class _ZhozViewState extends State<_ZhozView> {
  late final seedDomain = context.read<SeedDomain>();

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await seedDomain.searchSeed(
      page: page,
      limit: pageSize,
      word: widget.word,
    );

    return result.data!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => PostCard.seed(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
