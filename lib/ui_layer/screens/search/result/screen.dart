import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../../domain/model/comic/comic_item_model.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../domain/model/novel/novel_item_model.dart';
import '../../../../domain/model/video/video_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../../../domain/remote_domain/domains/comic.dart';
import '../../../../domain/remote_domain/domains/live.dart';
import '../../../../domain/remote_domain/domains/novel.dart';
import '../../../../report/ui_layer/report_search_click.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../bit/comic/card/comic_item_card.dart';
import '../../bit/live/widgets/live_video_card.dart';
import '../../bit/novel/card/novel_item_card.dart';
import '../../common_widgets/chat/card.dart';
import '../../common_widgets/girl/card.dart';
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
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  Widget build(BuildContext context) {
    final openLive = homeConfigNotifier.config.openLive == 1 ? true : false;

    final data = {
      'shp': _VideoView(word: widget.title),
      'tiezt': _TieztView(word: widget.title),
      'zhoz': _ZhozView(word: widget.title),
    };
    if (openLive) {
      data['zhib'] = _LiveVideoView(word: widget.title);
    }
    data.addAll({
      'manh': _ComicView(word: widget.title),
      'xs': _NovelView(word: widget.title),
    });

    data.addAll({
      // 'yup': _GirlView(word: widget.title),
      'lliao': _ChatView(word: widget.title),
    });

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
          titles: [for (final title in data.keys) title.tr(context: context)],
          views: [
            for (final child in data.values)
              KeepAliveWrapper(
                child: child,
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
      itemBuilder: (_, item, index) =>
          VideoCardView(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "video",
        "click_item_type_name": "视频",
        "click_ position": index,
      }),
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
      itemBuilder: (context, item, index) =>
          PostCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "community",
        "click_item_type_name": "帖子",
        "click_ position": index,
      }),
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
      itemBuilder: (context, item, index) =>
          PostCard.seed(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "seed",
        "click_item_type_name": "种子",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _LiveVideoView extends StatefulWidget {
  const _LiveVideoView({required this.word});

  final String word;

  @override
  State<_LiveVideoView> createState() => _LiveVideoViewState();
}

class _LiveVideoViewState extends State<_LiveVideoView> {
  late final _domain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.getLiveSearch(
        page: page, limit: pageSize, word: widget.word);
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: LiveVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      itemBuilder: (_, item, index) =>
          LiveVideoCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "live",
        "click_item_type_name": "直播",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ComicView extends StatefulWidget {
  const _ComicView({required this.word});

  final String word;

  @override
  State<_ComicView> createState() => _ComicViewState();
}

class _ComicViewState extends State<_ComicView> {
  late final _domain = context.read<ComicDomain>();

  Future<List<ComicItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.comicSearchList(
        word: widget.word, page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: ComicItemCard.aspectRatio,
      crossAxisSpacing: 10.w,
      crossAxisCount: 3,
      itemBuilder: (_, item, index) =>
          ComicItemCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "comic",
        "click_item_type_name": "漫画",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _NovelView extends StatefulWidget {
  const _NovelView({required this.word});

  final String word;

  @override
  State<_NovelView> createState() => _NovelViewState();
}

class _NovelViewState extends State<_NovelView> {
  late final _domain = context.read<NovelDomain>();

  Future<List<NovelItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.novelSearchList(
        word: widget.word, page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: NovelItemCard.aspectRatio,
      crossAxisSpacing: 10.w,
      crossAxisCount: 3,
      itemBuilder: (_, item, index) =>
          NovelItemCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "novel",
        "click_item_type_name": "小说",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _GirlView extends StatefulWidget {
  const _GirlView({required this.word});

  final String word;

  @override
  State<_GirlView> createState() => _GirlViewState();
}

class _GirlViewState extends State<_GirlView> {
  late final _domain = context.read<GirlDomain>();

  Future<List<GirlListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.girlSearchList(
        word: widget.word, page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
      childAspectRatio: 165 / (213 + 68),
      itemBuilder: (context, item, index) =>
          GirlCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "girl",
        "click_item_type_name": "约炮",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({required this.word});

  final String word;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final _domain = context.read<ChatDomain>();

  Future<List<ChatListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.chatSearchList(
        word: widget.word, page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
      childAspectRatio: 165 / (213 + 68),
      itemBuilder: (context, item, index) => ChatCard(data: item).withSearchReport({
        "event": "keyword_click",
        "keyword": widget.word,
        "click_item_id": item.id,
        "click_item_type_key": "chat",
        "click_item_type_name": "裸聊",
        "click_ position": index,
      }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

extension EventClick on Widget {
  Widget withSearchReport(Map data) {
    return ReportSearchClick(
      child: this,
      data: data,
    );
  }
}
