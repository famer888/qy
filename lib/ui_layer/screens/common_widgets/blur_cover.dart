import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurCover extends StatelessWidget {
  const BlurCover({
    super.key,
    this.onTap,
    this.borderRadius,
  });

  final VoidCallback? onTap;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? .0), // 圆角半径
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            onTap?.call();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
          ),
        ),
      ),
    );
  }
}
