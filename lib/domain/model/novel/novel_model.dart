import '../banner_model.dart';
import '../part_nav_model.dart';
import '../tip_model.dart';
import 'novel_item_model.dart';
import 'recommend_novel_model.dart';

//除了推荐以外的分类数据model
class NovelWithBannersModel {
  List<NovelItemModel>? novels;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  NovelSubjectListItemModel? theme;

  NovelWithBannersModel({this.novels, this.banner, this.tips, this.theme});

  factory NovelWithBannersModel.fromJson(Map<String, dynamic> json) =>
      NovelWithBannersModel(
          novels: List<NovelItemModel>.from(
              json['novels'].map((e) => NovelItemModel.fromJson(e))),
          banner: json['banner'] != null
              ? List<BannerModel>.from(
                  json['banner'].map((e) => BannerModel.fromJson(e)))
              : [],
          tips: json['tips'] != null
              ? List<TipModel>.from(
                  json['tips'].map((e) => TipModel.fromJson(e)))
              : [],
          theme: NovelSubjectListItemModel.fromJson(json['theme']));

  Map<String, dynamic> toJson() => {
        'novels': novels,
        'banner': banner,
        'tips': tips,
        'theme': theme?.toJson()
      };
}

//热门推荐model数据
class RecommendNovelWithBannersModel {
  List<RecommendNovelModel>? novels;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  List<PartModel>? nav;
  RecommendNovelWithBannersModel(
      {this.novels, this.banner, this.nav, this.tips});

  factory RecommendNovelWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecommendNovelWithBannersModel(
        novels: json['novels'] == null
            ? null
            : List<RecommendNovelModel>.from(
                json['novels'].map((e) => RecommendNovelModel.fromJson(e))),
        banner: json['banner'] == null
            ? null
            : List<BannerModel>.from(
                json['banner'].map((e) => BannerModel.fromJson(e))),
        nav:
            List<PartModel>.from(json['nav'].map((e) => PartModel.fromJson(e))),
        tips: json['tips'] == null
            ? null
            : List<TipModel>.from(
                json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'novels': novels?.map((e) => e.toJson()).toList(),
        'banner': banner?.map((e) => e.toJson()).toList(),
        'nav': nav?.map((e) => e.toJson()).toList(),
        'tips': tips?.map((e) => e.toJson()).toList(),
      };
}

class NovelDetailWithBannersModel {
  final List<NovelItemModel> recommend;
  final List<BannerModel> banner;
  final NovelDetailModel detail;

  NovelDetailWithBannersModel({
    required this.recommend,
    required this.banner,
    required this.detail,
  });

  factory NovelDetailWithBannersModel.fromJson(Map<String, dynamic> json) =>
      NovelDetailWithBannersModel(
        recommend: List<NovelItemModel>.from(
            json['recommend'].map((e) => NovelItemModel.fromJson(e)) ?? []),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e)) ?? []),
        detail: NovelDetailModel.fromJson(json['detail']),
      );
}

class NovelDetailModel {
  final int id;
  final String? title;
  final String? cover;
  final int? chapterCt; //总章节数
  final int? themeIds;
  final String? createdAt;
  final int? viewFct;
  final int? viewCt;
  int favoriteFct;
  final String? renewedAt;
  final int? commentCt;
  final String? tag;
  final int? isEnd;
  final String? intro;
  int isFavorite;
  int isLike;
  int likeFct;
  int likeCt;
  int? fontCt;
  final String? author;
  final List<NovelChaptersModel> chapters;

  NovelDetailModel({
    required this.id,
    this.title,
    this.cover,
    this.chapterCt,
    this.themeIds,
    this.createdAt,
    this.viewFct,
    this.viewCt,
    required this.favoriteFct,
    this.renewedAt,
    this.commentCt,
    this.tag,
    this.isEnd,
    this.intro,
    required this.isFavorite,
    required this.isLike,
    required this.likeFct,
    required this.likeCt,
    required this.chapters,
    this.fontCt,
    this.author,
  });

