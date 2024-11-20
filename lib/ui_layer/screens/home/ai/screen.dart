import 'package:qypj/ui_layer/screens/home/ai/widgets/face_swapper/widgets/sheet.dart';

import '../../common_widgets/appbar_with_tabbar.dart';
import '../../common_widgets/screen_background.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/clothes_remover/screen.dart';
import 'widgets/face_swapper/screen.dart';

class HomeAiScreen extends StatefulWidget {
  const HomeAiScreen({super.key});

  @override
  State<HomeAiScreen> createState() => _HomeAiScreenState();
}

class _HomeAiScreenState extends State<HomeAiScreen>
    with TickerProviderStateMixin {
  late final navList = ['aihl', 'aiqy'];
  late final tabController = TabController(length: navList.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: AppBarWithTabBar(
          tabController: tabController,
          titles: navList,
          fontSize: 17.sp,
        ),
        body: TabBarView(
          controller: tabController,
          children: const [
            FaceSwapperView(),
            ClothesRemoverView(),
          ],
        ),
      ),
    );
  }
}
