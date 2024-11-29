import '../banner_model.dart';
import 'monitor_with_banners_model.dart';

class MonitorVideoDetailData {
  MonitorVideoDetailData({required this.monitor, this.banners});
  final MonitorModel monitor;
  final List<BannerModel>? banners;

  factory MonitorVideoDetailData.fromJson(Map<String, dynamic> json) =>
      MonitorVideoDetailData(
          monitor: MonitorModel.fromJson(json['monitor']),
          banners: json['banners'] == null
              ? null
              : List<BannerModel>.from(
                  json['banners'].map((e) => BannerModel.fromJson(e))));

  Map<String, dynamic> toJson() => {
        'monitor': monitor,
        'banners': banners,
      };
}
