import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/enum.dart';
import '../../../../../domain/model/novel/novel_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../../domain/remote_domain/domains/user.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/keep_alive_wrapper.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_tab_bar.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../di/notifier.dart';
import 'novel_comment_content.dart';
import 'novel_intro_content.dart';

///小说详情界面
class NovelDetailScreen extends StatefulWidget {
  const NovelDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<NovelDetailScreen> createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen>
    with TickerProviderStateMixin {
  late final _domain = context.read<NovelDomain>();
  late final _novelChangeNotifier = context.read<NovelChangeNotifier>();

  AsyncValue<NovelDetailWithBannersModel> _asyncValue = const AsyncInit();

  late final tabController = TabController(length: 2, vsync: this);

  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await _domain.novelDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      if ((data.detail.likeFct == 0 && data.detail.isLike == 1)) {
        data.detail.likeFct = 1;
      }
      _asyncValue = AsyncData(data);
      await _novelChangeNotifier.setCurrentNovel(data.detail);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          rightWidget: GestureDetector(
            onTap: () {
              const MineShareToUserRoute().push(context);
            },
            child: MyImage.asset(MyImagePaths.appNavShare,
                width: 25.w, height: 25.w),
          ),
        ),
        body: _asyncValue.maybeWhen(
          orElse: () => const LoadingView(),
          error: (_, __) => NetworkErrorView(onTap: _getData),
          data: (data) => configContentView(data),
        ));
  }

  Widget configContentView(NovelDetailWithBannersModel data) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        SliverToBoxAdapter(
          child: _Header(
            data: data,
          ),
        ),
      ],
      body: Column(
        children: [
          _TabBar(
            tabController: tabController,
            titles: [
              'xq'.tr(context: context),
              '${'pl'.tr(context: context)}(${data.detail.commentCt ?? 0})'
            ],
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              NovelIntroContent(data: data),
              KeepAliveWrapper(
                  child: NovelCommentContent(id: data.detail.id ?? 0))
            ]),
          )
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabController,
    required this.titles,
  });

  final TabController tabController;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: MyTabBarTheme.line(
          labelStyle: MyTheme.jellyCyan_15.copyWith(fontSize: 15.sp),
          unselectedLabelStyle: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 1),
            fontSize: 15.sp,
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
              isScrollable: true,
              padding: EdgeInsets.symmetric(vertical: 2.w),
              controller: tabController,
              tabAlignment: TabAlignment.start,
              tabs: titles
                  .map((title) => Tab(
                        height: MyTheme.navbarHegiht,
                        text: title,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data});

  final NovelDetailWithBannersModel data;

  NovelDetailModel get detail => data.detail;

  @override
  Widget build(BuildContext context) {
    final banner = data.banner;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150.w,
            child: Row(
              children: [
                SizedBox(
                    width: 100.w,
                    height: 137.w,
                    child: MyImage.network(
                      detail.cover ?? '',
                      borderRadius: 5.w,
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: SizedBox(
                  height: 137.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        detail.title ?? '',
                        style: MyTheme.white14,
                        maxLines: 2,
                      ),
                      detail.isEnd == 1
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(255, 46, 49, 0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                              ),
                              child: Text(
                                'wj'.tr(context: context),
                                style: MyTheme.white11,
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(0, 157, 255, 0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                              ),
                              child: Text(
                                'lzz'.tr(context: context),
                                style: MyTheme.jellyCyan_11,
                              )),
                      Text(
                        '${CommonUtils.renderFixedNumber(detail.fontCt ?? 0)}字',
                        style: MyTheme.white14,
                      ),
                      Text(
                        '${'zhgx'.tr(context: context)}: ${detail.renewedAt}',
                        style: MyTheme.white04_12,
                        maxLines: 5,
                      ),
                      Text(
                        '${'zuoz'.tr(context: context)}: ${detail.author}',
                        style: MyTheme.white07_12,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MyTheme.pagePadding, top: 8.w),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    MyImage.asset(MyImagePaths.appComicView,
                        width: 20.w, height: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${CommonUtils.renderNumber(detail.viewFct ?? 0)}',
                      style: MyTheme.white04_12,
                      maxLines: 1,
                    )
                  ]),
                  Row(children: [
                    MyImage.asset(MyImagePaths.appComicComment,
                        width: 20.w, height: 20.w),
                    SizedBox(width: 3.w),
                    Text(
                      '${CommonUtils.renderNumber(detail.commentCt ?? 0)}',
                      style: MyTheme.white04_12,
                      maxLines: 1,
                    )
                  ]),
                  StatefulBuilder(builder: (_, setState) {
                    return GestureDetector(
                      onTap: () async {
                        if (detail.id case final id) {
                          final domain = context.read<UserDomain>();
                          final res = await domain.toggleUserLike(
                              type: ModuleType.novel, id: id);
                          if (res.data?.isLike case final isLike?) {
                            detail.isLike = isLike;
                            detail.likeFct += isLike == 1 ? 1 : -1;
                            setState(() {});
                          } else if (res.msg case final msg?) {
                            MyToast.showText(text: msg);
                          }
                        }
                      },
                      child: Row(children: [
                        MyImage.asset(
                            detail.isLike == 1
                                ? MyImagePaths.appCommReviewH
                                : MyImagePaths.appCommReviewN,
                            width: 21.w,
                            height: 21.w),
                        SizedBox(width: 3.w),
                        Text(
                          '${CommonUtils.renderNumber(detail.likeFct ?? 0)}',
                          style: MyTheme.white04_12,
                          maxLines: 1,
                        )
                      ]),
                    );
                  }),
                  Selector<NovelChangeNotifier, bool>(
                      selector: (_, notifier) =>
                          notifier.currentNovel.isFavorite == 1,
                      builder: (_, isFavorite, __) {
                        final novelChangeNotifier =
                            context.read<NovelChangeNotifier>();
                        return GestureDetector(
                          onTap: () {
                            novelChangeNotifier.toggleFavorite();
                          },
                          child: Row(children: [
                            MyImage.asset(
                                isFavorite
                                    ? MyImagePaths.appCollectOn
                                    : MyImagePaths.appCollectOff,
                                width: 18.w,
                                height: 18.w),
                            SizedBox(width: 3.w),
                            Text(
                              '${CommonUtils.renderNumber(novelChangeNotifier.currentNovel.favoriteFct)}',
                              style: MyTheme.white04_12,
                              maxLines: 1,
                            )
                          ]),
                        );
                      }),
                ]),
          ),
          if (banner.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 5.w),
              child: GeneralBanner(data: banner, aspectRatio: 7 / 2),
            ),
        ],
      ),
    );
  }
}
