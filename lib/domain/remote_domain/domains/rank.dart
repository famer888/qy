import '../../model/video/video_model.dart';
import '../../type_def.dart';

abstract class RankDomain {
  /// 视频搜索
  AsyncResult<List<VideoCardModel>?> rankMVList({
    required String type,
    required String cycle,
  });
}
