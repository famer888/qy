import '../../enum.dart';
import '../../model/bit_detail_model.dart';
import '../../model/bit_nav_model.dart';
import '../../model/post_model.dart';
import '../../model/posts_with_banners_model.dart';
import '../../model/review_data_model.dart';
import '../../type_def.dart';

abstract class SeedDomain {
  /// 获取种子导航
  AsyncResult<List<BitNavModel>> reqGetPostBit();

  /// 种子排序列表
  AsyncResult<PostsWithBannersModel> bitSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  });

  /// 种子帖子详情
  AsyncResult<BitDetail> bitTopicDetail({required String id});

  /// 购买视频
  AsyncJson buyBit({required int id});

  /// 种子 一级评论列表
  AsyncResult<List<ReviewData>> bitPostComments({
    required String id,
    required int page,
    required int limit,
  });

  /// 种子帖子或评论点赞/取消点赞
  AsyncResult bitTopicLike({required MyLikeType type, required String id});

  /// 发布评论
  AsyncJson bitPostComment({
    required String postId,
    required String commentId,
    required String content,
  });

  /// 评论详情列表
  AsyncResult<List<ReviewData>> bitPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  });

  /// 种子帖子收藏/取消收藏
  AsyncResult bitTopicFavorite({required String id});

  /// 美图搜索
  AsyncResult<List<PostModel>> searchBit({
    required int page,
    required int limit,
    required String word,
  });
}
