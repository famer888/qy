import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/model/novel/novel_item_model.dart';
import '../../../../../domain/remote_domain/domains/novel.dart';
import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_app_bar.dart';
import '../../../common_widgets/my_list_view.dart';
import '../../../theme.dart';
import '../card/novel_item_card.dart';

///分类界面
class NovelSortScreen extends StatefulWidget {
  const NovelSortScreen({super.key});

  @override
  State<NovelSortScreen> createState() => _NovelSortScreenState();
}

class _NovelSortScreenState extends State<NovelSortScreen> {
  late final _domain = context.read<NovelDomain>();
  late final _homeConfig = context.read<HomeConfigNotifier>();
  late final navs = _homeConfig.config.novelTypeNav;

  late final List<int> navTypeIndexList =
      List<int>.generate(navs.length, (_) => 0);

  Future<List<NovelItemModel>?> _getData(
      {required int page, required int pageSize}) async {
    final params = <String, String>{};

    for (int i = 0; i < navs.length; i++) {
      final nav = navs[i];
      final key = nav.value;
      final typeIndex = navTypeIndexList[i];
      final type = nav.items[typeIndex].value;
      params[key] = type;
    }

    final result = await _domain.novelTypeList(
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
                    childAspectRatio: NovelItemCard.aspectRatio,
                    crossAxisCount: 3,
                    padding: EdgeInsets.all(MyTheme.pagePadding),
                    itemBuilder: (context, item, index) =>
                        NovelItemCard(data: item),
                    onFetchingMore: (currentPage, pageSize) =>
                        _getData(page: currentPage, pageSize: pageSize),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: MyTheme.pagePadding,
                  left: MyTheme.pagePadding,
                  child: ValueListenableBuilder(
                    valueListenable: expendedNavIndex,
                    builder: (_, value, __) {
                      return ColoredBox(
                        color: MyTheme.bgColor,
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          alignment: Alignment.topCenter,
                          curve: Curves.ease,
                          child: value == null
                              ? const SizedBox.shrink()
                              : GridView.builder(
                                  padding:
                                      EdgeInsets.only(top: 10.w, bottom: 10.w),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 8.w,
                                    mainAxisSpacing: 8.w,
                                    childAspectRatio: 80 / 35,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
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
                                                navTypeIndexList[value] = index;
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
