
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChapterReaderController {
  bool get isInit => scrollController.hasClients;
  final isPlayingNotifier = ValueNotifier(false);

  ScrollController get scrollController => _scrollController;
  ScrollController _scrollController = ScrollController();
  void setScrollController(ScrollController value) {
    _scrollController = value;
  }

  final speeds = [0.5, 1.0, 1.5, 2.0, 3.0];
  final currentSpeedIndexNotifier = ValueNotifier(1);

  double get picsHeight => _picsHeight;
  double _picsHeight = 0.0;
  void setPicsHeight(double value) {
    _picsHeight = value;
  }

  final scrollWeight = 6000 / 1.sh;

  final progressNotifier = ValueNotifier<(int, int)>((0, 0));

  void play() async {
    final speed = speeds[currentSpeedIndexNotifier.value];
    final diff = _picsHeight - scrollController.offset;
    final milliseconds = (scrollWeight * diff / speed).toInt();

    isPlayingNotifier.value = true;

    await scrollController.animateTo(
      _picsHeight,
      duration: Duration(milliseconds: milliseconds),
      curve: Curves.linear,
    );
  }

  bool checkIsEnded() => (scrollController.offset - _picsHeight).abs() < 10;

  void pause() async {
    isPlayingNotifier.value = false;
    await scrollController.animateTo(
      scrollController.offset,
      duration: Duration.zero,
      curve: Curves.linear,
    );
  }

  void updateProgress() {
    final len = progressNotifier.value.$2;
    if (len == 0) return;
    final progress = _scrollController.offset / picsHeight;
    final currentPic = ((progress * (len - 1)).round() + 1).clamp(1, len);
    progressNotifier.value = (currentPic, len);
  }

  void jumpToPic(int index) {
    final len = progressNotifier.value.$2;
    if (len == 0) return;
    final picH = picsHeight / (len - 1);
    scrollController.jumpTo(picH * (index - 1));
    updateProgress();
  }
}