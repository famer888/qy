import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../domain/model/tiezt_model.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../theme.dart';
import '../../card/media.dart';

class PostCenterCard extends StatelessWidget {
  const PostCenterCard({super.key, required this.data});
  final TieztModel data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: data.status == 1
            ? () => CommunityPostDetailRoute(data.id.toString()).push(context)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                RelativeDateFormat.format(
                    date: DateTime.parse(data.createdAt ?? '')),
                style: MyTheme.gray102_14),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.w),
              child: Container(
                padding: EdgeInsets.only(
                  left: 10.w,
                ),
                decoration: BoxDecoration(
                  border: Border(
                      left: BorderSide(
                    color: const Color(0xFF60B2DC),
                    width: 2.w,
                  )),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.w),
                    Text.rich(TextSpan(children: [
                      data.isBest == 1
                          ? WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.only(right: 2.w),
                                child: Container(
                                  height: 16.w,
                                  decoration: BoxDecoration(
                                    gradient:
                                        MyTheme.btnGradient_ff00edfd_ffbbe954,
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: Text(
                                    'jhua'.tr(context: context),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ))
                          : const TextSpan(),
                      TextSpan(text: data.title, style: MyTheme.white255_15)
                    ])),
                    CardMediaView(
                      medias: data.medias,
                    ),
                    SizedBox(height: 15.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () =>
                              CommunityTagDetailRoute('${data.topic?.id}')
                                  .push(context),
                          child: Text(
                            '#${data.topic?.name ?? ''}',
                            style: MyTheme.blue96_13_M,
                          ),
                        ),
                        Text(
                          "${CommonUtils.renderFixedNumber(data.commentNum)}${tr("tpl")} ｜ ${CommonUtils.renderFixedNumber(data.viewNum)}${tr("llan")} ｜ ${CommonUtils.renderFixedNumber(data.likeNum)}${tr("dz")}",
                          style: MyTheme.gray163_11,
                        )
                      ],
                    ),
                    SizedBox(height: 18.w),
                    switch (data.status) {
                      0 => Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${'shzt'.tr(context: context)}：${'dsh'.tr(context: context)}',
                                style: MyTheme.red255_11),
                          ),
                        ),
                      2 => Padding(
                          padding: EdgeInsets.only(bottom: 10.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${'bjyy'.tr(context: context)}：',
                                  style: MyTheme.red255_11),
                              SizedBox(height: 5.w),
                              Text(
                                data.refuseReason ?? '',
                                style: MyTheme.red255_11,
                                maxLines: 20,
                              ),
                            ],
                          ),
                        ),
                      _ => const SizedBox.shrink()
                    }
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
