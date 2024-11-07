import 'package:flutter/cupertino.dart';

import '../../domain/domain.dart';
import '../../domain/model/comic/comic_model.dart';

class ComicNotifier extends ChangeNotifier {
  ComicNotifier(this._cache) {
    _init();
  }
  final CacheDomain _cache;
  final currentChapterIndex = <String, int>{};

  void _init() async {
    currentChapterIndex.addAll(await _cache.readComicReaderChapterIndex());
  }

  setCurrentChapterIndex(String id, int index) {
    _cache.upsertComicReaderChapterIndex({...currentChapterIndex});
    currentChapterIndex[id] = index;
    notifyListeners();
  }
}
