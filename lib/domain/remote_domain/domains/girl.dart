import '../../enum.dart';
import '../../model/girl/girl_option_model.dart';
import '../../model/girl/girl_index_model.dart';
import '../../model/girl/girl_list_model.dart';
import '../../model/girl/girl_detail_model.dart';
import '../../model/post/circle/circle_post_nav_model.dart';
import '../../model/post/community/community_post_nav_model.dart';
import '../../model/post/post_creator_info_model.dart';
import '../../model/post/posts_with_banners_model.dart';
import '../../model/post/post_model.dart';
import '../../model/review_data_model.dart';
import '../../model/tiezt_model.dart';
import '../../model/topic_detail_model.dart';
import '../../model/topic_model.dart';
import '../../model/topics_with_banners_model.dart';
import '../../type_def.dart';

abstract class GirlDomain {
  /// 获取筛选项
  AsyncResult<List<GirlOptionModel>> getOptions();

  /// 妹子信息列表
  AsyncResult<GirlIndexModel> girlIndex({
    required Map<String, dynamic> girlOptions,
    required int page,
    required int limit,
  });

  /// 妹子详情
  AsyncResult<GirlDetailModel> girlDetail({
    required int id,
  });

  // 发布妹子信息
  AsyncJson girlCreate({
    required Map<String, dynamic> allInfo,
  });

  // 解锁约炮信息
  AsyncJson girlBuy({
    required int id,
  });

  /// 我的购买
  AsyncResult<List<GirlListModel>> girlBuyList({
    required int page,
    required int limit,
  });

  /// 他人发布
  AsyncResult<List<GirlListModel>> girlPeerList({
    required int aff,
    required int page,
    required int limit,
  });

  /// 我的发布
  AsyncResult<List<GirlListModel>> girlMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  });

  /// 搜索
  AsyncResult<List<GirlListModel>> girlSearchList({
    required String word,
    required int page,
    required int limit,
  });

  /// 我的点赞列表
  AsyncResult<List<GirlListModel>> girlLikeList({
    required int page,
    required int limit,
  });

  /// 我的收藏列表
  AsyncResult<List<GirlListModel>> girlFavoriteList({
    required int page,
    required int limit,
  });
}
