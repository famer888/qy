import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme.dart';

class FabPopButton extends StatelessWidget {
  const FabPopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    if (size.height < size.width) return const SizedBox();
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 40.r),
        height: 40.r,
        width: 40.r,
        decoration: BoxDecoration(
          gradient: MyTheme.btnGradient_ff00edfd_ffbbe954,
          borderRadius: BorderRadius.all(
            Radius.circular(20.r),
          ),
        ),
        child: Center(
          child: Text(
            'fahui'.tr(context: context),
            style: MyTheme.white255_13_M,
          ),
        ),
      ),
    );
  }
}
