class CommunityPostNavModel {
  final int id;
  final String title;

  CommunityPostNavModel({
    required this.id,
    required this.title,
  });

  factory CommunityPostNavModel.fromJson(Map<String, dynamic> json) =>
      CommunityPostNavModel(
        id: json['id'],
        title: json['title'],
      );
}
