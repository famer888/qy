import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qypj/model/videolist.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:qypj/utils/shelf_proxy.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/global.dart';
import 'package:dio/dio.dart';

mixin GeneralVideoMinxin<T extends StatefulWidget> on State<T> {
  //获取播放控制器
  Future<VideoPlayerController> initController(VideoItem _itdata,
      {bool isLocal = false, bool isNew = false}) {
    String purl = "";
    if (_itdata.source_240.length > 0) {
      purl = _itdata.source_240;
    } else if (_itdata.preview_url.length > 0) {
      purl = _itdata.preview_url;
    }
    if (kIsWeb) {
      if (AppGlobal.m3u8_encrypt == '1') {
        new Dio().get(purl).then((res) {
          String decrypted = PlatformAwareCrypto.decryptM3U8(res.data);
          final _blob =
              html.Blob([decrypted], 'application/x-mpegURL', 'native');
          final _url = html.Url.createObjectUrl(_blob);
          CommonUtils.debugPrint(_url);
          return VideoPlayerController.network(_url);
        });
      } else {
        return Future.delayed(Duration(seconds: 0), () {
          return VideoPlayerController.network(purl);
        });
      }
    } else if (!isLocal) {
      if (AppGlobal.m3u8_encrypt == '1') {
        createServer(purl).then((proxyConfig) {
          String proxyurl =
              purl.replaceAll(proxyConfig['origin'], proxyConfig['localproxy']);
          return VideoPlayerController.network(proxyurl);
        });
      } else {
        return Future.delayed(Duration(seconds: 0), () {
          return VideoPlayerController.network(purl);
        });
      }
    } else {
      // 创建本地播放服务
      createStaticServer(purl).then((url) {
        return VideoPlayerController.network(url);
      });
    }
  }
}
