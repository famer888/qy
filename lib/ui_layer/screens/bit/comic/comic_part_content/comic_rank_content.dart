import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/comic/comic_item_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/comic_item_card.dart';

///排行榜界面
class ComicRankContent extends StatefulWidget {
  const ComicRankContent({super.key});

  @override
  State<ComicRankContent> createState() => _ComicRankContentState();
}

class _ComicRankContentState extends State<ComicRankContent> {
  late final _domain = context.read<ComicDomain>();

  Future<List<ComicItemsModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.comicRankList(page: page, limit: pageSize);

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
        appBar: MyAppBar(title: 'phb'.tr(context: context)),
        body: MyListView.grid(
          childAspectRatio: ComicItemCard.aspectRatio,
          crossAxisCount: 3,
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          itemBuilder: (context, item, index) => ComicItemCard(data: item),
          onFetchingMore: (currentPage, pageSize) =>
              _getData(page: currentPage, pageSize: pageSize),
        ));
  }
}
