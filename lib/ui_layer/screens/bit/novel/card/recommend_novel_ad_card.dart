import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../domain/model/novel/recommend_novel_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../common_widgets/my_image.dart';
import '../../../theme.dart';

class RecommendNovelAdCard extends StatelessWidget {
  const RecommendNovelAdCard({super.key, required this.data});
  final RecommendNovelAdModel data;

  String get imgUrl => data.imgUrl ?? '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        CommonUtils.openRoute(context, data.toJson());
      },
      child: AspectRatio(
        aspectRatio: 7 / 2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            MyImage.network(
              imgUrl,
              borderRadius: 5.w,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 38.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(252, 231, 80, 0.8),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(3.w),
                      bottomRight: Radius.circular(3.w)),
                ),
                child: Center(
                    child: Text(
                  'gg'.tr(),
                  style: MyTheme.black12_M,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
