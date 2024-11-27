import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/banner_model.dart';
import '../../../../domain/model/chat/chat_index_model.dart';
import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../../domain/model/chat_nav_model.dart';
import '../../../../domain/model/girl/girl_option_model.dart';
import '../../../../domain/model/tip_model.dart';
import '../../../../domain/remote_domain/domains/index.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../common_widgets/chat/card.dart';
import '../../common_widgets/marquee.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../../notifiers/home_config_notifier.dart';
import '../../common_widgets/general_banner.dart';
import '../../common_widgets/my_list_view.dart';
import '../../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final _tipsNotifier = ValueNotifier<List<TipModel>>([]);

  late final List<ChatNavModel> _titles = _homeConfig.config.chatNav;

  List<GirlOptionModel> options = [];

  Map<String, dynamic> _filterMap = {};
  Map _filterTempMap = {};

  void headerFunc(List<BannerModel> bannerList, List<TipModel> tipList) {
    _bannersNotifier.value = bannerList;
    _tipsNotifier.value = tipList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverToBoxAdapter(
                child: _Header(
                  bannersNotifier: _bannersNotifier,
                  tipsNotifier: _tipsNotifier,
                ),
              ),
            ],
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: TabBarWithView.fillColor(
                tabBarPadding: EdgeInsets.symmetric(vertical: 6.w),
                tabBarHeight: 32.w,
                isScrollable: true,
                titles: [for (final title in _titles) title.name ?? ''],
                views: [
                  for (final ChatNavModel nav in _titles)
                    ChatChildScreen(
                      nav: nav,
                      headerFunc: _titles.indexOf(nav) == 0 ? headerFunc : null,
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
          //       const ChatIssueRoute().push(context);
          //     },
          //     child: MyImage.asset(
          //       MyImagePaths.appChatPublish,
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
    required this.tipsNotifier,
    this.filterAction,
  });
  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  final Function? filterAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (_, tips, __) => MyMarqueeTipsWidget(tips: tips),
        ),
        // Divider(
        //   color: Colors.white.withOpacity(0.04),
        //   height: 10,
        //   indent: MyTheme.pagePadding,
        //   endIndent: MyTheme.pagePadding,
        // ),
      ],
    );
  }
}

class ChatChildScreen extends StatefulWidget {
  ChatChildScreen({
    super.key,
    required this.nav,
    this.headerFunc,
  });
  ChatNavModel nav;
  Function(List<BannerModel> bannerList, List<TipModel> tipList)? headerFunc;

  @override
  State<ChatChildScreen> createState() => _ChatChildScreenState();
}

class _ChatChildScreenState extends State<ChatChildScreen> {
  late final _domain = context.read<ChatDomain>();

  Future<List<ChatListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = widget.nav.type == 2
        ? await _domain.chatSortIndex(
            sort: widget.nav.sort!,
            page: page,
            limit: pageSize,
          )
        : await _domain.chatIndex(
            id: widget.nav.id ?? 0,
            page: page,
            limit: pageSize,
          );

    if (widget.headerFunc != null) {
      List<BannerModel> banner = [];

      List<TipModel> tips = [];

      if (result.data?.banner case final data? when data.isNotEmpty) {
        banner = data;
      }
      if (result.data?.tips case final data? when data.isNotEmpty) {
        tips = data;
      }

      widget.headerFunc?.call(banner, tips);
    }

    if (result.data?.chats case final chats) {
      return chats;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      // contentPadding: 15.w,
      padding: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
      childAspectRatio: 165 / (213 + 68),

      itemBuilder: (context, item, index) => ChatCard(
        data: item,
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
