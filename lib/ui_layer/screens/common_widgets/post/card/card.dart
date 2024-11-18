import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'user_view.dart';

import '../../../../../domain/model/post/post_model.dart';
import '../../../../router/routes.dart';
import '../../../theme.dart';
import 'content.dart';
import 'count_view.dart';
import 'media.dart';

enum _Type {
  seed,
  post,
}

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.data,
    this.rank,
  }) : _type = _Type.post;

  const PostCard.seed({
    super.key,
    required this.data,
  })  : _type = _Type.seed,
        rank = null;

  final PostModel data;
  final _Type _type;
  final int? rank;

  @override
  Widget build(BuildContext context) {
    final child = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => switch (_type) {
        _Type.post => CommunityPostDetailRoute('${data.id}').push(context),
        _Type.seed => BitPostDetailRoute('${data.id}').push(context),
      },
      child: Padding(
        padding: EdgeInsets.all(MyTheme.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.user case final user? when _type == _Type.post)
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
              topic: _type == _Type.post ? data.topic : null,
            ),
          ],
        ),
      ),
    );

    if (rank case final rank? when rank < 3) {
      final rankColors = [
        [
          const Color(0xff04f7ff).withOpacity(0.3),
          Colors.transparent,
        ],
        [
          const Color(0xffff0404).withOpacity(0.3),
          Colors.transparent,
        ],
        [
          const Color(0xffffee04).withOpacity(0.3),
          Colors.transparent,
        ],
      ];
      return DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xff232337),
          borderRadius: BorderRadius.circular(5.w),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            gradient: LinearGradient(
              colors: rankColors[rank],
              stops: const [0.0, 0.3],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  'TOP${rank + 1}',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.1),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      height: 1.0),
                ),
              ),
              child,
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.all(Radius.circular(10.w)),
      ),
      child: child,
    );
  }
}
