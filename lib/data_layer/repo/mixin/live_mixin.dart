part of '../repo.dart';

mixin _Live on _BaseAppRepo implements LiveDomain {
  @override
  AsyncResult<LiveWithBannersModel> getLiveIndex({
    required int id,
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveIndex(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(LiveWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<LiveModel>?> getLiveSearch({
    required String word,
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveSearch(
            word: word,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(LiveModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<LiveVideoDetailData?> getLiveDetail({required int id}) =>
      _liveService
          .getLiveDetail(id: id)
          .deserializeJsonBy(LiveVideoDetailData.fromJson)
          .guard;

  @override
  AsyncResult<List<LiveModel>?> getLiveRecommend({
    required int id,
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveRecommend(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(LiveModel.fromJson).toList())
          .guard;

  @override
  AsyncResult getLiveBuy({required int id}) =>
      _liveService.getLiveBuy(id: id).deserialize().guard;

  @override
  AsyncResult<List<LiveModel>?> getLiveListFavorite({
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveListFavorite(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(LiveModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<LiveModel>?> getLiveListBuy({
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveListBuy(
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(LiveModel.fromJson).toList())
          .guard;

  @override
  AsyncResult getLiveComment({required String text, required int id}) =>
      _liveService.getLiveComment(text: text, id: id).deserialize().guard;

  @override
  AsyncResult<List<CommentModel>?> getLiveListComment({
    required int id,
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveListComment(
            id: id,
            page: page,
            limit: limit,
          )
          .deserializeJsonListBy((e) => e.map(CommentModel.fromJson).toList())
          .guard;

  @override
  AsyncResult toggleLiveCommentLike({required int id}) =>
      _liveService.getLiveLikeComment(id: id).deserialize().guard;

  @override
  AsyncResult getLiveReward({required int id, required int coins}) =>
      _liveService.getLiveReward(id: id, coins: coins).deserialize().guard;

  @override
  AsyncResult<RecommendLiveWithBannersModel?> getLiveRecListComment({
    required int page,
    required int limit,
  }) =>
      _liveService
          .getLiveRecListComment(
            page: page,
            limit: limit,
          )
          .deserializeJsonBy(RecommendLiveWithBannersModel.fromJson)
          .guard;
}
