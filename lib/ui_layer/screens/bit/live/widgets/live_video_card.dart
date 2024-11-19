import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/blur_cover.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';

class LiveVideoCard extends StatelessWidget {
  const LiveVideoCard({super.key, required this.data});

  static const aspectRatio = 1.0;

  final LiveModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());
  bool get isOnline => data.show == 'public';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        LiveVideoDetailRoute('${data.id}').push(context);
      },
      child: SizedBox(
        height: 170.w,
        child: Stack(
          children: [
            Positioned.fill(
              child: MyImage.network(
                imageUrl,
                borderRadius: 5,
                backgroundColor: MyTheme.imageBgColor,
              ),
            ),
            Positioned.fill(
              child: !isOnline
                  ? BlurCover(borderRadius: 5.w)
                  : const SizedBox.shrink(),
            ),
            Positioned.fill(
              child: !isOnline
                  ? Center(
                      child: MyImage.asset(
                        MyImagePaths.appFigureN,
                        width: 70.w,
                        height: 70.w,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            Positioned(
                top: 5.w,
                left: 5.w,
                right: 5.w,
                child: isOnline
                    ? Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 3.w, right: 6.w),
                            height: 18.w,
                            decoration: BoxDecoration(
                              color: MyTheme.blackColor25505,
                              borderRadius: BorderRadius.circular(9.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MyImage.asset(
                                  MyImagePaths.appHots,
                                  height: 18.w,
                                  width: 18.w,
                                ),
                                Text(
                                  '${CommonUtils.renderNumber(data.viewFct ?? 0)}${'gzong'.tr()}',
                                  style: MyTheme.white09_10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink()),
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
                        data.username ?? '',
                        style: MyTheme.white13medium,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 7.w,
              right: 5.w,
              child: Row(
                children: [
                  MyImage.asset(
                    isOnline ? MyImagePaths.appOnline : MyImagePaths.appOffline,
                    height: 11.w,
                    width: 11.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    isOnline ? 'zbz'.tr() : 'yixx'.tr(),
                    style: MyTheme.white10,
                    maxLines: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
