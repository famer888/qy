import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/enum.dart';
import '../../../../../domain/model/seed/seed_detail_model.dart';
import '../../../../../domain/remote_domain/domains/seed.dart';
import '../../../../../domain/type_def.dart';
import '../../../../notifiers/user_notifier.dart';
import '../../../../router/routes.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/post/content/comment_count.dart';
import '../../../common_widgets/post/content/content.dart';
import '../../../common_widgets/post/content/like_collect_share_area.dart';
import '../../../common_widgets/post/content/media.dart';
import '../../../common_widgets/post/content/title.dart';
import '../../../theme.dart';

class SeedContentView extends StatelessWidget {
  const SeedContentView({super.key, required this.data});
  final SeedDetail data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PostTitleView(
            topicTitle: data.title,
            viewCount: data.fakeViewCt,
            createdAt: data.createdAt,
          ),
          PostMediaView(
            medias: data.medias ?? [],
            unlockCoins: data.unlockCoins ?? 0,
          ),
          PostContentView(content: data.content),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.w),
            child: _SourceArea(data: data),
          ),
          _LikeCollectShareArea(data: data),
          Divider(
            height: 1,
            thickness: 0.5.w,
            color: const Color(0xFF2a2a33),
          ),
          SizedBox(height: 20.w),
          PostCommentCountView(commentCount: data.commentNum ?? 0),
        ],
      ),
    );
  }
}

class _SourceArea extends StatefulWidget {
  const _SourceArea({this.data});
  final SeedDetail? data;

  @override
  State<_SourceArea> createState() => _SourceAreaState();
}

class _SourceAreaState extends State<_SourceArea> {
  bool get showSecret => widget.data?.secret?.isNotEmpty == true;
  String get secret => widget.data?.secret ?? '';
  int get coins => widget.data?.coins ?? 0;
  String get link => widget.data?.link ?? '';

  late ValueNotifier<String> linkNotifier = ValueNotifier(link);
  late final _domain = context.read<SeedDomain>();
  late final _userNotifier = context.read<UserNotifier>();

  Future<void> _buyBit() async {
    MyToast.showLoading(text: 'dhz'.tr(context: context));
    final result = await _domain.buySeed(id: widget.data?.id ?? 0);
    MyToast.closeAllLoading();

    if (result.status != 0) {
      linkNotifier.value = result.data;
      _userNotifier.setMoney(money: _userNotifier.member.money - coins);
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: linkNotifier,
      builder: (context, currentLink, child) {
        if (currentLink.isEmpty) {
          switch (widget.data?.type ?? 0) {
            case 1:
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  const VipCenterRoute().push(context);
                },
                child: Text('ktvpczz'.tr(context: context),
                    style: MyTheme.blue80_14_M),
              );
            case 2:
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _buyBit,
                child: Text("$coins${'jbjsbtzz'.tr(context: context)}",
                    style: MyTheme.blue80_14_M),
              );
          }
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!showSecret) return;
                CommonUtils.copyToClipboard(text: secret);
                MyToast.showText(text: 'fzcg'.tr(context: context));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'jymm'.tr(context: context),
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14.sp)),
                    TextSpan(
                        text: showSecret ? secret : 'ptjc'.tr(context: context),
                        style: TextStyle(
                            color: MyTheme.cyanColor00edfd, fontSize: 14.sp)),
                    if (showSecret)
                      TextSpan(
                          text: " [${'dwfz'.tr(context: context)}]",
                          style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.w),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                CommonUtils.copyToClipboard(text: currentLink);
                MyToast.showText(text: 'fzcg'.tr(context: context));
              },
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: 'xzlj'.tr(context: context),
                        style:
                            TextStyle(color: Colors.white70, fontSize: 14.sp)),
                    TextSpan(
                        text: currentLink.replaceAll(',', '\n'),
                        style: TextStyle(
                            color: MyTheme.cyanColor00edfd, fontSize: 14.sp)),
                    TextSpan(
                        text: " [${'dwfz'.tr(context: context)}]",
                        style: TextStyle(color: Colors.red, fontSize: 14.sp)),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _LikeCollectShareArea extends StatefulWidget {
  const _LikeCollectShareArea({required this.data});
  final SeedDetail data;

  @override
  State<_LikeCollectShareArea> createState() => _LikeCollectShareAreaState();
}

class _LikeCollectShareAreaState extends State<_LikeCollectShareArea> {
  late final _domain = context.read<SeedDomain>();
  bool _isChangeLikeLoading = false;
  bool _isChangeCollectLoading = false;

  Future<void> _changeLike() async {
    if (_isChangeLikeLoading) return;
    _isChangeLikeLoading = true;

    try {
      final result = await _domain.seedTopicLike(
          id: '${widget.data.id}', type: MyLikeType.post);
      if (result.status == 1) {
        final oldValue = widget.data.isLike ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;
        widget.data.isLike = newValue;
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}

    _isChangeLikeLoading = false;
  }

  Future<void> _changeCollect() async {
    if (_isChangeCollectLoading) return;
    _isChangeCollectLoading = true;

    try {
      final result = await _domain.seedTopicFavorite(id: '${widget.data.id}');
      if (result.status == 1) {
        final oldValue = widget.data.isFavorite ?? 0;
        final newValue = oldValue == 0 ? 1 : 0;

        widget.data.isFavorite = newValue;
        if (mounted) {
          setState(() {});
        }
      } else {
        MyToast.showText(text: result.msg ?? '');
      }
    } catch (_) {}

    _isChangeCollectLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: MyTheme.pagePadding, vertical: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PostLikeButton(isLiked: widget.data.isLike == 1, onTap: _changeLike),
          SizedBox(width: 20.w),
          PostCollectButton(
              isCollected: widget.data.isFavorite == 1, onTap: _changeCollect),
          SizedBox(width: 20.w),
          PostShareButton(onTap: () {
            const MineShareToUserRoute().push(context);
          }),
        ],
      ),
    );
  }
}
