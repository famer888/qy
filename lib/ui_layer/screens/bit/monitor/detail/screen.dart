import '../../../../../domain/async_value.dart';

import '../../../../../domain/model/monitor/monitor_video_detail_data.dart';
import '../../../../../domain/model/monitor/monitor_with_banners_model.dart';
import '../../../../../domain/remote_domain/domains/monitor.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/video_player/monitor_mv_player.dart';

import '../../../common_widgets/keep_alive_wrapper.dart';
import '../../../common_widgets/screen_background.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../theme.dart';
import '../../../../utils/my_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'widgets/comment_view.dart';
import 'widgets/introduction_view.dart';

class MonitorVideoDetailScreen extends StatefulWidget {
  const MonitorVideoDetailScreen({super.key, required this.id});

  final String id;

  @override
  State<MonitorVideoDetailScreen> createState() =>
      _MonitorVideoDetailScreenState();
}

class _MonitorVideoDetailScreenState extends State<MonitorVideoDetailScreen> {
  late final monitorDomain = context.read<MonitorDomain>();

  AsyncValue<MonitorVideoDetailData> _asyncValue = const AsyncInit();

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future _initData() async {
    if (_asyncValue.isLoading) return;
    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final res = await monitorDomain.getMonitorDetail(id: int.parse(widget.id));
    if (res.data case final data?) {
      _asyncValue = AsyncData(data);
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
    return ScreenBackground(
      child: SafeArea(
        // bottom: false,
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: MyAppBar(
              title: _asyncValue.data?.monitor.title,
              backgroundColor: Colors.black),
          floatingActionButton: GestureDetector(
            onTap: () {
              context.pop();
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 40.w),
              height: 40.w,
              width: 40.w,
              decoration: BoxDecoration(
                gradient: MyTheme.gradient_90_114,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.w),
                ),
              ),
              child: Center(
                child: Text(
                  'fahui'.tr(context: context),
                  style: MyTheme.white255_13_M,
                ),
              ),
            ),
          ),
          body: _asyncValue.maybeWhen(
            orElse: () => const LoadingView(),
            error: (_, __) => NetworkErrorView(onTap: _initData),
            data: (data) => Column(
              children: [
                _VideoView(data: data.monitor), //todo：待处理
                Expanded(child: _Body(id: widget.id, data: data)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VideoView extends StatelessWidget {
  const _VideoView({required this.data});

  final MonitorModel data;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: MonitorMvPlayer(
        info: data,
      ),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({
    required this.id,
    required this.data,
  });

  final String id;
  final MonitorVideoDetailData data;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with TickerProviderStateMixin {
  late final titles = [
    'jj'.tr(context: context),
    'pl'.tr(context: context),
  ];
  late final tabController = TabController(length: titles.length, vsync: this);

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      labelStyle: MyTheme.white16medium,
      unselectedLabelStyle: MyTheme.gray16,
      indicator: const BoxDecoration(),
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      dividerColor: Colors.transparent,
      dividerHeight: 0,
      labelPadding: EdgeInsets.only(left: 10.w),
      overlayColor: WidgetStateProperty.resolveWith<Color>(
        (_) => Colors.transparent,
      ),
      tabs: [
        Tab(child: Text(titles[0])),
        Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${titles[1]}(${widget.data.monitor.commentCt})'),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              KeepAliveWrapper(
                child: MonitorVideoDetailIntroductionView(
                  id: widget.id,
                  data: widget.data,
                ),
              ),
              KeepAliveWrapper(
                child: MonitorVideoCommentView(
                  id: widget.id,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
