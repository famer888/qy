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
  late final titles =
      config.showApp == 1 ? ['dlzq', 'flrw', 'yytj'] : ['dlzq', 'flrw'];
  late final tabController = TabController(
      length: titles.length, vsync: this, initialIndex: widget.index);
  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: AppBarWithTabBar(
          tabController: tabController,
          titles: titles,
          fontSize: 15.sp,
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            KeepAliveWrapper(child: AgentView()),
            KeepAliveWrapper(child: TaskView()),
            KeepAliveWrapper(child: AppCenterView()),
          ],
        ),
      ),
    );
  }
}
