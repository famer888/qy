import '../banner_model.dart';
import 'live_with_banners_model.dart';

class LiveVideoDetailData {
  LiveVideoDetailData({required this.live, this.banners});
  final LiveModel live;
  final List<BannerModel>? banners;

  factory LiveVideoDetailData.fromJson(Map<String, dynamic> json) =>
      LiveVideoDetailData(
          live: LiveModel.fromJson(json['live']),
          banners: json['banners'] == null
              ? null
              : List<BannerModel>.from(
                  json['banners'].map((e) => BannerModel.fromJson(e))));

  Map<String, dynamic> toJson() => {
        'live': live,
        'banners': banners,
      };
}
