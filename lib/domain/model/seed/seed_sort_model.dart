class SeedSortModel {
  final String title;
  final String type;
  SeedSortModel({required this.title, required this.type});
  factory SeedSortModel.fromJson(Map<String, dynamic> json) =>
      SeedSortModel(title: json['title'], type: json['type']);
}
