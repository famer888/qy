import '../banner_model.dart';
import '../post/post_model.dart';

class SeedPostsWithBannersModel {
  List<PostModel> posts;
  List<BannerModel> banners;
  SeedPostsWithBannersModel({required this.posts, required this.banners});
  factory SeedPostsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      SeedPostsWithBannersModel(
          posts: List<PostModel>.from(
              json['posts'].map((e) => PostModel.fromJson(e))),
          banners: List<BannerModel>.from(
              json['banners'].map((e) => BannerModel.fromJson(e))));
  Map<String, dynamic> toJson() => {'posts': posts, 'banners': banners};
}
