import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../router/routes.dart';
import '../../utils/common_utils.dart';
import '../theme.dart';

import '../../../domain/type_def.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/banner_model.dart';
import '../../../domain/model/feed/feed_model.dart';
import '../../../domain/model/link_model.dart';
import '../../../domain/model/nav_model.dart';
import '../../../domain/model/navigator_model.dart';
import '../../notifiers/home_config_notifier.dart';
import '../../utils/my_toast.dart';
import 'feed/feed_card.dart';
import 'general_banner.dart';
import 'my_list_view.dart';
import 'my_tab_bar.dart';

class ApiLinkView extends StatefulWidget {
  const ApiLinkView(
      {super.key, required this.linkModel, required this.onLinkNavTap});
  final LinkModel linkModel;
  final ValueChanged<String> onLinkNavTap;
  @override
  State<ApiLinkView> createState() => _ApiLinkViewState();
}

class _ApiLinkViewState extends State<ApiLinkView> {
  late final _appDomain = context.read<AppDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  final ValueNotifier<List<BannerModel>> bannersNotifier = ValueNotifier([]);
  final ValueNotifier<List<NavModel>> topicsNotifier = ValueNotifier([]);
  late final List<NavigatorModel> titles = _homeConfig.config.sortNav ?? [];

  bool isInit = false;

  Future<List<FeedModel>?> _getData({
    required int page,
    required int pageSize,
    required String type,
  }) async {
    final param = Map.from(widget.linkModel.params)
      ..['page'] = page
      ..['limit'] = pageSize
      ..['sort'] = type;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: widget.linkModel.api,
      params: param,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data['banner'] case final List data
          when data.isNotEmpty && bannersNotifier.value.isEmpty) {
        final banner = data.map((x) => BannerModel.fromJson(x)).toList();
        bannersNotifier.value = banner;
      }
      if (result.data['nav'] case final List data
          when data.isNotEmpty && topicsNotifier.value.isEmpty) {
        final nav = data.map((x) => NavModel.fromJson(x)).toList();
        topicsNotifier.value = nav;
      }
      return result.data['list']
          ?.map<FeedModel>((x) => FeedModel.fromJson(x))
          .toList();
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
            topicsNotifier: topicsNotifier,
            onLinkNavTap: widget.onLinkNavTap,
          ),
        ),
      ],
      body: TabBarWithView.fillColor(
        tabBarPadding: EdgeInsets.symmetric(
            vertical: 6.w, horizontal: MyTheme.pagePadding),
        tabBarHeight: 32.w,
        labelStyle: MyTheme.white12,
        unselectedLabelStyle: MyTheme.whiteOpacity612w400,
        titles: isInit ? [for (final title in titles) title.title] : [],
        views: [
          for (final NavigatorModel nav in titles)
            MyListView.grid(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              childAspectRatio: FeedCard.aspectRatio,
              crossAxisSpacing: 8.w,
              itemBuilder: (context, item, index) => FeedCard(feed: item),
              onFetchingMore: (currentPage, pageSize) => _getData(
                page: currentPage,
                pageSize: pageSize,
                type: nav.type,
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
    required this.topicsNotifier,
    required this.onLinkNavTap,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<NavModel>> topicsNotifier;
  final ValueChanged<String> onLinkNavTap;

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
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBanner(data: banners),
            );
          },
        ),
        SizedBox(height: 10.w),
        ValueListenableBuilder(
          valueListenable: topicsNotifier,
          builder: (context, topics, child) {
            if (topics.isEmpty) return const SizedBox.shrink();
            return Padding(
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
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.w,
                  ),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        color: const Color(0xff262631),
                      ),
                      child: Center(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            final linkUrl = topic.linkUrl;
                            final redirectType = topic.redirectType;
                            if (linkUrl.isEmpty) {
                              return;
                            }

                            if (redirectType < 3) {
                              CommonUtils.openRoute(context, topic.toJson());
                            } else {
                              if (topic.openType == 0) {
                                onLinkNavTap(topic.linkUrl);
                              } else if (topic.openType == 1) {
                                MoreVideoRoute(
                                        name: topic.name, id: topic.linkUrl)
                                    .push(context);
                              }
                            }
                          },
                          child: Text(
                            topic.name,
                            style: MyTheme.white13,
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
        Divider(
          color: Colors.white.withOpacity(0.04),
          height: 10,
          indent: MyTheme.pagePadding,
          endIndent: MyTheme.pagePadding,
        ),
      ],
    );
  }
}
