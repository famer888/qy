import '../../type_def.dart';

abstract class AccountDomain {
  /// 用户名帐号登登录
  AsyncJson loginByAccount({
    required String username,
    required String password,
  });

  /// 用户名注册登录
  AsyncJson loginByReg({
    required String userName,
    required String password,
  });

  /// 验证用户名
  AsyncResult validateUsername({
    required String username,
  });

  Future logout();
}
