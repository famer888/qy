part of '../repo.dart';

mixin _Index on _BaseAppRepo implements IndexDomain {
  @override
  AsyncResult<RecommendVideoWithBannersModel> getRecommendVideosWithBanners({
    required int id,
    required int page,
    required int limit,
  }) =>
      _indexService
          .getRecommendVideosWithBanners(id: id, page: page, limit: limit)
          .deserializeJsonBy(RecommendVideoWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<List<VideoCardModel>> getMoreRecommendVideosBySort({
    required int id,
    required int limit,
    required int page,
  }) =>
      _indexService
          .getMoreRecommendVideosBySort(id: id, limit: limit, page: page)
          .then((value) => {...value, 'data': value['data']['list']})
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VideoCardModel>> getMoreRecommendVideosByPart({
    required int id,
    required int limit,
    required int page,
    required String sort,
  }) =>
      _indexService
          .getMoreRecommendVideosByPart(
              id: id, limit: limit, page: page, sort: sort)
          .then((value) => {...value, 'data': value['data']['list']})
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;
}
