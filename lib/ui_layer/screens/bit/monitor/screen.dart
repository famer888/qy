import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/my_tab_bar.dart';
import 'content.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late final config = context.read<HomeConfigNotifier>().config;
  late final navList = config.liveTopNav;

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      titles: [for (final e in navList) e.name],
      views: [for (final e in navList) MonitorVideoView(id: e.id)],
    );
  }
}
