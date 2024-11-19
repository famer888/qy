import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/comic/comic_item_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/comic_item_card.dart';

///分类界面
class ComicSortScreen extends StatefulWidget {
  const ComicSortScreen({super.key});

  @override
  State<ComicSortScreen> createState() => _ComicSortScreenState();
}

class _ComicSortScreenState extends State<ComicSortScreen> {
  late final _domain = context.read<ComicDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final navs = _homeConfig.config.comicTypeNav;

  late final List<int> navTypeIndexList =
      List<int>.generate(navs.length, (_) => 0);

  Future<List<ComicItemModel>?> _getData(
      {required int page, required int pageSize}) async {
    final params = <String, String>{};

    for (int i = 0; i < navs.length; i++) {
      final nav = navs[i];
      final key = nav.value;
      final typeIndex = navTypeIndexList[i];
      final type = nav.items[typeIndex].value;
      params[key] = type;
    }

    final result = await _domain.comicTypeList(
        page: page, limit: pageSize, sortParams: params);

    if (result.status == 1) {
      return result.data;
    } else {
      MyToast.showText(text: result.msg ?? '');
    }
    return null;
  }

  final expendedNavIndex = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'fl'.tr(context: context)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MyTheme.pagePadding, vertical: 5.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = 0; i < navs.length; i++) buildNavItem(i),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: MyListView.grid(
                    key: UniqueKey(),
                    childAspectRatio: ComicItemCard.aspectRatio,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(MyTheme.pagePadding),
                    itemBuilder: (context, item, index) =>
                        ComicItemCard(data: item),
                    onFetchingMore: (currentPage, pageSize) =>
                        _getData(page: currentPage, pageSize: pageSize),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: ValueListenableBuilder(
                    valueListenable: expendedNavIndex,
                    builder: (_, value, __) {
                      return ColoredBox(
                        color: MyTheme.bgColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MyTheme.pagePadding,
                          ),
                          child: AnimatedSize(
                            duration: const Duration(milliseconds: 250),
                            alignment: Alignment.topCenter,
                            curve: Curves.ease,
                            child: value == null
                                ? const SizedBox.shrink()
                                : GridView.builder(
                                    padding: EdgeInsets.only(
                                        top: 10.w, bottom: 10.w),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 8.w,
                                      mainAxisSpacing: 8.w,
                                      childAspectRatio: 80 / 35,
                                    ),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount:
                                        navs[value].items.length, // 网格项目的数量
                                    itemBuilder: (_, index) {
                                      final type = navs[value].items[index];
                                      final isSelected =
                                          navTypeIndexList[value] == index;

                                      return GestureDetector(
                                        onTap: isSelected
                                            ? null
                                            : () {
                                                setState(() {
                                                  navTypeIndexList[value] =
                                                      index;
                                                  expendedNavIndex.value = null;
                                                });
                                              },
                                        child: Container(
                                          color: Colors.white.withOpacity(0.08),
                                          child: Center(
                                            child: Text(
                                              type.title,
                                              style: isSelected
                                                  ? MyTheme.jellyCyan_14
                                                  : MyTheme.white14,
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildNavItem(int index) {
    final nav = navs[index];
    final type = nav.items[navTypeIndexList[index]];

    return GestureDetector(
      onTap: () {
        expendedNavIndex.value = expendedNavIndex.value == index ? null : index;
      },
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Row(
          children: [
            Text(
              nav.title,
              style: MyTheme.white14,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                '-',
                style: MyTheme.white14,
              ),
            ),
            Text(
              type.title,
              style: MyTheme.jellyCyan_14,
            ),
            ValueListenableBuilder(
                valueListenable: expendedNavIndex,
                builder: (_, value, __) {
                  return Icon(
                    value == index
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: Colors.white,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
