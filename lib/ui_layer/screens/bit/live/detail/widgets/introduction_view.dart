import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/enum.dart';
import '../../../../../../domain/model/live/live_video_detail_data.dart';
import '../../../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../../../domain/remote_domain/domains/live.dart';
import '../../../../../router/routes.dart';
import '../../../../../utils/common_utils.dart';
import '../../../../../utils/my_toast.dart';
import '../../../../common_widgets/general_banner.dart';
import '../../../../common_widgets/my_image.dart';
import '../../../../common_widgets/my_list_view.dart';
import '../../../../image_paths.dart';
import '../../../../theme.dart';
import '../../widgets/live_video_card.dart';

class LiveVideoDetailIntroductionView extends StatefulWidget {
  const LiveVideoDetailIntroductionView(
      {super.key, required this.id, required this.data});
  final String id;
  final LiveVideoDetailData data;
  @override
  State<LiveVideoDetailIntroductionView> createState() =>
      _LiveVideoDetailIntroductionViewState();
}

class _LiveVideoDetailIntroductionViewState
    extends State<LiveVideoDetailIntroductionView> {
  late final liveDomain = context.read<LiveDomain>();

  Future<List<LiveModel>?> _getData(
      {required int page, required int pageSize}) async {
    final res = await liveDomain.getLiveRecommend(
        id: int.parse(widget.id), page: page, limit: 20 //推荐直播视频只显示20个
        );
    if (res.data case final data?) {
      return data;
    } else {
      if (res.msg case final msg?) {
        MyToast.showText(text: msg);
      }
    }
    if (mounted) {
      setState(() {});
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data;
    return MyListView.grid(
      childAspectRatio: LiveVideoCard.aspectRatio,
      crossAxisSpacing: 8.w,
      header: _HeaderView(data: videoInfo),
      isNeedMore: false,
      padding: EdgeInsets.symmetric(
          horizontal: MyTheme.pagePadding, vertical: MyTheme.pagePadding),
      itemBuilder: (context, item, index) => LiveVideoCard(data: item),
      onFetchingMore: (currentPage, pageSize) =>
          _getData(page: currentPage, pageSize: pageSize),
    );
  }
}

class _HeaderView extends StatefulWidget {
  const _HeaderView({required this.data});
  final LiveVideoDetailData data;

  @override
  State<_HeaderView> createState() => _HeaderViewState();
}

class _HeaderViewState extends State<_HeaderView> {
  @override
  Widget build(BuildContext context) {
    final videoInfo = widget.data.live;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(height: 5.w),
          Text(
            videoInfo.username ?? '',
            style: MyTheme.white255_16_M,
            maxLines: 2,
          ),
          Offstage(
              offstage: videoInfo.intro?.isEmpty ?? false,
              child: Padding(
                  padding: EdgeInsets.only(top: 15.w, bottom: 0),
                  child: Text(videoInfo.intro ?? '',
                      style: MyTheme.white06_14_M))),
          SizedBox(height: 22.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyImage.asset(
                    MyImagePaths.app2024ComBofangliangBig1,
                    width: 16.w,
                    height: 16.w,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    CommonUtils.renderNumber(videoInfo.viewFct ?? 0),
                    style: MyTheme.whiteOpacity612w500,
                  ),
                  Text(
                    'cbf'.tr(context: context),
                    style: MyTheme.whiteOpacity612w500,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatefulBuilder(builder: (_, setState) {
                    final isFavorite = videoInfo.isFavorite == 1;
                    return GestureDetector(
                      onTap: () async {
                        if (videoInfo.id case final id?) {
                          final domain = context.read<UserDomain>();
                          final res = await domain.toggleUserFavorite(
                              type: ModuleType.live, id: id);
                          if (res.data?.isFavorite case final isFavorite?) {
                            videoInfo.isFavorite = isFavorite;
                            videoInfo.favoriteFct += isFavorite == 1 ? 1 : -1;
                            setState(() {});
                          } else if (res.msg case final msg?) {
                            MyToast.showText(text: msg);
                          }
                        }
                      },
                      child: _btnItem(
                          icon: isFavorite
                              ? MyImagePaths.appLiveColloctionS
                              : MyImagePaths.appLiveColloctionN,
                          name: tr('sc')
                          // name: CommonUtils.renderFixedNumber(
                          //     videoInfo.favoriteFct ?? 0),
                          ),
                    );
                  }),
                  SizedBox(width: 20.w),
                  GestureDetector(
                    onTap: () {
                      const MineShareToUserRoute().push(context);
                    },
                    child: _btnItem(
                      icon: MyImagePaths.appLiveShare,
                      name: 'fx'.tr(context: context),
                    ),
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: Container(
              height: 1.w,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
          if (widget.data.banners case final banners? when banners.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 15.w),
              child: GeneralAppsListVidget(
                data: banners,
                aspectRatio: 10 / 3,
              ),
            ),
          Text('jctj'.tr(context: context), style: MyTheme.white16medium),
        ],
      ),
    );
  }

  Widget _btnItem({required String icon, required String name, Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyImage.asset(
          icon,
          width: 25.w,
          height: 25.w,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(width: 4.w),
        Text(
          name,
          style: MyTheme.white08_14_M,
        )
      ],
    );
  }
}
