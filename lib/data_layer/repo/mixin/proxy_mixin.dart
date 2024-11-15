part of '../repo.dart';

mixin _Proxy on _BaseAppRepo implements ProxyDomain {
  @override
  AsyncResult<ProxyDetailModel> getProxyDetail() => _proxyService
      .getProxyDetail()
      .deserializeJsonBy(ProxyDetailModel.fromJson)
      .guard;

  @override
  AsyncResult<ProxyInviteRecordListModel> getProxyInviteRecord({
    required int currentPage,
    required int limit,
  }) =>
      _proxyService
          .getProxyInviteRecord(page: currentPage, limit: limit)
          .deserializeJsonBy(ProxyInviteRecordListModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ProxyProfitModel>> getProxyProfitList({
    required int page,
    required int limit,
  }) =>
      _proxyService
          .getProxyProfitList(page: page, limit: limit)
          .deserializeJsonListBy(
              (e) => e.map(ProxyProfitModel.fromJson).toList())
          .guard;
}
