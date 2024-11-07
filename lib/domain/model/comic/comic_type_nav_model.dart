//漫画排序条件
class ComicTypeNavListModel {
  ComicTypeNavListModel({
    this.items,
    this.value,
    this.title,
  });

  final List<ComicTypeNavModel>? items;
  final String? value;
  final String? title;

  factory ComicTypeNavListModel.fromJson(Map<String, dynamic> json) =>
      ComicTypeNavListModel(
        items: json['items'] == null
            ? null
            : List.from(
                json['items'].map((x) => ComicTypeNavModel.fromJson(x))),
        value: json['value'],
        title: json['title'],
      );
}

class ComicTypeNavModel {
  ComicTypeNavModel({
    this.value,
    this.title,
  });

  final String? value;
  final String? title;

  factory ComicTypeNavModel.fromJson(Map<String, dynamic> json) =>
      ComicTypeNavModel(
        value: json['value'].toString(),
        title: json['title'],
      );
}
