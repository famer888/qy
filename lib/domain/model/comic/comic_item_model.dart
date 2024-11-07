class ComicItemsModel {
  final int? id;
  final String? themeIds;
  final String? cover;
  final String? title;
  final String? tag;
  final int? isEnd;
  final int? chapterCt; //总章节数
  final int? viewCt;
  final int? viewFct;
  final String? intro;

  ComicItemsModel({
    this.id,
    this.themeIds,
    this.title,
    this.cover,
    this.tag,
    this.isEnd,
    this.chapterCt,
    this.viewCt,
    this.viewFct,
    this.intro,
  });

  factory ComicItemsModel.fromJson(Map<String, dynamic> json) =>
      ComicItemsModel(
        id: json['id'],
        themeIds: json['theme_ids'],
        title: json['title'],
        cover: json['cover'],
        tag: json['tag'],
        isEnd: json['is_end'],
        chapterCt: json['chapter_ct'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        intro: json['intro'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'theme_ids': themeIds,
        'title': title,
        'cover': cover,
        'tag': tag,
        'is_end': isEnd,
        'chapter_ct': chapterCt,
        'view_fct': viewFct,
        'view_ct': viewCt,
        'intro': intro,
      };
}
