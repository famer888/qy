import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../router/routes.dart';
import '../../../../../domain/model/feed/feed_model.dart';
import '../../../../utils/common_utils.dart';
import '../../../theme.dart';
import '../../my_image.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.data});
  final FeedVideoModel data;

  String get imageUrl => CommonUtils.getThumb(data.toJson());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        VideoDetailRoute('${data.id}').push(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 94.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    MyImage.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      backgroundColor: MyTheme.imageBgColor,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${CommonUtils.renderFixedNumber(data.playCt)}${'bf'.tr()}',
                              style: MyTheme.white12medium,
                            ),
                            Text(
                              RelativeDateFormat.getHMTime(time: data.duration),
                              style: MyTheme.white12medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                data.title,
                style: MyTheme.white244_14,
                maxLines: 2,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                RelativeDateFormat.format(date: DateTime.parse(data.createdAt)),
                style: MyTheme.graya3a2a2_11,
              ),
              Text(
                '${'pl'.tr()} ${data.countComment}',
                style: MyTheme.graya3a2a2_11,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
