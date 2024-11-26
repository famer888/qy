import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/banner_model.dart';
import '../../../../domain/model/girl/girl_index_model.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/girl/girl_option_model.dart';
import '../../../../domain/model/girl_sort_model.dart';
import '../../../../domain/model/navigator_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../../../domain/model/topic_model.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/girl/card.dart';
import '../../common_widgets/girl/list_card.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/general_banner.dart';
import '../../common_widgets/my_list_view.dart';
import '../../common_widgets/post/card/card.dart';
import '../../image_paths.dart';
import '../../theme.dart';

class GirlScreen extends StatefulWidget {
  const GirlScreen({super.key});
  @override
  State<GirlScreen> createState() => _GirlScreenState();
}

class _GirlScreenState extends State<GirlScreen> with TickerProviderStateMixin {
  late final _domain = context.read<GirlDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<TopicModel>> topicsNotifier = ValueNotifier([]);

  late final List<GirlSortModel> _titles = _homeConfig.config.girlSort;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final List<GlobalKey<MyListViewState>> _listViewKeys = [];

  late TabController _tabController;

  bool isInit = false;

  List<GirlOptionModel> options = [];

  Map<String, dynamic> _filterMap = {};
  Map _filterTempMap = {};

  // final key = GlobalKey<MyListViewState>();

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < _titles.length; i++) {
      _listViewKeys.add(GlobalKey<MyListViewState>());
    }

    _tabController = TabController(length: _titles.length, vsync: this);

    getOptionData();
  }

  _showFilterView() {
    _scaffoldKey.currentState?.openEndDrawer();
    // showModalBottomSheet(context: context, builder: builder)
  }

  Widget filterView() {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      color: MyTheme.bgColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Column(
            children: [
              SizedBox(
                height: MyTheme.navbarHegiht, // + MyTheme.navHegiht,
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    GirlOptionModel itemMap = options[index];
                    List<GirlOptionItemModel> items =
                        List.from(itemMap.items ?? []);
                    return Column(
                      children: [
                        Container(
                          height: 27.w,
                          margin: EdgeInsets.symmetric(vertical: 10.w),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            options[index].label ?? '',
                            style: MyTheme.white255_15_semibold,
                          ),
                        ),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: 80 / 30,
                                    mainAxisSpacing: 10.w,
                                    crossAxisSpacing: 8.w),
                            itemBuilder: (context, iIndex) {
                              GirlOptionItemModel item = items[iIndex];
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (_filterTempMap[itemMap.value] ==
                                      item.value) {
                                    _filterTempMap[itemMap.value] = null;
                                  } else {
                                    _filterTempMap[itemMap.value] = item.value;
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: _filterTempMap[itemMap.value] ==
                                              item.value
                                          ? MyTheme.red220Color
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: MyTheme.red22005Color,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(2.w)),
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        item.name ?? '',
                                        style: _filterTempMap[itemMap.value] ==
                                                item.value
                                            ? MyTheme.white255_14
                                            : MyTheme.font_red_220_14,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                      ],
                    );
                  }),
              SizedBox(
                height: 130.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _filterTempMap = {};
                      setState(() {});
                    },
                    child: Container(
                      width: 140.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                          color: MyTheme.red220Color,
                          borderRadius: BorderRadius.circular(20.w)),
                      alignment: Alignment.center,
                      child: Text(
                        'chz'.tr(),
                        style: MyTheme.white255_14,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _filterMap = Map.from(_filterTempMap);
                      // _getData(page: 1, pageSize: 15, sort: 'hot');
                      setState(() {});

                      _scaffoldKey.currentState?.closeEndDrawer();

                      _listViewKeys[_tabController.index]
                          .currentState
                          ?.reloadPage();
                    },
                    child: Container(
                      width: 140.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                          color: MyTheme.red220Color,
                          borderRadius: BorderRadius.circular(20.w)),
                      alignment: Alignment.center,
                      child: Text(
                        'qd'.tr(),
                        style: MyTheme.white255_14,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 64.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  getOptionData() async {
    final result = await _domain.getOptions();

    if (result.status == 1) {
      if (result.data case final data? when data.isNotEmpty) {
        options = data;

        for (var element in options) {
          if (element.value == 'class') {
            List<GirlOptionItemModel> girlClassList =
                List.from(element.items ?? []);

            // GirlCacheDomain cache = context.read<GirlCacheDomain>();
            // cache.upsertGirlClasses(
            //     list: girlClassList.map((x) => x.toJson()).toList());

            AppGlobal.girlClassList = girlClassList;
            break;
          }
        }

        if (mounted) setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    // return null;
  }

  Future<List<GirlListModel>?> _getData({
    required int page,
    required int pageSize,
    required String sort,
  }) async {
    Map<String, dynamic> param = {};
    for (var key in _filterMap.keys) {
      if (_filterMap[key] != null) {
        param[key] = _filterMap[key];
      }
    }

    param.addAll({'sort': sort});
    final result = await _domain.girlIndex(
      girlOptions: param,
      page: page,
      limit: pageSize,
    );

    if (!isInit) {
      setState(() {
        isInit = true;
      });
    }

    if (result.status == 1) {
      if (result.data?.banner case final data? when data.isNotEmpty) {
        _bannersNotifier.value = data;
      }

      // if (result.data?.notice case final data? when data.isNotEmpty) {
      //   topicsNotifier.value = data;
      // }

      if (result.data?.girls case final girls?) {
        return girls;
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: filterView(),
      key: _scaffoldKey,
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: _Header(
                  bannersNotifier: _bannersNotifier,
                  topicsNotifier: topicsNotifier,
                  filterAction: () {
                    _showFilterView();
                  },
                ),
              ),
            ],
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: TabBarWithView.fillColor(
                tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
                tabBarHeight: 32.w,
                isScrollable: true,
                tabController: _tabController,
                titles: isInit
                    ? [for (final title in _titles) title.title ?? '']
                    : [],
                views: [
                  for (final GirlSortModel nav in _titles)
                    MyListView.grid(
                      key: _listViewKeys[_titles.indexOf(nav)],
                      // contentPadding: 15.w,
                      padding:
                          EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
                      childAspectRatio: 165 / (213 + 68),

                      itemBuilder: (context, item, index) => GirlCard(
                        data: item,
                      ),
                      onFetchingMore: (currentPage, pageSize) => _getData(
                        page: currentPage,
                        pageSize: pageSize,
                        sort: nav.type ?? '', // nav.sort ?? ''
                      ),
                    )
                ],
              ),
            ),
          ),
          // Positioned(
          //   right: 20.w,
          //   bottom: MyTheme.navbarHegiht + MyTheme.pagePadding * 2,
          //   child: GestureDetector(
          //     onTap: () {
          //       // Utils.navTo(context, '/homedatepublishpage');

          //       GirlIssueRoute().push(context);
          //     },
          //     child: MyImage.asset(
          //       MyImagePaths.appGirlPublish,
          //       width: 40.w,
          //       height: 40.w,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.topicsNotifier,
    this.filterAction,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TopicModel>> topicsNotifier;

  final Function? filterAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 36.w,
          margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 36.w,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      // border: Border.all(
                      //     color: MyTheme.black31Color, width: 1.5.w),
                      borderRadius: BorderRadius.all(Radius.circular(17.5.w))),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // Utils.navTo(context, "/homesearchpage");
                    },
                    child: Row(
                      children: [
                        SizedBox(width: 10.w),
                        // LocalPNG(name: "hls_search", width: 20.w, height: 20.w),
                        SizedBox(width: 10.w),
                        Expanded(
                            child: Text("qsrssgjz".tr(),
                                style: MyTheme.white08_14_M,
                                textAlign: TextAlign.left)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  // showFilterView();

                  filterAction?.call();
                },
                child: Row(
                  children: [
                    MyImage.asset(
                      MyImagePaths.appGirlFilter,
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(
                      width: 7.5.w,
                    ),
                    Text(
                      'sx'.tr(),
                      style: MyTheme.white255_14_M,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        // SizedBox(height: 6.w),
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
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2,
                  mainAxisSpacing: 10.w,
                  crossAxisSpacing: 10.w,
                ),
                primary: false,
                padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.w),
                        ),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentDirectional.center,
                        children: [
                          MyImage.network(
                            topic.bgThumb,
                            borderRadius: 6.w,
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              CommunityTagDetailRoute('${topic.id}')
                                  .push(context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  topics[index].name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 2.w),
                                Center(
                                    child: Text(
                                  "${topic.postNum}${'tiez'.tr(context: context)}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ],
                      ));
                },
                itemCount: topics.length,
              ),
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
