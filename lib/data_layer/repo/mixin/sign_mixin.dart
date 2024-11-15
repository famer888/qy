part of '../repo.dart';

mixin _Sign on _BaseAppRepo implements SignDomain {
  @override
  AsyncResult<ExpOfVIPListModel> getExpOfVIP() => _signService
      .getExpOfVIP()
      .deserializeJsonBy(ExpOfVIPListModel.fromJson)
      .guard;

  @override
  AsyncJson expConvertVIP({required int id}) =>
      _signService.expConvertVIP(id: id);

  @override
  AsyncResult<WelfareTaskListModel> signListTask() => _signService
      .signListTask()
      .deserializeJsonBy(WelfareTaskListModel.fromJson)
      .guard;

  @override
  AsyncResult signListTaskAccept(Map request) =>
      _signService.signListTaskAccept(request).deserialize().guard;

  @override
  AsyncResult signUp() => _signService.signUpt().deserialize().guard;
}
