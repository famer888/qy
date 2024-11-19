import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../notifiers/home_config_notifier.dart';
import '../common_widgets/screen_background.dart';
import '../theme.dart';
import 'comic/screen.dart';
import 'live/screen.dart';
import 'monitor/screen.dart';
import 'novel/screen.dart';
import 'seed/screen.dart';

class BitScreen extends StatefulWidget {
  const BitScreen({super.key});

  @override
  State<BitScreen> createState() => _BitScreenState();
}

class _BitScreenState extends State<BitScreen> with TickerProviderStateMixin {
  late final navs = context.read<HomeConfigNotifier>().config.resourceNav;

  late final data = {
    '1': const LiveScreen(),
    '2': const MonitorScreen(),
    '3': const ComicScreen(),
    '4': const NovelScreen(),
    '5': const SeedScreen(),
  };

  late final tabController = TabController(
    length: navs.length,
    vsync: this,
  );

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _AppBar(tabController: tabController, titles: [
          for (final nav in navs) nav.title,
        ]),
        body: TabBarView(controller: tabController, children: [
          for (final nav in navs) data[nav.type] ?? const SizedBox.shrink()
        ]),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({required this.tabController, required this.titles});

  final TabController tabController;
  final List<String> titles;

  @override
  final Size preferredSize = const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      title: SizedBox(
        height: 30.w,
        child: TabBar(
          padding: EdgeInsets.zero,
          controller: tabController,
          labelPadding: EdgeInsets.zero,
          tabAlignment: TabAlignment.center,
          labelStyle: MyTheme.white255_18,
          unselectedLabelStyle: MyTheme.white06_18,
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (_) => Colors.transparent,
          ),
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: MyTheme.jellyCyanColor103224185,
            borderRadius: BorderRadius.circular(30.w),
          ),
          dividerColor: Colors.transparent,
          dividerHeight: 0,
          tabs: titles.map((e) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Tab(
                iconMargin: EdgeInsets.zero,
                height: MyTheme.navbarHegiht,
                child: Center(
                  child: Text(e),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
