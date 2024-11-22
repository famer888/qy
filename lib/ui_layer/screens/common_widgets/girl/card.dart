import 'package:flutter/widgets.dart';

import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/video/video_model.dart';
import '../video/card/widgets/ad_view.dart';
import 'list_card.dart';

class GirlCard extends StatelessWidget {
  const GirlCard({super.key, required this.data});
  static const aspectRatio = 163 / 128;
  final GirlListModel data;
  @override
  Widget build(BuildContext context) {
    return data.map(
      girl: (girl) => GirlListCard(data: girl),
      ad: (ad) => AdCardView(ad: VideoCardAdModel.fromJson(ad.toJson())),
    );
  }
}
