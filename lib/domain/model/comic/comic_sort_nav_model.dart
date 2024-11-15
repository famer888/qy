class ComicSortNavModel {
  final String title;
  final String sort;

  ComicSortNavModel({required this.title, required this.sort});

  factory ComicSortNavModel.fromJson(Map<String, dynamic> json) => ComicSortNavModel(
        title: json['title'],
        sort: json['sort'],
      );
}
