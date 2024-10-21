import '../../model/exp_of_vip_model.dart';
import '../../model/welfare_task_model.dart';
import '../../type_def.dart';

abstract class SignDomain {
  /// 获取积分列表
  AsyncResult<ExpOfVIPData> getExpOfVIP();

  /// VIP积分兑换
  AsyncJson expConvertVIP({required int id});

  /// 新人福利
  AsyncResult<WelfareTaskModel?> signListTask();

  /// 新人福利 领取
  AsyncResult signListTaskAccept(Map request);
}
