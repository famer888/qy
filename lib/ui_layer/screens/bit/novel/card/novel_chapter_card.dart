import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/novel/novel_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../mixin/route_to_reader.dart';

class NovelChapterCard extends StatelessWidget with RouteToReaderMixin {
  const NovelChapterCard({
    super.key,
    required this.data,
    this.isLocation,
    required this.onTap,
  });

  final NovelChaptersModel data;
  final bool? isLocation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: MyTheme.pagePadding),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      data.title ?? '',
                      style: MyTheme.white14,
                      maxLines: 1,
                    ),
                  ),
                  if (isLocation ?? false) ...[
                    SizedBox(width: 6.w),
                    MyImage.asset(MyImagePaths.appNovelLocation,
                        width: 15.w, height: 15.w)
                  ],
                ],
              ),
            ),
            SizedBox(width: 10.w),
            isFreeBadge(data)
          ],
        ),
      ),
    );
  }

  Widget isFreeBadge(NovelChaptersModel item) {
    Color bgColor;
    Color bordColor;
    Widget ww;
    EdgeInsets padding;

    if (item.type == 0 || (item.txt?.isNotEmpty ?? false)) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = Colors.transparent;
      bordColor = const Color.fromRGBO(255, 255, 255, 0.7);
      ww = Text(
        'gk'.tr(),
        style: TextStyle(color: bordColor, fontSize: 12.sp),
        textAlign: TextAlign.center,
      );
    } else if (item.type == 1) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = MyTheme.jellyCyanColor;
      bordColor = MyTheme.jellyCyanColor;
      ww = Text(
        'VIP',
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
        textAlign: TextAlign.center,
      );
    } else if (item.type == 2) {
      padding = EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w);
      bgColor = MyTheme.jellyCyanColor.withOpacity(0.2);
      bordColor = MyTheme.jellyCyanColor;
      ww = Row(
        children: [
          Text(
            CommonUtils.renderFixedNumber(item.coins ?? 0),
            style: MyTheme.white12medium,
          ),
          SizedBox(width: 2.w),
          MyImage.asset(
            MyImagePaths.appCoinLogo,
            width: 12.w,
            height: 12.w,
          )
        ],
      );
    } else {
      return Container();
    }
    return Container(
      padding: padding,
      constraints: BoxConstraints(
        minWidth: 40.w, // 设置最小宽度为 40
      ),
      decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: bordColor, // 设置边框颜色
            width: 0.5, // 设置边框宽度
          ),
          borderRadius: BorderRadius.all(Radius.circular(5.w))),
      child: ww,
    );
  }
}
