class ExpOfVIPListModel {
  final List<ExpOfVIPModel> list;
  final int? exp;
  ExpOfVIPListModel({required this.list, required this.exp});
  factory ExpOfVIPListModel.fromJson(Map<String, dynamic> json) =>
      ExpOfVIPListModel(
        list: List.from(
          json['list'].map((e) => ExpOfVIPModel.fromJson(e)) ?? [],
        ),
        exp: json['exp'],
      );
}

class ExpOfVIPModel {
  final int id;
  final String vipStr;
  final String expStr;
  ExpOfVIPModel({
    required this.id,
    required this.vipStr,
    required this.expStr,
  });
  factory ExpOfVIPModel.fromJson(Map<String, dynamic> json) => ExpOfVIPModel(
        id: json['id'] ?? '',
        vipStr: json['vip_str'] ?? '',
        expStr: json['exp_str'] ?? '',
      );
}
