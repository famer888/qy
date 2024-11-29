import 'bank_card_model.dart';

class BankCardListModel {
  final List<BankCardModel> list;
  final String lastIx;
  BankCardListModel({required this.list, required this.lastIx});
  factory BankCardListModel.fromJson(Map<String, dynamic> json) =>
      BankCardListModel(
        list: List.from(
          json['list']?.map((e) => BankCardModel.fromJson(e)) ?? [],
        ),
        lastIx: json['last_ix'],
      );
}
