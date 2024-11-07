import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/banner_model.dart';
import '../../../../domain/model/tip_model.dart';
import '../../../../domain/model/monitor/monitor_with_banners_model.dart';
import '../../../../domain/remote_domain/domains/monitor.dart';
import '../../../utils/common_utils.dart';
import '../../../utils/my_toast.dart';
import '../../common_widgets/general_banner.dart';
import '../../common_widgets/marquee.dart';
import '../../common_widgets/my_list_view.dart';
import '../../theme.dart';
import 'widgets/monitor_video_card.dart';

class MonitorVideoView extends StatefulWidget {
  const MonitorVideoView({super.key, required this.id});
  final int id;
  @override
  State<MonitorVideoView> createState() => _MonitorVideoViewState();
}

class _MonitorVideoViewState extends State<MonitorVideoView> {
  late final _domain = context.read<MonitorDomain>();
  final _bannersNotifier = ValueNotifier<List<BannerModel>>([]);
  final _tipsNotifier = ValueNotifier<List<TipModel>>([]);

  Future<List<MonitorModel>?> _getData(int page, int pageSize) async {
    final result = await _domain.getMonitorIndex(
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

      return result.data?.monitors;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: MonitorVideoCard.aspectRatio,
      header: _Header(
        bannersNotifier: _bannersNotifier,
        tipsNotifier: _tipsNotifier,
      ),
      padding: EdgeInsets.all(MyTheme.pagePadding),
      itemBuilder: (_, item, __) => MonitorVideoCard(data: item),
      onFetchingMore: _getData,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.bannersNotifier,
    required this.tipsNotifier,
  });

  final ValueNotifier<List<BannerModel>> bannersNotifier;
  final ValueNotifier<List<TipModel>> tipsNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 6.w),
        ValueListenableBuilder(
          valueListenable: bannersNotifier,
          builder: (context, banners, child) {
            if (banners.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
              child: GeneralBanner(data: banners),
            );
          },
        ),
        SizedBox(height: 4.w),
        ValueListenableBuilder(
          valueListenable: tipsNotifier,
          builder: (_, tips, __) => MyMarqueeTipsWidget(tips: tips),
        ),
      ],
    );
  }
}
