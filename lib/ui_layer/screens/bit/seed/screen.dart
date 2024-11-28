import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../domain/async_value.dart';
import '../../../../domain/model/seed/seed_nav_model.dart';
import '../../../../domain/remote_domain/domains/seed.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/status/loading.dart';
import '../../common_widgets/status/network_error.dart';
import '../../theme.dart';
import 'content.dart';

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  late final _appDomain = context.read<SeedDomain>();

  AsyncValue<List<SeedNavModel>> _asyncValue = const AsyncInit();

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

    final result = await _appDomain.reqGetPostSeed();

    if (result.data case final data?) {
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
      data: (data) => TabBarWithView.none(
        labelStyle: MyTheme.jellyCyan_15,
        unselectedLabelStyle: MyTheme.white15,
        tabBarHeight: 30.w,
        titles: data.map((e) => e.name).toList(),
        views: data.map((e) => SeedContentView(nav: e)).toList(),
      ),
      error: (_, __) => NetworkErrorView(onTap: _init),
      orElse: () => const LoadingView(),
    );
  }
}
