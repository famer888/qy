import '../banner_model.dart';
import 'ai_face_material_model.dart';

class AiFaceMaterialsWithBannersModel {
  List<BannerModel>? banners;
  List<AiFaceMaterialModel>? materials;
  AiFaceMaterialsWithBannersModel({this.materials, this.banners});

  factory AiFaceMaterialsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      AiFaceMaterialsWithBannersModel(
        materials: List<AiFaceMaterialModel>.from(
            json['materials'].map((e) => AiFaceMaterialModel.fromJson(e))),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {'materials': materials, 'banners': banners};
}

