class SeedNavModel {
  final int id;
  final String name;
  SeedNavModel({required this.id, required this.name});
  factory SeedNavModel.fromJson(Map<String, dynamic> json) =>
      SeedNavModel(id: json['id'], name: json['name']);
}
