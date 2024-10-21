import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common_widgets/my_button.dart';
import '../../../theme.dart';

class PostButton extends StatelessWidget {
  const PostButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
          borderRadius: BorderRadius.circular(14.w),
        ),
        height: 28.w,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Center(
          child: Text(
            'fb'.tr(context: context),
            style: MyTheme.white255_14,
          ),
        ),
      ),
    );
  }
}
