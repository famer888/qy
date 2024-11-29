class CoinRechargeDetailModel {
  CoinRechargeDetailModel({
    this.id,
    this.aff,
    this.source,
    this.type,
    this.coinCnt,
    this.desc,
    this.sourceAff,
    this.createdAt,
    this.sourceStr,
    this.typeStr,
    this.sourceName,
    this.coin,
  });

  final int? id;
  final int? aff;
  final int? source;
  final int? type;
  final String? coinCnt;
  final String? desc;
  final int? sourceAff;
  final String? createdAt;
  final String? sourceStr;
  final String? typeStr;
  final String? sourceName;
  final int? coin;

  factory CoinRechargeDetailModel.fromJson(Map<String, dynamic> json) =>
      CoinRechargeDetailModel(
        id: json['id'],
        aff: json['aff'],
        source: json['source'],
        type: json['type'],
        coinCnt: json['coinCnt'],
        desc: json['desc'],
        sourceAff: json['source_aff'],
        createdAt: json['created_at'],
        sourceStr: json['source_str'],
        typeStr: json['type_str'],
        sourceName: json['source_name'],
        coin: json['coin'],
      );
}
