import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/novel_item_card.dart';

///完结界面
class NovelEndScreen extends StatefulWidget {
  const NovelEndScreen({super.key});

  @override
  State<NovelEndScreen> createState() => _NovelEndScreenState();
}

class _NovelEndScreenState extends State<NovelEndScreen> {
  late final _domain = context.read<NovelDomain>();

  Future<List<NovelItemModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.novelEndList(page: page, limit: pageSize);

    if (result.status == 1) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: 'wj'.tr(context: context)),
        body: MyListView.grid(
          childAspectRatio: NovelItemCard.aspectRatio,
          crossAxisCount: 3,
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          itemBuilder: (context, item, index) => NovelItemCard(data: item),
          onFetchingMore: (currentPage, pageSize) =>
              _getData(page: currentPage, pageSize: pageSize),
        ));
  }
}
