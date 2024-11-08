import '../../model/comic/comic_item_model.dart';
import '../../model/comic/comic_model.dart';
import '../../model/video_comment_model.dart';
import '../../type_def.dart';

abstract class ComicDomain {
  ///漫画推荐接口
  AsyncResult<RecommendComicWithBannersModel> comicReComment({
    required int id,
    required int page,
    required int limit,
  });

  ///首页推荐更多/换一换
  AsyncResult<List<ComicItemsModel>?> comicMoreChangeList({
    required String sort, // rec漫画推荐接口中comics字段下value的值
    required int page,
    required int limit,
  });

  ///分类筛选列表
  AsyncResult<List<ComicItemsModel>?> comicTypeList({
    required String themeId, //分类ID
    required String sort, // 分类排序
    required String end, //是否完结
    required int page,
    required int limit,
  });

  ///除了推荐以外的分类列表
  AsyncResult<ComicWithBannersModel> comicThemeList({
    required int id, //分类ID
    required String sort, // 排序字段 使用config 中comic_sort_nav sort的值
    required int page,
    required int limit,
  });

  ///最新列表
  AsyncResult<List<ComicItemsModel>?> comicNewList({
    required int page,
    required int limit,
  });

  ///完结列表
  AsyncResult<List<ComicItemsModel>?> comicEndList({
    required int page,
    required int limit,
  });

  ///排行榜列表
  AsyncResult<List<ComicItemsModel>?> comicRankList({
    required int page,
    required int limit,
  });

  ///搜索列表
  AsyncResult<List<ComicItemsModel>?> comicSearchList({
    required String word,
    required int page,
    required int limit,
  });

  ///我的漫画收藏列表
  AsyncResult<List<ComicItemsModel>?> comicFavoriteList({
    required int page,
    required int limit,
  });

  ///我的漫画购买列表
  AsyncResult<List<ComicItemsModel>?> comicBuyList({
    required int page,
    required int limit,
  });

  ///漫画详情
  AsyncResult<ComicDetailWithBannersModel> comicDetail({
    required int id,
  });

  ///漫画章节详情
  AsyncResult<ComicChaptersDetailModel> comicChapterDetail({
    required int id,
  });

  ///漫画章节购买
  AsyncResult comicBuy({required int id});

  ///漫画评论
  AsyncResult comicComment({required int id, required String text});

  ///漫画评论列表
  AsyncResult<List<CommentModel>?> comicCommentList({
    required int limit,
    required int page,
    required int id,
  });
}
