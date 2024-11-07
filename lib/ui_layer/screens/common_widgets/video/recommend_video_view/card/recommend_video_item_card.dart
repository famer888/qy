import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../domain/model/video/recommend_video_model.dart';
import '../../../../../router/routes.dart';
import '../../../../theme.dart';
import '../../../localization_text.dart';
import '../../card/video_card.dart';

class RecommendVideoItemCard extends StatefulWidget {
  const RecommendVideoItemCard({super.key, required this.data});

  final RecommendVideoCardModel data;

  @override
  State<RecommendVideoItemCard> createState() => _RecommendVideoItemCardState();
}

class _RecommendVideoItemCardState extends State<RecommendVideoItemCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.data.title ?? '',
                    style: MyTheme.white15_M,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    widget.data.subTitle ?? '',
                    style: MyTheme.white07_12,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  MoreRecommendVideoRoute(
                          name: widget.data.title,
                          id: widget.data.id,
                          type: widget.data.type)
                      .push(context);
                },
                child: LocalizationText('gd', style: MyTheme.white04_12),
              )
            ],
          ),
        ),
        if (widget.data.items?.isNotEmpty == true)
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.data.items!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: VideoCard.aspectRatio,
              mainAxisSpacing: 8.w,
              crossAxisSpacing: 8.w,
            ),
            itemBuilder: (context, index) {
              final partsItem = widget.data.items?[index];
              return VideoCard(data: partsItem!);
            },
          ),
      ],
    );
  }
}
