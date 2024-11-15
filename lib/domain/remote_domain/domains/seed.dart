import '../../enum.dart';
import '../../model/seed/seed_detail_model.dart';
import '../../model/seed/seed_nav_model.dart';
import '../../model/post/post_model.dart';
import '../../model/review_data_model.dart';
import '../../model/seed/seed_posts_with_banners_model.dart';
import '../../type_def.dart';

abstract class SeedDomain {
  /// 获取种子导航
  AsyncResult<List<SeedNavModel>> reqGetPostSeed();

  /// 种子排序列表
  AsyncResult<SeedPostsWithBannersModel> seedSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  });

  /// 种子帖子详情
  AsyncResult<SeedDetail> seedTopicDetail({required String id});

  /// 购买视频
  AsyncJson buySeed({required int id});

  /// 种子 一级评论列表
  AsyncResult<List<ReviewData>> seedPostComments({
    required String id,
    required int page,
    required int limit,
  });

  /// 种子帖子或评论点赞/取消点赞
  AsyncResult seedTopicLike({required MyLikeType type, required String id});

  /// 发布评论
  AsyncJson seedPostComment({
    required String postId,
    required String commentId,
    required String content,
  });

  /// 评论详情列表
  AsyncResult<List<ReviewData>> seedPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  });

  /// 种子帖子收藏/取消收藏
  AsyncResult seedTopicFavorite({required String id});

  /// 美图搜索
  AsyncResult<List<PostModel>> searchSeed({
    required int page,
    required int limit,
    required String word,
  });
}