  factory NovelDetailModel.fromJson(Map<String, dynamic> json) =>
      NovelDetailModel(
        id: json['id'] ?? 0,
        title: json['title'],
        cover: json['cover'],
        chapterCt: json['chapter_ct'],
        themeIds: json['theme_ids'],
        createdAt: json['created_at'],
        viewFct: json['view_fct'],
        viewCt: json['view_ct'],
        favoriteFct: json['favorite_fct'] ?? 0,
        renewedAt: json['renewed_at'],
        commentCt: json['comment_ct'],
        tag: json['tag'],
        isEnd: json['is_end'],
        intro: json['intro'],
        isFavorite: json['is_favorite'] ?? 0,
        isLike: json['is_like'] ?? 0,
        likeFct: json['like_fct'] ?? 0,
        likeCt: json['like_ct'] ?? 0,
        chapters: List<NovelChaptersModel>.from(
            json['chapters']?.map((e) => NovelChaptersModel.fromJson(e)) ?? []),
        fontCt: json['font_ct'],
        author: json['author'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cover': cover,
        'chapter_ct': chapterCt,
        'theme_ids': themeIds,
        'created_at': createdAt,
        'view_fct': viewFct,
        'view_ct': viewCt,
        'favorite_fct': favoriteFct,
        'renewed_at': renewedAt,
        'comment_ct': commentCt,
        'tag': tag,
        'is_end': isEnd,
        'intro': intro,
        'is_favorite': isFavorite,
        'is_like': isLike,
        'like_fct': likeFct,
        'like_ct': likeCt,
        'chapters': chapters.map((e) => e.toJson()),
        'font_ct': fontCt,
        'author': author,
      };
}

class NovelChaptersModel {
  final int? pId;
  final int? id;
  final int? type;
  final int coins;
  final String? title;

  // int? isPay;
  final String? payTip;
  String txt; //获取章节文字url链接
  String? text; //文字内容，通过txt接口请求获取

  NovelChaptersModel({
    this.pId,
    this.id,
    this.type,
    required this.coins,
    this.title,
    // this.isPay,
    this.payTip,
    required this.txt,
    this.text,
  });

  factory NovelChaptersModel.fromJson(Map<String, dynamic> json) =>
      NovelChaptersModel(
        pId: json['p_id'],
        id: json['id'],
        type: json['type'],
        coins: json['coins'] ?? 0,
        title: json['title'],
        // isPay: json['is_pay'],
        payTip: json['pay_tip'],
        txt: json['txt'] ?? '',
        text: json['text'],
      );

  Map<String, dynamic> toJson() => {
        'p_id': pId,
        'id': id,
        'type': type,
        'coins': coins,
        'title': title,
        // 'is_pay': isPay,
        'pay_tip': payTip,
        'txt': txt,
        'text': text,
      };
}

//关注的专题的小说model
class NovelSubjectNovelListModel {
  List<NovelItemModel>? list;

  NovelSubjectNovelListModel({this.list});

  factory NovelSubjectNovelListModel.fromJson(Map<String, dynamic> json) =>
      NovelSubjectNovelListModel(
        list: json['list'] == null
            ? null
            : List<NovelItemModel>.from(
                json['list'].map((e) => NovelItemModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'list': list};
}

//关注的专题列表model
class NovelSubjectListModel {
  List<NovelSubjectListItemModel>? list;

  NovelSubjectListModel({this.list});

  factory NovelSubjectListModel.fromJson(Map<String, dynamic> json) =>
      NovelSubjectListModel(
        list: json['list'] == null
            ? null
            : List<NovelSubjectListItemModel>.from(
                json['list'].map((e) => NovelSubjectListItemModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'list': list};
}

class NovelSubjectListItemModel {
  final int? id;
  final String? name;
  final int? followNum;
  final int? worksNum;
  final String? thumb;
  int? isFollow;
  int? hasSort;
  int? hasFollow;
  final String? moreApi;
  final NovelApiParamsModel? apiParams;

  NovelSubjectListItemModel(
      {this.id,
      this.name,
      this.followNum,
      this.worksNum,
      this.thumb,
      this.isFollow,
      this.hasSort,
      this.hasFollow,
      this.moreApi,
      this.apiParams});

  factory NovelSubjectListItemModel.fromJson(Map<String, dynamic> json) =>
      NovelSubjectListItemModel(
          id: json['id'],
          name: json['name'],
          followNum: json['follow_num'],
          worksNum: json['works_num'],
          thumb: json['thumb'],
          isFollow: json['is_follow'],
          hasSort: json['has_sort'],
          hasFollow: json['has_follow'],
          moreApi: json['more_api'],
          apiParams: json['api_params'] == null
              ? null
              : NovelApiParamsModel.fromJson(json['api_params']));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'follow_num': followNum,
        'works_num': worksNum,
        'thumb': thumb,
        'is_follow': isFollow,
        'has_sort': hasSort,
        'has_follow': hasFollow,
        'more_api': moreApi,
        'api_params': apiParams?.toJson(),
      };
}

class NovelApiParamsModel {
  final int? id;
  final String? sort;

  NovelApiParamsModel({
    this.id,
    this.sort,
  });

  factory NovelApiParamsModel.fromJson(Map<String, dynamic> json) =>
      NovelApiParamsModel(
        id: json['id'] ?? 0,
        sort: json['sort'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sort': sort,
      };
}
