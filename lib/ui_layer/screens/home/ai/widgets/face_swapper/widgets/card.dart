import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../domain/model/ai/ai_model.dart';
import '../../../../../../utils/common_utils.dart';
import '../../../../../common_widgets/my_image.dart';
import '../../../../../theme.dart';
import 'sheet.dart';

class FaceSwapperCard extends StatelessWidget {
  static const aspectRatio = 170 / 230;

  const FaceSwapperCard({super.key, required this.data});

  final AIModel data;

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
              AspectRatio(
                aspectRatio: 170 / 200,
                child: MyImage.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  borderRadius: 4,
                  backgroundColor: MyTheme.imageBgColor,
                ),
              ),
              SizedBox(height: 7.w),
              Text(data.title ?? '', style: MyTheme.white244_15_M, maxLines: 1),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showSheetView(BuildContext context, AIModel data) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) => FaceSwapSheetView(data: data),
    );
  }
}
