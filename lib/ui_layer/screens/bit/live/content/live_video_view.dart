import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/model/live/live_with_banners_model.dart';
import '../../../../../domain/model/marquee_tips.dart';
import '../../../../../domain/remote_domain/domains/live.dart';

import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../widgets/live_video_card.dart';
import '../widgets/live_video_view_header.dart';

class LiveVideoView extends StatefulWidget {
  const LiveVideoView({super.key, required this.id});

  final int id;
  @override
  State<LiveVideoView> createState() => _LiveVideoViewState();
}

class _LiveVideoViewState extends State<LiveVideoView> {
  late final _domain = context.read<LiveDomain>();
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _tipsNotifier = ValueNotifier<List<MarqueeTipsModel>>([]);

  Future<List<LiveModel>?> _getData(int page, int pageSize) async {
    final result = await _domain.getLiveIndex(
      id: widget.id,
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

      return result.data?.lives;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: LiveVideoCard.aspectRatio,
      header: LiveVideoViewHeader(
        bannersNotifier: _bannersNotifier,
        tipsNotifier: _tipsNotifier,
      ),
      padding: EdgeInsets.all(MyTheme.pagePadding),
      itemBuilder: (_, item, __) => LiveVideoCard(data: item),
      onFetchingMore: _getData,
    );
  }
}
