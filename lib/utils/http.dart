import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qypj/mixin/imchatmanager_io.dart';
import 'package:universal_html/html.dart' as html;
import 'package:qypj/global.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/crypto.dart';
import 'package:http_parser/http_parser.dart';

// 是否因token失效跳转到登录页
bool isJump = false;
Dio _imageDio = new Dio(new BaseOptions(
  connectTimeout: 60 * 1000,
  receiveTimeout: 300 * 1000,
  responseType: ResponseType.bytes,
  validateStatus: (status) {
    return status < 500;
  },
));
getToken() {
  Box box = AppGlobal.appBox;
  return box.get('qypj_token');
}

Dio _uploadDio = new Dio(new BaseOptions(
  connectTimeout: 60 * 1000,
  receiveTimeout: 300 * 1000,
));

Dio _apiDio = new Dio(new BaseOptions(
    connectTimeout: 60 * 1000,
    receiveTimeout: 300 * 1000,
    validateStatus: (status) {
      return status < 500;
    },
    contentType: Headers.formUrlEncodedContentType))
  ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    Map _data = {};
    String token = getToken();
    if (token != null && token != '') {
      AppGlobal.apiToken = token;
    }
    _data.addAll(AppGlobal.appinfo);
    _data.addAll({'token': AppGlobal.apiToken});
    if (options.data != null) {
      _data.addAll(options.data);
    }
    CommonUtils.debugPrint(_data);
    options.data =
        await PlatformAwareCrypto.encryptReqParams(jsonEncode(_data));

    return handler.next(options);
  }, onResponse: (response, handler) async {
    if (response.data['data'] != null) {
      String _data = await PlatformAwareCrypto.decryptResData(response.data);
      response.data = jsonDecode(_data);
    }
    // if (response.realUri.toString().contains("home/config")) {
    //   CommonUtils.debugPrint("dajsndnsamdak${response.realUri.toString()}");
    //   response.data["msg"] = "token无效";
    // }
    if (response.data["msg"] == "token无效" &&
        !isJump &&
        AppGlobal.appContext != null &&
        AppGlobal.apInit) {
      CommonUtils.showText(CommonUtils.txt('dlsx'));
      //关闭IM
      IMChatManagerIO.instance().activeClose();
      isJump = true;
      AppGlobal.apiToken = '';
      Box box = AppGlobal.appBox;
      box.delete('qypj_token');
      if (AppGlobal.routerReplace) {
        AppGlobal.appContext.pop();
      }
      Future.delayed(Duration(seconds: 1), () {
        AppGlobal.appContext.go("/login/1");
      });
      Future.delayed(Duration(seconds: 3), () {
        isJump = false;
      });
    }
    return handler.next(response);
  }, onError: (DioError e, handler) {
    return handler.next(e);
  }));

class PlatformAwareHttp {
  static Future getImage(url) {
    if (url.contains('http')) {
      return kIsWeb
          ? html.HttpRequest.request(url, responseType: 'arraybuffer')
              .then((xhr) {
              if (xhr.response != null) {
                ByteBuffer bb = xhr.response;
                return base64Encode(bb.asUint8List());
              }
              return '';
            }).onError((error, stackTrace) => '')
          : _imageDio
              .get(url)
              .then((res) => base64Encode(res.data))
              .onError((error, stackTrace) => '');
    } else {
      return Future(() => url);
    }
  }

  static Future getNovel(url) {
    return kIsWeb
        ? html.HttpRequest.request(url, responseType: 'arraybuffer')
            .then((xhr) {
            if (xhr.response != null) {
              ByteBuffer bb = xhr.response;
              return utf8.decode(bb.asUint8List());
            }
            return '';
          }).onError((error, stackTrace) => '')
        : _imageDio
            .get(url)
            .then((res) => utf8.decode(res.data))
            .onError((error, stackTrace) => '');
  }

  static Future xfileUploadImage(
      {XFile file,
      String id,
      String position = 'head',
      ProgressCallback progressCallback}) async {
    try {
      if (id == null) id = '${DateTime.now().millisecondsSinceEpoch}';
      var imgKey = AppGlobal.uploadImgKey.replaceFirst('head', '');
      var newKey = 'id=$id&position=$position$imgKey';
      var tmpSha256 = CommonUtils.gvSha256(newKey);
      var sign = CommonUtils.gvMD5(tmpSha256);
      var ext = file.name.split(".").last;

      FormData formData = FormData.fromMap({
        'id': id,
        'position': position,
        'sign': sign,
        'cover': await MultipartFile.fromFile(
          file.path,
          filename: '${file.name}',
          contentType: MediaType.parse('image/$ext'),
        ),
      });
      Response response = await _uploadDio.post(AppGlobal.uploadImgUrl,
          data: formData,
          onSendProgress: progressCallback,
          options: Options(contentType: 'multipart/form-data'));
      return response.data;
    } catch (e) {
      return null;
    }
  }

