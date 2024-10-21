class CommunityNavModel {
  final int id;
  final String title;

  CommunityNavModel({
    required this.id,
    required this.title,
  });

  factory CommunityNavModel.fromJson(Map<String, dynamic> json) =>
      CommunityNavModel(
        id: json['id'],
        title: json['title'],
      );
}

class CircleCommunityNavModel {
  final int id;
  final String name;
  final int mask;

  CircleCommunityNavModel({
    required this.id,
    required this.name,
    required this.mask,
  });
  factory CircleCommunityNavModel.fromJson(Map<String, dynamic> json) =>
      CircleCommunityNavModel(
        id: json['id'],
        name: json['name'],
        mask: json['mask'],
      );
}
