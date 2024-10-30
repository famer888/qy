import '../banner_model.dart';

class AIFaceMaterialsWithBannersModel {
  List<BannerModel>? banners;
  List<AIFaceMaterials>? materials;
  AIFaceMaterialsWithBannersModel({this.materials, this.banners});

  factory AIFaceMaterialsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      AIFaceMaterialsWithBannersModel(
        materials: List<AIFaceMaterials>.from(
            json['materials'].map((e) => AIFaceMaterials.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'materials': materials, 'banners': banners};
}

class AIFaceMaterials {
  final int id;
  final int aff;
  final String title;
  final String thumb;
  final int thumbW;
  final int thumbH;
  final int usedCt;
  final String? usedFct;
  final int? isHot;

  AIFaceMaterials(
      {required this.id,
      required this.aff,
      required this.thumb,
      required this.title,
      required this.usedCt,
      this.usedFct,
      this.isHot,
      required this.thumbW,
      required this.thumbH});

  factory AIFaceMaterials.fromJson(Map<String, dynamic> json) =>
      AIFaceMaterials(
          id: json['id'],
          aff: json['aff'],
          thumb: json['thumb'],
          title: json['title'],
          usedCt: json['used_ct'],
          usedFct: json['used_fct'].toString(),
          isHot: json['is_hot'] ?? 0,
          thumbW: json['thumb_w'],
          thumbH: json['thumb_h']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'thumb': thumb,
        'title': title,
        'used_ct': usedCt,
        'used_fct': usedFct,
        'is_hot': isHot,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      };
}
