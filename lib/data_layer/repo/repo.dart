import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http_parser/http_parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:utils/utils.dart';

import '../../app_config.dart';
import '../../crypto.dart';
import '../../domain/enum.dart';
import '../../domain/model/app_center_model.dart';
import '../../domain/model/bank_card_model.dart';
import '../../domain/model/bit_detail_model.dart';
import '../../domain/model/bit_nav_model.dart';
import '../../domain/model/cash_withdraw_rule_model.dart';
import '../../domain/model/coin_detail_model.dart';
import '../../domain/model/collection_model.dart';
import '../../domain/model/community_nav_model.dart';
import '../../domain/model/community_with_banner_model.dart';
import '../../domain/model/creator_info_model.dart';
import '../../domain/model/element_model.dart';
import '../../domain/model/exp_of_vip_model.dart';
import '../../domain/model/feed/feed_model.dart';
import '../../domain/model/feedback_data_model.dart';
import '../../domain/model/follow_user_model.dart';
import '../../domain/model/home_data_model.dart';
import '../../domain/model/income_detail_data_model.dart';
import '../../domain/model/member_model.dart';
import '../../domain/model/mine_withdrawal_record_model.dart';
import '../../domain/model/notice_message.dart';
import '../../domain/model/official_group_model.dart';
import '../../domain/model/order_model.dart';
import '../../domain/model/post_model.dart';
import '../../domain/model/posts_with_banners_model.dart';
import '../../domain/model/product_vip_coin_model.dart';
import '../../domain/model/proxy_detail_model.dart';
import '../../domain/model/proxy_invite_record_model.dart';
import '../../domain/model/proxy_profit_model.dart';
import '../../domain/model/review_data_model.dart';
import '../../domain/model/search_model.dart';
import '../../domain/model/system_notice_model.dart';
import '../../domain/model/tiezt_model.dart';
import '../../domain/model/topic_detail_model.dart';
import '../../domain/model/topic_model.dart';
import '../../domain/model/topics_with_banners_model.dart';
import '../../domain/model/video_comment_model.dart';
import '../../domain/model/video_detail_model.dart';
import '../../domain/model/welfare_task_model.dart';
import '../../domain/result.dart';
import '../../domain/type_def.dart';
import '../../domain/domain.dart';
import '../../logger.dart';
import '../data_source/remote/account_service.dart';
import '../data_source/remote/community_service.dart';
import '../data_source/remote/dynamic_service.dart';
import '../data_source/remote/element_service.dart';
import '../data_source/remote/home_service.dart';
import '../data_source/remote/message_service.dart';
import '../data_source/remote/mv_service.dart';
import '../data_source/remote/order_service.dart';
import '../data_source/remote/privilege_service.dart';
import '../data_source/remote/proxy_service.dart';
import '../data_source/remote/search_service.dart';
import '../data_source/remote/seed_service.dart';
import '../data_source/remote/sign_service.dart';
import '../data_source/remote/user_service.dart';
import '../data_source/remote/withdraw_service.dart';
import 'http_interceptor.dart';
import 'utils.dart';
part 'cache.dart';
part 'mixin/home_mixin.dart';
part 'mixin/user_mixin.dart';
part 'mixin/element_mixin.dart';
part 'mixin/dynamic_mixin.dart';
part 'mixin/community_mixin.dart';
part 'mixin/seed_mixin.dart';
part 'mixin/order_mixin.dart';
part 'mixin/sign_mixin.dart';
part 'mixin/account_mixin.dart';
part 'mixin/proxy_mixin.dart';
part 'mixin/withdraw_mixin.dart';
part 'mixin/search_mixin.dart';
part 'mixin/mv_mixin.dart';
part 'mixin/message_mixin.dart';
part 'mixin/privilege_mixin.dart';

class AppRepo extends _BaseAppRepo
    with
        _Home,
        _User,
        _Element,
        _Dynamic,
        _Community,
        _Seed,
        _Order,
        _Sign,
        _Account,
        _Proxy,
        _Withdraw,
        _Search,
        _Mv,
        _Message,
        _Privilege {}

