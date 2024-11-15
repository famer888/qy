import '../../model/mine/withdrawal/withdraw_rule_model.dart';
import '../../type_def.dart';

abstract class WithdrawDomain {
  /// 提现 规则
  AsyncResult<WithdrawRuleModel> cashWithdrawRule();
}
