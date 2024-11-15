class NovelNavModel {
  final int id;
  final String name;
  final String type;
  NovelNavModel({required this.id, required this.name, required this.type});
  factory NovelNavModel.fromJson(Map<String, dynamic> json) => NovelNavModel(
        id: json['id'],
        name: json['name'],
        type: json['type'].toString(),
      );
}
