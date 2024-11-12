//除了推荐以外的分类数据model
import '../banner_model.dart';
import '../part_nav_model.dart';
import '../tip_model.dart';
import 'comic_item_model.dart';
import 'recommend_comic_model.dart';

class ComicWithBannersModel {
  final List<ComicItemsModel>? comics;
  final List<BannerModel>? banner;
  final List<TipModel>? tips;

  ComicWithBannersModel({this.comics, this.banner, this.tips});

  factory ComicWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicWithBannersModel(
        comics: List<ComicItemsModel>.from(
            json['comics'].map((e) => ComicItemsModel.fromJson(e))),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'comics': comics, 'banner': banner, 'tips': tips};
}

//热门推荐model数据
class RecommendComicWithBannersModel {
  List<RecommendComicModel>? comics;
  List<BannerModel>? banner;
  List<TipModel>? tips;
  List<PartModel>? nav;

  RecommendComicWithBannersModel(
      {this.comics, this.banner, this.tips, this.nav});

  factory RecommendComicWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecommendComicWithBannersModel(
        comics: List<RecommendComicModel>.from(
            json['comics'].map((e) => RecommendComicModel.fromJson(e))),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e))),
        nav:
            List<PartModel>.from(json['nav'].map((e) => PartModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        'comics': comics?.map((e) => e.toJson()).toList(),
        'banner': banner?.map((e) => e.toJson()).toList(),
        'tips': tips?.map((e) => e.toJson()).toList(),
        'nav': nav?.map((e) => e.toJson()).toList()
      };
}

class ComicDetailWithBannersModel {
  ComicDetailWithBannersModel({
    required this.recommend,
    required this.banner,
    required this.detail,
  });

  final List<ComicItemsModel> recommend;
  final List<BannerModel> banner;
  final ComicDetailModel detail;

  factory ComicDetailWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailWithBannersModel(
        recommend: List<ComicItemsModel>.from(
            json['recommend'].map((e) => ComicItemsModel.fromJson(e)) ?? []),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e)) ?? []),
        detail: ComicDetailModel.fromJson(json['detail']),
      );
}

class ComicDetailModel {
  final int? id;
  final String? title;
  final String? cover;
  final int? chapterCt; //总章节数
  final String? themeIds;
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
  int? isLike;
  int? likeFct;
  final List<ComicChapterModel> chapters;

  ComicDetailModel({
    this.id,
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
    this.isLike,
    this.likeFct,
    required this.chapters,
  });

  factory ComicDetailModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailModel(
        id: json['id'],
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
        isLike: json['is_like'],
        likeFct: json['like_fct'],
        chapters: List<ComicChapterModel>.from(
            json['chapters'].map((e) => ComicChapterModel.fromJson(e)) ?? []),
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
        'chapters': chapters,
      };
}

class ComicChapterModel {
  final int? pId;
  final int? id;
  final int? type;
  final int? coins;
  final String? title;
  int? isPay;
  final String? payTip;
  final String? cover; //章节封面

  //章节详情
  final String? thumb;
  final int? thumbW;
  final int? thumbH;

  ComicChapterModel({
    this.pId,
    this.id,
    this.type,
    this.coins,
    this.title,
    this.isPay,
    this.payTip,
    this.cover,
    this.thumb,
    this.thumbW,
    this.thumbH,
  });

  factory ComicChapterModel.fromJson(Map<String, dynamic> json) =>
      ComicChapterModel(
        pId: json['p_id'],
        id: json['id'],
        type: json['type'],
        coins: json['coins'],
        title: json['title'],
        isPay: json['is_pay'],
        payTip: json['pay_tip'],
        cover: json['cover'],
        thumb: json['thumb'],
        thumbW: json['thumb_w'],
        thumbH: json['thumb_h'],
      );

  Map<String, dynamic> toJson() => {
        'p_id': pId,
        'id': id,
        'type': type,
        'coins': coins,
        'title': title,
        'is_pay': isPay,
        'pay_tip': payTip,
        'cover': cover,
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      };
}

class ComicChaptersDetailModel {
  ComicChaptersDetailModel({required this.pics});

  final List<ComicChapterModel> pics;

  factory ComicChaptersDetailModel.fromJson(Map<String, dynamic> json) =>
      ComicChaptersDetailModel(
        pics: List<ComicChapterModel>.from(
            json['pics'].map((e) => ComicChapterModel.fromJson(e)) ?? []),
      );
}
