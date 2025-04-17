import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/model/monitor/monitor_video_detail_data.dart';
import '../../../../../../domain/model/monitor/monitor_with_banners_model.dart';
import '../../../../../../domain/remote_domain/domains/monitor.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/general_banner.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../../widgets/monitor_video_card.dart';

class MonitorVideoDetailIntroductionView extends StatefulWidget {
  const MonitorVideoDetailIntroductionView(
      {super.key, required this.id, required this.data});
  final String id;
  final MonitorVideoDetailData data;
  @override
  State<MonitorVideoDetailIntroductionView> createState() =>
      _MonitorVideoDetailIntroductionViewState();
}

class _MonitorVideoDetailIntroductionViewState
    extends State<MonitorVideoDetailIntroductionView> {
  late final monitorDomain = context.read<MonitorDomain>();

  Future<List<MonitorModel>?> _getData(
      {required int page, required int pageSize}) async {
    final res = await monitorDomain.getMonitorRecommend(
        id: int.parse(widget.id), page: page, limit: 20 //推荐监控视频只显示20个
        );
    if (res.data case final data?) {
      return data;
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
    }
    if (mounted) {
      setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data;
    return MyListView.grid(
      childAspectRatio: MonitorVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      isNeedMore: false,
      header: _HeaderView(data: videoInfo),
      padding: EdgeInsets.all(MyTheme.pagePadding),
      itemBuilder: (context, item, index) => MonitorVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _HeaderView extends StatefulWidget {
  const _HeaderView({required this.data});
  final MonitorVideoDetailData data;

  @override
  State<_HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<_HeaderView> {
  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data.monitor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: SizedBox(
        width: double.infinity, // 确保宽度约束
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Offstage(
                offstage: videoInfo.intro?.isEmpty ?? false,
                child:
                    Text(videoInfo.intro ?? '', style: MyTheme.white06_14_M)),
            SizedBox(height: 22.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    MyImage.asset(
                      MyImagePaths.app2024ComBofangliangBig1,
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      CommonUtils.renderNumber(videoInfo.viewFct ?? 0),
                      style: MyTheme.whiteOpacity612w500,
                    ),
                    Text(
                      'cbf'.tr(context: context),
                      style: MyTheme.whiteOpacity612w500,
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.w),
              child: Container(
                height: 1.w,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
            if (widget.data.banners case final banners? when banners.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: 12.w),
                child: GeneralAppsListVidget(
                  data: banners,
                  aspectRatio: 10 / 3,
                ),
              ),
            Text('jctj'.tr(context: context), style: MyTheme.white16medium),
          ],
        ),
      ),
    );
  }
}
