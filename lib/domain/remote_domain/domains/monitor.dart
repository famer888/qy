import '../../model/monitor/monitor_video_detail_data.dart';
import '../../model/monitor/monitor_with_banners_model.dart';
import '../../model/video_comment_model.dart';
import '../../type_def.dart';

abstract class MonitorDomain {
  /// 监控列表
  AsyncResult<MonitorWithBannersModel> getMonitorIndex({
    required int id,
    required int page,
    required int limit,
  });

  /// 监控搜索
  AsyncResult<List<MonitorModel>?> getMonitorSearch({
    required String word,
    required int page,
    required int limit,
  });

  /// 监控详情
  AsyncResult<MonitorVideoDetailData?> getMonitorDetail({required int id});

  /// 监控推荐数据
  AsyncResult<List<MonitorModel>?> getMonitorRecommend(
      {required int id, required int page, required int limit});

  /// 监控购买
  AsyncResult getMonitorBuy({required int id});

  /// 监控收藏列表
  AsyncResult<List<MonitorModel>?> getMonitorListFavorite(
      {required int page, required int limit});

  /// 监控已购买列表
  AsyncResult<List<MonitorModel>?> getMonitorListBuy(
      {required int page, required int limit});

  /// 监控评论
  AsyncResult getMonitorComment({required String text, required int id});

  /// 监控评论列表
  AsyncResult<List<CommentModel>?> getMonitorListComment(
      {required int id, required int page, required int limit});
}
