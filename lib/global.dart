/*
 * @Author: Tom
 * @Date: 2021-12-29 16:03:08
 * @LastEditTime: 2021-12-29 16:03:28
 * @LastEditors: Tom
 * @Description: 
 * @FilePath: /flutter2021/lib/global.dart
 */
// 应用级全局变量
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class AppGlobal {
  static FluroRouter router;
  // 全局路由实例
  static String comicThumb; //避免传参，用来记录漫画封面
  static dynamic comicData; // 漫画的数据
  static Map appinfo;
  static bool isSave = false;
  static String apiBaseURL = "";
  static int smallVideoLimit = 15;
  static List<String> apiLines = [
    "https://api1.uappapi.com/api.php",
    "https://api2.uappapi.com/api.php",
    "https://api3.uappapi1.com/api.php",
    "https://api4.uappapi1.com/api.php",
  ];

  static String uploadImgUrl;
  static String uploadImgKey;
  static String bannerImgBase;
  static String uploadMp4Url;
  static String uploadMp4Key;
  static String imgBase;
  static String apiToken;
  static int visibilityDetectorIndex = 0;
  static bool yyShow = true;
  static bool showActivity = true;
  static Box appBox;
  static Box imageCacheBox;
  static Box videoWatchRecordBox;
  static Box manhuaWatchRecordBox;
  static Box bookWatchRecordBox;
  static Box smallVideoWatchRecordBox;
  static List helpList = [];
  static int isSetPassword = 0;

  static dynamic yuemeiSellerInfoData;

// const VIP_LEVEL_NORMAL = 0;
// const VIP_LEVEL_TMP = 1;
// const VIP_LEVEL_WEEKLY = 2;
// const VIP_LEVEL_MONTHLY = 3;
// const VIP_LEVEL_QUARTERLY = 4;
// const VIP_LEVEL_HALFYEAR = 5;
// const VIP_LEVEL_ANNUAL = 6;
// const VIP_LEVEL_TWO_YEAR = 7;
// const VIP_LEVEL_LONG = 8;
// const VIP_LEVEL = [
//     self::VIP_LEVEL_NORMAL => '普通用户',
//     self::VIP_LEVEL_TMP => '临时会员',
//     self::VIP_LEVEL_WEEKLY => '周卡',
//     self::VIP_LEVEL_MONTHLY => '月卡',
//     self::VIP_LEVEL_QUARTERLY => '季卡',
//     self::VIP_LEVEL_HALFYEAR => '半年卡',
//     self::VIP_LEVEL_ANNUAL => '年卡',
//     self::VIP_LEVEL_TWO_YEAR => '两年卡',
//     self::VIP_LEVEL_LONG => '永久卡',
// ];
  static int vipLevel = 0;
  static BuildContext appContext;
  static bool apInit = false;
  static bool routerReplace = false;

  static Map<String, dynamic> currentDetailRouteExtra;
  static Map<String, dynamic> currentReaderRouteExtra;
  static Map<String, dynamic> webExtra;
  static List<dynamic> blues = []; //保存章节信息
  static bool isAutoBy = false; //是否自动购买
  static List<dynamic> comicDownloadList = []; //保存章节下载进度

  static GoRouter appRouter;
  static String m3u8_encrypt;
  static Widget banner = Container();

  static Map<dynamic, dynamic> yuemeiFilterOption;
  static int maxLines = 1000; //纯txt最大行
  static String rules = ""; //上传规则
  static List<Map<dynamic, dynamic>> reports = []; //上报播放记录
}
