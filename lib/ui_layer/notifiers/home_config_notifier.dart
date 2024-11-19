import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import '../../domain/domain.dart';
import '../../domain/model/home_data_model.dart';
import '../../domain/type_def.dart';

class HomeConfigNotifier extends ChangeNotifier {
  HomeConfigNotifier(this._domain);

  final AppDomain _domain;

  HomeData get homeData => _homeData;
  late HomeData _homeData;

  Config get config => _config;
  late Config _config;

  List<String> get searchHistory => [..._searchHistory];
  final _searchHistory = <String>[];

  Future<bool> init() async {
    final result = await _domain.getHomeConfig();
    if (result.data case final data?) {
      _homeData = data;
      _config = _homeData.config;
      await _initSearchHistory();
      return true;
    }
    return false;
  }

  Future _initSearchHistory() async {
    _searchHistory.clear();
    _searchHistory.addAll(await _domain.cache.readSearchHistory());
  }

  Future<Json?> uploadImage(XFile xFile) async {
    try {
      final result = await _domain.uploadImage(
        baseUrl: _config.imgUploadUrl,
        key: _config.uploadImgKey,
        xFile: xFile,
        position: 'upload',
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  Future<Json?> uploadVideo({
    required XFile xFile,
    required void Function(int count, int total) progressCallback,
  }) async {
    try {
      final result = await _domain.uploadVideo(
        xFile: xFile,
        baseUrl: config.mp4UploadUrl ?? '',
        key: config.uploadMp4Key ?? '',
        progressCallback: progressCallback,
      );
      return result;
    } catch (_) {
      return null;
    }
  }

  /// 更新搜索记录
  Future<void> upsertSearchHistory({
    required List<String> searchHistory,
  }) async {
    await _domain.cache.upsertSearchHistory(searchHistory: searchHistory);
    _searchHistory.clear();
    _searchHistory.addAll(searchHistory);
    notifyListeners();
  }

  /// 更新搜索记录
  Future<void> clearSearchHistory() async {
    await _domain.cache.clearSearchHistory();
    _searchHistory.clear();
    notifyListeners();
  }
}
