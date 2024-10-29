import '../banner_model.dart';
import '../marquee_tips.dart';

class MonitorWithBannersModel {
  List<MonitorModel>? monitors;
  List<BannerModel>? banners;
  List<MarqueeTipsModel>? tips;

  MonitorWithBannersModel({this.monitors, this.banners, this.tips});

  factory MonitorWithBannersModel.fromJson(Map<String, dynamic> json) =>
      MonitorWithBannersModel(
        monitors: List<MonitorModel>.from(
            json['monitors'].map((e) => MonitorModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips: List<MarqueeTipsModel>.from(
            json['tips'].map((e) => MarqueeTipsModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'monitors': monitors, 'banners': banners, 'tips': tips};
}

class MonitorModel {
  final int? id;
  final String? title;
  final String? cover;
  String? hls;
  final String? show;
  int? type;
  final int? coins;
  final String? intro;
  int? isFavorite;
  int? isLike;
  final String? payTip;
  final int? viewFct;
  final int? commentCt;
  int? favoriteFct;
  final int? streamType;

  MonitorModel({
    this.id,
    this.title,
    this.cover,
    this.hls,
    this.show,
    this.type,
    this.coins,
    this.intro,
    this.isFavorite,
    this.payTip,
    this.viewFct,
    this.favoriteFct,
    this.isLike,
    this.commentCt,
    this.streamType,
  });

  factory MonitorModel.fromJson(Map<String, dynamic> json) => MonitorModel(
        id: json['id'],
        cover: json['cover'],
        title: json['title'],
        hls: json['hls'],
        show: json['show'],
        type: json['type'],
        coins: json['coins'],
        intro: json['intro'],
        isFavorite: json['is_favorite'] ?? 0,
        payTip: json['pay_tip'],
        viewFct: json['view_fct'],
        favoriteFct: json['favorite_fct'] ?? 0,
        isLike: json['is_like'] ?? 0,
        commentCt: json['comment_ct'],
        streamType: json['stream_type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cover': cover,
        'title': title,
        'hls': hls,
        'show': show,
        'type': type,
        'coins': coins,
        'intro': intro,
        'is_favorite': isFavorite,
        'is_like': isLike,
        'pay_tip': payTip,
        'view_fct': viewFct,
        'comment_ct': commentCt,
        'favorite_fct': favoriteFct,
        'stream_type': streamType,
      };
}
