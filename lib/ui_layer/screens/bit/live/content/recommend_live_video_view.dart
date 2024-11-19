import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../../domain/model/tip_model.dart';
import '../../../../../domain/remote_domain/domains/live.dart';

import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../widgets/live_video_card.dart';
import '../widgets/live_video_view_header.dart';

class RecommendLiveVideoView extends StatefulWidget {
  const RecommendLiveVideoView({super.key, required this.onMoreButtonClick});
  final ValueChanged<String> onMoreButtonClick;

  @override
  State<RecommendLiveVideoView> createState() => _RecommendLiveVideoViewState();
}

class _RecommendLiveVideoViewState extends State<RecommendLiveVideoView> {
  late final _domain = context.read<LiveDomain>();
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _tipsNotifier = ValueNotifier<List<TipModel>>([]);

  Future<List<LiveThemesModel>?> _getData(int page, int pageSize) async {
    final result = await _domain.getLiveRecListComment(
      page: page,
      limit: pageSize,
    );

    if (result.status == 1) {
      if (result.data?.banners case final data?
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }
      if (result.data?.tips case final data?
          when data.isNotEmpty && _tipsNotifier.value.isEmpty) {
        _tipsNotifier.value = data;
      }

      return result.data?.themes;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.list(
      header: LiveVideoViewHeader(
        bannersNotifier: _bannersNotifier,
        tipsNotifier: _tipsNotifier,
      ),
      contentPadding: 5.w,
      padding: EdgeInsets.all(MyTheme.pagePadding),
      itemBuilder: (_, item, __) => _Card(
        model: item,
        onMoreButtonClick: () => widget.onMoreButtonClick(item.name ?? ''),
      ),
      onFetchingMore: _getData,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.model,
    required this.onMoreButtonClick,
  });

  final LiveThemesModel model;
  final VoidCallback onMoreButtonClick;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              model.name ?? '',
              style: MyTheme.white15semibold,
              maxLines: 1,
            ),
          ),
          InkWell(
            onTap: onMoreButtonClick,
            child: Container(
              alignment: Alignment.centerRight,
              width: 60.w,
              height: 22.w,
              child: Text(
                'gd'.tr(),
                style: MyTheme.white08_12,
                textAlign: TextAlign.right,
              ),
            ),
          )
        ],
      ),
      GridView.builder(
        padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 每行的网格数
          crossAxisSpacing: 8.w, // 网格之间的水平间距
          mainAxisSpacing: 8.w, // 网格之间的垂直间距
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: model.lives?.length, // 网格项目的数量
        itemBuilder: (_, index) => LiveVideoCard(data: model.lives![index]),
      ),
    ]);
  }
}
