import 'mine_income_detail_source_member_model.dart';

class MineIncomeDetailModel {
  final int? id;
  final int? aff;
  final int? source;
  final int? type;
  final String? coinCnt;
  final String? desc;
  final int? sourceAff;
  final String? createdAt;
  final String? dataName;
  final int? dataId;
  final String? nickname;
  final String? title;
  final MineIncomeDetailSourceMemberModel? sourceMember;

  MineIncomeDetailModel({
    this.id,
    this.aff,
    this.source,
    this.type,
    this.coinCnt,
    this.desc,
    this.sourceAff,
    this.createdAt,
    this.dataName,
    this.dataId,
    this.nickname,
    this.title,
    this.sourceMember,
  });

  factory MineIncomeDetailModel.fromJson(Map<String, dynamic> json) =>
      MineIncomeDetailModel(
        id: json['id'],
        aff: json['aff'],
        source: json['source'],
        type: json['type'],
        coinCnt: json['coinCnt'],
        desc: json['desc'],
        sourceAff: json['source_aff'],
        createdAt: json['created_at'],
        dataName: json['data_name'],
        dataId: json['data_id'],
        nickname: json['nickname'],
        title: json['title'],
        sourceMember: json['source_member'] != null
            ? MineIncomeDetailSourceMemberModel.fromJson(json['source_member'])
            : null,
      );
}