abstract class _BaseAppRepo implements AppDomain {
  late final _homeService = HomeService(_apiDio);
  late final _userService = UserService(_apiDio);
  late final _elementService = ElementService(_apiDio);
  late final _dynamicService = DynamicService(_apiDio);
  late final _communityService = CommunityService(_apiDio);
  late final _seedService = SeedService(_apiDio);
  late final _orderService = OrderService(_apiDio);
  late final _signService = SignService(_apiDio);
  late final _accountService = AccountService(_apiDio);
  late final _proxyService = ProxyService(_apiDio);
  late final _withdrawService = WithdrawService(_apiDio);
  late final _searchService = SearchService(_apiDio);
  late final _mvService = MvService(_apiDio);
  late final _messageService = MessageService(_apiDio);
  late final _privilegeService = PrivilegeService(_apiDio);

  final _cacheManager = _CacheManager();

  @override
  late final tokenStatusStream =
      _tokenValidStreamController.stream.asBroadcastStream();

  final _tokenValidStreamController = StreamController<MyTokenStatus?>();

  late final _apiDio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 300),
      contentType: Headers.formUrlEncodedContentType,
    ),
  );

  /// 未加密网路服务/上传资源
  late final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 300),
    ),
  );

  bool _isInitialized = false;
  Json _appInfo = {};

  @override
  CacheDomain get cache => _cacheManager;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await _cacheManager.init();
    _appInfo = await _getAppInfo();

    _apiDio.interceptors.add(AutoEncryptAndDecryptInterceptor(_appInfo));
    _apiDio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) async {
          if (response.data case final Map data when data['msg'] == 'token无效') {
            await _cleanToken();
            _tokenValidStreamController.sink.add(MyTokenStatus.invalid);
          }
          return handler.next(response);
        },
      ),
    );
  }

  Future _cleanToken() async {
    try {
      if (_appInfo.token != null) {
        _appInfo.removeToken();
        await _cacheManager.deleteAuthToken();
      }
    } catch (_) {}
  }

  void _updateToken(String token) {
    _appInfo.token = token;
    _cacheManager.upsertAuthToken(token);
    _tokenValidStreamController.sink.add(MyTokenStatus.valid);
  }

  Future<String> _getOAuthId() async {
    String? deviceId;
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        const androidIdPlugin = AndroidId();
        final androidId = await androidIdPlugin.getId();
        deviceId = androidId;
      } else if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    }

    deviceId ??= await _cacheManager.readOauthId();

    if (deviceId == null) {
      deviceId =
          '${RepoUtils.randomId(16)}_${DateTime.now().millisecondsSinceEpoch}';
      await _cacheManager.upsertOauthId(deviceId);
    }
    return RepoUtils.gvMD5(deviceId);
  }

  @override
  String getOAuthId() => _appInfo['oauth_id'] ?? '';

  @override
  String getOAuthType() {
    if (kIsWeb) {
      return 'web';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    return 'web';
  }

  Future<Json> _getAppInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final info = kIsWeb
        ? {
            'bundleId': BuildConfig.webBundleId,
            'version': packageInfo.version,
            'language': 'zh',
            'via': 'pwa',
          }
        : {
            'bundleId': packageInfo.packageName,
            'version': packageInfo.version,
          };

    info.addAll({
      'oauth_id': await _getOAuthId(),
      'oauth_type': getOAuthType(),
    });

    final token = await _cacheManager.readAuthToken();

    if (token != null) {
      info.token = token;
      _tokenValidStreamController.sink.add(MyTokenStatus.valid);
    } else {
      _tokenValidStreamController.sink.add(null);
    }

    return info;
  }

  @override
  Future<bool> initLine() async {
    final cacheLines = await _cacheManager.readLinesUrl();

    final lines = cacheLines ?? BuildConfig.apiLines;

    List<Map> errorLines = [];
    String? targetLine;

    for (String line in lines) {
      Map<String, dynamic>? headers;

      /// get secret value
      if (!kIsWeb) {
        final fdsKey = await _getFdsKey();
        final secretValue = PlatformAwareCrypto.secretValue(fdsKey: fdsKey);
        headers = {
          'Cf-Ray-Xf': secretValue,
        };
      }

      /// check line
      if (await _checkLine(line, headers)) {
        targetLine = line;
        _apiDio.options.headers = headers;
        break;
      }
      errorLines.add({'url': line});
    }

    /// use backup line
    targetLine ??= await _backupLine();

    if (targetLine != null) {
      _apiDio.options.baseUrl = targetLine;
      if (errorLines.isNotEmpty) {
        _reportErrorLine(errorLines);
      }
      return true;
    }
    return false;
  }

  Future<String> _getFdsKey() async {
    const duration = Duration(seconds: 5);
    for (String fdsApi in BuildConfig.fdsKeyApi) {
      try {
        final resp = await Dio(
                BaseOptions(connectTimeout: duration, receiveTimeout: duration))
            .get(fdsApi);
        if (resp.statusCode == 200) {
          final fdsKey = resp.data.toString().replaceAll('\n', '');
          _cacheManager.upsertFdsKey(fdsKey);
          return fdsKey;
        }
      } catch (_) {}
    }

    final fdsKey = await _cacheManager.readFdsKey();
    return fdsKey ?? '';
  }

  /// check line
  Future<bool> _checkLine(String line, Map<String, dynamic>? headers) async {
    const duration = Duration(seconds: 5);
    try {
      final resp = await Dio(BaseOptions(
        connectTimeout: duration,
        receiveTimeout: duration,
        headers: headers,
      )).get('$line/api/callback/checkLine');
      if (resp.statusCode == 200) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// 启用备用线路
  Future<String?> _backupLine() async {
    try {
      final github =
          (await _cacheManager.readGithubUrl()) ?? BuildConfig.githubLine;
      const duration = Duration(seconds: 5);
      final resp = await Dio(
        BaseOptions(connectTimeout: duration, receiveTimeout: duration),
      ).get(github);
      if (resp.statusCode == 200) {
        return resp.data.toString().replaceAll('\n', '');
      }
    } catch (_) {}
    return null;
  }

  /// 回报错误线路
  Future<void> _reportErrorLine(List<Map> lines) =>
      _apiDio.post('/api/home/domainCheckReport', data: {'list': lines});

  @override
  AsyncJson uploadImage({
    required XFile xFile,
    required String baseUrl,
    required String key,
    String position = 'head',
    String? id,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    final _id = id ?? '${DateTime.now().millisecondsSinceEpoch}';
    final newKey = 'id=$_id&position=$position${key.replaceFirst('head', '')}';
    final tmpSha256 = _gvSha256(newKey);
    final sign = _gvMD5(tmpSha256);
    final imageName = _gvMD5(_id);
    final ext = xFile.name.split('.').last;

    final formData = FormData.fromMap({
      'id': _id,
      'position': position,
      'sign': sign,
      'cover': MultipartFile.fromBytes(
        await xFile.readAsBytes(),
        filename: '$imageName.$ext',
        contentType: MediaType.parse('image/$ext'),
      ),
    });

    final response = await _dio.post(
      baseUrl,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: progressCallback,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return jsonDecode(response.data);
  }

  @override
  AsyncJson uploadVideo({
    required XFile xFile,
    required String baseUrl,
    required String key,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  }) async {
    final timeStamp = '${DateTime.now().millisecondsSinceEpoch}';
    final newKey = '$timeStamp${key.replaceFirst('head', '')}';
    final sign = _gvMD5(newKey);

    final formData = FormData.fromMap({
      'timestamp': timeStamp,
      'uuid': '9544f11ed4381ebcef5429b6f20e69c1',
      'sign': sign,
      'video': await MultipartFile.fromFile(
        xFile.path,
        filename: xFile.name,
        contentType: MediaType.parse('video/mp4'),
      ),
    });
    final response = await _dio.post(
      baseUrl,
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: progressCallback,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return jsonDecode(response.data);
  }

  @override
  Future<Response> downloadApk(
          {required String urlPath,
          required String savePath,
          ProgressCallback? onReceiveProgress}) =>
      _dio.download(urlPath, savePath, onReceiveProgress: onReceiveProgress);
}

extension _MapHelper on Map {
  String get _tokenKey => 'token';

  void removeToken() => remove(_tokenKey);

  String? get token => this[_tokenKey];
  set token(String? value) {
    if (value == null) {
      remove(_tokenKey);
    } else {
      this[_tokenKey] = value;
    }
  }
}

extension _Guard<T> on AsyncResult<T> {
  AsyncResult<T> get guard async {
    try {
      return await this;
    } catch (err, stack) {
      logger.e(err);
      logger.e(stack);
      return Result(msg: err.toString() + stack.toString());
    }
  }
}

String _gvMD5(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = md5.convert(content);
  var text = hex.encode(digest.bytes);
  return text;
}

String _gvSha256(String data) {
  var content = const Utf8Encoder().convert(data);
  var digest = sha256.convert(content);
  var text = hex.encode(digest.bytes);
  return text;
}
