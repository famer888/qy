import '../../model/mine/vip/exp_of_vip_model.dart';
import '../../model/mine/welfare/welfare_task_list_model.dart';
import '../../type_def.dart';

abstract class SignDomain {
  /// 获取积分列表
  AsyncResult<ExpOfVIPListModel> getExpOfVIP();

  /// VIP积分兑换
  AsyncJson expConvertVIP({required int id});

  /// 新人福利
  AsyncResult<WelfareTaskListModel?> signListTask();

  /// 新人福利 领取
  AsyncResult signListTaskAccept(Map request);

  /// 签到
  AsyncResult signUp();
}
