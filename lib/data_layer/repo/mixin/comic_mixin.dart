part of '../repo.dart';

mixin _Comic on _BaseAppRepo implements ComicDomain {
  @override
  AsyncResult<RecommendComicWithBannersModel> comicRecommend({
    required int id,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicReComment(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(RecommendComicWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicMoreChangeList({
    required String sort,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicMoreChangeList(
            sort: sort,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<ComicWithBannersModel> comicThemeList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicThemeList(
            id: id,
            sort: sort,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(ComicWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicTypeList({
    required Map<String, String> sortParams,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicTypeList(
            sortParams: sortParams,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicNewList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicNewList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicEndList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicEndList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicRankList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicRankList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicSearchList(
            word: word,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicFavoriteList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicFavoriteList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<ComicItemModel>?> comicBuyList({
    required int page,
    required int limit,
  }) =>
      _comicService
          .comicBuyList(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(ComicItemModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<ComicDetailWithBannersModel> comicDetail({
    required int id,
  }) =>
      _comicService
          .comicDetail(id: id)
          .deserializeJsonBy(ComicDetailWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<ComicChaptersDetailModel> comicChapterDetail({
    required int id,
  }) =>
      _comicService
          .comicChapterDetail(id: id)
          .deserializeJsonBy(ComicChaptersDetailModel.fromJson)
          .guard;

  @override
  AsyncResult comicBuy({
    required int id,
  }) =>
      _comicService.comicBuy(id: id).deserialize().guard;

  @override
  AsyncResult comicComment({
    required int id,
    required String text,
  }) =>
      _comicService.comicComment(id: id, text: text).deserialize().guard;

  @override
  AsyncResult<List<CommentModel>?> comicCommentList(
          {required int limit, required int page, required int id}) =>
      _comicService
          .comicCommentList(id: id, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(CommentModel.fromJson).toList())
          .guard;
}
