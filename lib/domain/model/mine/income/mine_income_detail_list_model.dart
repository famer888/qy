import 'mine_income_detail_model.dart';

class MineIncomeDetailListModel {
  final List<MineIncomeDetailModel>? list;
  final String? lastIx;

  MineIncomeDetailListModel({
    this.list,
    this.lastIx,
  });

  factory MineIncomeDetailListModel.fromJson(Map<String, dynamic> json) =>
      MineIncomeDetailListModel(
        list: List.from(
          json['list'].map((e) => MineIncomeDetailModel.fromJson(e)),
        ),
        lastIx: json['last_ix'],
      );
}
