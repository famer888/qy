import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/model/banner_model.dart';
import '../../ui_layer/screens/common_widgets/my_image.dart';
import '../../ui_layer/screens/theme.dart';
import '../../ui_layer/utils/common_utils.dart';

import 'report_gesture_detector.dart';
import '../event_tracking.dart';
import 'report_timing_observer.dart';

class ReportGeneralAppListSwiper extends StatefulWidget {
  ReportGeneralAppListSwiper({
    super.key,
    required this.data,
    this.radius = 5,
    this.aspectRatio = 7 / 3,
    this.maxWidth = 375,
    this.columnNumber = 5,
    this.useMargin = false,
  });

  List<BannerModel> data;
  final double radius;
  final double aspectRatio;

  final double maxWidth;
  final int columnNumber;
  bool useMargin = false;

  @override
  State<ReportGeneralAppListSwiper> createState() => _ReportGeneralAppListSwiperState();
}

class _ReportGeneralAppListSwiperState extends State<ReportGeneralAppListSwiper> {
  int threshold = 10;
  int _ColumNumber = 5;

  Map<String, bool> adIdMap = {}; // 已经显示true 未显示null
  List<String> get adIds => List<String>.from(adIdMap.keys);
  bool didReport = false; //本生命周期内 只上报一次

  @override
  void initState() {
    super.initState();
    _ColumNumber = 6; // 统一为6列
    threshold = _ColumNumber * 2;
  }

  void _showBanner(BannerModel banner) {
    // 没存进Map 就是没上传过show 上传&记录

    CommonUtils.log('_showBanner ');
    if (adIdMap[banner.advertiseCode] == null) {
      CommonUtils.log('_showBanner show');
      postActionReport(banner, "show");
      adIdMap[banner.advertiseCode ?? ''] = true;
    }

    if (adIds.length == widget.data.length) {
      postShowReport();
    }
  }

  @override
  void dispose() {
    postShowReport();
    super.dispose();
  }

  //展示广告上报 展示完或页面消失上报
  void postShowReport() {
    if (didReport) return;

    // final pageName = context.parentTitle;
    // final widgetType = context.parentWidgetType.toString();
    BannerModel tp = widget.data.first;
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
  Widget build(BuildContext context) {
    // 统一为6列网格布局，不限制行数
    if (widget.data.isEmpty) {
      return Container();
    }
    final itemWidth = (ScreenUtil().screenWidth - (_ColumNumber + 1) * 6.w - MyTheme.pagePadding * 2) / _ColumNumber;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _ColumNumber,
          mainAxisSpacing: 10.w,
          crossAxisSpacing: 6.w,
          childAspectRatio: 57 / 76,
        ),
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          final item = widget.data[index];
          _showBanner(item);

          return ReportGestureDetector(
            onTap: () {
              postClickReport(item);
              CommonUtils.openRoute(context, item.toJson());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: itemWidth,
                  height: itemWidth,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: MyImage.network(
                      CommonUtils.getThumb(item.toJson()),
                      fit: BoxFit.cover,
                      borderRadius: 8.w,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  item.name ?? item.title ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.none,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
