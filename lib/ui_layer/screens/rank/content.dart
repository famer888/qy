import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/rank_nav_model.dart';
import '../../../domain/model/video/video_model.dart';
import '../../../domain/remote_domain/domains/rank.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/my_list_view.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/video/card/video_card.dart';
import '../theme.dart';

class RankContentScreen extends StatefulWidget {
  const RankContentScreen({super.key, required this.data});

  final RankNavModel data;

  @override
  State<RankContentScreen> createState() => _RankContentScreenState();
}

class _RankContentScreenState extends State<RankContentScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavModel> _titles = _homeConfig.config.rankCycleNav;
  late final _domain = context.read<RankDomain>();
  int _page = 1;

  Future<List<VideoCardModel>?> _getData(
      {required int page, required String cycle, required String type}) async {
    _page = page;

    final result = await _domain.rankMVList(cycle: cycle, type: type);

    if (result.status == 1) {
      if (result.data case final data) {
        if (_page == 1) {
          return data;
        } else {
          return []; //接口不需要分页是一次性返回所有数据，在第二页时返回的时重复数据所以返回空就行
        }
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.fillColor(
      tabBarHeight: 32.w,
      titles: _titles.map((model) => model.title ?? '').toList(),
      views: _titles.map((model) {
        return MyListView.grid(
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 5.w),
          childAspectRatio: VideoCard.aspectRatio,
          crossAxisSpacing: 8.w,
          itemBuilder: (context, item, index) => VideoCard(data: item),
          onFetchingMore: (currentPage, pageSize) => _getData(
              cycle: model.value ?? '',
              type: widget.data.value ?? '',
              page: currentPage),
        );
      }).toList(),
    );
  }
}
