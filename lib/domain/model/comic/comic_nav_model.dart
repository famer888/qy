class ComicNavModel {
  final int id;
  final String name;
  final String type;
  ComicNavModel({required this.id, required this.name, required this.type});
  factory ComicNavModel.fromJson(Map<String, dynamic> json) => ComicNavModel(
        id: json['id'],
        name: json['name'],
        type: json['type'].toString(),
      );
}
