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

class MineFaceSwapperRecordContent extends StatefulWidget {
  const MineFaceSwapperRecordContent({super.key});

  @override
  State<MineFaceSwapperRecordContent> createState() =>
      _MineFaceSwapperRecordContentState();
}

class _MineFaceSwapperRecordContentState
    extends State<MineFaceSwapperRecordContent> {
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
          child: _ContentFaceSwapRecordScreen(status: AiStatus.pending),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: AiStatus.processing),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: AiStatus.successful),
        ),
        KeepAliveWrapper(
          child: _ContentFaceSwapRecordScreen(status: AiStatus.failure),
        ),
      ],
    );
  }
}

class _ContentFaceSwapRecordScreen extends StatefulWidget {
  const _ContentFaceSwapRecordScreen({super.key, required this.status});

  final AiStatus status;

  @override
  State<_ContentFaceSwapRecordScreen> createState() =>
      _ContentFaceSwapRecordScreenState();
}

class _ContentFaceSwapRecordScreenState
    extends State<_ContentFaceSwapRecordScreen> {
  late final aiDomain = context.read<AIDomain>();

  Future<List<AiRecordModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await aiDomain.aIMyFace(
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
          type: AIRecordType.FaceSwap,
          delSucess: () {
            context.pop();
            setState(() {});
          }),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
