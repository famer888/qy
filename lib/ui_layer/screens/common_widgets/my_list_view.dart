import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoSliverRefreshControl, RefreshIndicatorMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../theme.dart';
import 'status/empty_data.dart';
import 'status/loading.dart';
import 'status/network_error.dart';

typedef FetchMoreCallback<T> = Future<T> Function(
    int currentPage, int pageSize);

enum MyListViewType { list, grid }

class MyListView<T> extends StatefulWidget {
  const MyListView.grid({
    super.key,
    required this.itemBuilder,
    required this.onFetchingMore,
    this.header,
    this.headerBackgroundColor,
    this.childAspectRatio = 167 / 142,
    this.crossAxisSpacing = 8,
    this.mainAxisSpacing = 8,
    this.crossAxisCount = 2,
    this.contentPadding,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.pageSize = 15,
    this.scrollController,
    this.noMoreItemsIndicator,
  }) : type = MyListViewType.grid;

  const MyListView.list({
    super.key,
    required this.itemBuilder,
    required this.onFetchingMore,
    this.header,
    this.headerBackgroundColor,
    this.contentPadding,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.pageSize = 15,
    this.scrollController,
    this.noMoreItemsIndicator,
  })  : childAspectRatio = 167 / 142,
        crossAxisCount = 2,
        crossAxisSpacing = 8,
        mainAxisSpacing = 16,
        type = MyListViewType.list;

  final ItemWidgetBuilder<T> itemBuilder;
  final FetchMoreCallback<List<T>?> onFetchingMore;
  final MyListViewType type;
  final Widget? header;
  final Color? headerBackgroundColor;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int crossAxisCount;
  final double? contentPadding;
  final EdgeInsetsGeometry padding;
  final int pageSize;
  final ScrollController? scrollController;

  final Widget? noMoreItemsIndicator;

  @override
  MyListViewState<T> createState() => MyListViewState<T>();
}

class MyListViewState<T> extends State<MyListView<T>> {
  late final _pageSize = widget.pageSize;
  static const _firstPageKey = 1;
  late final MyPagingController<T> pagingController = MyPagingController(
    firstPageKey: _firstPageKey,
    pageSize: _pageSize,
    firstFetchCallBack: widget.onFetchingMore,
    invisibleItemsThreshold: 5,
  );

  @override
  void initState() {
    pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  ///代码刷新用
  Future<void> reloadPage() async {
    if (_isOnRefresh) {
      return;
    }
    _isOnRefresh = true;

    pagingController.value = const PagingState(
      nextPageKey: _firstPageKey,
      itemList: null,
      error: null,
    );
    _isOnRefresh = false;
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final items = (await widget.onFetchingMore(pageKey, _pageSize))!;
      if (!mounted) return;

      final isLastPage = items.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(items);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(items, nextPageKey);
      }
    } catch (error) {
      if (!mounted) return;
      pagingController.error = error;
    }
  }

  @override
  void dispose() {
    pagingController.removePageRequestListener(_fetchPage);
    pagingController.dispose();
    super.dispose();
  }

  bool _isOnRefresh = false;

  Future<void> _onRefresh() async {
    if (_isOnRefresh) return;

    _isOnRefresh = true;

    await pagingController.refresh();

    _isOnRefresh = false;
  }

  @override
  Widget build(BuildContext context) {
    final sliver = [
      MyIndicator(
        onRefresh: _onRefresh,
      ),
      if (widget.header != null)
        SliverToBoxAdapter(
          child: RepaintBoundary(
            child: widget.header,
          ),
        ),
      SliverPadding(
        padding: widget.padding,
        sliver: switch (widget.type) {
          MyListViewType.grid => PagedSliverGrid(
              showNewPageProgressIndicatorAsGridChild: false,
              showNewPageErrorIndicatorAsGridChild: false,
              showNoMoreItemsIndicatorAsGridChild: false,
              pagingController: pagingController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                crossAxisSpacing: widget.crossAxisSpacing.w,
                mainAxisSpacing: widget.mainAxisSpacing.w,
                childAspectRatio: widget.childAspectRatio,
              ),
              builderDelegate: PagedChildBuilderDelegate<T>(
                noItemsFoundIndicatorBuilder: (context) =>
                    const PageEmptyDataView(),
                noMoreItemsIndicatorBuilder: (context) =>
                    widget.noMoreItemsIndicator ??
                    DataStatusText(
                      text: 'wydx'.tr(context: context),
                    ),
                firstPageProgressIndicatorBuilder: (context) =>
                    const LoadingView(),
                firstPageErrorIndicatorBuilder: (context) =>
                    NetworkErrorView(onTap: _onRefresh),
                newPageErrorIndicatorBuilder: (context) => DataStatusText(
                  text: 'djjz'.tr(context: context),
                  onTap: pagingController.retryLastFailedRequest,
                ),
                newPageProgressIndicatorBuilder: (context) =>
                    const MoreLoading(),
                itemBuilder: widget.itemBuilder,
              ),
            ),
          MyListViewType.list => PagedSliverList<int, T>.separated(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate<T>(
                noMoreItemsIndicatorBuilder: (context) =>
                    widget.noMoreItemsIndicator ??
                    DataStatusText(
                      text: 'wydx'.tr(context: context),
                    ),
                noItemsFoundIndicatorBuilder: (context) =>
                    const PageEmptyDataView(),
                firstPageProgressIndicatorBuilder: (context) =>
                    const LoadingView(),
                firstPageErrorIndicatorBuilder: (context) =>
                    NetworkErrorView(onTap: _onRefresh),
                newPageErrorIndicatorBuilder: (context) => DataStatusText(
                  text: 'djjz'.tr(context: context),
                  onTap: pagingController.retryLastFailedRequest,
                ),
                newPageProgressIndicatorBuilder: (context) =>
                    const MoreLoading(),
                itemBuilder: widget.itemBuilder,
              ),
              separatorBuilder: (context, index) => SizedBox(
                height: widget.contentPadding,
              ),
            ),
        },
      )
    ];

    return CustomScrollView(
      controller: widget.scrollController,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: sliver,
    );
  }
}

