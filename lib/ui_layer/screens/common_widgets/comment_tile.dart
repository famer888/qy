import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../domain/api_validator.dart';
import '../../../domain/enum.dart';
import '../../../domain/model/video_comment_model.dart';
import '../../../domain/remote_domain/domains/user.dart';
import '../../const.dart';
import '../../utils/common_utils.dart';
import '../../utils/my_toast.dart';
import '../image_paths.dart';
import '../theme.dart';
import 'member_vip.dart';
import 'my_avatar.dart';
import 'my_image.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.data, required this.moduleType});
  final CommentModel data;
  final ModuleType moduleType;

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
                          date: DateTime.parse(data.createdAt)),
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
                if (data.id case final id?) {
                  final domain = context.read<UserDomain>();
                  final res = await domain.toggleUserCommentLike(
                      type: moduleType, id: id);
                  if (res.isValid) {
                    data.isLike = isLike ? 0 : 1;
                    isLike ? data.likeCount-- : data.likeCount++;
                    if (data.likeCount < 0) data.likeCount = 0;
                    setState(() {});
                  } else if (res.msg case final msg?) {
                    MyToast.showText(text: msg);
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
                      CommonUtils.renderFixedNumber(
                          data.isLike == 1 && data.likeCount <= 0
                              ? 1
                              : data.likeCount),
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
              CommonUtils.convertEmojiAndHtml(data.content),
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
