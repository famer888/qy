import 'package:flutter/widgets.dart';

import '../../../../../domain/model/video/video_model.dart';
import 'widgets/ad_view.dart';
import 'widgets/video_view.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.data});
  static const aspectRatio = 163 / 158;
  final VideoCardModel data;
  @override
  Widget build(BuildContext context) {
    return data.map(
      video: (video) => VideoCardView(data: video),
      ad: (ad) => AdCardView(ad: ad),
    );
  }
}
