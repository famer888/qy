import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'user_view.dart';

import '../../../../../domain/model/post_model.dart';
import '../../../../router/routes.dart';
import '../../../theme.dart';
import 'content.dart';
import 'count_view.dart';
import 'media.dart';

enum _Type {
  bit,
  community,
}

class PostCard extends StatelessWidget {
  const PostCard.bit({
    super.key,
    required this.data,
  }) : _type = _Type.bit;
  const PostCard.community({
    super.key,
    required this.data,
  }) : _type = _Type.community;

  final PostModel data;
  final _Type _type;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => switch (_type) {
          _Type.community =>
            CommunityPostDetailRoute('${data.id}').push(context),
          _Type.bit => BitPostDetailRoute('${data.id}').push(context),
        },
        child: Padding(
          padding: EdgeInsets.all(MyTheme.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.user case final user? when _type == _Type.community)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.w),
                  child: CardUserView(
                    user: user,
                    createdAt: data.createdAt ?? '',
                  ),
                ),
              CardContentView(
                isBest: data.isBest == 1,
                title: data.title,
              ),
              if (data.medias case final medias? when medias.isNotEmpty)
                CardMediaView(
                  medias: medias,
                ),
              Divider(color: Colors.white.withOpacity(0.04), height: 18.w),
              CardCountView(
                viewCount: data.viewNum,
                commentCount: data.commentNum,
                likeCount: data.likeNum,
                topic: _type == _Type.community ? data.topic : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
