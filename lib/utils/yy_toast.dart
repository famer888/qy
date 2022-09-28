import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qypj/utils/common.dart';

class YyToast {
  static successToast(String text,
      {ToastGravity gravity = ToastGravity.TOP, int timeInSecForIos = 2}) {
    return Fluttertoast.showToast(
        msg: text ?? CommonUtils.txt('czcg'),
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIos,
        backgroundColor: Color(0xffe1f3d8),
        textColor: Color(0xff67c23a),
        fontSize: ScreenUtil().setSp(15));
  }

  static warningToast(String text,
      {ToastGravity gravity = ToastGravity.TOP, int timeInSecForIos = 3}) {
    return Fluttertoast.showToast(
        msg: text ?? CommonUtils.txt('jgcw'),
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIos,
        backgroundColor: Color(0xfffdf6ec),
        textColor: Color(0xffe6a23c),
        fontSize: ScreenUtil().setSp(15));
  }

  static errorToast(String text,
      {ToastGravity gravity = ToastGravity.TOP, int timeInSecForIos = 2}) {
    return Fluttertoast.showToast(
        msg: text ?? CommonUtils.txt('czsb'),
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIos,
        backgroundColor: Color(0xfffef0f0),
        textColor: Color(0xfff56c6c),
        fontSize: ScreenUtil().setSp(15));
  }
}
