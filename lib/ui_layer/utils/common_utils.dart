import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import '../../app_config.dart';
import '../../crypto.dart';
import '../../logger.dart';
import '../notifiers/home_config_notifier.dart';
import '../screens/theme.dart';
import 'my_toast.dart';

import '../../domain/domain.dart';
import '../router/routes.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/js_util.dart' as js_util;

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

  static const _isDebug = !(bool.fromEnvironment('dart.vm.product'));

  static log(dynamic object) {
    if (_isDebug) {
      // logger.i(object);
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

  //苹果PWA浏览器
  static bool isPWA() {
    if (kIsWeb) {
      final isStandalone =
          html.window.matchMedia('(display-mode: standalone)').matches;
      final isIOSStandalone =
          js_util.getProperty(html.window.navigator, 'standalone') as bool? ??
              false;
      return isStandalone || isIOSStandalone;
    }
    return false;
  }

  static void copyToClipboard({required String text}) {
    if (kIsWeb) {
      final tempTextArea = html.TextAreaElement();
      tempTextArea.value = text;
      html.document.body!.append(tempTextArea);
      tempTextArea.select();
      html.document.execCommand('copy');
      tempTextArea.remove();
    } else {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  //苹果浏览器
  static bool isIPhoneWeb() {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('iphone') || userAgent.contains('ipad');
    }
    return false;
  }

  //安卓浏览器
  static bool isAndroidWeb() {
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('android');
    }
    return false;
  }

  //Safari浏览器
  static bool isSafariBrowser() {
    if (kIsWeb) {
      final ua = html.window.navigator.userAgent.toLowerCase();
      return ua.contains('iphone') &&
          ua.contains('safari') &&
          !ua.contains('crios') && // Chrome on iOS
          !ua.contains('fxios') && // Firefox on iOS
          !ua.contains('edg') && // Edge (new)
          !ua.contains('qqbrowser') && // QQ
          !ua.contains('micromessenger') && // wechat on ios
          !ua.contains('360browser') && // 360 on ios
          !ua.contains('baidubrowser') && // baidu on ios
          !ua.contains('huawei') && // hauwei on ios
          !ua.contains('miuibrowser') && // xaiomi on ios
          !ua.contains('quark') && // quark on ios
          !ua.contains('sogoumobilebrowser') && // sogo on ios
          !ua.contains('maxthon') && // aoyou on ios
          !ua.contains('cheetahbrowser') && // Cheetah on ios
          !ua.contains('ucbrowser'); // Uc on iOS
    }
    return false;
  }

  //下载APP
  static Future<void> downLoadApp(
      {required String pwaDownloadUrl, required String pwaApk}) async {
    String site = pwaDownloadUrl;
    String apk = pwaApk;
    Uri u = Uri.parse(html.window.location.href);
    String aff = u.queryParameters[BuildConfig.affCodeKey] ?? '';

    if (isIPhoneWeb()) {
      if (isSafariBrowser()) {
        await url_launcher.launchUrl(
            Uri.parse('$site${BuildConfig.mobileConfigPath}?aff_code=$aff'),
            webOnlyWindowName: '_self');
        await Future.delayed(const Duration(seconds: 2));
        bool flag = await url_launcher.launchUrl(
          Uri.parse('$site${BuildConfig.mobileprovisionPath}?v=1'),
          webOnlyWindowName: '_self',
        );
        if (!flag) {
          MyToast.showText(text: 'azbz'.tr());
        }
      } else {
        MyToast.showText(text: 'qsyxz'.tr());
      }
      return;
    }

    if (isAndroidWeb()) {
      copyToClipboard(text: '${BuildConfig.affCodeKey}:$aff');
      html.window.open(apk, '_blank');
      return;
    }

    html.window.open(site, '_blank');
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
    if (data['link_url'] ?? data['url_str'] case final url?
        when url.isNotEmpty) {
      if (data['report_id'] case final reportiId? when reportiId != null) {
        ///上报点击量 report_id存在才上报
        context.read<HomeDomain>().reqAdClickCount(
              id: data['report_id'],
              type: data['report_type'],
            );
      }

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

  static String optimizeWebText(String text) {
    if (kIsWeb) {
      final char = String.fromCharCode(0xFEFF);
      return text.split('').join(char);
    }
    return text;
  }

  static Future<bool> pngLimit2MSize(XFile file, {int size = 100}) async {
    int length = await file.length();
    if (length / 1024 > 2000) {
      MyToast.showText(
        text: tr('qxzb2mkbp'),
      );
      return true;
    }
    return false;
  }

  /// xfile限制图片大小
  static Future<bool> _pngLimitSize(XFile file) async {
    int length = await file.length();
    if (length / (1024 * 1024) > 5) {
      MyToast.showText(text: 'qxzbkbp'.tr());
      return false;
    }
    return true;
  }

  /// xfile限制视频大小
  static Future<bool> _videoLimitSize(XFile file, {int size = 2048}) async {
    int length = await file.length();
    if (length / (1024 * 1024) > size) {
      MyToast.showText(
        text: 'qxzbmbv'.tr(),
      );
      return false;
    }
    return true;
  }

  static Future<XFile?> pick2MImage() async {
    if (await ImagePicker().pickImage(source: ImageSource.gallery)
        case final xFile? when await pngLimit2MSize(xFile)) {
      return xFile;
    }
    return null;
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

  //自定义输入框
  static InputDecoration customInputStyle({
    String? hit,
    TextStyle? style,
    TextStyle? counterStyle,
    double horizontal = 8,
    double vertical = 0,
  }) {
    //边框
    OutlineInputBorder outline() {
      return OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0));
    }

    return InputDecoration(
      counterStyle: counterStyle,
      hoverColor: Colors.white,
      hintText: hit ?? 'qtxxbt'.tr(),
      hintStyle: style ?? MyTheme.white08_14,
      contentPadding:
          EdgeInsets.symmetric(horizontal: horizontal.w, vertical: vertical.w),
      disabledBorder: outline(),
      focusedBorder: outline(),
      border: outline(),
      enabledBorder: outline(),
    );
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

  static void localStorageImage(String imgUrl) async {
    if (kIsWeb) {
    } else {
      PermissionStatus storageStatus = await Permission.camera.status;
      if (storageStatus == PermissionStatus.denied) {
        storageStatus = await Permission.camera.request();
        if (storageStatus == PermissionStatus.denied ||
            storageStatus == PermissionStatus.permanentlyDenied) {
          MyToast.showText(text: tr('qdkqx'));
          return;
        } else {}
      } else if (storageStatus == PermissionStatus.permanentlyDenied) {
        MyToast.showText(text: tr('wfbc'));
        return;
      }
    }

    MyToast.showLoading(text: tr('bctpz'));
    final Uint8List? bytes = await CommonUtils.isolatedImage(imgUrl);
    if (bytes?.lengthInBytes == 0 || bytes == null) {
      MyToast.showText(text: tr('tpybc'));
      return;
    }

    if (kIsWeb) {
      dynamic blob = html.Blob([bytes]);
      String url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement anchor =
          html.document.createElement('a') as html.AnchorElement
            ..href = url
            ..style.display = 'none'
            ..download = '${CommonUtils.randomId(16)}.jpg';
      html.document.body?.children.add(anchor);
// download
      anchor.click();
// cleanup
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      final result = await ImageGallerySaver.saveImage(bytes); //这个是核心的保存图片的插件
      if (result['isSuccess']) {
        MyToast.showText(text: tr('tpybc'));
      } else if (Platform.isAndroid) {
        if (result.length > 0) {
          MyToast.showText(text: tr('tpybc'));
        }
      }
    }

    MyToast.closeAllLoading();
  }

  static Future<Uint8List?> isolatedImage(String url) async {
    Uint8List? bytes;
    if (kIsWeb) {
      html.HttpRequest xhr = await html.HttpRequest.request(
          method: 'GET', url, responseType: 'arraybuffer');
      if (xhr.response != null) {
        ByteBuffer bb = xhr.response;
        bytes = bb.asUint8List();
      }
    } else {
      final Uri resolved = Uri.base.resolve(url);
      final HttpClient httpClient = HttpClient()..autoUncompress = false;
      final HttpClientRequest request = await httpClient.getUrl(resolved);
      final HttpClientResponse response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        return null;
      }
      bytes = await consolidateHttpClientResponseBytes(response);
    }
    if (bytes?.lengthInBytes == 0 || bytes == null) {
      return null;
    }
    //解密后的图片
    Uint8List? bys;
    bys = await PlatformAwareCrypto.imageDecrypt(bytes);
    return bys;
  }

  //随机字符串
  static String randomId(int range) {
    String str = '';
    List<String> arr = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z',
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    for (int i = 0; i < range; i++) {
      int pos = Random().nextInt(arr.length - 1);
      str += arr[pos];
    }
    return str;
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

  //时间转换
  static String format({DateTime? date}) {
    date = date ?? DateTime.now();
    DateTime bjTime = DateTime.now();
    int time = (bjTime.millisecondsSinceEpoch / 1000).round();
    int step = (date.millisecondsSinceEpoch / 1000).round();
    int delta = time - step;
    if (delta < 60) {
      return '${delta <= 0 ? 1 : delta}${'mq'.tr()}';
    } else if (delta <= 3600) {
      int minutes = (delta / 60).floor();
      return '${minutes <= 0 ? 1 : minutes}${'fq'.tr()}';
    } else if (delta <= 43200) {
      //12小时为准
      int hours = (delta / 60 / 60).floor();
      return '${hours <= 0 ? 1 : hours}${'sq'.tr()}';
    } else {
      return '${date.month}月${date.day}日';
    }
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
