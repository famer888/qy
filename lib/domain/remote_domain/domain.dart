import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';

import '../enum.dart';
import '../type_def.dart';
import 'domains/account.dart';
import 'domains/community.dart';
import 'domains/dynamic.dart';
import 'domains/element.dart';
import 'domains/home.dart';
import 'domains/message.dart';
import 'domains/mv.dart';
import 'domains/order.dart';
import 'domains/privilege.dart';
import 'domains/proxy.dart';
import 'domains/search.dart';
import 'domains/seed.dart';
import 'domains/sign.dart';
import 'domains/user.dart';
import 'domains/withdraw.dart';

abstract class RemoteDomain
    implements
        AccountDomain,
        CommunityDomain,
        DynamicDomain,
        ElementDomain,
        HomeDomain,
        OrderDomain,
        ProxyDomain,
        SeedDomain,
        SignDomain,
        UserDomain,
        WithdrawDomain,
        SearchDomain,
        MvDomain,
        MessageDomain,
        PrivilegeDomain {
  Stream<MyTokenStatus?> get tokenStatusStream;
  Future<bool> initLine();

  String getOAuthId();
  String getOAuthType();

  AsyncJson uploadImage({
    required String baseUrl,
    required XFile xFile,
    required String key,
    String? id,
    String position = 'head',
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  });

  /// 视频上传
  AsyncJson uploadVideo({
    required String baseUrl,
    required XFile xFile,
    required String key,
    CancelToken? cancelToken,
    ProgressCallback? progressCallback,
  });

  /// 下载apk
  Future<Response> downloadApk({
    required String urlPath,
    required String savePath,
    ProgressCallback? onReceiveProgress,
  });
}
