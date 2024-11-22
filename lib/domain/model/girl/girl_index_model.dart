import '../../result.dart';
import 'girl_list_model.dart';
import '../banner_model.dart';

class GirlIndexModel {
  final List<BannerModel>? banner;

  final List<String>? notice;
  final List<GirlListModel>? girls;

  GirlIndexModel({required this.banner, this.notice, required this.girls});

  factory GirlIndexModel.fromJson(Map<String, dynamic> json) {
    return GirlIndexModel(
        banner: List.from(json['banner'].map((e) => BannerModel.fromJson)),
        notice: List.from(json['notice'] ?? []),
        girls: List.from(json['girls'])
            .map((x) => GirlListModel.fromJson(x))
            .toList());
  }
}
