import 'package:bot_toast/bot_toast.dart';
import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../domain/type_def.dart';
import '../notifiers/home_config_notifier.dart';
import '../screens/theme.dart';

class MyToast {
  static showText({
    required String text,
    int? time,
    VoidCallback? onClose,
    TextStyle? textStyle,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return BotToast.showText(
      text: text,
      contentColor: const Color(0xFF1C1C1C),
      textStyle: textStyle ??
          TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              decoration: TextDecoration.none),
      align: const Alignment(0, 0),
      duration: Duration(seconds: time ?? 2),
      contentPadding: contentPadding ??
          EdgeInsets.symmetric(
            horizontal: 45.w,
            vertical: 23.w,
          ),
      onClose: onClose,
    );
  }

  static showLoading({String text = '加载中'}) {
    BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
      return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(54, 54, 54, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: 110.w,
        width: 110.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: CircularProgressIndicator(
                color: MyTheme.jellyCyanColor103224185,
                strokeWidth: 1.w,
              ),
            ),
            SizedBox(height: 10.w),
            Text(text, style: MyTheme.white255_14)
          ],
        ),
      );
    });
  }

  static void closeAllLoading() => BotToast.closeAllLoading();
}

class XFileProgressToast extends StatefulWidget {
  const XFileProgressToast({
    super.key,
    required this.file,
    required this.response,
  });
  final XFile file;
  final ValueChanged<Json?> response;

  @override
  State<XFileProgressToast> createState() => _XFileProgressToastState();
}

class _XFileProgressToastState extends State<XFileProgressToast> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  String progress = 'scz'.tr();

  @override
  void initState() {
    super.initState();
    _upData();
  }

  _upData() async {
    final result = await homeConfigNotifier.uploadVideo(
      xFile: widget.file,
      progressCallback: (count, total) {
        final tmp = (count / total * 100).round();
        setState(() => progress = "${'scz'.tr()} $tmp%");
      },
    );
    widget.response(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(54, 54, 54, 0.8),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      height: 110.w,
      width: 110.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            height: 40.w,
            child: CircularProgressIndicator(
              color: MyTheme.jellyCyanColor103224185,
              strokeWidth: 1.w,
            ),
          ),
          SizedBox(height: 10.w),
          Text(progress, style: MyTheme.white255_14)
        ],
      ),
    );
  }
}
