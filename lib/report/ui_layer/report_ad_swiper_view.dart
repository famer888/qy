import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety_flutter3/flutter_swiper_null_safety_flutter3.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../domain/model/home_data_model.dart';
import '../../ui_layer/notifiers/home_config_notifier.dart';
import '../../../domain/model/banner_model.dart';
import '../../ui_layer/router/routes.dart';
import '../../ui_layer/screens/common_widgets/my_image.dart';
import '../../ui_layer/screens/theme.dart';
import '../../ui_layer/utils/common_utils.dart';
import 'report_general_apps_list_swiper.dart';

import 'report_gesture_detector.dart';
import '../event_tracking.dart';
import 'report_timing_observer.dart';

class ReportAdSwiperView extends StatefulWidget {
  const ReportAdSwiperView({super.key, required this.adModels});

  final List<AdModel> adModels;

  @override
  State<ReportAdSwiperView> createState() => _ReportAdSwiperViewState();
}

class _ReportAdSwiperViewState extends State<ReportAdSwiperView> {
  final ValueNotifier<int> countDownNotifier = ValueNotifier(5);
  late final Timer _timer;

  Map<String, bool> adIdMap = {}; // 已经显示true 未显示null
  List<String> get adIds => List<String>.from(adIdMap.keys);
  bool didReport = false; //本生命周期内 只上报一次

  void _showBanner(BannerModel banner) {
    // 没存进Map 就是没上传过show 上传&记录

    CommonUtils.log('_showBanner ');
    if (adIdMap[banner.advertiseCode] == null) {
      CommonUtils.log('_showBanner show');
      postActionReport(banner, "show");
      adIdMap[banner.advertiseCode ?? ''] = true;
    }

    if (adIds.length == widget.adModels.length) {
      postShowReport();
    }
  }

  //展示广告上报 展示完或页面消失上报
  void postShowReport() {
    if (didReport) return;

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
    AdModel tp = widget.adModels.first;
    EventTracking().reportSingle({
      "event": "ad_impression",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": adIds.join(","),
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      didReport = true;
      // CommonUtils.log(value);
    });
  }

  //上传广告行为
  void postActionReport(BannerModel tp, String action) {
    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();

    EventTracking().reportSingle({
      "event": "advertising",
      "event_type": action,
      "advertising_key": tp.advertiseLocationCode,
      "advertising_name": tp.adSlotName,
      "advertising_id": tp.advertiseCode,
    });
  }

  //点击广告上报
  void postClickReport(BannerModel tp) {
    postActionReport(tp, "click");

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
    EventTracking().reportSingle({
      "event": "ad_click",
      "page_key": RouteStore.currentPageKey,
      "page_name": RouteStore.currentPageName,
      "ad_slot_key": tp.advertiseLocationCode,
      "ad_slot_name": tp.adSlotName,
      "ad_id": tp.advertiseCode,
      "creative_id": "",
      "ad_type": tp.adType,
    }).then((value) {
      // CommonUtils.log(value);
    });
  }

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
    final length = widget.adModels.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: Swiper(
          autoplay: length > 1,
          itemBuilder: (BuildContext context, int index) {
            precacheImage(
                NetworkImage(CommonUtils.getThumb(widget
                    .adModels[(index + 1).clamp(0, length - 1)]
                    .toJson())),
                context);

            return GestureDetector(
              onTap: () {
                final ad = widget.adModels[index];
                CommonUtils.openRoute(context, {
                  'report_id': ad.id,
                  'report_type': ad.type,
                  'link_url': ad.url,
                });
              },
              child: MyImage.network(
                CommonUtils.getThumb(widget.adModels[index].toJson()),
                fit: BoxFit.cover,
              ),
            );
          },
          itemCount: length,
          pagination: SwiperPagination(
            builder: SwiperCustomPagination(
              builder: (context, config) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  length,
                  (index) {
                    bool isActive = config.activeIndex == index;
                    return Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.only(right: 7.w),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        )),
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
