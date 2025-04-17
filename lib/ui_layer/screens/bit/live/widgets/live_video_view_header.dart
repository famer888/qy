import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/tip_model.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/marquee.dart';
import '../../../theme.dart';

class LiveVideoViewHeader extends StatelessWidget {
  const LiveVideoViewHeader({
    super.key,
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralAppsListVidget(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (_, tips, __) => MyMarqueeTipsWidget(tips: tips),
        ),
      ],
    );
  }
}
