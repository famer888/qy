import 'package:flutter/material.dart';
import '../../../../../../domain/api_validator.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../../domain/enum.dart';
import '../../../../../../domain/model/comic/comic_model.dart';
import '../../../../utils/debounce.dart';

class ComicChangeNotifier extends ChangeNotifier {
  ComicChangeNotifier(this._cache, this._userDomain);

  final _debounce = Debounce();
  final UserDomain _userDomain;
  final ComicCacheDomain _cache;
  int? _currentChapterIndex;

  int? get currentChapterIndex => _currentChapterIndex;

  ComicDetailModel get currentComic => _currentComic;

  late ComicDetailModel _currentComic;

  setCurrentChapterIndex(int index) {
    _currentChapterIndex = index;
    _cache.upsertComicReaderChapterIndex('${_currentComic.id}', index);

    notifyListeners();
  }

  setCurrentComic(ComicDetailModel data) async {
    _currentComic = data;
    _currentChapterIndex =
        await _cache.readComicReaderChapterIndex('${_currentComic.id}');
    notifyListeners();
  }

  toggleFavorite() {
    final oldValue = _currentComic.isFavorite;
    final newValue = oldValue == 0 ? 1 : 0;
    _changeFavorite(newValue);

    final id = currentComic.id;

    if (_debounce.containsKey('$id')) {
      _debounce.cancelAndRemove('$id');
    } else {
      _debounce.run(
        id: '$id',
        action: () async {
          final result = await _userDomain.toggleUserFavorite(
              type: ModuleType.comic, id: id);
          if (result.data?.isFavorite case final isFavorite
              when isFavorite != newValue) {
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
