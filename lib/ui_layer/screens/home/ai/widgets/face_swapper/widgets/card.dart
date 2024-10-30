import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:utils/utils.dart';

import '../../../../../../../domain/model/ai/ai_model.dart';
import '../../../../../../utils/common_utils.dart';
import '../../../../../common_widgets/my_image.dart';
import '../../../../../theme.dart';
import 'sheet.dart';

class FaceSwapperCard extends StatelessWidget {
  static const aspectRatio = 17 / 24;

  const FaceSwapperCard({super.key, required this.data});

  final AIFaceMaterials data;

  String get imageUrl {
    return CommonUtils.getThumb(data.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _showSheetView(context, data);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.w),
                child: Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 170 / 210,
                      child: MyImage.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        backgroundColor: MyTheme.imageBgColor,
                      ),
                    ),
                    if (data.isHot == 1)
                      Positioned(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffee1313),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.w),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 2.w,
                            horizontal: 6.w,
                          ),
                          child: Text('rm'.tr(), style: MyTheme.white12),
                        ),
                      ),
                    // Positioned(
                    //   right: 0,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xffee8b13),
                    //       borderRadius: BorderRadius.only(
                    //         bottomLeft: Radius.circular(5.w),
                    //       ),
                    //     ),
                    //     padding: EdgeInsets.symmetric(
                    //       vertical: 2.w,
                    //       horizontal: 6.w,
                    //     ),
                    //     child: Text('99${'jb'.tr()}', style: MyTheme.white12),
                    //   ),
                    // ),
                    Positioned(
                      bottom: 10.w,
                      right: 10.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0x80000000),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 1.w,
                          horizontal: 5.w,
                        ),
                        child: Text('${'sycs'.tr()}${data.usedFct}',
                            style: MyTheme.white10),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 6.w),
              Text(data.title ?? '', style: MyTheme.white244_15_M, maxLines: 1),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showSheetView(BuildContext context, AIFaceMaterials data) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => FaceSwapSheetView(data: data),
    );
  }
}
