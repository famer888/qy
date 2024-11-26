import '../common_media_model.dart';

class GirlDetailModel {
  final String? tip;
  GirlInfoModel? girl;

  GirlDetailModel({
    this.tip,
    this.girl,
  });

  factory GirlDetailModel.fromJson(Map<String, dynamic> json) {
    return GirlDetailModel(
      tip: json['tip'],
      girl: GirlInfoModel.fromJson(json['girl']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tip': tip,
      'girl': girl?.toJson(),
    };
  }
}

class GirlInfoModel {
  final int? id;
  final int? aff;
  final String? title;
  final String? class_;
  final String? tag;
  final int? type;
  final int? coins;
  final String? price;
  final int? height;
  final int? age;
  final String? service;
  final String? cup;
  String? contact;
  final String? intro;
  final int? photoCt;
  final int? videoCt;
  final int? viewFct;
  int? favoriteFct;
  final int? likeCt;
  final int? likeFct;
  int? isFavorite;
  final int? isLike;
  final List<CommonMediaModel>? medias;

  GirlInfoModel({
    this.id,
    this.aff,
    this.title,
    this.class_,
    this.tag,
    this.type,
    this.coins,
    this.price,
    this.height,
    this.age,
    this.service,
    this.cup,
    this.contact,
    this.intro,
    this.photoCt,
    this.videoCt,
    this.viewFct,
    this.favoriteFct,
    this.likeCt,
    this.likeFct,
    this.isFavorite,
    this.isLike,
    this.medias,
  });

  factory GirlInfoModel.fromJson(Map<String, dynamic> json) {
    return GirlInfoModel(
      id: json['id'],
      aff: json['aff'],
      title: json['title'],
      class_: json['class'],
      tag: json['tag'],
      type: json['type'],
      coins: json['coins'],
      price: json['price'],
      height: json['height'],
      age: json['age'],
      service: json['service'],
      cup: json['cup'],
      contact: json['contact'],
      intro: json['intro'],
      photoCt: json['photo_ct'],
      videoCt: json['video_ct'],
      viewFct: json['view_fct'],
      favoriteFct: json['favorite_fct'],
      likeCt: json['like_ct'],
      likeFct: json['like_fct'],
      isFavorite: json['is_favorite'],
      isLike: json['is_like'],
      medias: List.from(
          json['medias'].map((x) => CommonMediaModel.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'title': title,
      'class': class_,
      'tag': tag,
      'type': type,
      'coins': coins,
      'price': price,
      'height': height,
      'age': age,
      'service': service,
      'cup': cup,
      'contact': contact,
      'intro': intro,
      'photo_ct': photoCt,
      'video_ct': videoCt,
      'view_fct': viewFct,
      'favorite_fct': favoriteFct,
      'like_ct': likeCt,
      'like_fct': likeFct,
      'is_favorite': isFavorite,
      'is_like': isLike,
      'medias': (medias ?? []).map((x) => x.toJson()),
    };
  }
}
