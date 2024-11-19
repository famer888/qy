class LiveNavModel {
  final int id;
  final String name;
  final int? uiType;

  LiveNavModel({
    required this.id,
    required this.name,
    this.uiType,
  });

  factory LiveNavModel.fromJson(Map<String, dynamic> json) => LiveNavModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        uiType: json['ui_type'],
      );
}
