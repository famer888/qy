import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/domain.dart';
import '../../../../../domain/model/member_model.dart';
import '../../../../../domain/model/welfare_task_model.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_avatar.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/status/empty_data.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late final config = context.read<HomeConfigNotifier>().config;
  late final userNotifier = context.read<UserNotifier>();
  late final signDomain = context.read<SignDomain>();
  AsyncValue<WelfareTaskModel> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = AsyncLoading(value: _asyncValue.data);
    });

    final res = await signDomain.signListTask();

    if (!mounted) return;

    if (res.data case final data?) {
      userNotifier.setExp(data.exp);
      _asyncValue = AsyncData(data);
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future _signUp() async {
    MyToast.showLoading();
    final res = await signDomain.signUp();
    MyToast.closeAllLoading();
    if (res.isValid) {
      await userNotifier.init(); //签到成功更新用户数据
      _initData(); //刷新当前界面数据
    } else if (res.msg case final msg?) {
      MyToast.showText(text: msg);
    }
  }

  Widget _buildDataView(WelfareTaskModel data) {
    return CustomScrollView(
      // physics: const BouncingScrollPhysics(
      //   parent: AlwaysScrollableScrollPhysics(),
      // ),
      slivers: [
        MyIndicator(onRefresh: _initData),
        SliverList.list(children: [
          SizedBox(height: 13.w),
          _MemberView(
            data: data,
            signCall: () {
              ///立即签到
              _signUp();
            },
          ),
          _signInContent(data),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.circular(10.w),
              color: MyTheme.white008Color,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: MyTheme.pagePadding, vertical: MyTheme.pagePadding),
            padding: EdgeInsets.symmetric(
                horizontal: MyTheme.pagePadding, vertical: 5.w),
            child: Column(
              children: [
                _Header(data: data),
                (data.list == null || data.list?.isEmpty == true)
                    ? Column(
                        children: [
                          SizedBox(height: 20.w),
                          const PageEmptyDataView(),
                          SizedBox(height: 0.5.sh),
                        ],
                      )
                    : ListView.builder(
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: false,
                        shrinkWrap: true,
                        cacheExtent: 1.sh,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.list?.length,
                        itemBuilder: (context, index) => _Tile(
                          data: data.list![index],
                          getTaskData: _initData,
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 50.w),
        ]),
      ],
    );
  }

  //签到view
  Widget _signInContent(WelfareTaskModel data) {
    return data.signRewardList == null
        ? Container()
        : Container(
            margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            padding: EdgeInsets.all(MyTheme.pagePadding),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'zmrrw'.tr(context: context),
                    style: MyTheme.white18bold,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'ljl'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                  const Spacer(),
                  Text(
                    'yljqd'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                  Text(
                    ' ${data.signNum} ',
                    style: MyTheme.yellow_12,
                  ),
                  Text(
                    'tian'.tr(context: context),
                    style: MyTheme.white04_12,
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              LayoutBuilder(builder: (_, c) {
                final spacing = 10.w;
                final itemW = (c.maxWidth - spacing * 3) / 4;
                final dataList = [...data.signRewardList!];
                final latestItem = dataList.removeLast();
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    for (final e in dataList)
                      SizedBox(
                        width: itemW,
                        child: siginItem(e, data.signNum ?? 0),
                      ),
                    SizedBox(
                      width: itemW * 2 + spacing,
                      child: siginItem(latestItem, data.signNum ?? 0),
                    ),
                  ],
                );
              }),
              SizedBox(height: 15.w),
              GestureDetector(
                onTap: () {
                  //兑换VIP
                  const VipCenterRoute().push(context);
                },
                child: MyButton.gradient(
                  onPressed: () async {},
                  minimumSize: Size(260.w, 40.w),
                  text: 'dhvp'.tr(context: context),
                ),
              ),
            ]),
          );
  }

  Widget siginItem(WelfareTaskListModel data, int signNum) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: MyTheme.white02Color,
        borderRadius: BorderRadius.all(
          Radius.circular(10.w),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                decoration: BoxDecoration(
                  // color: MyTheme.jellyCyanColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.w),
                    bottomRight: Radius.circular(10.w),
                  ),
                ),
                child: Text(
                  data.title ?? '',
                  style: MyTheme.white10,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyImage.asset(
                          (data.desc?.contains('积分') ?? false)
                              ? MyImagePaths.appSingInJf
                              : (data.desc?.contains('VIP') ?? false)
                                  ? MyImagePaths.appSingInVip
                                  : MyImagePaths.appSingInJb,
                          width: 35.w,
                          height: 35.w),
                      SizedBox(height: 5.w),
                      Text(
                        data.desc ?? '',
                        style: MyTheme.yellow_11,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          data.sort == 7
              ? Positioned(
                  right: 0,
                  top: 0,
                  child: MyImage.asset(MyImagePaths.appSiginCz,
                      width: 30.w, height: 30.w))
              : Container(),
          (data.sort ?? 0) <= signNum
              ? Container(
                  color: Colors.black45,
                  child: Center(
                      child: Text(
                    'yqiandao'.tr(context: context),
                    style: MyTheme.white14,
                  )))
              : Container(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _initData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
  }
}

class _MemberView extends StatelessWidget {
  const _MemberView({required this.data, required this.signCall});

  final WelfareTaskModel data;

  final Function signCall;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.w,
      child: Padding(
        padding: EdgeInsets.only(
            left: MyTheme.pagePadding, right: 6.w, bottom: MyTheme.pagePadding),
        child: Column(
          children: [
            Selector<UserNotifier, Member?>(
              selector: (_, notifier) => notifier.member,
              builder: (context, member, child) {
                return member == null
                    ? const SizedBox.shrink()
                    : Container(
                        height: 53.w,
                        margin: EdgeInsets.only(
                            left: MyTheme.pagePadding,
                            right: MyTheme.pagePadding,
                            bottom: MyTheme.pagePadding),
                        child: Row(
                          children: [
                            MyAvatar(
                              size: 53.w,
                              thumb: member.thumb,
                            ),
                            SizedBox(width: 9.w),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Text(member.nickname,
                                            style: MyTheme.white18mudium),
                                        SizedBox(width: 9.w),
                                        member.vipLevel > 0
                                            ? MyImage.asset(
                                                MyImagePaths.appTaskVipIcon,
                                                width: 39.w,
                                                height: 18.w)
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        member.vipLevel > 0
                                            ? Flexible(
                                                child: Text(
                                                    'vpwxk'
                                                        .tr(context: context),
                                                    style: MyTheme.white07_12),
                                              )
                                            : Text(
                                                '${'sygkcs'.tr(context: context)}: ${data.freeViewCnt}/${data.totalFreeViewCnt}',
                                                style: MyTheme.white07_12),
                                        SizedBox(width: 10.w),
                                        Text('${'jbye'.tr(context: context)}: ',
                                            style: MyTheme.white07_12),
                                        Text('${member.money}',
                                            style: MyTheme.yellow_12),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
            MyButton.gradient(
              minimumSize: Size(260.w, 40.w),
              onPressed: () async {
                signCall.call();
              },
              text: 'ljqd'.tr(context: context),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.data});

  final WelfareTaskModel data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 13.w),
        Row(
          children: [
            Text(
              'flrw'.tr(context: context),
              style: MyTheme.white18bold,
            ),
            SizedBox(width: 10.w),
            Text(
              '${'ts'.tr(context: context)}: ${'rwwchsx'.tr(context: context)}',
              style: MyTheme.white04_12,
            )
          ],
        ),
        SizedBox(height: 20.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${'yqrs'.tr(context: context)}${data.invitedNum}人',
                style: MyTheme.white14),
            Selector<UserNotifier, Member?>(
                builder: (context, member, child) {
                  return Text(
                      '${'wdjf'.tr(context: context)}${member?.exp ?? ''}',
                      style: MyTheme.white14);
                },
                selector: (_, notifier) => notifier.member),
            MyButton.gradient(
              onPressed: () async {
                const VipCenterRoute().push(context);
              },
              minimumSize: Size(75.w, 32.w),
              child: Text(
                tr('dhvp'),
                style: MyTheme.white12,
              ),
            )
          ],
        ),
        SizedBox(height: 10.w),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.data, required this.getTaskData});

  final WelfareTaskListModel data;
  final VoidCallback getTaskData;

  /// 领取
  _tapSignListTask(BuildContext context) async {
    MyToast.showLoading();
    final Map param = {'task_id': data.id};

    final result = await context.read<SignDomain>().signListTaskAccept(param);
    result.status == 1 ? getTaskData() : MyToast.showText(text: result.msg!);

    MyToast.closeAllLoading();
  }

  @override
  Widget build(BuildContext context) {
    final int type = data.taskType!;
    int state = data.progressStatus!;

    /// 0 = 未开始，1 = 未完成 ，2 = 待领取奖励， 3 = 已经领取
    state = state == 0 ? 1 : state;
    return Container(
      constraints: BoxConstraints(minHeight: 70.w),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 42.w,
            child: MyImage.network(
              data.icon ?? '',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.title}',
                    style: MyTheme.white14,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${data.subTitle}',
                    style: MyTheme.white07_10,
                    maxLines: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          MyButton.gradient(
            gradient: state == 3
                ? const LinearGradient(
                    colors: [
                      Color.fromRGBO(150, 150, 150, 1),
                      Color.fromRGBO(150, 150, 150, 1)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : null,
            onPressed: () async {
              if (state == 2) {
                _tapSignListTask(context);
              } else {
                if (type == 3) {
                  if (state != 2) {
                    CommonUtils.launchUrl(data.appUrl!);
                  }
                } else if (type >= 4 && type <= 7) {
                  // text = state != 2 ? '去邀请' : '领取';
                  const MineShareToUserRoute().push(context);
                }
              }
            },
            padding: EdgeInsets.zero,
            minimumSize: Size(75.w, 32.w),
            child: Center(
              child: Builder(builder: (context) {
                String text = '';
                text = state == 2
                    ? 'lq'.tr(context: context)
                    : state == 1
                        ? 'wwc'.tr(context: context)
                        : state == 3
                            ? 'ylq'.tr(context: context)
                            : 'wks'.tr(context: context);
                if (type == 3) {
                  text = state == 2
                      ? 'lq'.tr(context: context)
                      : state == 3
                          ? 'ylq'.tr(context: context)
                          : 'ljxz'.tr(context: context);
                } else if (type >= 4 && type <= 7) {
                  text = state == 2
                      ? 'lq'.tr(context: context)
                      : state == 3
                          ? 'ylq'.tr(context: context)
                          : 'qyq'.tr(context: context);
                }
                return Text(
                  text,
                  style: MyTheme.white255_13,
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
