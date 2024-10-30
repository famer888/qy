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
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import 'widgets/card.dart';

class FaceSwapperView extends StatefulWidget {
  const FaceSwapperView({super.key});

  @override
  State<FaceSwapperView> createState() => _FaceSwapperViewState();
}

class _FaceSwapperViewState extends State<FaceSwapperView> {
  late final homeConfig = context.read<HomeConfigNotifier>();
  late final topics = homeConfig.config.faceTopNav;
  late final currentTopicNotifier = ValueNotifier<AiFaceTopicModel>(
      topics.isNotEmpty ? topics.first : AiFaceTopicModel(id: -1, name: ''));

  final bannersNotifier = ValueNotifier<List<BannerModel>>([]);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            bannersNotifier: bannersNotifier,
            topics: topics,
            currentTopicNotifier: currentTopicNotifier,
          ),
        ),
      ],
      body: _Body(
        bannersNotifier: bannersNotifier,
        currentTopicNotifier: currentTopicNotifier,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topics,
    required this.currentTopicNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final List<AiFaceTopicModel> topics;
  final ValueNotifier<AiFaceTopicModel> currentTopicNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                  child: GeneralBanner(data: banners),
                ),
                SizedBox(height: 10.w),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    addRepaintBoundaries: false,
                    addAutomaticKeepAlives: false,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: topics.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 80.w / 35.w,
                      mainAxisSpacing: 5.w,
                      crossAxisSpacing: 5.w,
                    ),
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          currentTopicNotifier.value = topic;
                        },
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            color: const Color(0xff262631),
                          ),
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: currentTopicNotifier,
                              builder: (context, currentTopic, child) {
                                return Text(
                                  topic.name,
                                  style: topic.id == currentTopic.id
                                      ? MyTheme.jellyCyan_13
                                      : MyTheme.white13,
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.bannersNotifier,
    required this.currentTopicNotifier,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<AiFaceTopicModel> currentTopicNotifier;
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final homeConfig = context.read<HomeConfigNotifier>();
  late final sorts = homeConfig.config.faceSortNav;
  late final tabController = TabController(length: sorts.length, vsync: this);
  late final _aiDomain = context.read<AIDomain>();

  Future<List<AIFaceMaterials>?> _getData({
    required int page,
    required int pageSize,
    required int id,
    required String sort,
    required String value,
  }) async {
    final result = await _aiDomain.faceMaterialList(
      id: id,
      page: page,
      limit: pageSize,
      type: value,
      sort: sort,
    );

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && widget.bannersNotifier.value.isEmpty) {
        widget.bannersNotifier.value = data;
        setState(() {});
      }

      return result.data?.materials;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  _buildTab(AiFaceSortModel nav) {
    return Tab(
      height: MyTheme.navbarHegiht,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(nav.title),
            nav.type == 1 ? Container() : SizedBox(width: 3.w), //推荐没有排序
            nav.type == 1
                ? Container()
                : MyImage.asset(
                    nav.sort == 'asc'
                        ? MyImagePaths.appFilterUp
                        : MyImagePaths.appFilterDown,
                    width: 13.w,
                    height: 13.w,
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.bannersNotifier.value.isNotEmpty)
          TabBar(
            controller: tabController,
            isScrollable: true,
            labelStyle: MyTheme.white15_M,
            labelPadding: EdgeInsets.only(left: 5.w),
            unselectedLabelStyle: MyTheme.white07_14,
            overlayColor: WidgetStateProperty.resolveWith<Color>(
              (_) => Colors.transparent,
            ),
            onTap: (index) {
              final nav = sorts[index];
              if (nav.type == 1) return;
              if (!tabController.indexIsChanging) {
                setState(() {
                  if (nav.sort == 'asc') {
                    nav.sort = 'desc';
                  } else {
                    nav.sort = 'asc';
                  }
                });
              }
            },
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            tabs: [for (final nav in sorts) _buildTab(nav)],
          ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              for (final nav in sorts)
                ValueListenableBuilder(
                  valueListenable: widget.currentTopicNotifier,
                  builder: (_, topic, __) {
                    return MyListView.grid(
                      key: ValueKey('${topic.id}${nav.sort}'),
                      padding:
                          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                      childAspectRatio: FaceSwapperCard.aspectRatio,
                      crossAxisSpacing: 8.w,
                      itemBuilder: (context, item, index) =>
                          FaceSwapperCard(data: item),
                      onFetchingMore: (currentPage, pageSize) => _getData(
                        page: currentPage,
                        pageSize: pageSize,
                        id: topic.id,
                        sort: nav.sort,
                        value: nav.value,
                      ),
                    );
                  },
                )
            ],
          ),
        ),
      ],
    );
  }
}
