import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/comic/recommend_comic_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../router/routes.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/localization_text.dart';
import '../../../common_widgets/my_button.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import 'comic_item_card.dart';

class RecommendComicItemCard extends StatefulWidget {
  const RecommendComicItemCard({super.key, required this.data});

  final RecommendComicCardModel data;

  @override
  State<RecommendComicItemCard> createState() => _RecommendComicItemCardState();
}

class _RecommendComicItemCardState extends State<RecommendComicItemCard> {
  late final _domain = context.read<ComicDomain>();
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
              Text(
                widget.data.title ?? '',
                style: MyTheme.white15_M,
              ),
              GestureDetector(
                onTap: () {
                  //更多点击
                  MoreComicRoute(
                    title: widget.data.title ?? '',
                    sort: widget.data.value ?? '',
                  ).push(context);
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
              crossAxisCount: 3,
              childAspectRatio: ComicItemCard.aspectRatio,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 10.w,
            ),
            itemBuilder: (context, index) {
              final partsItem = widget.data.items?[index];
              return ComicItemCard(data: partsItem!);
            },
          ),
        Padding(
          padding: EdgeInsets.only(top: MyTheme.pagePadding, bottom: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyButton.highEmphasis(
                color: MyTheme.white008Color,
                borderRadius: 20.w,
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
                borderRadius: 20.w,
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
                  MoreComicRoute(
                    title: widget.data.title ?? '',
                    sort: widget.data.value ?? '',
                  ).push(context);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  //换一换
  Future<void> _getData() async {
    page++;
    final limit = max(6, widget.data.items?.length ?? 0);

    final result = await _domain.comicMoreChangeList(
      sort: widget.data.value ?? '',
      page: page,
      limit: limit,
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
