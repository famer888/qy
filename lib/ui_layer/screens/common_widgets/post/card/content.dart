import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/common_utils.dart';
import '../../../theme.dart';

class CardContentView extends StatelessWidget {
  const CardContentView({super.key, required this.isBest, required this.title});

  final bool isBest;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          if (isBest)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: Container(
                  height: 16.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  decoration: BoxDecoration(
                    gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'jhua'.tr(context: context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),
          TextSpan(
            text: CommonUtils.convertEmojiAndHtml(title),
            style: MyTheme.white255_15,
          )
        ],
      ),
    );
  }
}
