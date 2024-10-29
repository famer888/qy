import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/marquee_tips.dart';
import '../../../../utils/common_utils.dart';
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
  final ValueNotifier<List<MarqueeTipsModel>> tipsNotifier;

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
              child: GeneralBanner(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (context, tips, child) {
            if (tips.isEmpty) return const SizedBox.shrink();
            return MarqueeWidget(children: [
              for (final tip in tips)
                GestureDetector(
                  onTap: () {
                    CommonUtils.openRoute(context, tip.toJson());
                  },
                  child: Text(
                    tip.title ?? '',
                    style: MyTheme.white14,
                  ),
                ),
            ]);
          },
        ),
      ],
    );
  }
}