class MyPagingController<ItemType> extends PagingController<int, ItemType> {
  MyPagingController({
    required this.firstFetchCallBack,
    required super.firstPageKey,
    required this.pageSize,
    super.invisibleItemsThreshold,
  });
  final FetchMoreCallback<List<ItemType>?> firstFetchCallBack;

  final int pageSize;
  @override
  Future<void> refresh() async {
    try {
      final items = await firstFetchCallBack(firstPageKey, pageSize);
      if (items != null) {
        value = PagingState(
          nextPageKey: items.isEmpty ? null : firstPageKey + 1,
          itemList: items,
          error: null,
        );
      } else {
        value = PagingState(
          nextPageKey: firstPageKey,
          itemList: null,
          error: null,
        );
      }
    } catch (e) {
      error = e;
    }
  }
}

class MyIndicator extends StatefulWidget {
  const MyIndicator({super.key, required this.onRefresh});
  final RefreshCallback onRefresh;
  @override
  State<MyIndicator> createState() => _MyIndicatorState();
}

class _MyIndicatorState extends State<MyIndicator> {
  Widget _buildIndicatorForRefreshState(
      RefreshIndicatorMode refreshState, double percentageComplete) {
    final scale = percentageComplete * 0.6;
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        return Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: CircularProgressIndicator(
            value: percentageComplete,
            color: MyTheme.jellyCyanColor103224185,
          ),
        );

      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
      case RefreshIndicatorMode.done:
        return Transform.scale(
          scale: scale,
          alignment: Alignment.topCenter,
          child: const CircularProgressIndicator(
            color: MyTheme.jellyCyanColor103224185,
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      refreshTriggerPullDistance: 80,
      refreshIndicatorExtent: 80,
      builder: (
        BuildContext context,
        RefreshIndicatorMode refreshState,
        double pulledExtent,
        double refreshTriggerPullDistance,
        double refreshIndicatorExtent,
      ) {
        final double percentageComplete =
            clampDouble(pulledExtent / refreshTriggerPullDistance, 0.0, 1.0);

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildIndicatorForRefreshState(
              refreshState,
              percentageComplete,
            ),
          ),
        );
      },
      onRefresh: widget.onRefresh,
    );
  }
}

class DataStatusText extends StatelessWidget {
  const DataStatusText({
    super.key,
    this.onTap,
    required this.text,
  });
  final VoidCallback? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 90),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: Text(text, style: MyTheme.gray173),
          ),
        ),
      ),
    );
  }
}

class MoreLoading extends StatelessWidget {
  const MoreLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 45, bottom: 45),
      child: Center(
        child: RepaintBoundary(
          child: CircularProgressIndicator(
            color: MyTheme.jellyCyanColor103224185,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}
