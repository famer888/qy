class NovelItemModel {
  final int? id;
  final int? themeIds;
  final String? cover;
  final String? title;
  final String? tag;
  final int? isEnd;
  final int? chapterCt; //总章节数
  final int? viewCt;
  final int? viewFct;
  final String? intro;
  final int? fontCt;

  NovelItemModel({
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
    this.fontCt,
  });

  factory NovelItemModel.fromJson(Map<String, dynamic> json) => NovelItemModel(
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
        fontCt: json['font_ct'],
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
        'font_ct': fontCt,
      };
}
