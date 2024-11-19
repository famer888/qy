//通用处理获取URL连接

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:universal_html/html.dart' as html;

import '../../../../../app_global.dart';
import '../../../../../crypto.dart';
import '../../../../utils/common_utils.dart';
import 'shelf_proxy.dart';

mixin NVideoURLMinxin<T extends StatefulWidget> on State<T> {
  //获取播放控制器
  Future<VideoPlayerController>? initController({
    String source240 = '',
    String preview_url = '',
    bool isLocal = false,
    bool isNew = false,
  }) {
    String purl = '';
    if (source240.isNotEmpty) {
      purl = source240;
    } else if (preview_url.isNotEmpty) {
      purl = preview_url;
    }

    if (kIsWeb) {
      if (AppGlobal.m3u8Encrypt == '1') {
        return Dio().get(purl).then((res) {
          String decrypted = PlatformAwareCrypto.decryptM3U8(res.data);
          final _blob =
              html.Blob([decrypted], 'application/x-mpegURL', 'native');
          final _url = html.Url.createObjectUrl(_blob);
          CommonUtils.log(_url);
          return VideoPlayerController.network(_url);
        });
      } else {
        return Future(() {
          return VideoPlayerController.network(purl);
        });
      }
    } else if (!isLocal) {
      if (AppGlobal.m3u8Encrypt == '1') {
        return createServer(purl).then((proxyConfig) {
          String proxyurl =
              purl.replaceAll(proxyConfig['origin'], proxyConfig['localproxy']);
          return VideoPlayerController.network(proxyurl);
        });
      } else {
        return Future(() {
          return VideoPlayerController.network(purl);
        });
      }
    } else {
      // 创建本地播放服务
      return createStaticServer(purl).then((url) {
        return VideoPlayerController.network(url);
      });
    }
  }
}
