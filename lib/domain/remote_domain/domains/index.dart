import '../../model/video/recommend_video_with_banners_model.dart';
import '../../model/video/video_model.dart';
import '../../type_def.dart';

abstract class IndexDomain {
  ///视频推荐页
  AsyncResult<RecommendVideoWithBannersModel> getRecommendVideosWithBanners({
    required int id,
    required int page,
    required int limit,
  });

  ///视频推荐页
  AsyncResult<List<VideoCardModel>> getMoreRecommendVideosBySort({
    required int id,
    required int page,
    required int limit,
  });

  AsyncResult<List<VideoCardModel>> getMoreRecommendVideosByPart({
    required int id,
    required int limit,
    required int page,
    required String sort,
  });
}
