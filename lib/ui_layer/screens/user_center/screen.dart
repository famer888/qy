import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/post/post_creator_info_model.dart';
import '../../../domain/model/member_model.dart';
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

class UserCenterScreen extends StatefulWidget {
  const UserCenterScreen({super.key, required this.aff});
  final String aff;
  @override
  State<UserCenterScreen> createState() => _UserCenterScreenState();
}

class _UserCenterScreenState extends State<UserCenterScreen> {
  late final communityDomain = context.read<CommunityDomain>();

  AsyncValue<PostCreatorInfoModel> _asyncValue = const AsyncInit();

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

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: const MyAppBar(),
        body: _asyncValue.maybeWhen(
          orElse: () => const LoadingView(),
          error: (_, __) => NetworkErrorView(onTap: _initData),
          data: (data) => PostCenter(
              aff: widget.aff,
              header: Selector<UserNotifier, Member>(
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
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff00f1ff),
                              Color(0xff83ea78),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
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
                            if (data.agent == 1)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'kkyhrz'.tr(context: context),
                                    style: MyTheme.gray153_15,
                                  ),
                                  SizedBox(width: 2.w),
                                  Icon(
                                    Icons.verified_sharp,
                                    size: 14.w,
                                    color:
                                        const Color.fromRGBO(247, 208, 93, 1),
                                  ),
                                ],
                              ),
                            SizedBox(height: 5.w),
                            member.uuid == data.uuid
                                ? const SizedBox.shrink()
                                : Center(
                                    child: GestureDetector(
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
                                          nickName: nick,
                                          thumb: url,
                                          toUuid: uuid,
                                        ).push(context);
                                      },
                                      child: Container(
                                        height: 24.w,
                                        width: 80.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                96, 178, 220, 1),
                                            width: 0.5.w,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(2.w),
                                          ),
                                        ),
                                        child: Text(
                                          'sxta'.tr(context: context),
                                          style: MyTheme.blue96_13_M,
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        )
                      ],
                    ),
                  );
                },
                selector: (_, notifier) => notifier.member,
              )),
        ),
      ),
    );
  }
}
