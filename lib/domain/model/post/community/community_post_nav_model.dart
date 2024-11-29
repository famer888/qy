class CommunityPostNavModel {
  final int id;
  final String title;
  final int type;

  CommunityPostNavModel({
    required this.id,
    required this.title,
    required this.type,
  });

  factory CommunityPostNavModel.fromJson(Map<String, dynamic> json) =>
      CommunityPostNavModel(
        id: json['id'],
        title: json['title'],
        type: json['type'],
      );
}
