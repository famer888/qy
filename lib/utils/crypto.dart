import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:qypj/global.dart';
import 'package:qypj/model/myinvitation.dart';
import 'package:qypj/utils/common.dart';
import 'package:qypj/utils/http.dart';
import 'package:hex/hex.dart';
import 'package:isolated_worker/isolated_worker.dart';

// final key = Key.fromUtf8("95IjcBpExJdJK9pF");
// final iv = IV.fromUtf8("tfzBKVEIBk5V66RC");
// final appkey = "aaaS18bd6cXMnFqLqGdBViA3ytEZobb8";
final key = Key.fromUtf8("2acf7e91e9864673");
final iv = IV.fromUtf8("1c29882d3ddfcfd6");
final appkey = "5589d41f92a597d016b037ac37db243d";

final mediaKey = Key.fromUtf8("f5d965df75336270");
final mediaIv = IV.fromUtf8("97b60394abc2fbe1");

String getSign(Map obj) {
  String md5Text;
  List keyValues = [];
  keyValues.add("client=${obj['client']}");
  keyValues.add("data=${obj['data']}");
  keyValues.add("timestamp=${obj['timestamp']}");
  String text = '${keyValues.join('&')}$appkey';
  Digest _digest = sha256.convert(utf8.encode(text));
  md5Text = md5.convert(utf8.encode(_digest.toString())).toString();
  return md5Text;
}

class PlatformAwareCrypto {
  static Future<dynamic> encryptReqParams(String word) async {
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = encrypter.encryptBytes(utf8.encode(word), iv: iv);
    String data = utf8.decode(encrypted.base64.codeUnits);
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String sign =
        getSign({"client": "pwa", "data": data, "timestamp": timestamp});
    return "client=pwa&timestamp=$timestamp&data=$data&sign=$sign";
  }

  static Future<String> decryptResData(dynamic data) async {
    Encrypter encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    Encrypted encrypted = Encrypted.fromBase64(data['data']);
    String decrypted = encrypter.decrypt(encrypted, iv: iv);
    return decrypted;
  }

  //获取小说
  static Future<String> decryptNovel(String url) async {
    String base64 = await PlatformAwareHttp.getNovel(url);
    if (base64 != null) {
      dynamic decrypted = decryptImage(base64);
      if (decrypted != '' && decrypted != null) {
        decrypted = base64Decode(decrypted);
        String data = utf8.decode(decrypted);
        return data;
      }
    }
    return "";
  }

  static dynamic decryptImage(data) {
    try {
      Encrypter encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      Encrypted encrypted = Encrypted.fromBase64(data);
      final stopwatch = Stopwatch()..start();
      List<int> decrypted = encrypter.decryptBytes(encrypted, iv: mediaIv);
      CommonUtils.debugPrint('decode() executed in ${stopwatch.elapsed}');
      return base64Encode(decrypted);
    } catch (err) {
      CommonUtils.debugPrint(err);
      return null;
    }
  }

  static dynamic decryptM3U8(data) {
    try {
      Encrypter encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      Encrypted encrypted = Encrypted.fromBase64(data);
      final stopwatch = Stopwatch()..start();
      String decrypted = encrypter.decrypt(encrypted, iv: mediaIv);
      CommonUtils.debugPrint('decode() executed in ${stopwatch.elapsed}');
      return decrypted;
    } catch (err) {
      return null;
    }
  }

  static String encry(plainText) {
    try {
      final encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      final encrypted = encrypter.encrypt(plainText, iv: mediaIv);
      return encrypted.base16;
    } catch (err) {
      print("aes encode error:$err");
      return plainText;
    }
  }

  static String decry(encrypted) {
    try {
      final encrypter = Encrypter(AES(mediaKey, mode: AESMode.cbc));
      final decrypted = encrypter.decrypt16(encrypted, iv: mediaIv);
      return decrypted;
    } catch (err) {
      print("aes decode error:$err");
      return encrypted;
    }
  }

  //IM加密专用
  static Future<String> encryptReqParamsWithKey(
      String word, String key, String iv) async {
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    Encrypted encrypted =
        encrypter.encryptBytes(utf8.encode(word), iv: IV.fromUtf8(iv));
    String data = utf8.decode(encrypted.base64.codeUnits);
    return data;
  }

  //IM解密专用
  static Future<String> decryptResDataWithKey(
    dynamic data,
    String key,
    String iv,
  ) async {
    String data_str = data['data'] ?? "";
    // if (data_str.length % 4 > 0) {
    //   data_str += '=' * (4 - data_str.length % 4); // as suggested by Albert221
    // }
    Encrypter encrypter = Encrypter(AES(Key.fromUtf8(key), mode: AESMode.cbc));
    Encrypted encrypted = Encrypted.fromBase64(data_str);
    String decrypted = encrypter.decrypt(encrypted, iv: IV.fromUtf8(iv));
    return decrypted;
  }

  static Future<String> decryptSecret(String data) async {
    Encrypter encrypter =
        Encrypter(AES(Key.fromUtf8("56d028f9e1293e74"), mode: AESMode.cbc));
    Encrypted encrypted = Encrypted.fromBase64(data);
    String decrypted =
        encrypter.decrypt(encrypted, iv: IV.fromUtf8("153bc771dcfda5af"));
    return decrypted;
  }

  static Future<String> encryptSecret(String key) async {
    String serect = key.split('_').first ?? '';
    int interval = int.parse(key.split('_').last ?? '3600');
    int ct = (DateTime.now().millisecondsSinceEpoch / 1000 / interval).floor();
    String cal = (sha1.convert(utf8.encode(serect + ct.toString()))).toString();
    Digest sha = sha1.convert(utf8.encode(serect + cal));
    String str = md5.convert(utf8.encode(sha.toString())).toString();
    CommonUtils.debugPrint("ct: $ct cal:$cal sha:$sha str:$str");
    return str.substring(0, 16);
  }

  static Future<String> secretValue() async {
    String fds_key = AppGlobal.appBox.get('fds_key') ?? "";
    String key = await PlatformAwareCrypto.decryptSecret(fds_key.isEmpty
        ? "Vo+r0rRtdYoBhEVNA2UI8tFni929kY3ew27aeqSfQVC2V4gZZo1glBD7S67/2ZVP"
        : fds_key);
    String value = await PlatformAwareCrypto.encryptSecret(key);
    return value;
  }
}
