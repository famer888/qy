import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../image_paths.dart';
import '../../my_image.dart';

class AdDialog extends StatelessWidget {
  const AdDialog(
      {super.key,
      required this.cancel,
      required this.confirm,
      this.adWidth = 100,
      this.adHeight = 100,
      required this.adUrl});
  final String adUrl;
  final VoidCallback cancel;
  final VoidCallback confirm;
  final int? adWidth;
  final int? adHeight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => cancel.call(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () => confirm.call(),
              child: RepaintBoundary(
                child: Image.network(
                  adUrl,
                  width: adWidth?.w,
                  height: adHeight?.w,
                ),
              ),
            ),
            SizedBox(height: 20.w),
            GestureDetector(
              onTap: () => cancel.call(),
              child: SizedBox(
                child: MyImage.asset(
                  MyImagePaths.appCancelWithCircle,
                  fit: BoxFit.cover,
                  width: 33.w,
                  height: 33.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
