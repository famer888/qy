import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/api_validator.dart';
import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/novel_item_card.dart';

class NovelFollowingContent extends StatefulWidget {
  const NovelFollowingContent({super.key});

  @override
  State<NovelFollowingContent> createState() => _NovelFollowingContentState();
}

class _NovelFollowingContentState extends State<NovelFollowingContent> {
  late final _domain = context.read<NovelDomain>();

  Future<List<NovelItemModel>?> _getData({
    required int page,
    required int pageSize,
  }) async {
    final result = await _domain.novelFavoriteList(page: page, limit: pageSize);
    if (result.isValid) {
      return result.data;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyListView.grid(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
      childAspectRatio: NovelItemCard.aspectRatio,
      crossAxisSpacing: 10.w,
      crossAxisCount: 3,
      itemBuilder: (_, item, index) => NovelItemCard(data: item),
      onFetchingMore: (currentPage, pageSize) => _getData(
        page: currentPage,
        pageSize: pageSize,
      ),
    );
  }
}
