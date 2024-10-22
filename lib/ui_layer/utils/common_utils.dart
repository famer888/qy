import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_config.dart';
import '../../logger.dart';
import 'my_toast.dart';

import '../../domain/domain.dart';
import '../router/routes.dart';

class CommonUtils {
  static setStatusBar({bool isLight = false}) {
    if (kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
          isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    } else if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, //全局设置透明
          statusBarIconBrightness: isLight ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.black);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    } else if (Platform.isIOS) {
      //导航栏状态栏文字颜色
      SystemChrome.setSystemUIOverlayStyle(
          isLight ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    }
  }

  static Future<void> showDialog({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) async {
    await showGeneralDialog(
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      context: context,
      barrierDismissible: barrierDismissible,
      pageBuilder: (pageBuilderContext, __, ___) => builder(pageBuilderContext),
    );
  }

  static const _isDebug = !(bool.fromEnvironment('dart.vm.product'));

  static log(dynamic object) {
    if (_isDebug) {
      logger.i(object);
    }
  }

  static String convertEmojiAndHtml(String str) {
    if (str.isEmpty) return '';

    /// 转 html
    HtmlUnescape unescape = HtmlUnescape();
    str = unescape.convert(str);

    /// 转 emoji
    final Pattern unicodePattern = RegExp(r'\\\\u([0-9A-Fa-f]{4})');
    final String newStr =
        str.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1)!, radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    return newStr;
  }

  static launchUrl(String url) async {
    if (Uri.tryParse(url) case final uri?) {
      try {
        await url_launcher.launchUrl(uri,
            mode: url_launcher.LaunchMode.inAppBrowserView);
      } catch (_) {
        await url_launcher.launchUrl(uri);
      }
    }
  }

  static String getThumb(Map data) {
    final keys = [
      'media_url',
      'img_url',
      'resource_url',
      'thumb_horizontal',
      'thumb_vertical',
      'cover_thumb_horizontal',
      'cover_thumb_vertical',
      'cover_vertical',
      'cover_horizontal',
      'thumb_horizontal_url',
      'cover',
      'thumb',
      'bg_thumb',
      'thumb_vertical_url',
      'url',
    ];

    for (final key in keys) {
      if (data[key] case final value? when value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  static String clipImageUrl(String? url, {double inputWidth = 120}) {
    if (url == null) {
      return '';
    }
    String t = '';
    if (url.contains('!')) {
      return url;
    }

    inputWidth = inputWidth * (ScreenUtil().pixelRatio ?? 2.0);

    int width = 120;
    if (inputWidth > 720) {
      return url;
    } else if (inputWidth > 360) {
      width = 720;
    } else if (inputWidth > 120) {
      width = 360;
    }
    var list = url.split('.');
    if (list.length < 2) {
      return url;
    }
    for (var i = 0; i < list.length; i++) {
      t += list[i];

      if (i == list.length - 2) {
        t += '!${width}x0';
        t += '.';
        t += list.last;
        break;
      }
      t += '.';
    }
    return t;
  }

  static renderFixedNumber(int value) {
    late final String tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 1) + 'w'.tr();
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 1) + 'qa'.tr();
    } else {
      tips = value.toString().split('.')[0];
    }
    return tips;
  }

  static renderNumber(int value) {
    var tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 1) + 'W';
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 1) + 'K';
    } else {
      tips = value.toString().split('.')[0];
    }
    return tips;
  }

  static formatNum(double number, int postion) {
    if ((number.toString().length - number.toString().lastIndexOf('.') - 1) <
        postion) {
      //小数点后有几位小数
      return number
          .toStringAsFixed(postion)
          .substring(0, number.toString().lastIndexOf('.') + postion + 1)
          .toString();
    } else {
      return number
          .toString()
          .substring(0, number.toString().lastIndexOf('.') + postion + 1)
          .toString();
    }
  }

  static openRoute(BuildContext context, Map data) {
    if (data['link_url'] case final url? when url.isNotEmpty) {
      ///上报点击量
      context.read<HomeDomain>().reqAdClickCount(
            id: data['report_id'],
            type: data['report_type'],
          );

      if (data['redirect_type'] == 1) {
        final urlList = url.split('??');
        final Map<String, dynamic> params = {};
        if (urlList.first == BuildConfig.webViewPathName) {
          final newUrl = urlList.last.toString().substring(4).trim();
          if (kIsWeb) {
            launchUrl(Uri.decodeComponent(newUrl));
          } else {
            WebViewRoute(newUrl).push(context);
          }
        } else {
          if (urlList.length > 1 && urlList.last != '') {
            urlList[1].split('&').forEach((item) {
              final stringText = item.split('=');
              params[stringText[0]] =
                  stringText.length > 1 ? stringText[1] : null;
            });
          }
          String paramsStr = '';
          if (params.values.isNotEmpty) {
            params.forEach((key, value) {
              paramsStr += '/${Uri.decodeComponent(value)}';
            });
          }
          context.push('/${urlList.first}$paramsStr');
        }
      } else {
        launchUrl(data['link_url'].trim());
      }
    }
  }

  /// xfile限制图片大小
  static Future<bool> _pngLimitSize(XFile file) async {
    int length = await file.length();
    if (length / 1024 > 800) {
      MyToast.showText(text: 'qxzbkbp'.tr());
      return false;
    }
    return true;
  }

  /// xfile限制视频大小
  static Future<bool> _videoLimitSize(XFile file, {int size = 100}) async {
    int length = await file.length();
    if (length / (1024 * 1024) > size) {
      MyToast.showText(
        text:
            kIsWeb ? 'qxzbmbv'.tr().replaceAll('100', '$size') : 'qxzbmbv'.tr(),
      );
      return false;
    }
    return true;
  }

  static Future<XFile?> pickImage() async {
    if (await ImagePicker().pickImage(source: ImageSource.gallery)
        case final xFile? when await _pngLimitSize(xFile)) {
      return xFile;
    }
    return null;
  }

  static Future<XFile?> pickVideo() async {
    if (await ImagePicker().pickVideo(source: ImageSource.gallery)
        case final xFile? when await _videoLimitSize(xFile)) {
      return xFile;
    }
    return null;
  }

  ///把String分隔成4个字符一段的
  static String subStringFour(String text) {
    String str = '';
    int index = 1;
    for (var character in text.characters) {
      str += character;
      if (index % 4 == 0) {
        str += ' ';
      }
      index += 1;
    }
    str = str.trim();
    return str;
  }

  static getHMTime(int time) {
    int m = (time / 60).truncate();
    int s = (time - (m * 60)).truncate();
    String timeStr(int numb) {
      return numb < 10 ? '0$numb' : numb.toString();
    }

    return '${timeStr(m)}:${timeStr(s)}';
  }

  /// 检查安装未知安装包
  static checkRequestInstallPackages() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.requestInstallPackages.status;

      switch (status) {
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.permanentlyDenied:
          MyToast.showText(text: tr('jjazqq'));
          return false;
        default:
          await Permission.requestInstallPackages.request();
          return true;
      }
    }
    return false;
  }

  ///检查是否有权限
  static checkStoragePermission() async {
    //检查是否已有读写内存权限
    if (Platform.isAndroid) {
      PermissionStatus storageStatus = await Permission.storage.status;
      switch (storageStatus) {
        case PermissionStatus.granted:
          return true;
        case PermissionStatus.permanentlyDenied:
          MyToast.showText(text: tr('jjqxts'));
          return false;
        default:
          await Permission.storage.request();
          return true;
      }
    }
    return false;
  }
}

