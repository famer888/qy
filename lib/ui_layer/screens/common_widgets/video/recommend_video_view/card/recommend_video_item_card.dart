import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/video/recommend_video_model.dart';
import '../../../../../../domain/model/video/video_model.dart';
import '../../../../../../domain/remote_domain/domains/index.dart';
import '../../../../../notifiers/home_config_notifier.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../../../localization_text.dart';
import '../../../my_button.dart';
import '../../../my_image.dart';
import '../../card/video_card.dart';

class RecommendVideoItemCard extends StatefulWidget {
  const RecommendVideoItemCard({super.key, required this.data});

  final RecommendVideoCardModel data;

  @override
  State<RecommendVideoItemCard> createState() => _RecommendVideoItemCardState();
}

class _RecommendVideoItemCardState extends State<RecommendVideoItemCard> {
  late final _domain = context.read<IndexDomain>();
  int page = 1;
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
                    widget.data.title,
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
        if (widget.data.items.isNotEmpty == true)
          Column(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.data.items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: VideoCard.aspectRatio,
                  mainAxisSpacing: 8.w,
                  crossAxisSpacing: 8.w,
                ),
                itemBuilder: (context, index) {
                  final partsItem = widget.data.items[index];
                  return VideoCard(data: partsItem);
                },
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: MyTheme.pagePadding, bottom: 10.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyButton.highEmphasis(
                      color: MyTheme.white008Color,
                      borderRadius: 15.w,
                      minimumSize: Size(150.w, 40.w),
                      onPressed: _getData,
                      child: Row(
                        children: [
                          MyImage.asset(
                            MyImagePaths.appCommonReload,
                            width: 15.w,
                          ),
                          SizedBox(width: 8.w),
                          LocalizationText('hyh', style: MyTheme.white14),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    MyButton.highEmphasis(
                      color: MyTheme.white008Color,
                      borderRadius: 15.w,
                      minimumSize: Size(150.w, 40.w),
                      child: Row(
                        children: [
                          MyImage.asset(
                            MyImagePaths.appCommonMore,
                            width: 15.w,
                          ),
                          SizedBox(width: 8.w),
                          LocalizationText('ckgd', style: MyTheme.white14),
                        ],
                      ),
                      onPressed: () {
                        MoreRecommendVideoRoute(
                                name: widget.data.title,
                                id: widget.data.id,
                                type: widget.data.type)
                            .push(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
      ],
    );
  }

  //换一换
  Future<void> _getData() async {
    page++;

    late final navs =
        context.read<HomeConfigNotifier>().homeData.config.mvSecondSortNav;
    final limit = max(6, widget.data.items.length);

    final result = widget.data.type == 1
        ? await _domain.getMoreRecommendVideosBySort(
            id: widget.data.id,
            page: page,
            limit: limit,
          )
        : await _domain.getMoreRecommendVideosByPart(
            page: page,
            limit: limit,
            sort: navs.first.type,
            id: widget.data.id,
          );

    if (result.status == 1) {
      final newItems = result.data ?? [];
      if (newItems.isEmpty) {
        page = 0;
        _getData();
      } else {
        widget.data.items = newItems;
        setState(() {});
      }
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }
}
