import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/appbar_with_tabbar.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/screen_background.dart';
import 'widgets/agent_view.dart';
import 'widgets/app_center_view.dart';
import 'widgets/tasks_view.dart';

class MineWelfareScreen extends StatefulWidget {
  const MineWelfareScreen({super.key, required this.index});
  final int index;
  @override
  State<MineWelfareScreen> createState() => _MineWelfareScreenState();
}

class _MineWelfareScreenState extends State<MineWelfareScreen>
    with TickerProviderStateMixin {
  late final config = context.read<HomeConfigNotifier>().config;

  late final data = [
    ('dlzq', const KeepAliveWrapper(child: AgentView())),
    ('flrw', const KeepAliveWrapper(child: TaskView())),
    if (config.showApp == 1)
      ('yytj', const KeepAliveWrapper(child: AppCenterView())),
  ];

  late final tabController = TabController(
    length: data.length,
    vsync: this,
    initialIndex: widget.index,
  );

  @override
  Widget build(BuildContext context) {
    final titles = [for (final e in data) e.$1];
    final children = [for (final e in data) e.$2];
    return ScreenBackground(
      child: Scaffold(
        appBar: AppBarWithTabBar(
          tabController: tabController,
          titles: titles,
          fontSize: 15.sp,
        ),
        body: TabBarView(
          controller: tabController,
          children: children,
        ),
      ),
    );
  }
}
