class AiFaceTopicModel {
  final int id;
  final String name;
  AiFaceTopicModel({required this.id, required this.name});
  factory AiFaceTopicModel.fromJson(Map<String, dynamic> json) =>
      AiFaceTopicModel(id: json['id'], name: json['name']);
}

class AiFaceSortModel {
  AiFaceSortModel({
    required this.title,
    required this.value,
    required this.type,
  });

  final String title;
  final String value;

  // 1 没有排序
  final int type;

  //自定义字段， asc：正序 desc：倒序
  String sort = 'desc';

  factory AiFaceSortModel.fromJson(Map<String, dynamic> json) =>
      AiFaceSortModel(
        title: json['title'],
        value: json['value'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() =>
      {'title': title, 'value': value, 'type': type};
}
