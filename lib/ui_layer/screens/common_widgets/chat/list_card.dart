import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../router/routes.dart';
import '../../../utils/common_utils.dart';
import '../../image_paths.dart';
import '../../theme.dart';
import '../my_image.dart';

class ChatListCard extends StatelessWidget {
  const ChatListCard({
    super.key,
    required this.data,
    double imageRatio = 165 / 213,
  });
  final ChatListChatModel data;

  final double imageRatio = 165 / 213;

  @override
  Widget build(BuildContext context) {
    // return Container();

    return LayoutBuilder(builder: (context, constrains) {
      double _w = constrains.maxWidth;
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // if (disalbleTap) {
          //   return;
          // }
          // Utils.navTo(
          //   context,
          //   '/homedatedetailpage/${data["id"]}',
          // );

          ChatDetailRoute(data.id ?? 0).push(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  List.from(data.medias ?? []).isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: MyTheme.blackColor38,
                            // borderRadius: BorderRadius.vertical(
                            //     top: Radius.circular(5.w)),
                          ),
                          width: _w,
                          height: _w / imageRatio,
                          child: Center(
                              child: MyImage.asset(
                            MyImagePaths.app2024ComFenxiangOn,
                            width: 25.w,
                            height: 25.w,
                          )),
                        )
                      : SizedBox(
                          width: _w,
                          height: _w / imageRatio,
                          child: MyImage.network(
                            data.medias!.first.mediaUrl!,
                          ),
                        ),
                  Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: MyTheme.blackColor25.withOpacity(0.5),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(5.w)),
                        ),
                        child: Text(
                            CommonUtils.renderFixedNumber(data.payCt ?? 0) +
                                'rlg'.tr(),
                            style: MyTheme.white255_15),
                      )),

                  // Positioned(left: 0, top: 0, child: videoType(data)),
                ],
              ),
              Expanded(
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            maxLines: 2,
                            text: TextSpan(children: [
                              TextSpan(
                                text: data.name ?? "",
                                style: MyTheme.white255_14_M,
                              )
                            ])),
                        // Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       data["name"] ?? "",
                        //       style: StyleTheme.font_white_255_14_medium,
                        //       maxLines: 1,
                        //     )),
                        SizedBox(height: 5.w),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '${data.age}' +
                                  'sold'.tr() +
                                  '/' +
                                  '${data.cup}' +
                                  'bzcup'.tr() +
                                  '/' +
                                  '${data.height}' +
                                  'c'.tr(),
                              style: MyTheme.white08_14,
                              maxLines: 1,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
