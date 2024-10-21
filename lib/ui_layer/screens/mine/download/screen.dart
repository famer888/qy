import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../domain/model/video_detail_model.dart';
import '../../../router/routes.dart';
import '../../../utils/download_utils.dart';
import '../../common_widgets/keep_alive_wrapper.dart';
import '../../common_widgets/my_app_bar.dart';
import '../../common_widgets/my_image.dart';
import '../../common_widgets/my_tab_bar.dart';
import '../../common_widgets/screen_background.dart';
import '../../common_widgets/status/empty_data.dart';
import '../../theme.dart';

class MineDownloadScreen extends StatefulWidget {
  const MineDownloadScreen({super.key});

  @override
  State<MineDownloadScreen> createState() => _MineDownloadScreenState();
}

class _MineDownloadScreenState extends State<MineDownloadScreen> {
  late final downloadUtil = context.read<DownloadUtil>();
  late final videoDownloadCache = downloadUtil.cache;

  final isAllNotifier = ValueNotifier(false);
  final isEditNotifier = ValueNotifier(false);

  List<Map> _videoTasks = [];

  @override
  void initState() {
    getVideoDownloadInfo();
    super.initState();
  }

  // 获取视频下载信息
  Future getVideoDownloadInfo() async {
    _videoTasks =
        List<Map>.from(await videoDownloadCache.readDownloadVideoTasks());
    for (var element in _videoTasks) {
      element.choosed = false;
    }
    setState(() {});
  }

  void onTapAll() {
    isAllNotifier.value = !isAllNotifier.value;
    if (isAllNotifier.value) {
      for (var element in _videoTasks) {
        element.choosed = true;
      }
    } else {
      for (var element in _videoTasks) {
        element.choosed = false;
      }
    }
    setState(() {});
  }

  void onTapDelete() async {
    for (var element in _videoTasks) {
      if (element.choosed) {
        downloadUtil.removeTask(element['id']);
        String path = element['url'];
        String dir = path.substring(0, path.lastIndexOf('/'));
        Directory directory = Directory(dir);
        bool isExists = await directory.exists();
        if (isExists) {
          directory.deleteSync(recursive: true);
        }
      }
    }
    _videoTasks.removeWhere((element) => element.choosed);
    videoDownloadCache.upsertDownloadVideoTasks(tasks: _videoTasks);
    setState(() {});
  }

  Widget _buildBottom() {
    return ValueListenableBuilder(
        valueListenable: isEditNotifier,
        builder: (_, isEdit, __) {
          if (!isEdit) {
            return const SizedBox.shrink();
          }
          return Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(25, 25, 25, 1),
              boxShadow: [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    spreadRadius: 0)
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                      child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onTapAll,
                    child: Container(
                        padding: EdgeInsets.only(left: 15.w),
                        alignment: Alignment.centerLeft,
                        child: ValueListenableBuilder(
                          valueListenable: isAllNotifier,
                          builder: (_, isAll, __) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  isAll
                                      ? Icons.check_circle_outline
                                      : Icons.circle_outlined,
                                  color: isAll
                                      ? MyTheme.jellyCyanColor103224185
                                      : MyTheme.grayColor180,
                                  size: 20.w,
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: 10.w,
                                  ),
                                  child: Text(
                                    tr('qxu'),
                                    // isAll ? tr('qbx') : tr('qxu'),
                                    style: isAll
                                        ? MyTheme.blue80_15
                                        : MyTheme.gray180_15,
                                  ),
                                )
                              ],
                            );
                          },
                        )),
                  )),
                  GestureDetector(
                    onTap: onTapDelete,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.w,
                        horizontal: 40.w,
                      ),
                      decoration: const BoxDecoration(
                        gradient: MyTheme.gradient_90_114,
                      ),
                      child: Center(
                        child: Text(
                          tr('sch'),
                          style: MyTheme.white15bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBackground(
      child: Scaffold(
        appBar: MyAppBar(
          title: 'wdxz'.tr(context: context),
          rightWidget: GestureDetector(
            onTap: () {
              isEditNotifier.value = !isEditNotifier.value;
            },
            child: Text(
              tr('bj'),
              style: MyTheme.gray150_14,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarWithView.line(
                tabBarPadding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: MyTheme.pagePadding,
                ),
                labelStyle: MyTheme.jellyCyan_15,
                unselectedLabelStyle: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 15.sp,
                  overflow: TextOverflow.visible,
                  decoration: TextDecoration.none,
                ),
                tabBarHeight: 40.w,
                isScrollable: true,
                titles: [
                  'shp'.tr(context: context),
                ],
                views: [
                  KeepAliveWrapper(
                    child: _VideoView(
                      videoTasks: _videoTasks,
                      isEditNotifier: isEditNotifier,
                    ),
                  ),
                ],
              ),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.videoTasks, required this.isEditNotifier});
  final List<Map> videoTasks;
  final ValueNotifier<bool> isEditNotifier;
  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  @override
  Widget build(BuildContext context) {
    final data = widget.videoTasks;
    if (data.isEmpty) {
      return PageEmptyDataView(
        text: 'spxzk'.tr(),
      );
    }

    return GridView.builder(
        cacheExtent: 5.sh,
        padding: EdgeInsets.symmetric(
          horizontal: MyTheme.pagePadding,
          vertical: 20.w,
        ),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7.w,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              _VideoCard(
                width: (1.sw - MyTheme.pagePadding * 2 - 7.w) / 2,
                data: data[index],
              ),
              Positioned.fill(
                child: ValueListenableBuilder(
                    valueListenable: widget.isEditNotifier,
                    builder: (_, isEdit, __) {
                      return isEdit
                          ? GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                data[index].choosed = !data[index].choosed;
                                setState(() {});
                              },
                              child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(
                                  top: 6.w,
                                  left: 6.w,
                                ),
                                child: data[index].choosed == true
                                    ? Icon(Icons.check_circle,
                                        color: MyTheme.jellyCyanColor103224185,
                                        size: 17.w)
                                    : Icon(Icons.circle_outlined,
                                        color: const Color.fromRGBO(
                                            153, 153, 153, 1),
                                        size: 17.w),
                              ),
                            )
                          : const SizedBox.shrink();
                    }),
              ),
            ],
          );
        });
  }
}

