class ProxyDetailModel {
  final ProxyRecordModel today;
  final ProxyRecordModel curMonth;
  final String money;
  final int? level;
  final String? levelStr;
  final num levelRate;
  final num allReward;
  final int? directProxyNum;
  final int? directPayNum;
  final int? directXiaJiDaiLi;
  final String tips;
  final List<String> colorKey;
  ProxyDetailModel({
    required this.today,
    required this.curMonth,
    required this.money,
    this.level,
    required this.levelStr,
    required this.levelRate,
    required this.allReward,
    this.directProxyNum,
    this.directPayNum,
    this.directXiaJiDaiLi,
    required this.tips,
    required this.colorKey,
  });
  factory ProxyDetailModel.fromJson(Map<String, dynamic> json) =>
      ProxyDetailModel(
        today: ProxyRecordModel.fromJson(json['today']),
        curMonth: ProxyRecordModel.fromJson(json['curMonth']),
        money: json['proxy_money'],
        level: json['proxy_level'],
        levelStr: json['proxy_level_str'],
        levelRate: json['proxy_level_rate'],
        allReward: json['all_reward'],
        directProxyNum: json['direct_proxy_num'],
        directPayNum: json['direct_pay_num'],
        directXiaJiDaiLi: json['direct_xiajidaili'],
        tips: json['tips'],
        colorKey: List.from(json['color_key']),
      );
}

class ProxyRecordModel {
  final int reward;
  final int sell;
  final int invitedNum;
  ProxyRecordModel({
    required this.reward,
    required this.sell,
    required this.invitedNum,
  });
  factory ProxyRecordModel.fromJson(Map<String, dynamic> json) =>
      ProxyRecordModel(
        reward: json['reward'],
        sell: json['sell'],
        invitedNum: json['invited_num'],
      );
}
