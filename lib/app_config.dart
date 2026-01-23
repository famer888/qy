import 'package:flutter/foundation.dart';

class BuildConfig {
  static const appName = 'qypj';

  static const key = kIsWeb ? 'ffdf13c62bda8498' : '243de404db5e0f3a';
  static const iv = kIsWeb ? '1003a6bf984d0aa1' : 'f5c44a8cf74c0f56';
  static const appKey = kIsWeb
      ? '0d2c8b41b614bba3811e358f4983f82c'
      : '805d416b141a61bb857003b99704b6d5';
  static const ver = kIsWeb ? 'v3' : 'v2';

  static const mediaKey = 'f5d965df75336270';
  static const mediaIv = '97b60394abc2fbe1';
  static const secretKey = '56d028f9e1293e74';
  static const secretIv = '153bc771dcfda5af';
  static const defaultFdsKey =
      'Vo+r0rRtdYoBhEVNA2UI8tFni929kY3ew27aeqSfQVC2V4gZZo1glBD7S67/2ZVP';

  /// 备用接口线路
  static List<String> apiLines = kIsWeb
      ? [
          'https://api1.tptsrhf.xyz/api.php',
        ]
      : [
          'https://api2.tptsrhf.xyz/api.php',
          'https://api3.tptsrhf.xyz/api.php',
          'https://api4.tptsrhf.xyz/api.php',
        ];

  /// 备用线路
  static const githubLine =
      'https://raw.githubusercontent.com/ailiu258099-blip/master/main/qy.txt';

  static final fdsKeyApi = [
    'https://wvseee.jsbacjr.com/mb.txt',
    'https://gitee.com/fdsaw/ffewelmcxww/raw/master/mb.txt',
  ];

  /// 跳转webview路径
  static const webViewPathName = 'ktloadwebview';

  static const affCodeKey = '${appName}b_aff';

  static const webBundleId = 'com.pwa.$appName';

  static const cacheKeys = (
    appBox: '${appName}box',
    chats: '${appName}box_Chats',
    videoBox: '${appName}_video_box',
    imageBox: '${appName}box_ImageCache',
    girlBox: '${appName}girl_box',
    imageCacheSalt: 'B181a0y1tL',
  );

  static const mobileConfigPath = '/index.php/index/mobileConfig';
  static const mobileprovisionPath = '/js/embedded.mobileprovision';
}
