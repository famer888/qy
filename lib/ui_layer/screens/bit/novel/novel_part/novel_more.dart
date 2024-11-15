import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/novel_item_card.dart';

class NovelMoreScreen extends StatefulWidget {
  const NovelMoreScreen({super.key, required this.title, required this.sort});

  final String title;
  final String sort;

  @override
  State<NovelMoreScreen> createState() => _NovelMoreScreenState();
}

class _NovelMoreScreenState extends State<NovelMoreScreen> {
  late final _domain = context.read<NovelDomain>();

  Future<List<NovelItemModel>?> _getData(
      {required int page, required int pageSize}) async {
    final result = await _domain.novelMoreList(
        sort: widget.sort, page: page, limit: pageSize);

    if (result.status == 1) {
      setState(() {});
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(title: widget.title),
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
