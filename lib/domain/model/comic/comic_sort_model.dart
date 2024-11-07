class ComicSortModel {
  final String title;
  final String sort;

  ComicSortModel({required this.title, required this.sort});

  factory ComicSortModel.fromJson(Map<String, dynamic> json) => ComicSortModel(
        title: json['title'],
        sort: json['sort'],
      );
}
