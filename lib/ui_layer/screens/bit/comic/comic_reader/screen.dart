import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../domain/async_value.dart';
import '../../../../../domain/model/comic/comic_model.dart';
import '../../../../../domain/remote_domain/domains/comic.dart';
import '../../../common_widgets/my_image.dart';
import '../../../common_widgets/status/loading.dart';
import '../../../common_widgets/status/network_error.dart';
import '../../../image_paths.dart';
import '../../../theme.dart';
import '../widgets/di/notifier.dart';

///漫画阅读界面
class ComicReaderScreen extends StatefulWidget {
  const ComicReaderScreen({
    super.key,
  });

  @override
  State<ComicReaderScreen> createState() => _ComicReaderScreenState();
}

class _ComicReaderScreenState extends State<ComicReaderScreen>
    with TickerProviderStateMixin {
  late final comicChangeNotifier = context.read<ComicChangeNotifier>();
  late final comicData = comicChangeNotifier.currentComic;
  late final animationController = AnimationController(
    duration: const Duration(milliseconds: 150),
    value: 1.0,
    vsync: this,
  );

  bool _appBarVisible = true;

  final _progress = ValueNotifier<(int, int)>((0, 0));

  @override
  void dispose() {
    PaintingBinding.instance.imageCache.clear();
    super.dispose();
  }

  void onTogglePanelVisibility() {
    _appBarVisible = !_appBarVisible;
    _appBarVisible
        ? animationController.forward()
        : animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final index =
        comicChangeNotifier.currentChapterIndex['${comicData.id}'] ?? 0;
    final chapter = comicData.chapters![index];
    final title = chapter.title ?? '';
    final id = chapter.id ?? 0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _AppBar(
        animationController: animationController,
        child: Row(
          children: [
            Text(
              title,
              style: MyTheme.white18mudium,
            ),
            SizedBox(
              width: 5.w,
            ),
            ValueListenableBuilder(
                valueListenable: _progress,
                builder: (_, value, __) {
                  return Text(
                    '${value.$1}/${value.$2}',
                    style: MyTheme.white07_12,
                  );
                }),
          ],
        ),
      ),
      body: _ChapterReader(
        key: ValueKey(id),
        id: id,
        progress: _progress,
        onTogglePanelVisibility: onTogglePanelVisibility,
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({
    super.key,
    required this.animationController,
    required this.child,
  });
  final AnimationController animationController;
  final Widget child;
  @override
  Size get preferredSize => const Size.fromHeight(44);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.ease,
      )),
      child: ColoredBox(
        key: GlobalKey(),
        color: Colors.black.withOpacity(0.5),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.pagePadding),
            height: MyTheme.navbarHegiht,
            child: Row(
              children: [
                GestureDetector(
                  child: Image.asset(
                    MyImagePaths.appBackIcon,
                    width: 20.w,
                    height: 20.w,
                  ),
                  onTap: () {
                    context.pop();
                  },
                ),
                SizedBox(width: 10.w),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChapterReader extends StatefulWidget {
  const _ChapterReader({
    super.key,
    required this.id,
    required this.onTogglePanelVisibility,
    required this.progress,
  });
  final int id;
  final VoidCallback onTogglePanelVisibility;
  final ValueNotifier<(int, int)> progress;
  @override
  State<_ChapterReader> createState() => _ChapterReaderState();
}

class _ChapterReaderState extends State<_ChapterReader> {
  late final _domain = context.read<ComicDomain>();
  AsyncValue<List<ComicChapterModel>> _asyncValue = const AsyncInit();
  final scrollController = ScrollController();

  bool isScrolling = false;

  double maxH = 0;
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() async {
    if (_asyncValue.isLoading) return;

    setState(() {
      _asyncValue = const AsyncLoading();
    });

    final result = await _domain.comicChapterDetail(id: widget.id);

    if (result.data?.pics case final pics?) {
      double h = 0;

      for (final pic in pics) {
        h += 1.sw / ((pic.thumbW ?? 0) / (pic.thumbH ?? 0));
      }
      maxH = h - 1.sh;
      // final padding = MediaQuery.of(context).padding;
      // maxH = h + padding.top + padding.bottom - 1.sh;
      widget.progress.value = (1, pics.length);

      _asyncValue = AsyncData(pics);
    } else {
      _asyncValue = const AsyncError();
    }

    if (mounted) {
      setState(() {});
    }
  }

  Timer? scrollEndTimer;

  void tapPrev() {
    final nextOffset = scrollController.offset - 1.sh;
    scrollController.animateTo(
      max(nextOffset, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  void tapNext() {
    final nextOffset = scrollController.offset + 1.sh;
    scrollController.animateTo(
      min(nextOffset, maxH),
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _asyncValue.maybeWhen(
      orElse: () => const LoadingView(),
      error: (_, __) => NetworkErrorView(onTap: _getData),
      data: (pics) {
        return Stack(
          fit: StackFit.expand,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                switch (scrollInfo.runtimeType) {
                  case const (ScrollStartNotification):
                    isScrolling = true;
                    scrollEndTimer?.cancel();
                    break;
                  case const (ScrollUpdateNotification):
                    final progress = scrollController.offset / maxH;
                    final len = pics.length;
                    final currentPic =
                        ((progress * (len - 1)).round() + 1).clamp(1, len);
                    widget.progress.value = (currentPic, len);
                    break;
                  case const (ScrollEndNotification):
                    scrollEndTimer =
                        Timer(const Duration(milliseconds: 250), () {
                      isScrolling = false;
                    });
                }
                return true;
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                controller: scrollController,
                itemCount: pics.length,
                itemBuilder: (_, i) {
                  final pic = pics[i];
                  return AspectRatio(
                    aspectRatio: (pic.thumbW ?? 0) / (pic.thumbH ?? 0),
                    child: MyImage.network(pic.thumb ?? ''),
                  );
                },
              ),
            ),
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (!isScrolling) {
                        tapPrev();
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(onTap: () {
                    if (!isScrolling) {
                      widget.onTogglePanelVisibility();
                    }
                  }),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      if (!isScrolling) {
                        tapNext();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
