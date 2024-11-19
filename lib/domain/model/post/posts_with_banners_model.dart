import '../banner_model.dart';
import 'post_model.dart';
import '../topic_model.dart';

class PostsWithBannersModel {
  List<TopicModel> topics;
  List<BannerModel> banners;
  List<PostModel> posts;
  PostsWithBannersModel({
    required this.topics,
    required this.banners,
    required this.posts,
  });
  factory PostsWithBannersModel.fromJson(Map<String, dynamic> json) =>
      PostsWithBannersModel(
          topics: List<TopicModel>.from(
              (json['topics'] ?? []).map((e) => TopicModel.fromJson(e))),
          banners: List<BannerModel>.from(
              (json['banner'] ?? []).map((e) => BannerModel.fromJson(e))),
          posts: List<PostModel>.from(
              json['posts'].map((e) => PostModel.fromJson(e))));
  Map<String, dynamic> toJson() => {'topics': topics, 'banner': banners};
}
