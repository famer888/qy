import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../theme.dart';
import 'content/live_video_view.dart';
import 'content/recommend_live_video_view.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = config.liveTopNav;
  late final _tabController =
      TabController(length: navList.length, vsync: this);

  void onMoreButtonClick(String title) {
    //点击更多，滑动到对应栏目
    final index = navList.indexWhere((e) => e.name == title);
    _tabController.index = index;
  }

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.none(
      tabController: _tabController,
      titles: [for (final e in navList) e.name],
      labelStyle: MyTheme.jellyCyan_15,
      unselectedLabelStyle: MyTheme.white15,
      tabBarHeight: 30.w,
      views: [
        for (final e in navList)
          e.uiType == 0
              ? RecommendLiveVideoView(onMoreButtonClick: onMoreButtonClick)
              : LiveVideoView(id: e.id)
      ],
    );
  }
}
