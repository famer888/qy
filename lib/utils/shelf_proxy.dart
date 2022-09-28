// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

// import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DHP;
import 'package:flutter/foundation.dart';
import 'package:qypj/utils/common.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:pedantic/pedantic.dart';
import 'package:shelf/shelf.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:qypj/utils/crypto.dart';
import 'package:shelf_static/shelf_static.dart';

/// A handler that proxies requests to [url].
///
/// To generate the proxy request, this concatenates [url] and [Request.url].
/// This means that if the handler mounted under `/documentation` and [url] is
/// `http://example.com/docs`, a request to `/documentation/tutorials`
/// will be proxied to `http://example.com/docs/tutorials`.
///
/// [url] must be a [String] or [Uri].
///
/// [client] is used internally to make HTTP requests. It defaults to a
/// `dart:io`-based client.
///
/// [proxyName] is used in headers to identify this proxy. It should be a valid
/// HTTP token or a hostname. It defaults to `shelf_proxy`.

List<Map<String, int>> servers = [];
int current_port = 8888;
int static_port = 9999;

Future createServer(String url) async {
  RegExp domainReg = new RegExp(r"(http|https):\/\/[^\/]*");
  String domainStr = domainReg.stringMatch(url);
  int _port;
  bool _flag = servers.any((element) {
    if (element.keys.first == domainStr) {
      _port = element.values.first;
      return true;
    }
    return false;
  });
  if (domainStr.isEmpty) {
    // 如果解密的key为空字符串则不创建代理服务器，域名原封不动，不作替换
    return {"origin": domainStr, "localproxy": domainStr};
  } else {
    if (!_flag) {
      // 创建服务器
      await shelf_io.serve(proxyHandler(domainStr), '127.0.0.1', current_port,
          shared: true);

      servers.add({domainStr: current_port});
      current_port++;
      return {
        "origin": domainStr,
        "localproxy": "http://127.0.0.1:${current_port - 1}"
      };
    } else {
      return {"origin": domainStr, "localproxy": "http://127.0.0.1:$_port"};
    }
  }
}

Future createStaticServer(String url) async {
  List<String> urls = url.split('/');
  String fileName = urls[urls.length - 1];
  int _port;
  bool _flag = servers.any((element) {
    if (element.keys.first == fileName) {
      _port = element.values.first;
      return true;
    }
    return false;
  });
  Future _createServer() async {
    try {
      var handler = createStaticHandler(url.substring(0, url.lastIndexOf('/')),
          defaultDocument: fileName);
      var _server;
      _server = await shelf_io.serve(handler, '127.0.0.1', static_port);
      servers.add({fileName: static_port});
      static_port++;
      return "http://${_server.address.host}:${_server.port}/$fileName";
    } catch (e) {
      static_port++;
      return _createServer();
    }
  }

  String localUrl;
  if (!_flag) {
    localUrl = await _createServer();
    return localUrl;
  } else {
    return "http://127.0.0.1:${_port}/$fileName";
  }
}

Handler proxyHandler(url, {http.Client client, String proxyName}) {
  Uri uri;
  if (url is String) {
    uri = Uri.parse(url);
  } else if (url is Uri) {
    uri = url;
  } else {
    throw ArgumentError.value(url, 'url', 'url must be a String or Uri.');
  }
  final nonNullClient = client ?? http.Client();
  proxyName ??= 'shelf_proxy';

  return (serverRequest) async {
    final requestUrl = uri.resolve(serverRequest.url.toString());

    final clientRequest = http.StreamedRequest(serverRequest.method, requestUrl)
      ..followRedirects = false
      ..headers.addAll(serverRequest.headers)
      ..headers['host'] = uri.authority;

    serverRequest
        .read()
        .forEach(clientRequest.sink.add)
        .catchError(clientRequest.sink.addError)
        .whenComplete(clientRequest.sink.close)
        .ignore();

    // unawaited(serverRequest
    //     .read()
    //     .forEach(clientRequest.sink.add)
    //     .catchError(clientRequest.sink.addError)
    //     .whenComplete(clientRequest.sink.close));
    final clientResponse = await nonNullClient.send(clientRequest);
    // clientResponse.headers['accept-ranges'] = 'bytes';
    // clientResponse.headers['x-by'] = 'aws';

    clientResponse.headers.remove('transfer-encoding');

    if (clientResponse.headers['content-encoding'] == 'gzip') {
      clientResponse.headers.remove('content-encoding');
      clientResponse.headers.remove('content-length');
      _addHeader(
          clientResponse.headers, 'warning', '214 $proxyName "GZIP decoded"');
    }

    // Make sure the Location header is pointing to the proxy server rather
    // than the destination server, if possible.
    if (clientResponse.isRedirect &&
        clientResponse.headers.containsKey('location')) {
      final location =
          requestUrl.resolve(clientResponse.headers['location']).toString();
      if (p.url.isWithin(uri.toString(), location)) {
        clientResponse.headers['location'] =
            '/${p.url.relative(location, from: uri.toString())}';
      } else {
        clientResponse.headers['location'] = location;
      }
    }

    if (requestUrl.toString().contains('.m3u8') == true) {
      var encryptData = _checkIV(await clientResponse.stream.bytesToString());
      // var decryptData = PlatformAwareCrypto.decryptM3U8(encryptData);
      var str = await _parseM3U8(encryptData, requestUrl.toString());
      return Response(clientResponse.statusCode,
          body: str, headers: clientResponse.headers);
    } else {
      return Response(clientResponse.statusCode,
          body: clientResponse.stream, headers: clientResponse.headers);
    }
  };
}

String _checkIV(String data) {
  if (data.contains("IV=") == false) {
    String ivData = data.replaceAll(
        "#EXT-X-KEY:METHOD=AES-128,", "#EXT-X-KEY:METHOD=AES-128,IV=0x0,");
    return ivData;
  }
  return data;
}

Future _parseM3U8(String str, String m3u8_url) async {
  RegExp domainReg = new RegExp(r"(http|https):\/\/[^\/]*");
  String domainStr = domainReg.stringMatch(str);
  String resultStr = "";
  if (domainStr.isNotEmpty) {
    // 如果ts自带域名则建立新的代理服务器
    Map _config = await createServer(domainStr);
    resultStr = str.replaceAll(domainStr, _config['localproxy']);
  } else {
    // 如果ts不带域名则使用m3u8的域名作为代理服务器，ts列表字符串不做处理
    resultStr = str;
  }
  return resultStr;
}

void _addHeader(Map<String, String> headers, String name, String value) {
  final existing = headers[name];
  headers[name] = existing == null ? value : '$existing, $value';
}

String randomId(int len) {
  String str = '';
  int range = len;
  int pos;
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
    'Z',
  ];
  for (var i = 0; i < range; i++) {
    pos = Random().nextInt(arr.length - 1);
    str += arr[pos];
  }
  return str;
}
