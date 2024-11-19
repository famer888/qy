import '../../model/live/live_video_detail_data.dart';
import '../../model/live/live_with_banners_model.dart';
import '../../model/video_comment_model.dart';
import '../../type_def.dart';

abstract class LiveDomain {
  /// 直播列表
  AsyncResult<LiveWithBannersModel> getLiveIndex({
    required int id,
    required int page,
    required int limit,
  });

  /// 直播搜索
  AsyncResult<List<LiveModel>?> getLiveSearch({
    required String word,
    required int page,
    required int limit,
  });

  /// 直播详情
  AsyncResult<LiveVideoDetailData?> getLiveDetail({required int id});

  /// 直播推荐数据
  AsyncResult<List<LiveModel>?> getLiveRecommend(
      {required int id, required int page, required int limit});

  /// 直播购买
  AsyncResult getLiveBuy({required int id});

  /// 直播收藏列表
  AsyncResult<List<LiveModel>?> getLiveListFavorite(
      {required int page, required int limit});

  /// 直播已购买列表
  AsyncResult<List<LiveModel>?> getLiveListBuy(
      {required int page, required int limit});

  /// 直播评论
  AsyncResult getLiveComment({required String text, required int id});

  /// 直播评论列表
  AsyncResult<List<CommentModel>?> getLiveListComment(
      {required int id, required int page, required int limit});

  /// 直播打赏
  AsyncResult getLiveReward({required int id, required int coins});

  /// 直播热门推荐列表
  AsyncResult<RecommendLiveWithBannersModel?> getLiveRecListComment(
      {required int page, required int limit});
}
