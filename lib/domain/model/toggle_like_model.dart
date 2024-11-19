class ToggleLikeModel {
  final int isLike;

  ToggleLikeModel({required this.isLike});
  factory ToggleLikeModel.fromJson(Map<String, dynamic> json) =>
      ToggleLikeModel(
        isLike: json['is_like'] ?? 0,
      );
}