  static Future xfileHtmlUploadImage(
      {XFile file,
      String id,
      String position = 'head',
      Function(html.ProgressEvent) progressCallback}) async {
    try {
      if (id == null) id = '${DateTime.now().millisecondsSinceEpoch}';
      var imgKey = AppGlobal.uploadImgKey.replaceFirst('head', '');
      var newKey = 'id=$id&position=$position$imgKey';
      var tmpSha256 = CommonUtils.gvSha256(newKey);
      var sign = CommonUtils.gvMD5(tmpSha256);
      var ext = file.name.split(".").last;

      final html.FormData formData = html.FormData()
        ..append('id', id)
        ..append('position', position)
        ..append('sign', sign)
        ..appendBlob(
            "cover", html.Blob([await file.readAsBytes()], "image/$ext"));

      html.HttpRequest httpRequest = await html.HttpRequest.request(
          AppGlobal.uploadImgUrl,
          method: "POST",
          mimeType: "image/$ext",
          sendData: formData,
          onProgress: progressCallback);
      return httpRequest.response;
    } catch (e) {
      return null;
    }
  }

  static Future xfileBytesUploadMp4(
      {XFile file,
      String position = 'head',
      ProgressCallback progressCallback}) async {
    try {
      String timeStamp;
      if (timeStamp == null)
        timeStamp = '${DateTime.now().millisecondsSinceEpoch}';
      var videoKey = AppGlobal.uploadMp4Key.replaceFirst('head', '');
      var newKey = '$timeStamp$videoKey';
      var sign = CommonUtils.gvMD5(newKey);

      FormData formData = FormData.fromMap({
        'timestamp': timeStamp,
        'uuid': '9544f11ed4381ebcef5429b6f20e69c1',
        'sign': sign,
        'video': MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: file.name,
          contentType: MediaType.parse('video/mp4'),
        ),
      });

      Response response = await _uploadDio.post(
        AppGlobal.uploadMp4Url,
        data: formData,
        onSendProgress: progressCallback,
        options: Options(contentType: 'multipart/form-data'),
      );
      return response.data;
    } catch (e) {
      return null;
    }
  }

  static Future xfileUploadMp4(
      {XFile file,
      String position = 'head',
      ProgressCallback progressCallback}) async {
    try {
      String timeStamp;
      if (timeStamp == null)
        timeStamp = '${DateTime.now().millisecondsSinceEpoch}';
      var videoKey = AppGlobal.uploadMp4Key.replaceFirst('head', '');
      var newKey = '$timeStamp$videoKey';
      var sign = CommonUtils.gvMD5(newKey);
      var imageName = CommonUtils.gvMD5(timeStamp);

      var filename = '$imageName.mp4';
      FormData formData = FormData.fromMap({
        'timestamp': timeStamp,
        'uuid': '9544f11ed4381ebcef5429b6f20e69c1',
        'sign': sign,
        'video': await MultipartFile.fromFile(
          file.path,
          filename: filename,
          contentType: MediaType.parse('video/mp4'),
        ),
      });
      Response response = await _uploadDio.post(AppGlobal.uploadMp4Url,
          data: formData,
          onSendProgress: progressCallback,
          options: Options(contentType: 'multipart/form-data'));
      return response.data;
    } catch (e) {
      return null;
    }
  }

  static Future<Response> download(String urlPath, String savePath,
      {ProgressCallback onReceiveProgress}) {
    return _uploadDio.download(urlPath, savePath,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: {
          "user-agent":
              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36 Andr/hjsq"
        }));
  }

  // cancelToken 用于二级页面销毁时，中断正在进行中的异步请求
  static Future post(String path, {Map data, CancelToken cancelToken}) {
    CommonUtils.debugPrint("====baseurl:${AppGlobal.apiBaseURL + path}");
    return _apiDio.post(AppGlobal.apiBaseURL + path,
        data: data, cancelToken: cancelToken);
  }
}
