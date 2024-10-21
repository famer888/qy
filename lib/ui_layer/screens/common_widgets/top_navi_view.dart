import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/async_value.dart';
import '../../../domain/domain.dart';
import '../../../domain/model/link_model.dart';
import 'api_link_view.dart';
import 'my_tab_bar.dart';
import 'status/loading.dart';
import 'status/network_error.dart';

class TopNaviView extends StatefulWidget {
  const TopNaviView({super.key, this.id});

  final int? id;

  @override
  State<TopNaviView> createState() => _TopNaviViewState();
}

class _TopNaviViewState extends State<TopNaviView>
    with TickerProviderStateMixin {
  late final _appDomain = context.read<AppDomain>();
  AsyncValue<List<LinkModel>> _asyncValue = const AsyncInit();
  late final TabController _tabController;
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

    final result = await _appDomain.getFirstTopNavConfig(navId: widget.id);

    if (result.data?.value case final data?) {
      _tabController = TabController(length: data.length, vsync: this);
      _asyncValue = AsyncData(data);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      data: (data) => TabBarWithView.line(
        tabController: _tabController,
        titles: data.map((e) => e.name).toList(),
        views: data
            .map(
              (e) => ApiLinkView(
                linkModel: e,
                onLinkNavTap: (value) {
                  if (data.indexWhere((element) => element.linkUrl == value)
                      case final index when index != -1) {
                    _tabController.index = index;
                  }
                },
              ),
            )
            .toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
