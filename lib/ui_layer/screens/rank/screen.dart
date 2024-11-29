import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/model/rank_nav_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/keep_alive_wrapper.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import 'content.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({super.key});

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final List<RankNavModel> _titles = _homeConfig.config.rankTopNav;

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(title: 'phb'.tr(context: context)),
        body: TabBarWithView.line(
          tabBarHeight: 42.w,
          isCenter: true,
          titles: _titles.map((model) => model.title ?? '').toList(),
          views: _titles.map((model) {
            return KeepAliveWrapper(
              child: RankContentScreen(data: model),
            );
          }).toList(),
        ),
      ),
    );
  }
}
