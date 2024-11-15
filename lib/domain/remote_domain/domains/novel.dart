import '../../model/novel/novel_item_model.dart';
import '../../model/novel/novel_model.dart';
import '../../model/video_comment_model.dart';
import '../../type_def.dart';

abstract class NovelDomain {
  ///小说推荐接口
  AsyncResult<RecommendNovelWithBannersModel> novelRecommend({
    required int page,
    required int limit,
  });

  ///除了推荐以外的其他分类列表
  AsyncResult<NovelWithBannersModel?> novelSortList({
    required int id, // novelNav字段下id的值
    required String sort, // novelSort字段下sort的值
    required int page,
    required int limit,
  });

  ///更多
  AsyncResult<List<NovelItemModel>?> novelMoreList({
    required String sort,
    required int page,
    required int limit,
  });

  ///分类筛选列表
  AsyncResult<List<NovelItemModel>?> novelTypeList({
    required int page,
    required int limit,
    required Map<String, String> sortParams,
  });

  ///最新列表
  AsyncResult<List<NovelItemModel>?> novelNewList({
    required int page,
    required int limit,
  });

  ///连载列表
  AsyncResult<List<NovelItemModel>?> novelUpdatingList({
    required int page,
    required int limit,
  });

  ///完结列表
  AsyncResult<List<NovelItemModel>?> novelEndList({
    required int page,
    required int limit,
  });

  ///搜索列表
  AsyncResult<List<NovelItemModel>?> novelSearchList({
    required String word,
    required int page,
    required int limit,
  });

  ///我的小说收藏列表
  AsyncResult<List<NovelItemModel>?> novelFavoriteList({
    required int page,
    required int limit,
  });

  ///我的小说购买列表
  AsyncResult<List<NovelItemModel>?> novelBuyList({
    required int page,
    required int limit,
  });

  ///小说详情
  AsyncResult<NovelDetailWithBannersModel> novelDetail({
    required int id,
  });

  ///小说章节购买
  AsyncResult novelBuy({required int id});

  ///小说评论
  AsyncResult novelComment({required int id, required String text});

  ///小说评论列表
  AsyncResult<List<CommentModel>?> novelCommentList({
    required int limit,
    required int page,
    required int id,
  });

  ///小说关注专题
  AsyncResult novelFollowSubject({required int id});

  ///关注的小说专题列表
  AsyncResult<NovelSubjectListModel> novelFollowSubjectList({
    required int page,
    required int limit,
  });

  ///关注的专题中包含的小说列表
  AsyncResult<NovelSubjectNovelListModel> novelFollowSubjectNovelsList({
    required int page,
    required int limit,
  });

  ///大家都在看
  AsyncResult<List<NovelItemModel>?> novelSeeList({
    required int page,
    required int limit,
  });
}
