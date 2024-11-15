part of '../repo.dart';

mixin _Mv on _BaseAppRepo implements MvDomain {
  @override
  AsyncResult<List<VideoCardVideoModel>> videoSearch({
    required int page,
    required int limit,
    required String word,
    int type = 1,
  }) =>
      _mvService
          .videoSearch(page: page, limit: limit, word: word)
          .deserializeJsonListBy(
              (e) => e.map(VideoCardVideoModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VideoCardModel>> getListConstructWithParam({
    required String id,
    required int limit,
    required int page,
    required String sort,
  }) =>
      _mvService
          .getListConstructWithParam(
              id: id, limit: limit, page: page, sort: sort)
          .then((value) => {...value, 'data': value['data']['list']})
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<VideoCardModel>> getDiscoverVideoList({
    required int limit,
    required int page,
    required String sort,
  }) =>
      _mvService
          .getDiscoverVideoList(limit: limit, page: page, sort: sort)
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<VideoDetailData> getVideoDetail({required String id}) =>
      _mvService
          .getVideoDetail(id: id)
          .deserializeJsonBy(VideoDetailData.fromJson)
          .guard;

  @override
  AsyncResult<List<VideoCardModel>> getDetailRecommendList(
          {required String id}) =>
      _mvService
          .getDetailRecommendList(id: id)
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<CommentListModel> getVideoCommentList({
    required String id,
    required String lastIx,
    required int page,
    required int limit,
  }) =>
      _mvService
          .getVideoCommentList(id: id, lastIx: lastIx, page: page, limit: limit)
          .deserializeJsonBy(CommentListModel.fromJson)
          .guard;

  @override
  AsyncResult toggleCommentLike({required int id}) =>
      _mvService.toggleVideoCommentLike(id: id).deserialize().guard;

  @override
  AsyncResult sendVideoComment({
    required String id,
    required String content,
  }) =>
      _mvService.sendVideoComment(id: id, content: content).deserialize().guard;

  @override
  AsyncResult buyVideo({required int id}) =>
      _mvService.buyVideo(id: id).deserialize().guard;
}
