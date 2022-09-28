import 'dart:convert';

import 'package:qypj/utils/http.dart';
import 'package:qypj/utils/networkImage.dart';
import 'dart:convert' as convert;

class ComicDownloadManager {
  static List<dynamic> list = []; //保存章节下载进度

  static startWithObject(dynamic chapter) async {
    list.add(chapter);

    for (var item in chapter['list']) {
      String imgUrl = item['img_url'];

      String dataStr = await PlatformAwareHttp.getImage(imgUrl);
      var data = convert.jsonDecode(dataStr);
      print('object');
      return;
      PlatformAwareNetworkImage(url: '');
    }
  }
}
