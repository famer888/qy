import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:provider/provider.dart';

import '../../../../domain/domain.dart';
import '../../../../domain/model/banner_model.dart';
import '../../../../domain/model/chat/chat_index_model.dart';
import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../../domain/model/chat_nav_model.dart';
import '../../../../domain/model/girl/girl_index_model.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/girl/girl_option_model.dart';
import '../../../../domain/model/girl_sort_model.dart';
import '../../../../domain/model/navigator_model.dart';
import '../../../../domain/model/post/post_model.dart';
import '../../../../domain/model/topic_model.dart';
import '../../../../domain/type_def.dart';
import '../../../notifiers/user_notifier.dart';
import '../../../router/routes.dart';
import '../../../utils/app_global_data.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/chat/card.dart';
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final _userNotifier = context.read<UserNotifier>();

  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  final ValueNotifier<List<TopicModel>> topicsNotifier = ValueNotifier([]);

  late final List<ChatNavModel> _titles = _homeConfig.config.chatNav;

  List<GirlOptionModel> options = [];

  Map<String, dynamic> _filterMap = {};
  Map _filterTempMap = {};

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
                  topicsNotifier: topicsNotifier,
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

class ChatChildScreen extends StatefulWidget {
  ChatChildScreen({super.key, required this.nav});
  ChatNavModel nav;

  @override
  State<ChatChildScreen> createState() => _ChatChildScreenState();
}

class _ChatChildScreenState extends State<ChatChildScreen> {
  late final _domain = context.read<ChatDomain>();

  Future<List<ChatListModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    AsyncResult result;
// AsyncResult

    ChatIndexModel indexModel;
    if (widget.nav.type == 2) {
      final result = await _domain.chatSortIndex(
        sort: widget.nav.sort!,
        page: page,
        limit: pageSize,
      );
      // indexModel = result.data

      if (result.data?.chats case final chats) {
        return chats;
      }
    } else {
      final result = await _domain.chatIndex(
        id: widget.nav.id ?? 0,
        page: page,
        limit: pageSize,
      );

      if (result.data?.chats case final chats) {
        return chats;
      }
    }

    // if (result.status == 1) {
    //   // if (result.data?.banner case final data? when data.isNotEmpty) {
    //   //   _bannersNotifier.value = data;
    //   // }

    //   // if (result.data?.notice case final data? when data.isNotEmpty) {
    //   //   topicsNotifier.value = data;
    //   // }

    //   if (result.data.chats case final chats?) {
    //     return chats;
    //   }
    // } else {
    //   MyToast.showText(text: result.msg ?? '');
    // }
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
