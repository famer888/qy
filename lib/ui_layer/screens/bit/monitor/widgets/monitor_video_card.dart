import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/monitor/monitor_with_banners_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class MonitorVideoCard extends StatelessWidget {
  const MonitorVideoCard({super.key, required this.data});
  static const aspectRatio = 170 / 94;

  final MonitorModel data;
  String get imageUrl => CommonUtils.getThumb(data.toJson());

  bool get isOnline => data.streamType == 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        MonitorVideoDetailRoute('${data.id}').push(context);
      },
      child: SizedBox(
        height: 94.w,
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(
                imageUrl,
                borderRadius: 5,
                backgroundColor: MyTheme.imageBgColor,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MyImage.asset(
                MyImagePaths.appCardBottomBg,
                height: 53.w,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title ?? '',
                        style: MyTheme.white13medium,
                        maxLines: 1,
                      ),
                    ),
                    //实时监控才显示在线
                    Row(children: [
                      MyImage.asset(
                        isOnline
                            ? MyImagePaths.appOnline
                            : MyImagePaths.appOffline,
                        height: 12.w,
                        width: 12.w,
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        isOnline ? 'zxi'.tr() : 'lxi'.tr(),
                        style: MyTheme.white10medium,
                        maxLines: 1,
                      )
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
