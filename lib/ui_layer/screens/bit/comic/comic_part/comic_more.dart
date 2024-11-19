import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/comic/comic_item_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/comic_item_card.dart';

class ComicMoreScreen extends StatefulWidget {
  const ComicMoreScreen({super.key, required this.title, required this.sort});

  final String title;
  final String sort;

  @override
  State<ComicMoreScreen> createState() => _ComicMoreScreenState();
}

class _ComicMoreScreenState extends State<ComicMoreScreen> {
  late final _domain = context.read<ComicDomain>();

  Future<List<ComicItemModel>?> _getData(
      {required String sort, required int page, required int pageSize}) async {
    final result = await _domain.comicMoreChangeList(
        sort: sort, page: page, limit: pageSize);

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
        appBar: MyAppBar(title: widget.title),
        body: MyListView.grid(
          childAspectRatio: ComicItemCard.aspectRatio,
          crossAxisCount: 3,
          padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
          itemBuilder: (context, item, index) => ComicItemCard(data: item),
          onFetchingMore: (currentPage, pageSize) => _getData(
              sort: widget.sort, page: currentPage, pageSize: pageSize),
        ));
  }
}
