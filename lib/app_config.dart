class BuildConfig {
  static const appName = 'qypj';

  static const key = '2acf7e91e9864673';
  static const iv = '1c29882d3ddfcfd6';
  static const appKey = '5589d41f92a597d016b037ac37db243d';
  static const mediaKey = 'f5d965df75336270';
  static const mediaIv = '97b60394abc2fbe1';
  static const secretKey = '56d028f9e1293e74';
  static const secretIv = '153bc771dcfda5af';
  static const defaultFdsKey =
      'Vo+r0rRtdYoBhEVNA2UI8tFni929kY3ew27aeqSfQVC2V4gZZo1glBD7S67/2ZVP';

  /// 备用接口线路
  static final apiLines = [
    'https://api1.lambaz1.net/api.php',
    'https://api2.uappapi.com/api.php',
    'https://api3.uappapi1.com/api.php',
    'https://api4.uappapi1.com/api.php',
  ];

  /// 备用线路
  static const githubLine =
      'https://raw.githubusercontent.com/little-5/backup/master/${appName}b.txt';

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
}
