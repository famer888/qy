import '../../../domain/type_def.dart';
import 'base_service.dart';

class GirlService extends BaseService {
  GirlService(super._dio);

  @override
  final service = 'girl';

  /// 获取筛选项
  AsyncJson getOptions() => post('/option');

  /// 妹子信息列表
  AsyncJson girlIndex({
    required Map<String, dynamic> girlOptions,
    required int page,
    required int limit,
  }) =>
      post('/index',
          data: girlOptions
            ..addAll({
              'page': page,
              'limit': limit,
            }));

  /// 妹子详情
  AsyncJson girlDetail({
    required int id,
  }) =>
      post('/detail', data: {'id': id});

  // 发布妹子信息
  AsyncJson girlCreate({
    required Map<String, dynamic> allInfo,
  }) =>
      post('/create', data: allInfo);

  // 解锁约炮信息
  AsyncJson girlBuy({
    required int id,
  }) =>
      post('/buy', data: {'id': id});

  /// 我的购买
  AsyncJson girlBuyList({
    required int page,
    required int limit,
  }) =>
      post('/list_buy', data: {
        'page': page,
        'limit': limit,
      });

  /// 他人发布
  AsyncJson girlPeerList({
    required int aff,
    required int page,
    required int limit,
  }) =>
      post('/list_peer', data: {
        'aff': aff,
        'page': page,
        'limit': limit,
      });

  /// 我的发布
  AsyncJson girlMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  }) =>
      post('/list_my', data: {
        'status': status,
        'page': page,
        'limit': limit,
      });

  /// 搜索
  AsyncJson girlSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      post('/search', data: {
        'word': word,
        'page': page,
        'limit': limit,
      });

  /// 我的点赞列表
  AsyncJson girlLikeList({
    required int page,
    required int limit,
  }) =>
      post('/list_like', data: {
        'page': page,
        'limit': limit,
      });

  /// 我的收藏列表
  AsyncJson girlFavoriteList({
    required int page,
    required int limit,
  }) =>
      post('/list_favorite', data: {
        'page': page,
        'limit': limit,
      });
}
