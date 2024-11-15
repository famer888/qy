import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/my_tab_bar.dart';
import 'content/content.dart';
import 'content/following_content.dart';
import 'content/recommend_content.dart';

class NovelScreen extends StatefulWidget {
  const NovelScreen({super.key});

  @override
  State<NovelScreen> createState() => _NovelScreenState();
}

class _NovelScreenState extends State<NovelScreen>
    with TickerProviderStateMixin {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final titles = _homeConfig.config.novelNav;
  late final tabController = TabController(
    length: titles.length,
    vsync: this,
    initialIndex: 1,
  );

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
        tabController: tabController,
        titles: titles.map((e) => e.name).toList(),
        views: titles.map((e) {
          if (e.type == '3') {
            //关注
            return const NovelFollowingContent();
          } else if (e.type == '2') {
            //推荐
            return NovelRecommendContent(id: e.id);
          } else {
            return NovelContent(id: e.id);
          }
        }).toList());
  }
}
