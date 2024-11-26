import '../../model/mine/proxy/proxy_detail_model.dart';
import '../../model/mine/proxy/proxy_invite_record_model.dart';
import '../../model/mine/proxy/proxy_profit_model.dart';
import '../../type_def.dart';

abstract class ProxyDomain {
  /// 代理 推广数据 | 等级信息
  AsyncResult<ProxyDetailModel> getProxyDetail();

  /// 代理 邀请记录
  AsyncResult<ProxyInviteRecordListModel> getProxyInviteRecord({
    required int currentPage,
    required int limit,
  });

  /// 代理 收益明细
  AsyncResult<List<ProxyProfitModel>> getProxyProfitList({
    required int page,
    required int limit,
  });

  AsyncResult proxyApply({required String contact});
}
