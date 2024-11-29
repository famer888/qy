class ProxyProfitModel {
  final String? nickName;
  final ProxyProfitType? type;
  final String? amount;
  final ProxyProfitSourceType? source;
  final String? createdAt;

  ProxyProfitModel({
    this.nickName,
    required this.type,
    this.amount,
    required this.source,
    this.createdAt,
  });
  factory ProxyProfitModel.fromJson(Map<String, dynamic> json) =>
      ProxyProfitModel(
        nickName: json['nickname'],
        type: ProxyProfitType.values[json['type'] as int? ?? 0],
        amount: json['amount'],
        source: ProxyProfitSourceType.values[json['source'] as int? ?? 0],
        createdAt: json['created_at'],
      );
}

enum ProxyProfitType {
  _,

  /// 收入
  income,

  /// 支出
  expenditure;
}

enum ProxyProfitSourceType {
  _,

  ///提现
  withdrawal,

  /// 提现退款
  refundWithdrawal,

  /// 代理分成
  agentCommission;
}
