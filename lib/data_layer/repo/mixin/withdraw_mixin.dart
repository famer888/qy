part of '../repo.dart';

mixin _Withdraw on _BaseAppRepo implements WithdrawDomain {
  @override
  AsyncResult<WithdrawRuleModel> cashWithdrawRule() => _withdrawService
      .cashWithdrawRule()
      .deserializeJsonBy(WithdrawRuleModel.fromJson)
      .guard;
}
