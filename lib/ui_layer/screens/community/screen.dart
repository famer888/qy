import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../domain/api_validator.dart';
import '../../../domain/domain.dart';
import '../../router/routes.dart';
import '../image_paths.dart';

import '../../../domain/async_value.dart';
import '../../../domain/model/post/community/community_post_nav_model.dart';
import '../../router/router.dart';
import '../common_widgets/my_image.dart';
import '../common_widgets/my_tab_bar.dart';
import '../common_widgets/screen_background.dart';
import '../common_widgets/status/loading.dart';
import '../common_widgets/status/network_error.dart';
import '../theme.dart';
import 'content.dart';
import 'issue/screen.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  Future<void> _showIssueAlert() {
    final issues = [
      (
        title: 'tp'.tr(context: context),
        iconName: MyImagePaths.appFabuPicture,
        type: CommunityIssueType.image,
      ),
      (
        title: 'spingty'.tr(context: context),
        iconName: MyImagePaths.appFabuVideo,
        type: CommunityIssueType.video,
      ),
      (
        title: 'twen'.tr(context: context),
        iconName: MyImagePaths.appFabuText,
        type: CommunityIssueType.imageAndText,
      ),
    ];
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: AppRouter.rootNavigatorKey.currentContext ?? context,
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF23262f),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.w),
            topRight: Radius.circular(10.w),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.w),
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Text(
                      'xzfblx'.tr(),
                      style: MyTheme.white16bold,
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: MyImage.asset(
                        MyImagePaths.appIssueClose,
                        width: 11.w,
                        height: 11.w,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final issue in issues)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        context.pop();
                        CommunityIssueRoute(type: issue.type, circle: false)
                            .push(context);
                      },
                      child: Column(
                        children: [
                          MyImage.asset(
                            issue.iconName,
                            width: 50.w,
                            height: 52.7.w,
                          ),
                          SizedBox(height: 4.w),
                          Text(
                            issue.title,
                            style: MyTheme.gray163_15,
                          )
                        ],
                      ),
                    )
                ],
              ),
              SizedBox(height: 42.5.w)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        body: const SafeArea(child: _Body()),
        floatingActionButton: GestureDetector(
          onTap: _showIssueAlert,
          behavior: HitTestBehavior.translucent,
          child: MyImage.asset(
            MyImagePaths.appIssueIcon,
            width: 50.w,
            height: 50.w,
          ),
        ),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late final _appDomain = context.read<CommunityDomain>();
  AsyncValue<List<CommunityPostNavModel>> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _appDomain.reqGetPostNav();

    setState(() {
      if (result.data case final data? when result.isValid) {
        _asyncValue = AsyncData(data);
      } else {
        _asyncValue = const AsyncError();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => TabBarWithView.line(
        titles: data.map((e) => e.title).toList(),
        views: data.map((e) {
          return CommunityContentView(id: e.id);
        }).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
