import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../image_paths.dart';
import '../../../../theme.dart';

class NovelAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NovelAppBar({
    super.key,
    required this.animationController,
    required this.child,
  });
  final AnimationController animationController;
  final Widget child;

  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      )),
      child: ColoredBox(
        key: GlobalKey(),
        color: Colors.black.withOpacity(0.7),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            height: MyTheme.navbarHegiht,
            child: Row(
              children: [
                GestureDetector(
                  child: Image.asset(
                    MyImagePaths.appBackIcon,
                    width: 20.w,
                    height: 20.w,
                  ),
                  onTap: () {
                    context.pop();
                  },
                ),
                SizedBox(width: 10.w),
                Expanded(child: child),
                SizedBox(width: 30.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
