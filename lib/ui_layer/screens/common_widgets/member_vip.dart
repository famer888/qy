import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberVipWidget extends StatelessWidget {
  const MemberVipWidget({
    super.key,
    this.showText,
    this.fontSize = 10,
    this.height = 16,
    this.margin = 0,
  });
  final String? showText;
  final double fontSize;
  final double height;
  final double margin;

  @override
  Widget build(BuildContext context) {
    if (showText case final text? when text.isNotEmpty) {
      return Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        margin: EdgeInsets.only(right: margin.w),
        decoration: kIsWeb
            ? BoxDecoration(
                color: const Color(0xFFf4d4b5),
                borderRadius: BorderRadius.circular(height.w / 2),
              )
            : BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Color(0xFFf5e0d1),
                  Color(0xFFfbeadd),
                  Color(0xFFf4d4b5)
                ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(height.w / 2),
              ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: const Color(0xFF89583c), fontSize: fontSize.sp),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
