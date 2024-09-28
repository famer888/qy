import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:bot_toast/bot_toast.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/model/imchat_model.dart';
import 'package:qypj/theme/default.dart';
import 'package:hive/hive.dart';
import 'package:isolated_worker/worker_delegator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qypj/utils/extensionlibrary.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/systemnotice.dart';
import 'package:qypj/store/homeConfig.dart';
import 'package:qypj/utils/api.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/http.dart';
import 'package:convert/convert.dart';
import 'package:qypj/utils/logUtilS.dart';
import 'package:universal_html/html.dart' as html;
import 'package:vibration/vibration.dart';

Map _cacheJSON = {}; //全局使用

class CommonUtils {
  //导航栏
  static Widget createNav({Widget left, Widget right, Widget title}) {
    return Column(
      children: [
        SizedBox(height: GQStyle.topHeight),
        Container(
          padding: EdgeInsets.symmetric(horizontal: GQStyle.pagePadding),
          height: GQStyle.navbarHegiht,
          width: ScreenUtil().screenWidth,
          child: Stack(
            children: [
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    left ?? SizedBox(width: 20.w, height: 20.w),
                    right ?? SizedBox(width: 20.w, height: 20.w),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Center(child: title),
              )
            ],
          ),
        )
      ],
    );
  }

  //关闭键盘
  static bool unFocusNode(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (currentFocus.focusedChild == null && kIsWeb) {
      return true;
    } else if (currentFocus.hasPrimaryFocus) {
      return true;
    } else {
      return false;
    }
  }

  static showMsgNoti(ChatMessage chat) async {
    if (!kIsWeb && await Vibration.hasVibrator() == true) {
      Vibration.vibrate();
    }
    // return BotToast.showSimpleNotification(
    //   title: CommonUtils.txt("tzzz"),
    //   subTitle: CommonUtils.txt("nyxxx"),
    //   titleStyle: GQStyle.black1434,
    //   subTitleStyle: GQStyle.gray105_12,
    //   backgroundColor: Colors.white,
    //   onTap: () {
    //     AppGlobal.appContext.push(
    //         "/imtochatpage/${chat.touser?.uuid}/${chat.touser?.nickname ?? ""}/${chat.touser?.avatar?.isEmpty == true ? " " : (chat.touser?.avatar ?? "")}");
    //   },
    // );
  }

  //特殊字符处理
  static Widget getContentSpan(
    String text, {
    bool isCopy = false,
    TextStyle style,
    TextStyle lightStyle,
  }) {
    style = style ?? GQStyle.gray102_14;
    lightStyle = lightStyle ??
        TextStyle(
            color: const Color.fromRGBO(25, 103, 210, 1), fontSize: 14.sp);
    List<InlineSpan> _contentList = [];
    RegExp exp = RegExp(
        r'(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int index = 0;
    for (var match in matches) {
      /// start 0  end 8
      /// start 10 end 12
      String c = text.substring(match.start, match.end);
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index, match.start);
        index = match.end;
        _contentList.add(
          TextSpan(text: a, style: style),
        );
      }
      if (RegexUtil.isURL(c)) {
        _contentList.add(TextSpan(
            text: c,
            style: lightStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                CommonUtils.launchURL(text.substring(match.start, match.end));
              }));
      } else {
        _contentList.add(
          TextSpan(text: c, style: style),
        );
      }
    }
    if (index < text.length) {
      String a = text.substring(index, text.length);
      _contentList.add(
        TextSpan(text: a, style: style),
      );
    }
    if (isCopy) {
      return SelectableText.rich(
        TextSpan(children: _contentList),
        strutStyle:
            const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5),
      );
    }
    return RichText(
        textAlign: TextAlign.left,
        text: TextSpan(children: _contentList),
        strutStyle:
            const StrutStyle(forceStrutHeight: true, height: 1, leading: 0.5));
  }

  static Widget memberVip(
    String value, {
    double h = 16,
    double fontsize = 10,
    double margin = 0,
  }) {
    return value.isEmpty || value == null
        ? Container()
        : Container(
            height: h.w,
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            margin: EdgeInsets.only(right: margin.w),
            decoration: kIsWeb
                ? BoxDecoration(
                    color: Color(0xFFf4d4b5),
                    borderRadius: BorderRadius.all(Radius.circular(h.w / 2)))
                : BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFf5e0d1),
                      Color(0xFFfbeadd),
                      Color(0xFFf4d4b5)
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.all(Radius.circular(h.w / 2))),
            child: Center(
                child: Text(value,
                    style: TextStyle(
                        color: Color(0xFF89583c), fontSize: fontsize.sp))),
          );
  }

  //加载动画
  static startLoadGIF({String tip = "加载中"}) {
    BotToast.showCustomLoading(toastBuilder: (cancelFunc) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(54, 54, 54, 0.8),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        height: ScreenUtil().setWidth(110),
        width: ScreenUtil().setWidth(110),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // LImage("ref_data_n",
            //     width: ScreenUtil().setWidth(40),
            //     height: ScreenUtil().setWidth(40),
            //     ext: ".gif"),
            Column(
              children: [
                Container(
                  width: ScreenUtil().setWidth(25),
                  height: ScreenUtil().setWidth(25),
                  child: CircularProgressIndicator(
                    color: GQStyle.jellyCyanColor103224185,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setWidth(12),
            ),
            Text(tip, style: GQStyle.white255_14)
          ],
        ),
      );
    });
  }

  //xfile限制视频大小
  static Future<bool> videoLimitSize(XFile file, {int size = 100}) async {
    int length = await file.length();
    if (length / (1024 * 1024) > size) {
      CommonUtils.showText(CommonUtils.txt("qxzbmbv"));
      return true;
    }
    return false;
  }

  //xfile限制图片大小
  static Future<bool> pngLimitSize(XFile file) async {
    int length = await file.length();
    if (length / 1024 > 1000) {
      CommonUtils.showText(CommonUtils.txt("qxzbkbp"));
      return true;
    }
    return false;
  }

  //初始化加载本地JSON
  static Future<void> loadJSON() async {
    if (_cacheJSON.length == 0) {
      ByteData data = await rootBundle.load("assets/file/ext.json");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      _cacheJSON = jsonDecode(utf8.decode(bytes));
    }
  }

  //加载本地文字
  static String txt(String key) {
    return _cacheJSON[key] ?? "未知";
  }

  static Size boundingTextSize(
      BuildContext context, String text, TextStyle style,
      {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text == null || text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        locale: Localizations.localeOf(context),
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }

  static setStatusBar({bool isLight = false}) {
    if (kIsWeb) {
      return SystemChrome.setSystemUIOverlayStyle(
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

  static Widget identiWget(dynamic data,
      {bool isHideCoin = false, double topRightRaiuds = 5}) {
    int flag = data["is_free"] ?? data["isfree"];
    String type = "";
    if (flag == 0) {
      type = CommonUtils.txt("mf");
    } else if (flag == 1) {
      type = "VIP";
    } else {
      type =
          "${isHideCoin ? "" : (data["coins"] ?? data["view_money"])}${txt("jb")}";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(8)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFdf6e49), Color(0xFFb62c1f)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(5),
            topRight: Radius.circular(topRightRaiuds)),
      ),
      height: ScreenUtil().setWidth(18),
      child: Center(child: Text(type, style: GQStyle.white255_10)),
    );
  }

// -
  static Color freeColor1 = Color(0xff00edfa);
  static Color freeColor2 = Color(0xff00baef);

  static Color vipColor1 = Color(0xffff7d3e);
  static Color vipColor2 = Color(0xffffcd3b);

  static Color dimondColor1 = Color(0xffb19afb);
  static Color dimondColor2 = Color(0xff3386ef);

  ///漫画 用的身份图标
  static Widget identifyWidget(dynamic data,
      {bool isHideCoin = false, double topRightRaiuds = 5}) {
    int flag = data["is_free"] ?? data["isfree"];
    String type = "";
    Color color1;
    Color color2;

    if (flag == 0) {
      type = CommonUtils.txt("mf");
      color1 = freeColor1;
      color2 = freeColor2;
    } else if (flag == 1) {
      type = "VIP";
      color2 = vipColor1;
      color1 = vipColor2;
    } else {
      type = "${(data["coins"] ?? data["view_money"])}${txt("jb")}";
      color1 = dimondColor1;
      color2 = dimondColor2;

      if (data["coins"] == null && data["view_money"] == null) {
        isHideCoin = true;
      }
      // return Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     LImage('comic_little_diamond',
      //         width: ScreenUtil().setWidth(10), scale: 1),
      //     SizedBox(width: ScreenUtil().setWidth(2.5)),
      //     Text(type, style: GQStyle.jellyCyan_11_M)
      //   ],
      // );
    }

    return isHideCoin == true
        ? Container()
        : ClipPath(
            clipper: ComicIdentifyClipper(),
            child: Container(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setWidth(2.5),
                  bottom: ScreenUtil().setWidth(2.5),
                  left: ScreenUtil().setWidth(3.5),
                  right: ScreenUtil().setWidth(6.5)),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color1, color2],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              // height: ScreenUtil().setWidth(20),
              child: Center(
                  child: Text(type,
                      style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                          fontSize: ScreenUtil().setSp(11),
                          height: 1.2,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none))),
            ),
          );
  }

  static int platform() {
    if (kIsWeb) {
      return 2;
    } else if (Platform.isAndroid) {
      return 0;
    } else {
      return 1;
    }
  }

  static updateSystemNotice(context) async {
    SystemNotice sysResult = await getSystemNotice();
    CommonUtils.debugPrint(sysResult.toJson());
    if (sysResult.status == 1) {
      Provider.of<HomeConfig>(context, listen: false)
          .setSystemNotice(sysResult);
    }
  }

  static showText(String text, {int time, Function call}) {
    return BotToast.showText(
      text: text,
      contentColor: Color(0xFF1C1C1C),
      textStyle: TextStyle(
          color: Colors.white,
          fontSize: ScreenUtil().setSp(13),
          decoration: TextDecoration.none),
      align: Alignment(0, 0),
      duration: new Duration(seconds: time != null ? time : 2),
      contentPadding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(45),
        vertical: ScreenUtil().setWidth(23),
      ),
      onClose: call,
    );
  }

  static getHMTime(int time) {
    int s = (time / 60).truncate();
    int h = (time - (s * 60)).truncate();
    String timeStr(int numb) {
      return numb < 10 ? '0$numb' : numb.toString();
    }

    return '${timeStr(s)}:${timeStr(h)}';
  }

  // 检查安装未知安装包
  static checkRequestInstallPackages() async {
    if (Platform.isAndroid) {
      PermissionStatus _status = await Permission.requestInstallPackages.status;
      if (_status == PermissionStatus.granted) {
        return true;
      } else if (_status == PermissionStatus.permanentlyDenied) {
        CommonUtils.showText(CommonUtils.txt('jjazqq'));
        return false;
      } else {
        await Permission.requestInstallPackages.request();
        return true;
      }
    }
  }

  ///检查是否有权限
  static checkStoragePermission() async {
    //检查是否已有读写内存权限
    if (Platform.isAndroid) {
      PermissionStatus storageStatus = await Permission.storage.status;
      if (storageStatus == PermissionStatus.granted) {
        return true;
      } else if (storageStatus == PermissionStatus.permanentlyDenied) {
        CommonUtils.showText(CommonUtils.txt('jjqxts'));
        return false;
      } else {
        await Permission.storage.request();
        return true;
      }
    }
  }

  static renderFixedNumber(int value) {
    var tips;
    if (value >= 10000) {
      var newvalue = (value / 1000) / 10.round();
      tips = formatNum(newvalue, 1) + CommonUtils.txt('w');
    } else if (value >= 1000) {
      var newvalue = (value / 100) / 10.round();
      tips = formatNum(newvalue, 1) + CommonUtils.txt('qa');
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
    if ((number.toString().length - number.toString().lastIndexOf(".") - 1) <
        postion) {
      //小数点后有几位小数
      return number
          .toStringAsFixed(postion)
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    } else {
      return number
          .toString()
          .substring(0, number.toString().lastIndexOf(".") + postion + 1)
          .toString();
    }
  }

  static launchURL(String url) async {
    try {
      await launch(url, forceSafariVC: false);
    } catch (e) {
      BotToast.showText(text: CommonUtils.txt('wzcw'));
    }
  }

  static String getRealHash([String value]) {
    if (kIsWeb) {
      var currentHash = html.window.location.hash.replaceAll('#', '');
      if (value == null) return currentHash;
      if (currentHash.lastIndexOf('/') == currentHash.length - 1) {
        return '$currentHash$value';
      } else {
        return '$currentHash/$value';
      }
    } else {
      var location = '${AppGlobal.appRouter.location}/$value';
      if (value == null) return AppGlobal.appRouter.location;
      if (location.contains('//')) {
        var current = location.replaceAll('//', '/');
        return current;
      } else {
        return location;
      }
    }
  }

  static void debugPrint(value) {
    LogUtilS.d(value);
  }

  static List<List> tasks = [];
  static List<bool> wdsRuningStatuses = List.generate(5, (index) => false);

  static void getRealImage({dynamic url, dynamic imgUrl, Function setUrl}) {
    if (url == null) return CommonUtils.debugPrint(CommonUtils.txt('wfmt'));
    void doWork(args, _freeIndex) async {
      if (args[0] != null || args[1] != null || args[0] != '') {
        dynamic decrypted;
        decrypted = AppGlobal.imageCacheBox.get(args[0]);
        if (decrypted == null) {
          try {
            String data = await PlatformAwareHttp.getImage(args[0]);
            if (data != '' && data != null) {
              decrypted =
                  await WorkerDelegator().run('decryptImage$_freeIndex', data);
              // decrypted = kIsWeb ? base64.decode(decrypted) : decrypted;
              decrypted = base64Decode(decrypted);
              if (decrypted != null) {
                AppGlobal.imageCacheBox.put(args[0], decrypted);
              }
            }
          } catch (err) {
            // CommonUtils.debugPrint('图片请求失败$err');
          }
        }
        if (decrypted != null && args[2] != null) {
          args[2](decrypted);
        }
      }
      wdsRuningStatuses[_freeIndex] = false;
      int f = wdsRuningStatuses.indexWhere((element) => !element);
      if (tasks.length > 0 && f != -1) {
        wdsRuningStatuses[f] = true;
        doWork(tasks.removeAt(0), f);
      }
    }

    tasks.add([url, imgUrl, setUrl]);
    int freeIndex = wdsRuningStatuses.indexWhere((element) => !element);
    if (freeIndex != -1 && tasks.length > 0) {
      wdsRuningStatuses[freeIndex] = true;
      doWork(tasks.removeAt(0), freeIndex);
    }
  }

  static String randomId(int range) {
    String str = "";
    List<String> arr = [
      "0",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z",
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];
    for (int i = 0; i < range; i++) {
      int pos = new Random().nextInt(arr.length - 1);
      str += arr[pos];
    }
    return str;
  }

  static String gvMD5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    var text = hex.encode(digest.bytes);
    return text;
  }

  static String gvSha256(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = sha256.convert(content);
    var text = hex.encode(digest.bytes);
    return text;
  }

  static getThumb(dynamic data) {
    if (data['media_url'] != null && data['media_url'] != '') {
      return data['media_url'];
    } else if (data['img_url'] != null && data['img_url'] != '') {
      return data['img_url'];
    } else if (data['resource_url'] != null && data['resource_url'] != '') {
      return data['resource_url'];
    } else if (data['thumb_horizontal'] != null &&
        data['thumb_horizontal'] != '') {
      return data['thumb_horizontal'];
    } else if (data['thumb_vertical'] != null && data['thumb_vertical'] != '') {
      return data['thumb_vertical'];
    } else if (data['cover_thumb_horizontal'] != null &&
        data['cover_thumb_horizontal'] != '') {
      return data['cover_thumb_horizontal'];
    } else if (data['cover_thumb_vertical'] != null &&
        data['cover_thumb_vertical'] != '') {
      return data['cover_thumb_vertical'];
    } else if (data['cover_vertical'] != null && data['cover_vertical'] != '') {
      return data['cover_vertical'];
    } else if (data['cover_horizontal'] != null &&
        data['cover_horizontal'] != '') {
      return data['cover_horizontal'];
    } else if (data['thumb_horizontal_url'] != null &&
        data['thumb_horizontal_url'] != '') {
      return data['thumb_horizontal_url'];
    } else if (data['cover'] != null && data['cover'] != '') {
      return data['cover'];
    } else if (data['thumb'] != null && data['thumb'] != '') {
      return data['thumb'];
    } else {
      return data['thumb_vertical_url'] ?? "";
    }
  }

  static void checkline({Function onSuccess, Function onFailed}) async {
    Box box = AppGlobal.appBox;
    List<String> unChecklines = box.get('lines_url') == null
        ? AppGlobal.apiLines
        : List<String>.from(box.get('lines_url'));
    // List<String> unChecklines = ["https://7uapi.hyys.info/api.php"];
    List<Map> errorLines = [];
    // int errorCount = 0;
    Function checkGit;
    Function doCheck;
    Function handleResult;

    Function reportErrorLines = () async {
      // 上报错误线路&保存服务端推荐线路到本地
      if (errorLines.length == 0) return;
      await PlatformAwareHttp.post('/api/home/domainCheckReport',
          data: {'list': errorLines});
    };

    handleResult = (String line) async {
      if (line != null) {
        AppGlobal.apiBaseURL = line;
        await reportErrorLines();
        onSuccess();
      } else {
        onFailed();
      }
    };

    checkGit = () async {
      String git = box.get("github_url") == null
          ? "https://raw.githubusercontent.com/little-5/backup/master/qypjb.txt"
          : box.get("github_url").toString();
      dynamic result;
      if (kIsWeb) {
        result = await html.HttpRequest.request(git, method: "GET")
            .then((value) => value.response)
            .timeout(Duration(milliseconds: 5 * 1000));
      } else {
        result = await new Dio(
                BaseOptions(connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
            .get(git);
      }

      handleResult(result.toString().trim());
    };

    doCheck = ({String line}) async {
      int code = 0;
      if (!kIsWeb) {
        try {
          Response<dynamic> resp = await Dio(BaseOptions(
                  connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
              .get("https://wvseee.jsbacjr.com/mb.txt");
          if (resp.statusCode == 200) {
            AppGlobal.appBox.put(
                "fds_key", resp.data.toString().replaceAll("\n", "") ?? "");
          }
        } catch (_) {
          try {
            Response<dynamic> resp = await Dio(BaseOptions(
                    connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
                .get("https://gitee.com/fdsaw/ffewelmcxww/raw/master/mb.txt");
            if (resp.statusCode == 200) {
              AppGlobal.appBox.put(
                  "fds_key", resp.data.toString().replaceAll("\n", "") ?? "");
            }
          } catch (_) {}
        }
      }
      try {
        if (kIsWeb) {
          code = await html.HttpRequest.request('$line/api/callback/checkLine',
                  method: "POST")
              .then((value) => value.status)
              .timeout(Duration(milliseconds: 5 * 1000));
        } else {
          code = await new Dio(BaseOptions(headers: {
            'Cf-Ray-Xf': await PlatformAwareCrypto.secretValue()
          }, connectTimeout: 5 * 1000, receiveTimeout: 5 * 1000))
              .post('$line/api/callback/checkLine')
              .then((value) => value.statusCode);
        }
      } catch (err) {
        code = 0;
      }
      CommonUtils.debugPrint(code);
      if (code == 200) {
        handleResult(line);
      } else {
        errorLines.add({'url': line});
        //启用备用github线路
        if (errorLines.length == unChecklines.length &&
            unChecklines.length > 1) {
          checkGit();
        }
      }
    };

    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      onFailed();
    } else {
      for (var i = 0; i < unChecklines.length; i++) {
        if (AppGlobal.apiBaseURL.isEmpty) {
          await doCheck(line: unChecklines[i]);
        } else {
          break;
        }
      }
    }
  }

  static String convertEmojiAndHtml(String str) {
    // 转 html
    var unescape = new HtmlUnescape();
    str = unescape.convert(str);
    // print(text);

    // 转 emoji
    final Pattern unicodePattern = new RegExp(r'\\\\u([0-9A-Fa-f]{4})');
    final String newStr =
        str.replaceAllMapped(unicodePattern, (Match unicodeMatch) {
      final int hexCode = int.parse(unicodeMatch.group(1), radix: 16);
      final unicode = String.fromCharCode(hexCode);
      return unicode;
    });

    // print('Old string: $str');
    // print('New string: $newStr');

    return newStr;
  }
}

class RelativeDateFormat {
  static final num oneMinute = 60000;
  static final num oneHour = 3600000;
  static final num oneDay = 86400000;
  static final num oneWeek = 604800000;

  static final String oneSecondAgo = CommonUtils.txt('mq');
  static final String oneMinuteAgo = CommonUtils.txt('fq');
  static final String oneHourAgo = CommonUtils.txt('sq');
  static final String oneDayAgo = CommonUtils.txt('tq');
  static final String oneMonthAgo = CommonUtils.txt('yq');
  static final String oneYearAgo = CommonUtils.txt('nq');

  //时间转换
  static String format(DateTime date) {
    num delta =
        DateTime.now().millisecondsSinceEpoch - date.millisecondsSinceEpoch;

    if (delta < 1 * oneMinute) {
      num seconds = toSeconds(delta);
      return (seconds <= 0 ? 1 : seconds).toInt().toString() + oneSecondAgo;
    }
    if (delta < 60 * oneMinute) {
      num minutes = toMinutes(delta);
      return (minutes <= 0 ? 1 : minutes).toInt().toString() + oneMinuteAgo;
    }
    if (delta < 24 * oneHour) {
      num hours = toHours(delta);
      return (hours <= 0 ? 1 : hours).toInt().toString() + oneHourAgo;
    }
    if (delta < 48 * oneHour) {
      return CommonUtils.txt('zut');
    }
    if (delta < 30 * oneDay) {
      num days = toDays(delta);
      return (days <= 0 ? 1 : days).toInt().toString() + oneDayAgo;
    }
    if (delta < 12 * 4 * oneWeek) {
      num months = toMonths(delta);
      return (months <= 0 ? 1 : months).toInt().toString() + oneMonthAgo;
    } else {
      num years = toYears(delta);
      return (years <= 0 ? 1 : years).toInt().toString() + oneYearAgo;
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
}

//加载本地图片
class LImage extends StatefulWidget {
  LImage(this.name,
      {Key key,
      this.width,
      this.height,
      this.fit,
      this.color,
      this.scale,
      this.ext = ".png"})
      : super(key: key);
  final String name;
  final double width;
  final double height;
  final BoxFit fit;
  final Color color;
  final double scale;
  final String ext;

  @override
  State<LImage> createState() => _LImageState();
}

class _LImageState extends State<LImage> {
  Widget _child = Container();

  @override
  void initState() {
    super.initState();
  }

  _loadImage() async {
    //开发先取消，后面统一处理
    _child = Image.asset(
      "assets/images/${widget.name}${widget.ext}",
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.color,
      scale: widget.scale,
    );
    setState(() {});
    return;
    if (_cacheJSON.length == 0 || widget.name == null) return;
    ByteData data =
        await rootBundle.load("assets/images/${_cacheJSON[widget.name]}");
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    List<int> dbytes =
        base64Decode(PlatformAwareCrypto.decry(utf8.decode(bytes)));
    if (dbytes != null || dbytes.length > 0) {
      _child = Image.memory(dbytes,
          fit: widget.fit,
          height: widget.height,
          width: widget.width,
          color: widget.color);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadImage();
    return _child;
  }
}

clipImageUrl(String url, {double inputWidth = 120}) {
  if (url == null) {
    return '';
  }
  String t = '';
  if (url != null && url.contains('!')) {
    return url;
  }

  inputWidth = inputWidth * ScreenUtil().pixelRatio;

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

class ComicIdentifyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = ScreenUtil().setWidth(2.5);

    double rightMargin = ScreenUtil().setWidth(6.5);

    // radius = 5;
    // rightMargin = 10;
    double halfRadius = radius / 2.0;

    Path path = Path();
    // double roundFactor = size.width;
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    path.lineTo(size.width - radius, 0);

    path.quadraticBezierTo(size.width, 0, size.width - 0, halfRadius);

    path.lineTo(
        size.width - rightMargin + halfRadius, size.height - halfRadius);

    path.quadraticBezierTo(size.width - rightMargin, size.height,
        size.width - rightMargin - halfRadius, size.height);

    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.lineTo(0, radius);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class StatusStrokBorderText extends StatelessWidget {
  const StatusStrokBorderText({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(7)),
      height: ScreenUtil().setWidth(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(17)),
          border: Border.all(color: Color(0xffffffff), width: 0.5)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xffffffff),
              fontSize: ScreenUtil().setSp(10),
              overflow: TextOverflow.ellipsis,
              height: 1,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}

class StatusBorderText extends StatelessWidget {
  const StatusBorderText({Key key, this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(9)),
      width: ScreenUtil().setWidth(39),
      height: ScreenUtil().setWidth(21),
      decoration: BoxDecoration(
        color: Color(0xff26313a),
        borderRadius: BorderRadius.circular(ScreenUtil().setWidth(21 / 2)),
        // border: Border.all(color: Color(0xffffffff), width: 0.5)
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xffffffff),
              fontSize: ScreenUtil().setSp(11),
              overflow: TextOverflow.visible,
              height: 1.2,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