class _VideoCard extends StatefulWidget {
  const _VideoCard({required this.data, required this.width});
  final Map data;
  final double width;

  @override
  State<_VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<_VideoCard> {
  late final downloadUtil = context.read<DownloadUtil>();
  final ValueNotifier<Map> progressNotifier = ValueNotifier({});
  bool isWaiting = false;

  @override
  void initState() {
    final data = widget.data;
    if (data['progress'] != null) {
      progressNotifier.value = {
        'progress': data['progress'] + .0,
        'downloading': data['downloading'],
      };
      isWaiting = data['isWaiting'];
    }
    downloadUtil.downloadVideoProgress.addListener(_listener);
    super.initState();
  }

  void _listener() {
    isWaiting = false;
    final data =
        downloadUtil.downloadVideoProgress.value['${widget.data['id']}'];
    if (data != null) {
      progressNotifier.value = data;
    }
  }

  @override
  void dispose() {
    downloadUtil.downloadVideoProgress.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final thumbWidth = widget.width;
    final thumbHeight = thumbWidth / 7 * 4;
    final thumbUrl = data['thumbCover'];
    final marginBottom = 6.5.w;
    return GestureDetector(
      onTap: () {
        final value = progressNotifier.value;
        final progress = value.progress;
        if (progress.toInt() == 1) {
          final videoData = VideoData(
              source240: widget.data['url'],
              title: widget.data['title'],
              coverThumbHorizontal: widget.data['cover_horizontal'],
              coverThumbVerticle: widget.data['cover_vertical']);
          LocalVideoRoute(videoData).push(context);
        } else if (value.downloading == false && !isWaiting) {
          downloadUtil.createDownloadTask(taskInfo: widget.data);
        }
      },
      child: SizedBox(
        width: thumbWidth,
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: thumbWidth,
                  height: thumbHeight,
                  margin: EdgeInsets.only(bottom: marginBottom),
                  child: MyImage.network(
                    thumbUrl,
                    backgroundColor: Colors.grey,
                    fit: BoxFit.cover,
                    borderRadius: 5.w,
                  ),
                ),
                ValueListenableBuilder(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      final progress = value.progress;
                      final downloadError = value.downloadError ?? false;
                      final downloading = value.downloading ?? true;
                      String getDownloadText() {
                        String text = downloadError
                            ? tr('xsbcs')
                            : isWaiting
                                ? tr('ddxz')
                                : progress == 0
                                    ? tr('djxz')
                                    : downloading
                                        ? tr('xzjd')
                                        : tr('ztxz');
                        return text;
                      }

                      return progress.toInt() != 1
                          ? Positioned(
                              top: 0,
                              right: 0,
                              bottom: marginBottom,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 0, 0, 0.5),
                                  borderRadius: marginBottom != 0
                                      ? BorderRadius.all(Radius.circular(5.w))
                                      : BorderRadius.vertical(
                                          bottom: Radius.zero,
                                          top: Radius.circular(5.w),
                                        ),
                                ),
                                child: Center(
                                  child: Text(
                                    getDownloadText(),
                                    style: TextStyle(
                                      color: progress == -1
                                          ? MyTheme.jellyCyanColor103224185
                                          : Colors.white,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ))
                          : const SizedBox.shrink();
                    }),
                ValueListenableBuilder(
                    valueListenable: progressNotifier,
                    builder: (_, value, __) {
                      final progress = value.progress;

                      return progress.toInt() != 1
                          ? Positioned(
                              top: 0,
                              right: 0,
                              bottom: marginBottom,
                              left: 0,
                              child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: marginBottom != 0
                                        ? BorderRadius.all(Radius.circular(5.w))
                                        : BorderRadius.vertical(
                                            bottom: Radius.zero,
                                            top: Radius.circular(5.w),
                                          ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: 2.w,
                                        width: thumbWidth * progress,
                                        decoration: BoxDecoration(
                                          color:
                                              MyTheme.jellyCyanColor103224185,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(1.w),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            )
                          : Container();
                    }),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.w),
              child: SizedBox(
                  child: Text(
                widget.data['title'],
                maxLines: 2,
                style: MyTheme.white255_15_M,
              )),
            )
          ],
        ),
      ),
    );
  }
}

extension _MapHelper on Map {
  dynamic get progress => this['progress'];
  dynamic get downloadError => this['downloadError'];
  dynamic get downloading => this['downloading'];
  bool get choosed => this['choosed'];
  set choosed(value) => this['choosed'] = value;
}
