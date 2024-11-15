import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/enum.dart';

import '../../../../domain/model/mine/post/mine_post_list_model.dart';
import '../../../../domain/model/mine/video/mine_video_model.dart';
import '../../../../domain/model/mine/video/mine_video_list_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../../../domain/result.dart';
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
  final data = {
    'shp': const _VideoView(),
    'tiezt': const _PostView(type: ModuleType.post),
    'zhoz': const _PostView(type: ModuleType.seed),
  };

  @override
  Widget build(BuildContext context) {
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
