import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/enum.dart';
import '../../../../../domain/model/ai/ai_record_model.dart';
import '../../../../../domain/remote_domain/domains/ai.dart';
import '../../../common_widgets/keep_alive_wrapper.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../common_widgets/my_tab_bar.dart';
import '../../../theme.dart';
import 'card/ai_record_card.dart';

class MineClothesRemoverRecordContent extends StatefulWidget {
  const MineClothesRemoverRecordContent({super.key});

  @override
  State<MineClothesRemoverRecordContent> createState() =>
      _MineClothesRemoverRecordContentState();
}

class _MineClothesRemoverRecordContentState
    extends State<MineClothesRemoverRecordContent> {
  late final aiDomain = context.read<AIDomain>();

  @override
  Widget build(BuildContext context) {
    return TabBarWithView.line(
      labelStyle: MyTheme.white15_M,
      unselectedLabelStyle: MyTheme.white07_15,
      tabBarHeight: 40.w,
      isCenter: true,
      titles: [
        'pdz'.tr(context: context),
        'clz'.tr(context: context),
        'sccg'.tr(context: context),
        'scsb'.tr(context: context),
      ],
      views: const [
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: AiStatus.pending),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: AiStatus.processing),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: AiStatus.successful),
        ),
        KeepAliveWrapper(
          child: _ContentStripOffRecordScreen(status: AiStatus.failure),
        ),
      ],
    );
  }
}

class _ContentStripOffRecordScreen extends StatefulWidget {
  const _ContentStripOffRecordScreen({super.key, required this.status});

  final AiStatus status;

  @override
  State<_ContentStripOffRecordScreen> createState() =>
      _ContentStripOffRecordScreenState();
}

class _ContentStripOffRecordScreenState
    extends State<_ContentStripOffRecordScreen> {
  late final aiDomain = context.read<AIDomain>();

  Future<List<AiRecordModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aIMyStrip(
      status: widget.status,
      page: page,
      limit: pageSize,
    );
    return result.data;
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      childAspectRatio: AIRecordCard.aspectRatio,
      itemBuilder: (_, item, __) => AIRecordCard(
        data: item,
        type: AIRecordType.StripOff,
        delSucess: () {
          context.pop();
          setState(
            () {},
          );
        },
      ),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
