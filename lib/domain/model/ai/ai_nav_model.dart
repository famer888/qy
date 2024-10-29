class AiNavModel {
  final int id;
  final String name;
  AiNavModel({required this.id, required this.name});
  factory AiNavModel.fromJson(Map<String, dynamic> json) =>
      AiNavModel(id: json['id'], name: json['name']);
}
