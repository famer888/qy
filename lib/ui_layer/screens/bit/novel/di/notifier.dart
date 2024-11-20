import 'package:flutter/material.dart';
import '../../../../../../domain/domain.dart';
import '../../../../../domain/enum.dart';
import '../../../../../domain/model/novel/novel_model.dart';
import '../../../../utils/debounce.dart';

class NovelChangeNotifier extends ChangeNotifier {
  NovelChangeNotifier(this._cache, this._userDomain) {
    _init();
  }
  _init() async {
    _bgColorIndex = await _cache.readNovelReaderBgColorIndex();
    _fontSize = await _cache.readNovelReaderFontSize();
    notifyListeners();
  }

  final _debounce = Debounce();
  final UserDomain _userDomain;
  final NovelCacheDomain _cache;

  NovelDetailModel get currentNovel => _currentNovel;
  late NovelDetailModel _currentNovel;

  int? _currentChapterIndex;
  int? get currentChapterIndex => _currentChapterIndex;

  int _bgColorIndex = 1;
  int get bgColorIndex => _bgColorIndex;

  double _fontSize = 15.0;
  double get fontSize => _fontSize;

  setCurrentChapterIndex(int index) {
    _currentChapterIndex = index;
    _cache.upsertNovelReaderChapterIndex('${_currentNovel.id}', index);
    notifyListeners();
  }

  setBgColorIndex(int index) {
    _bgColorIndex = index;
    _cache.upsertNovelBgColorIndex(index: index);
    notifyListeners();
  }

  setFontSize(double size) {
    _fontSize = size;
    _cache.upsertNovelFontSize(fontSize: size);
    notifyListeners();
  }

  setCurrentNovel(NovelDetailModel data) async {
    _currentNovel = data;
    _currentChapterIndex =
        await _cache.readNovelReaderChapterIndex('${_currentNovel.id}');

    notifyListeners();
  }

  toggleFavorite() {
    final oldValue = _currentNovel.isFavorite;
    final newValue = oldValue == 0 ? 1 : 0;
    _changeFavorite(newValue);

    final id = currentNovel.id;

    if (_debounce.containsKey('$id')) {
      _debounce.cancelAndRemove('$id');
    } else {
      _debounce.run(
        id: '$id',
        action: () async {
          final result = await _userDomain.toggleUserFavorite(
              type: ModuleType.novel, id: id);
          if (result.data?.isFavorite case final isFavorite
              when isFavorite != newValue) {
            _changeFavorite(oldValue);
          }
        },
      );
    }
  }

  _changeFavorite(int value) {
    if (_currentNovel.isFavorite == value) return;
    _currentNovel.isFavorite = value;
    _currentNovel.favoriteFct += value == 1 ? 1 : -1;
    notifyListeners();
  }
}
