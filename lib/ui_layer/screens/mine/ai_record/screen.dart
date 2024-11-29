import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import 'content/clothes_remover_record.dart';
import 'content/face_swapper_record.dart';

class MineAIRecordScreen extends StatefulWidget {
  const MineAIRecordScreen({super.key});

  @override
  State<MineAIRecordScreen> createState() => _MineAIRecordScreenState();
}

class _MineAIRecordScreenState extends State<MineAIRecordScreen>
    with TickerProviderStateMixin {
  List<String> navList = [
    tr('aihl'),
    tr('aiqy'),
  ];
  late final tabController = TabController(length: navList.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: _AppBar(
          tabController: tabController,
          titles: navList,
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            KeepAliveWrapper(
              child: MineFaceSwapperRecordContent(),
            ),
            KeepAliveWrapper(
              child: MineClothesRemoverRecordContent(),
            ),
          ],
        ),
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
      leadingWidth: 40.w,
      leading: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Image.asset(
            MyImagePaths.appBackIcon,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
      actions: [SizedBox(width: 40.w)],
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.white),
      title: Theme(
        data: Theme.of(context).copyWith(
          tabBarTheme: MyTabBarTheme.fillColor(
            labelStyle: MyTheme.white255_18,
            unselectedLabelStyle: MyTheme.white06_18,
            indicator: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30.w),
            ),
          ),
        ),
        child: RepaintBoundary(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SizedBox(
              height: 41.w,
              child: TabBar(
                physics: const BouncingScrollPhysics(),
                isScrollable: false,
                padding: EdgeInsets.symmetric(vertical: 2.w),
                controller: tabController,
                tabAlignment: TabAlignment.center,
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
          ),
        ),
      ),
    );
    //
    // return AppBar(
    //   centerTitle: true,
    //   backgroundColor: Colors.transparent,
    //   title: SizedBox(
    //     height: 30.w,
    //     child: TabBar(
    //       padding: EdgeInsets.zero,
    //       controller: tabController,
    //       labelPadding: EdgeInsets.zero,
    //       tabAlignment: TabAlignment.center,
    //       labelStyle: MyTheme.white255_18,
    //       unselectedLabelStyle: MyTheme.white06_18,
    //       overlayColor: WidgetStateProperty.resolveWith<Color>(
    //         (_) => Colors.transparent,
    //       ),
    //       indicatorColor: Colors.transparent,
    //       indicator: BoxDecoration(
    //         color: MyTheme.jellyCyanColor103224185,
    //         borderRadius: BorderRadius.circular(30.w),
    //       ),
    //       dividerColor: Colors.transparent,
    //       dividerHeight: 0,
    //       tabs: titles.map((e) {
    //         return Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 15.w),
    //           child: Tab(
    //             iconMargin: EdgeInsets.zero,
    //             height: MyTheme.navbarHegiht,
    //             child: Center(
    //               child: Text(e),
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );
  }
}
