import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
// import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isolated_worker/worker_delegator.dart';
import 'package:provider/provider.dart';
import 'package:qypj/global.dart';
import 'package:qypj/routers.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:qypj/store/homeConfig.dart';
// import 'package:qypj/theme/default.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';

void main() async {
  // 初始化数据库，必须放在最前面·
  await Hive.initFlutter();
  AppGlobal.appBox = await Hive.openBox('qypjbox'); // 用于存储一些简单的键值对
  AppGlobal.imageCacheBox = await Hive.openBox('qypjbox_ImageCache'); //图片缓存
  AppGlobal.videoWatchRecordBox =
      await Hive.openBox('qypjbox_VideoWatchRecord');
  AppGlobal.manhuaWatchRecordBox =
      await Hive.openBox('qypjbox_ManhuaWatchRecord');
  AppGlobal.bookWatchRecordBox = await Hive.openBox('qypjbox_BookWatchRecord');
  AppGlobal.smallVideoWatchRecordBox =
      await Hive.openBox('qypjbox_smallVideoWatchRecord');
  //注册图片加载线程
  DefaultDelegate<dynamic, dynamic> fooDelegate =
      DefaultDelegate(callback: PlatformAwareCrypto.decryptImage);
  JsDelegate fooJsDelegate = JsDelegate(callback: 'decryptImage');
  List<WorkerDelegate<dynamic, dynamic>> wds = List.generate(
      5,
      (index) => WorkerDelegate(
            key: 'decryptImage$index',
            defaultDelegate: fooDelegate,
            jsDelegate: fooJsDelegate,
          ));
  WorkerDelegator().addAllDelegates(wds);
  await WorkerDelegator().importScripts(const <String>[
    'js/aware.js?v=2',
    'https://cdnjs.cloudflare.com/ajax/libs/crypto-js/4.1.1/crypto-js.min.js?v=2'
  ]);

  // 搭建m3u8代理服务器
  // if (!kIsWeb) {
  //   var handler =
  //       const Pipeline().addMiddleware(logRequests()).addHandler(_echoRequest);
  //   var server = await shelf_io.serve(handler, 'localhost', 8888);
  //   server.autoCompress = true;
  //   CommonUtils.debugPrint(
  //       'Serving at http://${server.address.host}:${server.port}');
  // }
  // 初始化全局路由
  // 初始化APP基础信息
  AppGlobal.apiToken = AppGlobal.appBox.get('qypj_token') ?? "";
  AppGlobal.appinfo = {
    "oauth_id": CommonUtils.gvMD5(AppGlobal.appBox.get('oauth_id') ??
        '${CommonUtils.randomId(16)}_${DateTime.now().millisecondsSinceEpoch.toString()}'),
    "bundleId": "com.pwa.qypj",
    "version": "1.0.0",
    "oauth_type": "web",
    "language": 'zh',
    "via": 'pwa',
  };
  //设备ID统一32位
  if (!kIsWeb) {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      // bool vx = await DownloadUtil.getPermission();
      // if (!vx) {
      //   await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      //   return;
      // }
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      // String osid = await DownloadUtil.getUniqueId();
      AppGlobal.appinfo = {
        "oauth_id": CommonUtils.gvMD5(androidInfo.androidId),
        "bundleId": packageInfo.packageName,
        "version": packageInfo.version,
        "oauth_type": "android",
      };
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      AppGlobal.appinfo = {
        "oauth_id": CommonUtils.gvMD5(iosInfo.identifierForVendor),
        "bundleId": packageInfo.packageName,
        "version": "1.0.0",
        "oauth_type": "ios",
      };
    }
  } else {
    AppGlobal.appBox.put('oauth_id', AppGlobal.appinfo['oauth_id']);
  }
  //  test
  // AppGlobal.appinfo = {
  //   "oauth_id": "b91524d2fcd0ad89",
  //   "version": "3.2.0",
  //   "oauth_type": "android",
  // };

  //路由初始化
  // final _frouter = FluroRouter();
  // FluroRoutes.configureRoutes(_frouter);
  // AppGlobal.router = _frouter;
  //本地JSON初始化
  await CommonUtils.loadJSON();

  debugRepaintRainbowEnabled = false;
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeConfig()),
    ],
    child: qypj(),
  ));
  // 强制竖屏
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  CommonUtils.setStatusBar(isLight: true);
}

final _router = AppGlobal.appRouter = Routes.init();

class qypj extends StatefulWidget {
  qypj({Key key}) : super(key: key);
  @override
  _qypjState createState() => _qypjState();
}

class _qypjState extends State<qypj> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final botToastBuilder = BotToastInit();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ScreenUtilInit(
        designSize: Size(375, 667),
        builder: () => MaterialApp.router(
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: CommonUtils.txt("yybt"),
          builder: (context, widget) {
            widget = botToastBuilder(context, widget);
            widget = MediaQuery(
              //设置文字大小不随系统设置改变
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget,
            );
            return widget;
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: MaterialColor(
              0xFF000000, //改了不好看
              <int, Color>{
                50: Color(0xFF000000),
                100: Color(0xFF000000),
                200: Color(0xFF000000),
                300: Color(0xFF000000),
                400: Color(0xFF000000),
                500: Color(0xFF000000),
                600: Color(0xFF000000),
                700: Color(0xFF000000),
                800: Color(0xFF000000),
                900: Color(0xFF000000),
              },
            ),
          ),
        ),
      ),
    );
  }
}
