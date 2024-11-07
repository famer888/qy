import '../banner_model.dart';
import '../tip_model.dart';

class LiveWithBannersModel {
  List<LiveModel>? lives;
  List<BannerModel>? banners;
  List<TipModel>? tips;

  LiveWithBannersModel({this.lives, this.banners, this.tips});

  factory LiveWithBannersModel.fromJson(Map<String, dynamic> json) =>
      LiveWithBannersModel(
        lives: List<LiveModel>.from(
            json['lives'].map((e) => LiveModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'lives': lives, 'banners': banners, 'tips': tips};
}

class LiveModel {
  final int? id;
  final String? cover;
  final String? username;
  final int? viewFct;
  final int? commentCt;
  int? favoriteFct;
  List<LiveHlsModel>? hls;
  String? show;
  int? type;
  final int? coins;
  int? isFavorite;
  final String? payTip;
  final String? intro;
  final String? thumb;

  LiveModel({
    this.id,
    this.cover,
    this.username,
    this.viewFct,
    this.favoriteFct,
    this.commentCt,
    this.hls,
    this.show,
    this.type,
    this.coins,
    this.isFavorite,
    this.payTip,
    this.intro,
    this.thumb,
  });

  factory LiveModel.fromJson(Map<String, dynamic> json) => LiveModel(
        id: json['id'],
        cover: json['cover'],
        username: json['username'],
        viewFct: json['view_fct'],
        favoriteFct: json['favorite_fct'] ?? 0,
        commentCt: json['comment_ct'],
        hls: json['hls'] != null
            ? List.from(json['hls'].map((e) => LiveHlsModel.fromJson(e)))
            : null,
        show: json['show'],
        type: json['type'],
        coins: json['coins'],
        isFavorite: json['is_favorite'] ?? 0,
        payTip: json['pay_tip'],
        intro: json['intro'],
        thumb: json['thumb'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'cover': cover,
        'username': username,
        'view_fct': viewFct,
        'comment_ct': commentCt,
        'favorite_fct': favoriteFct,
        'hls': hls,
        'show': show,
        'type': type,
        'coins': coins,
        'is_favorite': isFavorite,
        'pay_tip': payTip,
        'intro': intro,
        'thumb': thumb,
      };
}

class LiveHlsModel {
  String label;
  String url;

  LiveHlsModel({required this.label, required this.url});

  factory LiveHlsModel.fromJson(Map<String, dynamic> json) {
    return LiveHlsModel(label: json['label'], url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'url': url,
      };
}

class RecommendLiveWithBannersModel {
  List<LiveThemesModel>? themes;
  List<BannerModel>? banners;
  List<TipModel>? tips;

  RecommendLiveWithBannersModel({this.themes, this.banners, this.tips});

  factory RecommendLiveWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecommendLiveWithBannersModel(
        themes: List<LiveThemesModel>.from(
            json['themes'].map((e) => LiveThemesModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
        tips:
            List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() =>
      {'themes': themes, 'banners': banners, 'tips': tips};
}

class LiveThemesModel {
  final int? id;
  final String? name;
  List<LiveModel>? lives;

  LiveThemesModel({this.id, this.name, this.lives});

  factory LiveThemesModel.fromJson(Map<String, dynamic> json) =>
      LiveThemesModel(
        id: json['id'],
        name: json['name'],
        lives: List<LiveModel>.from(
            json['lives'].map((e) => LiveModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'lives': lives};
}
