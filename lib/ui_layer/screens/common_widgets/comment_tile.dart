import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/model/video_comment_model.dart';
import '../../const.dart';
import '../../utils/common_utils.dart';
import '../image_paths.dart';
import '../theme.dart';
import 'member_vip.dart';
import 'my_avatar.dart';
import 'my_image.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.data, required this.changeLike});
  final CommentModel data;

  final AsyncValueGetter<bool> changeLike;

  @override
  Widget build(BuildContext context) {
    final member = data.member;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 15.w),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyAvatar(
            thumb: member?.thumb ?? '',
            size: 30.w,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 180.w),
                      child: Text(
                        member?.nickname ?? '',
                        style: MyTheme.white23_12,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    if (member?.agent == 1)
                      Icon(
                        Icons.verified_sharp,
                        size: 11.w,
                        color: const Color.fromRGBO(247, 208, 93, 1),
                      )
                  ],
                ),
                SizedBox(height: 4.w),
                Row(
                  children: [
                    MemberVipWidget(
                      showText: member?.vipStr,
                      height: 14,
                      fontSize: 7,
                      margin: 5,
                    ),
                    Text(
                      RelativeDateFormat.format(
                          date: DateTime.parse(data.createdAt ?? '')),
                      style: MyTheme.gray163_11,
                    ),
                  ],
                )
              ],
            ),
          ),
          StatefulBuilder(builder: (_, setState) {
            final isLike = data.isLike == 1;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                final result = await changeLike();
                if (result) {
                  data.isLike = isLike ? 0 : 1;
                  isLike ? data.likeCount-- : data.likeCount++;
                  if (context.mounted) {
                    setState(() {});
                  }
                }
              },
              child: SizedBox(
                width: 40.w,
                child: Column(
                  children: [
                    MyImage.asset(
                      isLike
                          ? MyImagePaths.appCommReviewH
                          : MyImagePaths.appCommReviewN,
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(height: 1.w),
                    Text(
                      CommonUtils.renderFixedNumber(data.likeCount),
                      style: MyTheme.gray203_12,
                    )
                  ],
                ),
              ),
            );
          })
        ],
      ),
      SizedBox(height: 13.w),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 40.w),
            child: Text(
              CommonUtils.convertEmojiAndHtml(data.content ?? ''),
              style: MyTheme.gray208_13,
              textAlign: TextAlign.left,
              maxLines: UILayerConst.maxLine,
            ),
          ),
        ],
      ),
      SizedBox(height: 15.w),
      Container(
        height: 0.5.w,
        color: const Color(0xFF15152a),
      )
    ]);
  }
}
