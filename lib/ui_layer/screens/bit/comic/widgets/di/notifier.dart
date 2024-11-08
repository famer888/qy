import 'package:flutter/material.dart';

import '../../../../../../domain/domain.dart';
import '../../../../../../domain/model/comic/comic_model.dart';

class ComicChangeNotifier extends ChangeNotifier {
  ComicChangeNotifier(this._cache) {
    _init();
  }

  final ComicCacheDomain _cache;
  final currentChapterIndex = <String, int>{};

  ComicDetailModel get currentComic => _currentComic;

  late ComicDetailModel _currentComic;

  void _init() async {
    currentChapterIndex.addAll(await _cache.readComicReaderChapterIndex());
  }

  setCurrentChapterIndex(int index) {
    _cache.upsertComicReaderChapterIndex({...currentChapterIndex});
    currentChapterIndex['${_currentComic.id}'] = index;
    notifyListeners();
  }

  setCurrentComic(ComicDetailModel data) {
    _currentComic = data;
    notifyListeners();
  }
}
