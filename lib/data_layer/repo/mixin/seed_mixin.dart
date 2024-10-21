part of '../repo.dart';

mixin _Seed on _BaseAppRepo implements SeedDomain {
  @override
  AsyncResult<List<BitNavModel>> reqGetPostBit() => _seedService
      .reqGetPostBit()
      .deserializeJsonListBy((e) => e.map(BitNavModel.fromJson).toList())
      .guard;

  @override
  AsyncResult<PostsWithBannersModel> bitSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _seedService
          .bitSortList(id: id, sort: sort, page: page, limit: limit)
          .deserializeJsonBy(PostsWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<BitDetail> bitTopicDetail({required String id}) => _seedService
      .bitTopicDetail(id: id)
      .deserializeJsonBy(BitDetail.fromJson)
      .guard;

  @override
  AsyncJson buyBit({required int id}) => _seedService.buyBit(id: id);

  @override
  AsyncResult<List<ReviewData>> bitPostComments(
          {required String id, required int page, required int limit}) =>
      _seedService
          .bitPostComments(id: id, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncResult bitTopicLike({required MyLikeType type, required String id}) =>
      _seedService.bitTopicLike(id: id, type: type.name).deserialize().guard;

  @override
  AsyncJson bitPostComment({
    required String postId,
    required String commentId,
    required String content,
  }) =>
      _seedService.bitPostComment(
          postId: postId, commentId: commentId, content: content);

  @override
  AsyncResult<List<ReviewData>> bitPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  }) =>
      _seedService
          .bitPostCommentsSecond(commentId: commentId, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncResult bitTopicFavorite({required String id}) =>
      _seedService.bitTopicFavorite(id: id).deserialize().guard;

  @override
  AsyncResult<List<PostModel>> searchBit({
    required int page,
    required int limit,
    required String word,
  }) =>
      _seedService
          .searchBit(page: page, limit: limit, word: word)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;
}
