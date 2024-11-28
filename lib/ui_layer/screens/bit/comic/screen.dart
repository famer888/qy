import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/comic/comic_nav_model.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../theme.dart';
import 'content/content.dart';
import 'content/recommend_content.dart';

class ComicScreen extends StatefulWidget {
  const ComicScreen({super.key});

  @override
  State<ComicScreen> createState() => _ComicScreenState();
}

class _ComicScreenState extends State<ComicScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<ComicNavModel> titles = _homeConfig.config.comicTopNav;

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.none(
        labelStyle: MyTheme.jellyCyan_15,
        unselectedLabelStyle: MyTheme.white15,
        tabBarHeight: 30.w,
        titles: titles.map((e) => e.name).toList(),
        views: titles.map((e) {
          if (e.type == '2') {
            //推荐
            return ComicRecommendContent(id: e.id);
          } else {
            return ComicContent(id: e.id);
          }
        }).toList());
  }
}
