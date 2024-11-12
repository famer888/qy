import 'package:flutter/material.dart';
import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/enum.dart';
import '../../../../../../domain/model/comic/comic_model.dart';
import '../../../../../utils/debounce.dart';

class ComicChangeNotifier extends ChangeNotifier {
  ComicChangeNotifier(this._cache, this._userDomain) {
    _init();
  }

  final _debounce = Debounce();
  final UserDomain _userDomain;
  final ComicCacheDomain _cache;
  final _currentChapterIndexMap = <String, int>{};

  int get currentChapterIndex =>
      _currentChapterIndexMap['${currentComic.id}'] ?? 0;

  ComicDetailModel get currentComic => _currentComic;

  late ComicDetailModel _currentComic;

  void _init() async {
    _currentChapterIndexMap.addAll(await _cache.readComicReaderChapterIndex());
    notifyListeners();
  }

  setCurrentChapterIndex(int index) {
    _currentChapterIndexMap['${_currentComic.id}'] = index;
    _cache.upsertComicReaderChapterIndex({..._currentChapterIndexMap});

    notifyListeners();
  }

  setCurrentComic(ComicDetailModel data) {
    _currentComic = data;
    notifyListeners();
  }

  toggleFavorite() {
    final oldValue = _currentComic.isFavorite;
    final newValue = oldValue == 0 ? 1 : 0;
    _changeFavorite(newValue);

    final id = currentComic.id ?? 0;

    if (_debounce.containsKey('$id')) {
      _debounce.cancelAndRemove('$id');
    } else {
      _debounce.run(
        id: '$id',
        action: () async {
          final result = await _userDomain.toggleUserFavorite(
              type: MyModuleType.comic, id: id);
          if (!result.isValid) {
            _changeFavorite(oldValue);
          }
        },
      );
    }
  }

  _changeFavorite(int value) {
    if (_currentComic.isFavorite == value) return;
    _currentComic.isFavorite = value;
    _currentComic.favoriteFct += value == 1 ? 1 : -1;
    notifyListeners();
  }
}
