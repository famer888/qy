class GirlSortModel {
  GirlSortModel({
    this.title,
    this.type,
  });

  final String? title;
  final String? type;

  factory GirlSortModel.fromJson(Map<String, dynamic> json) => GirlSortModel(
        title: json['title'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
      };
}
