import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/model/ai/ai_model.dart';
import '../../../../../../domain/model/ai/ai_nav_model.dart';
import '../../../../../../domain/model/banner_model.dart';
import '../../../../../../domain/remote_domain/domains/ai.dart';
import '../../../../../notifiers/home_config_notifier.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/general_banner.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../common_widgets/my_tab_bar.dart';
import '../../../../theme.dart';
import 'widgets/card.dart';

class FaceSwapperView extends StatefulWidget {
  const FaceSwapperView({super.key});

  @override
  State<FaceSwapperView> createState() => _FaceSwapperViewState();
}

class _FaceSwapperViewState extends State<FaceSwapperView> {
  late final _aiDomain = context.read<AIDomain>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  late final homeConfig = context.read<HomeConfigNotifier>();

  late final List<AiNavModel> titles = homeConfig.config.faceTopNav;

  bool isInit = false;

  Future<List<AIModel>?> _getData({
    required int page,
    required int pageSize,
    required int id,
  }) async {
    final result = await _aiDomain.aIListFaceMaterial(
      id: id,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        bannersNotifier.value = data;
      }

      return result.data?.materials;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: bannersNotifier,
          ),
        ),
      ],
      body: TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.symmetric(
            vertical: 6.w, horizontal: MyTheme.pagePadding),
        tabBarHeight: 32.w,
        labelStyle: MyTheme.white12,
        unselectedLabelStyle: MyTheme.whiteOpacity612w400,
        titles: isInit ? [for (final title in titles) title.name] : [],
        views: [
          for (final nav in titles)
            MyListView.grid(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              childAspectRatio: FaceSwapperCard.aspectRatio,
              crossAxisSpacing: 8.w,
              itemBuilder: (context, item, index) =>
                  FaceSwapperCard(data: item),
              onFetchingMore: (currentPage, pageSize) => _getData(
                page: currentPage,
                pageSize: pageSize,
                id: nav.id,
              ),
            )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(height: 6.w),
      ValueListenableBuilder(
        valueListenable: bannersNotifier,
        builder: (context, banners, child) {
          if (banners.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            child: GeneralBanner(data: banners),
          );
        },
      ),
      SizedBox(height: 10.w),
    ]);
  }
}
