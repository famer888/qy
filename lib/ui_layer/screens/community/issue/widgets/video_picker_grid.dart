import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cross_file/cross_file.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../notifiers/home_config_notifier.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/my_toast.dart';
import '../../../common_widgets/my_image.dart';
import '../../../image_paths.dart';

class VideoPickerGrid extends StatefulWidget {
  const VideoPickerGrid({super.key, required this.video, required this.upList});
  final List<Map> upList;
  final Map video;

  @override
  State<VideoPickerGrid> createState() => _VideoPickerGridState();
}

class _VideoPickerGridState extends State<VideoPickerGrid> {
  late final homeConfigNotifier = context.read<HomeConfigNotifier>();
  VideoPlayerController? _controller;

  Future<void> _videoPickerAssets() async {
    if (await CommonUtils.pickVideo() case final xFile?) {
      final ext = xFile.name.split('.').last.toLowerCase();
      if (ext == 'mp4' || xFile.mimeType == 'video/quicktime') {
        await uploadVideo(xFile);
      } else {
        MyToast.showText(text: 'qxzmpf'.tr());
      }
    }
  }

  Future<void> uploadVideo(XFile file) async {
    BotToast.showCustomLoading(
      toastBuilder: (cancel) => XFileProgressToast(
        file: file,
        response: (data) async {
          BotToast.closeAllLoading();
          if (data?['code'] == 1) {
            final url = "${data?['msg']}";
            if (kIsWeb) {
              _controller = VideoPlayerController.network(file.path);
            } else {
              _controller = VideoPlayerController.file(File(file.path));
            }
            await _controller?.initialize();
            widget.video.clear();

            setState(() {
              widget.video.addAll({
                'media_url': url,
                'type': 1,
                'thumb_width': _controller?.value.size.width.round(),
                'thumb_height': _controller?.value.size.height.round(),
              });
            });
          } else {
            MyToast.showText(text: data?['msg'] ?? 'failed');
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 10.w,
      crossAxisSpacing: 10.w,
      children: [
        widget.video.isNotEmpty
            ? Stack(
                children: [
                  Center(
                      child: AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )),
                  Center(
                    child: MyImage.asset(
                      MyImagePaths.appVPlayN,
                      width: 30.w,
                      height: 30.w,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => setState(() {
                        _controller?.dispose();
                        _controller = null;
                        widget.upList.removeWhere((el) => el['type'] == 1);
                        widget.video.clear();
                      }),
                      child: MyImage.asset(
                        MyImagePaths.appIssueCancelIcon,
                        width: 18.w,
                        height: 18.w,
                      ),
                    ),
                  )
                ],
              )
            : GestureDetector(
                onTap: _videoPickerAssets,
                child: const MyImage.asset(MyImagePaths.appIssueAdd),
              ),
      ],
    );
  }
}
