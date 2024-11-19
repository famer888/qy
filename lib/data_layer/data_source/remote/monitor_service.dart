import '../../../domain/type_def.dart';
import 'base_service.dart';

class MonitorService extends BaseService {
  MonitorService(super._dio);

  @override
  final service = 'monitor';

  /// 监控列表
  AsyncJson getMonitorIndex(
          {required int id, required int page, required int limit}) =>
      post('/index', data: {'id': id, 'page': page, 'limit': limit});

  /// 监控搜索
  AsyncJson getMonitorSearch(
          {required String word, required int page, required int limit}) =>
      post('/search', data: {'word': word, 'page': page, 'limit': limit});

  /// 监控详情
  AsyncJson getMonitorDetail({required int id}) =>
      post('/detail', data: {'id': id});

  /// 监控推荐数据
  AsyncJson getMonitorRecommend(
          {required int id, required int page, required int limit}) =>
      post('/recommend', data: {'id': id, 'page': page, 'limit': limit});

  /// 监控购买
  AsyncJson getMonitorBuy({required int id}) => post('/buy', data: {'id': id});

  /// 监控收藏列表
  AsyncJson getMonitorListFavorite({required int page, required int limit}) =>
      post('/list_favorite', data: {'page': page, 'limit': limit});

  /// 监控已购买列表
  AsyncJson getMonitorListBuy({required int page, required int limit}) =>
      post('/list_buy', data: {'page': page, 'limit': limit});

  /// 监控评论
  AsyncJson getMonitorComment({required String text, required int id}) =>
      post('/comment', data: {'text': text, 'id': id});

  /// 监控评论列表
  AsyncJson getMonitorListComment(
          {required int id, required int page, required int limit}) =>
      post('/list_comment', data: {'id': id, 'page': page, 'limit': limit});
}
