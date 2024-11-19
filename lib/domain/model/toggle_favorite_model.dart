class ToggleFavoriteModel {
  final int isFavorite;

  ToggleFavoriteModel({required this.isFavorite});
  factory ToggleFavoriteModel.fromJson(Map<String, dynamic> json) =>
      ToggleFavoriteModel(
        isFavorite: json['is_favorite'] ?? 0,
      );
}
