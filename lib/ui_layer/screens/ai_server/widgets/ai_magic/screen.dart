import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../domain/model/ai/ai_magic_model.dart';
import '../../../../../domain/model/banner_model.dart';
import '../../../../../domain/remote_domain/domains/aimagic.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/general_banner.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import 'card/magic_card.dart';

class AIMagic extends StatefulWidget {
  const AIMagic({
    super.key,
  });

  @override
  State<AIMagic> createState() => _AIMagicState();
}

class _AIMagicState extends State<AIMagic> {
  late final _appDomain = context.read<AIMagicDomain>();
  final ValueNotifier<List<BannerModel>> _bannersNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _getData(page: 1, pageSize: 20);
  }

  Future<List<AIMagicModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _appDomain.aiMagicList(page: page, limit: pageSize);
    print(result);

    if (mounted) {
      setState(() {});
    }

    if (result.status == 1) {
      if (result.data?.banner case final data?
          when data.isNotEmpty && _bannersNotifier.value.isEmpty) {
        _bannersNotifier.value = data;
      }

      return result.data!.material;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyListView.grid(
        header: _Header(bannersNotifier: _bannersNotifier),
        padding: EdgeInsets.symmetric(
            horizontal: MyTheme.pagePadding, vertical: 8.w),
        childAspectRatio: MagicCard.aspectRatio,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        itemBuilder: (context, item, index) => MagicCard(data: item),
        onFetchingMore: (currentPage, pageSize) =>
            _getData(page: currentPage, pageSize: pageSize),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.bannersNotifier});
  final ValueNotifier<List<BannerModel>> bannersNotifier;

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
              child: GeneralBannerAppsListWidget(data: banners),
            );
          },
        ),
      ],
    );
  }
}
