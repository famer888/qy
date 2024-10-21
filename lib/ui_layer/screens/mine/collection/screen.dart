import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/collection_model.dart';
import '../../../../domain/model/post_model.dart';
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
            'shp'.tr(context: context),
            'tiezt'.tr(context: context),
            'zhoz'.tr(context: context),
          ],
          views: const [
            KeepAliveWrapper(
              child: _VideoView(),
            ),
            KeepAliveWrapper(
              child: _TieztView(type: _TieztType.community),
            ),
            KeepAliveWrapper(
              child: _TieztView(type: _TieztType.bit),
            ),
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

  Future<List<MineVideoCardData>> _getData({
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

enum _TieztType {
  community,
  bit;

  int get id => switch (this) {
        _TieztType.community => 14,
        _TieztType.bit => 15,
      };
}

class _TieztView extends StatefulWidget {
  const _TieztView({required this.type});

  final _TieztType type;

  @override
  State<_TieztView> createState() => _TieztViewState();
}

class _TieztViewState extends State<_TieztView> {
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
    ) as Result<MineTieztListModel>;
    lastIx = result.data?.lastIx ?? '';

    return result.data!.list!;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      contentPadding: 15.w,
      itemBuilder: (context, item, index) => switch (widget.type) {
        _TieztType.community => PostCard.community(data: item),
        _TieztType.bit => PostCard.bit(data: item),
      },
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
