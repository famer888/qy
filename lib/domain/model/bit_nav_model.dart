class BitNavModel {
  final int id;
  final String name;
  BitNavModel({required this.id, required this.name});
  factory BitNavModel.fromJson(Map<String, dynamic> json) =>
      BitNavModel(id: json['id'], name: json['name']);
}
