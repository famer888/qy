import '../../result.dart';
import 'girl_list_model.dart';
import '../banner_model.dart';

import '../tip_model.dart';

class GirlIndexModel {
  final List<BannerModel>? banner;

  final List<TipModel>? tips;

  final List<GirlListModel>? girls;

  GirlIndexModel({required this.banner, this.tips, required this.girls});

  factory GirlIndexModel.fromJson(Map<String, dynamic> json) {
    return GirlIndexModel(
      banner: List.from(json['banner'].map((e) => BannerModel.fromJson(e))),
      tips: List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      girls: List.from(json['girls'])
          .map((x) => GirlListModel.fromJson(x))
          .toList(),
    );
  }
}
