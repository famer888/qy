class NovelSortNavModel {
  final String title;
  final String sort;

  NovelSortNavModel({required this.title, required this.sort});

  factory NovelSortNavModel.fromJson(Map<String, dynamic> json) =>
      NovelSortNavModel(
        title: json['title'],
        sort: json['sort'],
      );
}
