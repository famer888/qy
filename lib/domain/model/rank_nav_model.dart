class RankNavModel {
  RankNavModel({
    this.title,
    this.value,
  });

  final String? title;
  final String? value;

  factory RankNavModel.fromJson(Map<String, dynamic> json) => RankNavModel(
        title: json['title'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'value': value,
      };
}
