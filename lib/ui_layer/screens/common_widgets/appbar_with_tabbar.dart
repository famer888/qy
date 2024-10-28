import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../image_paths.dart';
import '../theme.dart';
import 'my_tab_bar.dart';

class AppBarWithTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWithTabBar({
    super.key,
    required this.tabController,
    required this.titles,
    required this.fontSize,
  });

  final TabController tabController;
  final List<String> titles;
  final double fontSize;

  @override
  final Size preferredSize = const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
          tabBarTheme: MyTabBarTheme.line(
            labelStyle: MyTheme.jellyCyan_15.copyWith(fontSize: fontSize),
            unselectedLabelStyle: TextStyle(
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontSize: fontSize,
              overflow: TextOverflow.visible,
              decoration: TextDecoration.none,
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
                tabs: titles
                    .map((title) => Tab(
                          height: MyTheme.navbarHegiht,
                          text: title.tr(context: context),
                        ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
