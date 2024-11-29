import '../banner_model.dart';
import '../part_nav_model.dart';
import 'recommend_video_model.dart';

class RecommendVideoWithBannersModel {
  RecommendVideoWithBannersModel(
      {required this.list, required this.banners, required this.navs});

  final List<RecommendVideoModel> list;
  final List<BannerModel> banners;
  final List<PartModel> navs;

  factory RecommendVideoWithBannersModel.fromJson(Map<String, dynamic> json) =>
      RecommendVideoWithBannersModel(
        list: List<RecommendVideoModel>.from(
            json['list'].map((e) => RecommendVideoModel.fromJson(e)) ?? []),
        banners: List<BannerModel>.from(
            json['banners'].map((e) => BannerModel.fromJson(e)) ?? []),
        navs: List<PartModel>.from(
            json['navs'].map((e) => PartModel.fromJson(e)) ?? []),
      );
}
