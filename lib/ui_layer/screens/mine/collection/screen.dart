import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/api_validator.dart';
import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';

import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../../domain/model/comic/comic_item_model.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../domain/model/mine/post/mine_post_list_model.dart';
import '../../../../domain/model/mine/video/mine_video_model.dart';
import '../../../../domain/model/mine/video/mine_video_list_model.dart';
import '../../../../domain/model/monitor/monitor_with_banners_model.dart';
import '../../../../domain/model/novel/novel_item_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../../../domain/remote_domain/domains/comic.dart';
import '../../../../domain/remote_domain/domains/live.dart';
import '../../../../domain/remote_domain/domains/monitor.dart';
import '../../../../domain/remote_domain/domains/novel.dart';
import '../../../../domain/result.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../bit/comic/card/comic_item_card.dart';
import '../../bit/live/widgets/live_video_card.dart';
import '../../bit/monitor/widgets/monitor_video_card.dart';
import '../../bit/novel/card/novel_item_card.dart';
import '../../common_widgets/chat/card.dart';
import '../../common_widgets/girl/card.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/post/card/card.dart';
import '../../common_widgets/screen_background.dart';
import '../common_widgets/video_tile.dart';
import '../../theme.dart';

class MineCollectionScreen extends StatefulWidget {
  const MineCollectionScreen({super.key});

  @override
  State<MineCollectionScreen> createState() => _MineCollectionScreenState();
}

class _MineCollectionScreenState extends State<MineCollectionScreen> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();

  @override
  Widget build(BuildContext context) {
    final openLive = homeConfigNotifier.config.openLive == 1 ? true : false;

    final data = {
      'shp': const _VideoView(),
      'tiezt': const _PostView(type: ModuleType.post),
      'zhoz': const _PostView(type: ModuleType.seed),
    };
    if (openLive) {
      data['zhib'] = const _LiveView();
    }
    data.addAll({
      'jiankong': const _MonitorView(),
      'manh': const _ComicView(),
      'xs': const _NovelView(),
    });

    data.addAll({
      // 'yup': const _GirlView(),
      'lliao': const _ChatView(),
    });

    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'wdsc'.tr(context: context),
        ),
        body: TabBarWithView.line(
          tabBarPadding: EdgeInsets.symmetric(
            vertical: 0.w,
            horizontal: MyTheme.pagePadding,
          ),
          labelStyle: MyTheme.jellyCyan_15,
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 15.sp,
            overflow: TextOverflow.visible,
            decoration: TextDecoration.none,
          ),
          tabBarHeight: 40.w,
          isScrollable: true,
          titles: [
            for (final title in data.keys) title.tr(context: context),
          ],
          views: [
            for (final view in data.values) KeepAliveWrapper(child: view),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView();

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<MineVideoModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: 1,
      lastIx: lastIx,
    ) as Result<MineVideoListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: 1,
      itemBuilder: (_, item, __) => MineVideoTile(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _PostView extends StatefulWidget {
  const _PostView({required this.type});

  final ModuleType type;

  @override
  State<_PostView> createState() => _PostViewState();
}

class _PostViewState extends State<_PostView> {
  late final userDomain = context.read<UserDomain>();
  String lastIx = '';

  Future<List<PostModel>> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await userDomain.getUserFavor(
      page: page,
      limit: pageSize,
      type: widget.type.id,
      lastIx: lastIx,
    ) as Result<MinePostListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => switch (widget.type) {
        ModuleType.post => PostCard(data: item),
        ModuleType.seed => PostCard.seed(data: item),
        _ => const SizedBox.shrink(),
      },
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _LiveView extends StatefulWidget {
  const _LiveView();

  @override
  State<_LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<_LiveView> {
  late final liveDomain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await liveDomain.getLiveListFavorite(
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: LiveVideoCard.aspectRatio,
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => LiveVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _ComicView extends StatefulWidget {
  const _ComicView();

  @override
  State<_ComicView> createState() => _ComicViewState();
}

class _ComicViewState extends State<_ComicView> {
  late final _domain = context.read<ComicDomain>();

  Future<List<ComicItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.comicFavoriteList(page: page, limit: pageSize);
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
      itemBuilder: (_, item, index) => ComicItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _NovelView extends StatefulWidget {
  const _NovelView();

  @override
  State<_NovelView> createState() => _NovelViewState();
}

class _NovelViewState extends State<_NovelView> {
  late final _domain = context.read<NovelDomain>();

  Future<List<NovelItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.novelFavoriteList(page: page, limit: pageSize);
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
      itemBuilder: (_, item, index) => NovelItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _MonitorView extends StatefulWidget {
  const _MonitorView();

  @override
  State<_MonitorView> createState() => _MonitorViewState();
}

class _MonitorViewState extends State<_MonitorView> {
  late final monitorDomain = context.read<MonitorDomain>();

  Future<List<MonitorModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await monitorDomain.getMonitorListFavorite(
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: MonitorVideoCard.aspectRatio,
      padding: EdgeInsets.symmetric(
          vertical: MyTheme.pagePadding, horizontal: MyTheme.pagePadding),
      itemBuilder: (context, item, index) {
        return MonitorVideoCard(data: item);
      },
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _GirlView extends StatefulWidget {
  const _GirlView();

  @override
  State<_GirlView> createState() => _GirlViewState();
}

class _GirlViewState extends State<_GirlView> {
  late final _domain = context.read<GirlDomain>();

  Future<List<GirlListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.girlFavoriteList(page: page, limit: pageSize);
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
      itemBuilder: (context, item, index) => GirlCard(
        data: item,
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  late final _domain = context.read<ChatDomain>();

  Future<List<ChatListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.chatFavoriteList(page: page, limit: pageSize);
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
      itemBuilder: (context, item, index) => ChatCard(
        data: item,
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
