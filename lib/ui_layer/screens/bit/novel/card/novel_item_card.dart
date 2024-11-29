import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/my_image.dart';
import '../../../theme.dart';

class NovelItemCard extends StatelessWidget {
  const NovelItemCard({super.key, required this.data});
  static const aspectRatio = 110 / 175;
  final NovelItemModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        NovelDetailRoute(data.id.toString()).push(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MyImage.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  backgroundColor: MyTheme.imageBgColor,
                  borderRadius: 5.w,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 40.w,
                    decoration: BoxDecoration(
                      gradient: MyTheme.grayBgGradient,
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${CommonUtils.renderFixedNumber(data.viewFct ?? 0)}${'yd'.tr(context: context)}',
                          style: MyTheme.white10,
                          // textAlign: ,
                        ),
                        Text(
                          data.isEnd == 1
                              ? 'wj'.tr(context: context)
                              : 'lzz'.tr(context: context),
                          // '${'gxz'.tr(context: context)}${data.chapterCt}${'hua'.tr(context: context)}',
                          style: MyTheme.white10,
                          // textAlign: ,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            data.title ?? '',
            style: MyTheme.white244_14,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
