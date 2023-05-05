import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qypj/utils/common.dart';
// import 'package:universal_html/html.dart';

class GQStyle {
  static LinearGradient btnGradient_ff00edfd_ffbbe954 = LinearGradient(
    // colors: [Color(0xff00edfd), Color(0xffbbe954)],
    colors: [Color(0xff00d2be), Color(0xff6496fc)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient btnGradient_e4b191_f6dec7 = LinearGradient(
    // colors: [Color(0xff00edfd), Color(0xffbbe954)],
    colors: [Color(0xffe4b191), Color(0xfff6dec7)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // 栏目顶部导航高度
  static double get navbarHegiht => ScreenUtil().setWidth(44);
  //大于2.16为iPhoneX
  // static bool ipx =
  //     ScreenUtil().screenHeight / ScreenUtil().screenWidth >= 2.16 &&
  //         CommonUtils.platform() == 2;
  static bool ipx = CommonUtils.platform() == 2;
  static double bottom = ScreenUtil().setWidth(ipx ? 15 : 0);
  // 底部导航高度
  static double get bottomnavbarHegiht =>
      ScreenUtil().setWidth(ipx ? (bottom + 55) : 55);
  // 页面通用边距
  static double get pagePadding => ScreenUtil().setWidth(13);
  static String get hanyi => null;

  static Color bgColor = Color.fromRGBO(11, 11, 33, 1);
  static Color naviColor = Color.fromRGBO(11, 11, 33, 1);

  static Color blackColor18 = Color.fromRGBO(18, 18, 18, 1);
  static Color blackColor25 = Color.fromRGBO(25, 25, 25, 1);
  static Color blackColor22 = Color.fromRGBO(22, 22, 22, 1);
  static Color blackColor32 = Color.fromRGBO(32, 32, 32, 1);
  static Color blackColor36 = Color.fromRGBO(36, 36, 36, 1);
  static Color blackColor38 = Color.fromRGBO(38, 38, 38, 1);
  static Color blackColor49 = Color.fromRGBO(49, 49, 49, 1);
  static Color blackColor61 = Color.fromRGBO(61, 61, 61, 1);

  static Color bloodOrange2501046 = Color.fromRGBO(250, 104, 6, 1);
  static Color bloodOrange2557710 = Color.fromRGBO(255, 77, 11, 1);
  static Color bloodOrange2551020 = Color.fromRGBO(255, 102, 0, 1);
  static Color bloodOrange255702 = Color.fromRGBO(253, 70, 2, 1);
  static Color brownColor = Color.fromRGBO(114, 47, 7, 1);
  static Color brownColor91_60_44 = Color.fromRGBO(118, 75, 51, 1);
  static Color grayColor180 = Color.fromRGBO(180, 180, 180, 1);
  static Color grayColor150 = Color.fromRGBO(150, 150, 150, 1);

  static Color goldColor234_202_147 = Color.fromRGBO(234, 202, 147, 1);

  static Color redColor255_57_13 = Color.fromRGBO(255, 57, 13, 1);

  static Color cyanColor00edfd = Color(0xff67e0b9);

  static Color jellyCyanColor103224185 = Color.fromRGBO(0, 210, 190, 1);
  static Color jellyCyanColor108235220 = Color.fromRGBO(108, 235, 220, 1);

  static TextStyle bloodOrange2557710_14 = TextStyle(
      fontFamily: hanyi,
      color: bloodOrange2557710,
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle bloodOrange255702_15 = TextStyle(
      fontFamily: hanyi,
      color: bloodOrange255702,
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle bloodOrange255702_15medium = TextStyle(
      fontFamily: hanyi,
      color: bloodOrange255702,
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown11medium = TextStyle(
      fontFamily: hanyi,
      color: brownColor,
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle brown916044_12medium = TextStyle(
      fontFamily: hanyi,
      color: brownColor91_60_44,
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle brown916044_12semibold = TextStyle(
      fontFamily: hanyi,
      color: brownColor91_60_44,
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle hex5c402b_12_S = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff5c402b),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle brown916044_14medium = TextStyle(
      fontFamily: hanyi,
      color: brownColor91_60_44,
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle brown1187551_12_semi = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(118, 75, 51, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle brown1187551_24_semi = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(118, 75, 51, 1),
      fontSize: ScreenUtil().setSp(24),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle hex5c402b_24_S = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff5c402b),
      fontSize: ScreenUtil().setSp(24),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle brown916044_24semibold = TextStyle(
      fontFamily: hanyi,
      color: brownColor91_60_44,
      fontSize: ScreenUtil().setSp(24),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle gold12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      // fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle gold12medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle gold12semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle hexffdbb2_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffc7a87f),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gold14medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle hexf2c774_14 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xfff2c774),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gold15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gold18M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 219, 178, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle copper13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(238, 196, 171, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle copper35 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(238, 196, 171, 1),
      fontSize: ScreenUtil().setSp(35),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle copper25 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(25),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  // 字体样式
  static TextStyle black51_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle black51_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray150_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray150_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(150, 150, 150, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black51_20_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(20),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle black51_18_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black26_18_semi = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(26, 26, 26, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle black26_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray192_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(192, 192, 192, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray192_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(192, 192, 192, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray199_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray198_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(198, 198, 198, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray205_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(205, 205, 205, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray205_14_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(205, 205, 205, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle hex00edfd_11 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff00edfd),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle hex00edfd_20_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff00edfd),
      fontSize: ScreenUtil().setSp(20),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray192_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(192, 192, 192, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray192_14_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(192, 192, 192, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white233_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(233, 233, 233, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white232_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 232, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white232_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 232, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white236_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(236, 236, 236, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white237_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(237, 237, 237, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white232_13_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 232, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white232_16 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 232, 1),
      fontSize: ScreenUtil().setSp(16),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white232_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 232, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray192_13_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(192, 192, 192, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle gray105_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(105, 105, 105, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray105_16_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(105, 105, 105, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray137_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(137, 137, 137, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray139_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(139, 139, 139, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya3a2a2_10 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya8f8f8f_11 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff77767e),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya3a2a2_11 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff949494),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya3a2a2_11_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(11),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle graya3a2a2_12 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray8f8e90_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff8f8e90),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya3a2a2_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray666_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff666666),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle graya3a2a2_15 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle grayaaa9a8_11 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffaaa9a8),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle grayaaa9a8_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffaaa9a8),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray105_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(105, 105, 105, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_8 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(8),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown137_8 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(137, 88, 60, 1),
      fontSize: ScreenUtil().setSp(8),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_10_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown_10_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(137, 88, 60, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white254_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray168_9 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 167, 171, 1),
      fontSize: ScreenUtil().setSp(9),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray168_16_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray213_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(213, 213, 213, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray213_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(213, 213, 213, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray202_14_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(202, 202, 202, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle gray202_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(202, 202, 202, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray204_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray240_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 239, 244, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray204_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray204_15medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle gray204_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray203_14medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(203, 203, 203, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray203_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(203, 202, 200, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray203_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(203, 202, 200, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray203_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(190, 189, 194, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray203_13_T = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(203, 202, 200, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough);

  static TextStyle gray203_15medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, .8),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray203_18medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(203, 203, 203, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray168_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 167, 171, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray163_10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(163, 162, 162, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray163_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(198, 199, 217, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray190_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(190, 189, 194, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray163_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(163, 162, 162, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray163_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(74, 74, 74, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray163_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(163, 162, 162, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray163_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(163, 162, 162, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray109_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(109, 109, 114, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray168_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 167, 171, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray95_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 167, 171, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_22_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(22),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_22_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(22),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white253_22_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(253, 70, 2, 1),
      fontSize: ScreenUtil().setSp(22),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_24_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(24),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_20_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_25_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(25),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_20_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_24_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(24),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_24_S = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(24),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_20_S = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hex666666_20_S = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff666666),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hex666666_24_S = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff666666),
      fontSize: ScreenUtil().setSp(24),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_18_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white23_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown_996619_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(99, 66, 19, 1),
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown_1378860_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(137, 88, 60, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown72_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(72, 23, 14, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle brown248_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white238_18_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(238, 196, 171, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white81_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(81, 43, 24, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 189, 57, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blue80_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(80, 237, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blue80_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(80, 237, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blue80_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(96, 178, 220, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blue80_11_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(80, 237, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue80_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(80, 237, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blue80_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(103, 224, 185, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue96_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(96, 178, 220, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue80_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(103, 224, 185, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue80_16_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(80, 237, 255, 1),
      fontSize: ScreenUtil().setSp(16),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue80_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(103, 224, 185, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle blue80_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(0, 210, 190, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray143_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white9255_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_16_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_16 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(16),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_16_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_20_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle teal103224185_20_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(103, 224, 185, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle teal103224185_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(103, 224, 185, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle greent113_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(113, 135, 184, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_12_M_T = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough);

  static TextStyle white255_12_semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle white255_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_11_03 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 0.3),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black0d141f_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(26, 26, 31, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black0d141f_11_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(26, 26, 31, 1),
      fontSize: ScreenUtil().setSp(11),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_11_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white127_11_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(127, 72, 26, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white217_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(217, 218, 218, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white255_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white23_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_13_T = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough);

  static TextStyle gry30_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(30, 30, 30, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow253_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(253, 70, 2, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray30_14_M_T = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(30, 30, 30, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough);

  static TextStyle white_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.w400,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_13_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_12_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white255_12_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle red255_12_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 69, 0, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle black84_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(84, 84, 84, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_14_place = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 93, 95, 0.8),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white255_14_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle white255_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle white255_14_N = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle white255_14_M_V = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.clip,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle white255_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle yellowffbd39_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffbd39),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle white255_15_semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle white95_15_semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 167, 171, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle white_17 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(17),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle white234_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(234, 234, 234, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white234_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(234, 234, 234, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red2555713_11 = TextStyle(
      fontFamily: hanyi,
      color: redColor255_57_13,
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray118_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(118, 118, 118, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray118_12_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(118, 118, 118, 1),
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray128_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(128, 128, 128, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray666666_11 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff666666),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray180_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_12medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray123_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(123, 123, 123, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray148_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(148, 148, 148, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 0.8),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_14medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray180_14_line = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray180_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_14_T = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.lineThrough);

  static TextStyle gray180_13medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle gray180_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray180_16_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray206_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(206, 206, 206, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray153_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray153_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray127_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray153_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray153_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray102_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray102_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray102_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray234_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(234, 234, 236, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray208_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(218, 218, 218, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 77, 11, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_14_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 73, 0, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 77, 11, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 77, 11, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_15 = TextStyle(
      color: Color(0xFFFF4D0B),
      fontSize: ScreenUtil().setSp(15),
      decoration: TextDecoration.underline);

  static TextStyle yellow255_16_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 77, 11, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow255_14_B = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 77, 11, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray30_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(30, 30, 30, 1),
      fontSize: ScreenUtil().setSp(14),
      decoration: TextDecoration.none);

  static TextStyle gray169_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(169, 169, 169, 1),
      fontSize: ScreenUtil().setSp(14),
      decoration: TextDecoration.none);

  static TextStyle gray172_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(110, 110, 123, 1),
      fontSize: ScreenUtil().setSp(14),
      decoration: TextDecoration.none);

  static TextStyle gray172_17 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(172, 171, 176, 1),
      fontSize: ScreenUtil().setSp(17),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle gray168_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(168, 168, 168, 1),
      fontSize: ScreenUtil().setSp(15),
      decoration: TextDecoration.none);

  static TextStyle yellow240_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 96, 0, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray157_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(157, 157, 157, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray214_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(214, 214, 214, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray179_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(179, 179, 179, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hexb3b3b3_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffb3b3b3),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray187_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(187, 187, 187, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black64_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(232, 232, 233, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_15_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white241_15_semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(241, 241, 241, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white244_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray143_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white244_14semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);
  static TextStyle white244_18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(244, 244, 244, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hex003dfd_25_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff00edfd),
      fontSize: ScreenUtil().setSp(25),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle hex003dfd_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff00edfd),
      fontSize: ScreenUtil().setSp(13),
      decoration: TextDecoration.none);

  static TextStyle black51_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(14),
      decoration: TextDecoration.none);

  static TextStyle white233_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(233, 233, 233, 1),
      fontSize: ScreenUtil().setSp(14),
      decoration: TextDecoration.none);

  static TextStyle gray156_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(156, 159, 166, 1),
      fontSize: ScreenUtil().setSp(15),
      decoration: TextDecoration.none);

  static TextStyle gray156_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(156, 159, 166, 1),
      fontSize: ScreenUtil().setSp(12),
      decoration: TextDecoration.none);

  static TextStyle black0_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(0, 0, 0, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle gray153_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray30_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(30, 30, 30, 1),
      fontSize: ScreenUtil().setSp(15),
      decoration: TextDecoration.none);

  static TextStyle black13_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(95, 95, 95, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red255_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 128, 128, 1.0),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle green0_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(0, 250, 154, 1.0),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle red255_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 128, 128, 1.0),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  //==============================分界线=============================================

  static TextStyle gray153_10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle lgray11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle lgray13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle lgray14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray12128 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(128, 128, 128, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray150 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(50, 50, 50, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray173 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(173, 173, 173, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray232_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle green85_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(172, 171, 176, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray153_15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(153, 153, 153, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray16 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(16),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle gray16medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(16),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle gray16blod = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(102, 102, 102, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray204 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray204_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray204_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(204, 204, 204, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 75, 62, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 75, 62, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red240 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(246, 95, 133, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red24015 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 75, 62, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 99, 71, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red14 = TextStyle(
    fontFamily: hanyi,
    color: Color.fromRGBO(240, 75, 62, 1),
    fontSize: ScreenUtil().setSp(14),
    overflow: TextOverflow.ellipsis,
    decoration: TextDecoration.none,
  );

  static TextStyle red16bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 157, 18, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red20bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 75, 62, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle red15bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(240, 75, 62, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle yellow12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 157, 18, 1),
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black20bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black1534 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.normal,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blackBlod1534 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle blackMedium1534 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black1834 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle black118_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(161, 161, 178, 1),
      fontSize: ScreenUtil().setSp(12),
      decoration: TextDecoration.none);

  static TextStyle black788187_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(78, 81, 87, 1),
      fontSize: ScreenUtil().setSp(12),
      decoration: TextDecoration.none);

  static TextStyle black12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(12),
      decoration: TextDecoration.none);

  static TextStyle black12_M = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontWeight: FontWeight.w600,
      fontSize: ScreenUtil().setSp(12),
      decoration: TextDecoration.none);

  static TextStyle black13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black13bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black1434 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black1234 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle black15bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black20bold51 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(20),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black18bold50 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(50, 50, 50, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black16 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(16),
      decoration: TextDecoration.none);

  static TextStyle black16bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.none);

  static TextStyle black16bold34 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle black16medium34 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle black1634 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(34, 34, 34, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.normal,
      decoration: TextDecoration.none);

  static TextStyle black18bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle black24 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(51, 51, 51, 1),
      fontSize: ScreenUtil().setSp(24),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white10 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hexa3a2a2_10 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hexa3a2a2_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(180, 180, 180, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white9 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(9),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white9medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(9),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle white10medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle white10semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(10),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle white24 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(24),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle green11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(87, 136, 245, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white11medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle white11semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.none);

  static TextStyle white12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle gray95_12 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(148, 148, 148, 1),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white12medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle hexa3a2a2_12 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hexa0a0a0_12 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffa0a0a0),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle rgb250219183_14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(250, 219, 183, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hex00a3f2_12 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff00a3f2),
      fontSize: ScreenUtil().setSp(12),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hexff2a8a_12 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffFF6347),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white13medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);

  static TextStyle hexa3a2a2_13 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hexa3a2a2_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffffff),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle hexfbe099_13_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xfffbe099),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none);
  static TextStyle white14 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white14Medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hexa3a2a2_15 = TextStyle(
      fontFamily: hanyi,
      color: Color(0xff999999),
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white15 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      // overflow: TextOverflow.fade,
      decoration: TextDecoration.none);

  static TextStyle white15bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white15semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white16bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white16medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white237242250_11medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(237, 242, 250, 1),
      fontSize: ScreenUtil().setSp(11),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white237242250_17medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(237, 242, 250, 1),
      fontSize: ScreenUtil().setSp(17),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white19_semi = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(19),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white18 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white18mudium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white18bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white18semibold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hexffbd39_18_M = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffffbd39),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hexaa5000_18_S = TextStyle(
      fontFamily: hanyi,
      color: Color(0xffaa5000),
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white20bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle white20medium = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(20),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle white22bold = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(255, 255, 255, 1),
      fontSize: ScreenUtil().setSp(22),
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle hex0d141f_11 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(26, 26, 31, 1),
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_11 = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(11),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_11_M = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(11),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle hex0d141f_13 = TextStyle(
      fontFamily: hanyi,
      color: Color.fromRGBO(26, 26, 31, 1),
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_13 = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(13),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle jellyCyan_13_M = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(13),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_14 = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(14),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_15 = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(15),
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_15_M = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(15),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);

  static TextStyle jellyCyan_18_M = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
  static TextStyle jellyCyan_25_semi = TextStyle(
      fontFamily: hanyi,
      color: jellyCyanColor103224185,
      fontSize: ScreenUtil().setSp(25),
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
      decoration: TextDecoration.none);
}