class RelativeDateFormat {
  static const num oneMinute = 60000;
  static const num oneHour = 3600000;
  static const num oneDay = 86400000;
  static const num oneWeek = 604800000;

  static final String oneSecondAgo = 'mq'.tr();
  static final String oneMinuteAgo = 'fq'.tr();
  static final String oneHourAgo = 'sq'.tr();
  static final String oneDayAgo = 'tq'.tr();
  static final String oneMonthAgo = 'yq'.tr();
  static final String oneYearAgo = 'nq'.tr();

  /// 时间转换
  static String format({DateTime? date}) {
    if (date case final target?) {
      num delta =
          DateTime.now().millisecondsSinceEpoch - target.millisecondsSinceEpoch;

      if (delta < 1 * oneMinute) {
        num seconds = toSeconds(delta);
        return '${(seconds <= 0 ? 1 : seconds).floor()}$oneSecondAgo';
      }
      if (delta < 60 * oneMinute) {
        num minutes = toMinutes(delta);
        return '${(minutes <= 0 ? 1 : minutes).floor()}$oneMinuteAgo';
      }
      if (delta < 24 * oneHour) {
        num hours = toHours(delta);
        return '${(hours <= 0 ? 1 : hours).floor()}$oneHourAgo';
      }
      if (delta < 48 * oneHour) {
        return 'zut'.tr();
      }
      if (delta < 30 * oneDay) {
        num days = toDays(delta);
        return '${(days <= 0 ? 1 : days).floor()}$oneDayAgo';
      }
      if (delta < 12 * 4 * oneWeek) {
        num months = toMonths(delta);
        return '${(months <= 0 ? 1 : months).floor()}$oneMonthAgo';
      } else {
        num years = toYears(delta);
        return '${(years <= 0 ? 1 : years).floor()}$oneYearAgo';
      }
    }
    return '';
  }

  static num toSeconds(num date) {
    return date / 1000;
  }

  static num toMinutes(num date) {
    return toSeconds(date) / 60;
  }

  static num toHours(num date) {
    return toMinutes(date) / 60;
  }

  static num toDays(num date) {
    return toHours(date) / 24;
  }

  static num toMonths(num date) {
    return toDays(date) / 30;
  }

  static num toYears(num date) {
    return toMonths(date) / 12;
  }

  static String getHMTime({int? time}) {
    if (time case final target?) {
      int m = (target / 60).truncate();
      int s = (target - (m * 60)).truncate();
      return '${formatTwoDigitNumber(m)}:${formatTwoDigitNumber(s)}';
    }
    return '';
  }

  /// 格式化两位数不足补0
  static String formatTwoDigitNumber(int number) =>
      number.toString().padLeft(2, '0');
}
