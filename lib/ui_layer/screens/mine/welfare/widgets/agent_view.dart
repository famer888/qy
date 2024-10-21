import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/member_model.dart';
import '../../../../../domain/model/proxy_detail_model.dart';
import '../../../../../domain/remote_domain/domains/proxy.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_avatar.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../../share_to_user/widgets/jelly_share.dart';
import '../../share_to_user/widgets/share_tips.dart';
import '../../widgets/mine_agent_apply.dart';

class AgentView extends StatefulWidget {
  const AgentView({super.key});

  @override
  State<AgentView> createState() => _AgentViewState();
}

class _AgentViewState extends State<AgentView> {
  late final proxyDomain = context.read<ProxyDomain>();
  late final member = context.read<UserNotifier>().member;
  late final config = context.read<HomeConfigNotifier>().config;

  AsyncValue<ProxyDetail?> _asyncValue = const AsyncInit();

  /// 是否显示申请页面
  bool showApplyPage = false;

  @override
  void initState() {
    _loadUserAgentData();
    super.initState();
  }

  Future _loadUserAgentData() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = AsyncLoading(value: _asyncValue.data);
    });
    if (!member.isSelf) {
      showApplyPage = true;
      setState(() {
        _asyncValue = const AsyncData(null);
      });
      return;
    }

    final res = await proxyDomain.getProxyDetail();

    if (!res.isValid) {
      if ((res.msg ?? '').contains('请先申请成为代理')) {
        showApplyPage = true;
        _asyncValue = const AsyncData(null);
      } else {
        MyToast.showText(text: res.msg ?? '');
        _asyncValue = const AsyncError();
      }
    } else {
      _asyncValue = AsyncData(res.data);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildActionView() => Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyButton.gradient(
              minimumSize: Size(150.w, 38.5.w),
              text: 'fztglj'.tr(context: context),
              onPressed: () async {
                Clipboard.setData(
                    ClipboardData(text: '${member.share?.affUrlCopy?.url}'));
                MyToast.showText(text: 'fzcg'.tr(context: context));
              },
            ),
            SizedBox(width: 15.w),
            MyButton.gradient(
              minimumSize: Size(150.w, 38.5.w),
              text: 'ljyqt'.tr(context: context),
              onPressed: () async {
                const MineShareToUserRoute().push(context);
              },
            ),
          ],
        ),
      );

  Widget _buildDataView(ProxyDetail? data) {
    return showApplyPage
        ? MineAgentApplyView(
            applySuccess: () {
              setState(() {});
              _loadUserAgentData();
            },
          )
        : CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              MyIndicator(onRefresh: _loadUserAgentData),
              SliverPadding(
                padding: EdgeInsets.all(18.w),
                sliver: SliverList.list(
                  // padding: const EdgeInsets.all(18),
                  children: [
                    Container(
                      height: 157.w,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            MyImagePaths.appDlPenal,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 53.w,
                            margin: EdgeInsets.all(16.5.w),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${data?.levelStr}',
                                            style: MyTheme.brown916044_14medium,
                                          ),
                                          Text(
                                            'ktxje'.tr(context: context),
                                            style:
                                                MyTheme.brown916044_12semibold,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'yhysj'.tr(context: context),
                                            style: MyTheme.brown916044_12medium,
                                          ),
                                          Text(
                                            '${data?.money}',
                                            style:
                                                MyTheme.brown916044_24semibold,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.w),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _CardButton(
                                onTap: () {
                                  const MineWithdrawalRoute(true).push(context);
                                },
                                text: 'ljtx'.tr(context: context),
                              ),
                              SizedBox(width: 54.w),
                              _CardButton(
                                onTap: () {
                                  const MineAgentPromoteDataRoute()
                                      .push(context);
                                },
                                text: 'tgsj'.tr(context: context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.w),
                    MineShareToUserTips(proxyDetail: data),
                    SizedBox(height: 25.w),
                    JellyShareCard(proxyDetail: data),
                    SizedBox(height: 31.w),
                    _buildActionView(),
                    SizedBox(height: 30.w),
                    Center(
                      child: Text(
                        'yqbz'.tr(context: context),
                        style: MyTheme.white255_24_B,
                      ),
                    ),
                    Center(
                      child: Text(
                        config.tipsShareText ?? 'loading',
                        style: MyTheme.white255_15,
                      ),
                    ),
                    SizedBox(height: 50.w),
                    Center(
                      child: Stack(
                        children: [
                          MyImage.asset(
                            MyImagePaths.appWdFxbotmbgN,
                            height: 500.w,
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 20.w,
                            child: GestureDetector(
                              onTap: () => const MineAgentRoute().push(context),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50.w),
                  ],
                ),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      error: (_, __) => NetworkErrorView(onTap: _loadUserAgentData),
      orElse: () => const LoadingView(),
      loading: (data) {
        if (data == null) return const LoadingView();
        return _buildDataView(data);
      },
      data: _buildDataView,
    );
  }
}

class _CardButton extends StatelessWidget {
  const _CardButton({
    required this.onTap,
    required this.text,
  });
  final GestureTapCallback onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 115.w,
        height: 35.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              MyImagePaths.appProxyBtnBg,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Text(
          text,
          style: MyTheme.brown_1378860_14_M,
        ),
      ),
    );
  }
}
