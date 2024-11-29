//除了推荐以外的分类数据model
import '../banner_model.dart';
import '../part_nav_model.dart';
import '../tip_model.dart';
import '../video_comment_model.dart';
import 'comic_item_model.dart';
import 'recommend_comic_model.dart';

class ComicWithBannersModel {
  final List<ComicItemModel>? comics;
  final List<BannerModel>? banner;
  final List<TipModel>? tips;

  ComicWithBannersModel({this.comics, this.banner, this.tips});

  factory ComicWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicWithBannersModel(
        comics: List<ComicItemModel>.from(
            json['comics'].map((e) => ComicItemModel.fromJson(e))),
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

  final List<ComicItemModel> recommend;
  final List<BannerModel> banner;
  final ComicDetailModel detail;

  factory ComicDetailWithBannersModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailWithBannersModel(
        recommend: List<ComicItemModel>.from(
            json['recommend'].map((e) => ComicItemModel.fromJson(e)) ?? []),
        banner: List<BannerModel>.from(
            json['banner'].map((e) => BannerModel.fromJson(e)) ?? []),
        detail: ComicDetailModel.fromJson(json['detail']),
      );
}

class ComicDetailModel {
  final int id;
  final String title;
  final String? cover;
  final int chapterCt; //总章节数
  final int viewFct;
  final int viewCt;
  int favoriteFct;
  final int commentCt;
  final String tag;
  final int isEnd;
  final String intro;
  int isFavorite;
  int isLike;
  int likeFct;
  final List<ComicChapterModel> chapters;
  final List<CommentModel> comments = [];

  ComicDetailModel({
    required this.id,
    required this.title,
    this.cover,
    required this.chapterCt,
    required this.viewFct,
    required this.viewCt,
    required this.favoriteFct,
    required this.commentCt,
    required this.tag,
    required this.isEnd,
    required this.intro,
    required this.isFavorite,
    required this.isLike,
    required this.likeFct,
    required this.chapters,
  });

  factory ComicDetailModel.fromJson(Map<String, dynamic> json) =>
      ComicDetailModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        cover: json['cover'],
        chapterCt: json['chapter_ct'] ?? 0,
        viewFct: json['view_fct'] ?? 0,
        viewCt: json['view_ct'] ?? 0,
        favoriteFct: json['favorite_fct'] ?? 0,
        commentCt: json['comment_ct'] ?? 0,
        tag: json['tag'] ?? '',
        isEnd: json['is_end'] ?? 0,
        intro: json['intro'] ?? '',
        isFavorite: json['is_favorite'] ?? 0,
        isLike: json['is_like'] ?? 0,
        likeFct: json['like_fct'] ?? 0,
        chapters: List<ComicChapterModel>.from(
            json['chapters']?.map((e) => ComicChapterModel.fromJson(e)) ?? []),
      );
}

class ComicChapterModel {
  final int? pId;
  final int? id;
  final int type;
  final int coins;
  final String? title;
  int isPay;
  final String? payTip;
  final String? cover; //章节封面

  List<ComicChapterPicModel>? pics;

  ComicChapterModel({
    this.pId,
    this.id,
    required this.type,
    required this.coins,
    this.title,
    required this.isPay,
    this.payTip,
    this.cover,
  });

  factory ComicChapterModel.fromJson(Map<String, dynamic> json) =>
      ComicChapterModel(
        pId: json['p_id'],
        id: json['id'],
        type: json['type'] ?? 0,
        coins: json['coins'] ?? 0,
        title: json['title'],
        isPay: json['is_pay'] ?? 0,
        payTip: json['pay_tip'],
        cover: json['cover'],
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
      };
}

class ComicChapterPicModel {
  ComicChapterPicModel(
      {required this.thumb, required this.thumbW, required this.thumbH});

  final String thumb;
  final int thumbW;
  final int thumbH;

  factory ComicChapterPicModel.fromJson(Map<String, dynamic> json) =>
      ComicChapterPicModel(
        thumb: json['thumb'],
        thumbW: json['thumb_w'],
        thumbH: json['thumb_h'],
      );

  Map<String, dynamic> toJson() => {
        'thumb': thumb,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      };
}

class ComicChaptersDetailModel {
  ComicChaptersDetailModel({required this.pics});

  final List<ComicChapterPicModel> pics;

  factory ComicChaptersDetailModel.fromJson(Map<String, dynamic> json) =>
      ComicChaptersDetailModel(
        pics: List<ComicChapterPicModel>.from(
            json['pics'].map((e) => ComicChapterPicModel.fromJson(e)) ?? []),
      );
}
