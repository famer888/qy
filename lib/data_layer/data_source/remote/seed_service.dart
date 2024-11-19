import '../../../domain/type_def.dart';
import 'base_service.dart';

class SeedService extends BaseService {
  SeedService(super._dio);

  @override
  final service = 'seed';

  /// 获取种子导航
  AsyncJson reqGetPostBit() => post('/nav');

  /// 种子排序列表
  AsyncJson seedSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      post('/post', data: {
        'topic_id': id,
        'sort': sort,
        'page': page,
        'limit': limit,
      });

  /// 种子帖子详情
  AsyncJson seedTopicDetail({required String id}) =>
      post('/detail', data: {'id': id});

  /// 购买视频
  AsyncJson buySeed({required int id}) => post('/buy', data: {'id': id});

  /// 种子 一级评论列表
  AsyncJson seedPostComments(
          {required String id, required int page, required int limit}) =>
      post('/post_comments', data: {'id': id, 'page': page, 'limit': limit});

  /// 种子帖子或评论点赞/取消点赞
  AsyncJson seedTopicLike({required String type, required String id}) =>
      post('/like', data: {'type': type, 'id': id});

  /// 种子 发布评论
  AsyncJson seedPostComment({
    required String postId,
    required String commentId,
    required String content,
  }) =>
      post('/comment', data: {
        'post_id': postId,
        'comment_id': commentId,
        'content': content
      });

  /// 评论详情列表
  AsyncJson seedPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  }) =>
      post('/comments', data: {
        'comment_id': commentId,
        'page': page,
        'limit': limit,
      });

  /// 种子帖子收藏/取消收藏
  AsyncJson seedTopicFavorite({required String id}) =>
      post('/favorite', data: {'id': id});

  /// 取得搜索种子结果
  AsyncJson searchSeed({
    required int page,
    required int limit,
    required String word,
  }) =>
      post('/search', data: {
        'page': page,
        'limit': limit,
        'word': word,
      });
}
