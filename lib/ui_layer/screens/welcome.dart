import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../domain/domain.dart';
import '../../domain/model/home_data_model.dart';
import '../notifiers/home_config_notifier.dart';
import '../notifiers/user_notifier.dart';
import '../router/routes.dart';
import '../utils/common_utils.dart';
import 'common_widgets/my_image.dart';
import 'common_widgets/pop_scope_wrapper.dart';
import 'common_widgets/status/network_error.dart';
import 'theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final cacheDomain = context.read<CacheDomain>();
  late final appDomain = context.read<AppDomain>();
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  late final userNotifier = context.read<UserNotifier>();

  AdModel? welcomeAds;
  String? officialWebUrl;

  bool isCheckingLine = false;
  bool isLineError = false;
  bool showAd = false;

  @override
  void initState() {
    _loadDataFromCache();
    _checkLineAndFetchBeforeEnterHome();
    super.initState();
  }

  void _loadDataFromCache() async {
    officialWebUrl = await cacheDomain.readOfficeWeb();
    welcomeAds = await cacheDomain.readAds();
    if (welcomeAds?.imgUrl case final url? when mounted) {
      precacheImage(NetworkImage(url), context);
    }
    setState(() {});
  }

  _checkLineAndFetchBeforeEnterHome() async {
    if (isCheckingLine) return;
    isCheckingLine = true;
    setState(() {
      isLineError = false;
    });

    if (await appDomain.initLine() &&
        await homeConfigNotifier.init() &&
        mounted) {
      if (welcomeAds != null) {
        setState(() {
          showAd = true;
        });
        return;
      }
      const HomeRoute().go(context);
    }

    isCheckingLine = false;

    setState(() {
      isLineError = true;
    });
  }

  Widget checkLineView() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'jcxlsd'.tr(context: context),
              style: MyTheme.gray14,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.w),
            if (officialWebUrl?.isNotEmpty == true)
              GestureDetector(
                onTap: () {
                  CommonUtils.launchUrl(officialWebUrl!);
                },
                child: Text(
                  '${'gwdzdz'.tr(context: context)}:\n$officialWebUrl',
                  style: MyTheme.red14,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
              ),
            if (isLineError)
              NetworkErrorView(
                text: 'wfljqsz'.tr(context: context),
                onTap: _checkLineAndFetchBeforeEnterHome,
              ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScopeWrapper(
      child: Scaffold(
        backgroundColor: MyTheme.bgColor,
        body: showAd ? AdView(adModel: welcomeAds!) : checkLineView(),
      ),
    );
  }
}

class AdView extends StatefulWidget {
  const AdView({super.key, required this.adModel});
  final AdModel adModel;

  @override
  State<AdView> createState() => _AdViewState();
}

class _AdViewState extends State<AdView> {
  final ValueNotifier<int> countDownNotifier = ValueNotifier(5);
  late final Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      countDownNotifier.value -= 1;
      if (countDownNotifier.value == 0) {
        _timer.cancel();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.adModel.imgUrl case final String imgUrl)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                final ad = widget.adModel;
                CommonUtils.openRoute(context, {
                  'report_id': ad.id,
                  'report_type': ad.type,
                  'link_url': ad.url,
                });
              },
              child: MyImage.network(
                imgUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10.w,
          right: 15.w,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (countDownNotifier.value > 0) return;
              const HomeRoute().go(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 15.w),
              height: 35.w,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(35.w),
              ),
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: countDownNotifier,
                  builder: (context, count, _) => Text(
                    '${count > 0 ? count : 'adtg'.tr(context: context)}',
                    style: MyTheme.white15semibold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
