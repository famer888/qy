class NovelTypeNavListModel {
  NovelTypeNavListModel({
    required this.items,
    required this.value,
    required this.title,
  });

  final List<NovelTypeNavModel> items;
  final String value;
  final String title;

  factory NovelTypeNavListModel.fromJson(Map<String, dynamic> json) =>
      NovelTypeNavListModel(
        items: List.from(
            json['items'].map((x) => NovelTypeNavModel.fromJson(x)) ?? []),
        value: json['value'] ?? '',
        title: json['title'] ?? '',
      );
}

class NovelTypeNavModel {
  NovelTypeNavModel({
    required this.value,
    required this.title,
  });

  final String value;
  final String title;

  factory NovelTypeNavModel.fromJson(Map<String, dynamic> json) =>
      NovelTypeNavModel(
        value: json['value']?.toString() ?? '',
        title: json['title'] ?? '',
      );
}
