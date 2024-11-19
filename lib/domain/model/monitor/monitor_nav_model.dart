class MonitorNavModel {
  final int id;
  final String name;

  MonitorNavModel({
    required this.id,
    required this.name,
  });

  factory MonitorNavModel.fromJson(Map<String, dynamic> json) =>
      MonitorNavModel(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
      );
}
