import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qypj/domain/model/mine/video/mine_video_model.dart';
import 'package:qypj/domain/model/video/video_model.dart';
import 'package:qypj/ui_layer/screens/common_widgets/follow_button.dart';
import 'package:qypj/ui_layer/screens/common_widgets/keep_alive_wrapper.dart';
import 'package:qypj/ui_layer/screens/common_widgets/my_list_view.dart';
import 'package:qypj/ui_layer/screens/common_widgets/my_tab_bar.dart';
import 'package:qypj/ui_layer/screens/common_widgets/video/card/video_card.dart';
import 'package:qypj/ui_layer/screens/mine/common_widgets/video_tile.dart';
import 'package:qypj/ui_layer/utils/common_utils.dart';

import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/post/post_creator_info_model.dart';
import '../../../domain/model/member_model.dart';
import '../../../domain/type_def.dart';
import '../../notifiers/user_notifier.dart';
import '../../router/routes.dart';
import '../../utils/my_toast.dart';
import '../common_widgets/member_vip.dart';
import '../common_widgets/my_app_bar.dart';
import '../common_widgets/my_avatar.dart';
import '../common_widgets/post/center/post_center.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/loading.dart';
import '../common_widgets/status/network_error.dart';
import '../theme.dart';

import '../../../report/ui_layer/report_gesture_detector.dart';

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key, required this.aff});
  final String aff;
  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  late final communityDomain = context.read<CommunityDomain>();
  late final userNotifier = context.read<UserNotifier>();

  AsyncValue<PostCreatorInfoModel> _asyncValue = const AsyncInit();
  var controller = ScrollController();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await communityDomain.peerCenterInfo(aff: widget.aff);

    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg? when msg.isNotEmpty) {
        MyToast.showText(
          text: msg,
        );
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget configSubListView(PostCreatorInfoModel data) {
    return Container(
      child: TabBarWithView.line(
        isCenter: true,
        initialIndex: 0,
        tabBarPadding: EdgeInsets.symmetric(horizontal: 10.w),
        titles: [
          'csp'.tr(context: context),
          'tiezt'.tr(context: context),
        ],
        views: [
          KeepAliveWrapper(
            child: _VideoView(aff: widget.aff),
          ),
          KeepAliveWrapper(
            child: PostCenter(aff: widget.aff),
          ),
        ],
      ),
    );
  }

  Widget _headerView(PostCreatorInfoModel data) {
    return Selector<UserNotifier, Member>(
      builder: (_, member, __) {
        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MyTheme.pagePadding, vertical: 10.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyAvatar(
                thumb: data.thumb,
                size: 63.w,
                gradient: MyTheme.gradient_90_114,
                margin: 2,
              ),
              SizedBox(height: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.nickname ?? 'kkyh'.tr(context: context),
                        style: MyTheme.white16bold,
                      ),
                      SizedBox(width: 5.w),
                      MemberVipWidget(showText: data.vipStr),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: CommonUtils.renderFixedNumber(
                                  data.followCount ?? 0),
                              style: MyTheme.gray102_15,
                            ),
                            TextSpan(
                              text: '${'fans'.tr(context: context)}  ',
                              style: MyTheme.gray102_15,
                            )
                          ])),
                      data.agent == 1
                          ? Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            'kkyhrz'.tr(context: context),
                            style: MyTheme.gray102_15,
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.verified_sharp,
                            size: 14.w,
                            color: const Color.fromRGBO(
                                247, 208, 93, 1),
                          ),
                        ],
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      member.uuid == data.uuid
                          ? const SizedBox.shrink()
                          : Center(
                        child: ReportGestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if ((member.username ?? '').isEmpty) {
                              MyToast.showText(
                                  text: 'zcyhcz'
                                      .tr(context: context));
                              return;
                            }
                            final uuid = data.uuid!;
                            final nick = data.nickname!;
                            final url =
                            data.thumb?.isNotEmpty == true
                                ? data.thumb!
                                : ' ';
                            ChatMessageRoute(
                              nickName: Uri.encodeComponent(nick),
                              thumb: Uri.encodeComponent(url),
                              toUuid: uuid,
                            ).push(context);
                          },
                          child: Container(
                            height: 24.w,
                            width: 80.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: MyTheme.cyanColor00edfd,
                                width: 0.5.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(2.w),
                              ),
                            ),
                            child: Text(
                              'sxta'.tr(context: context),
                              style: MyTheme.jellyCyan_13,
                            ),
                          ),
                        ),
                      ),
                      member.uuid == data.uuid
                          ? const SizedBox.shrink()
                          : Selector<UserNotifier, bool>(
                          selector: (_, notifier) =>
                              notifier.userFollowingStatus.contains('${data.aff}'),
                          builder: (_, isFollowed, __) {
                            return Container(
                              margin: EdgeInsets.only(left: 10.w),
                              child: FollowButton(
                                  isFollowed: isFollowed,
                                  onTap: () async {
                                    await userNotifier.changeUserFollow('${data.aff}');
                                  }),
                            );
                          })
                    ],
                  )
                ],
              )
            ],
          ),
        );
      },
      selector: (_, notifier) => notifier.member,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: _asyncValue.maybeWhen(
        orElse: () => const LoadingView(),
        error: (_, __) => NetworkErrorView(onTap: _initData),
        data: (data) => NestedScrollView(
          controller: controller,
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: _headerView(data),
            ),
          ],
          body: configSubListView(data),
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.aff});

  final String aff;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  late final _appDomain = context.read<AppDomain>();

  Future<List<MineVideoModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final param = Map.from({})
      ..['page'] = page
      ..['limit'] = pageSize
      ..['aff'] = widget.aff;

    final result = await _appDomain.getConstructByApiLink(
      apiLink: 'api/mv/peer_mvs',
      params: param,
    );

    if (result.status == 1) {
      return result.data?.map<MineVideoModel>((x) => MineVideoModel.fromJson(x)).toList();
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: 163 / 159,
      itemBuilder: (context, item, index) => MineVideoTile(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
