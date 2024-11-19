import '../../../domain/type_def.dart';
import 'base_service.dart';

class AccountService extends BaseService {
  AccountService(super._dio);

  @override
  final service = 'account';

  /// 用户名账号登录
  AsyncJson loginByAccount({
    required String username,
    required String password,
  }) =>
      post('/loginByPassword', data: {
        'username': username,
        'password': password,
      });

  /// 用户名注册登录
  AsyncJson loginByReg({
    required String username,
    required String password,
  }) =>
      post('/registerByPassword', data: {
        'username': username,
        'password': password,
      });

  /// 验证用户名
  AsyncJson validateUsername({
    required String username,
  }) =>
      post('/validateUsername', data: {
        'username': username,
      });
}
