part of '../repo.dart';

mixin _Seed on _BaseAppRepo implements SeedDomain {
  @override
  AsyncResult<List<SeedNavModel>> reqGetPostSeed() => _seedService
      .reqGetPostBit()
      .deserializeJsonListBy((e) => e.map(SeedNavModel.fromJson).toList())
      .guard;

  @override
  AsyncResult<SeedPostsWithBannersModel> seedSortList({
    required int id,
    required String sort,
    required int page,
    required int limit,
  }) =>
      _seedService
          .seedSortList(id: id, sort: sort, page: page, limit: limit)
          .deserializeJsonBy(SeedPostsWithBannersModel.fromJson)
          .guard;

  @override
  AsyncResult<SeedDetail> seedTopicDetail({required String id}) => _seedService
      .seedTopicDetail(id: id)
      .deserializeJsonBy(SeedDetail.fromJson)
      .guard;

  @override
  AsyncJson buySeed({required int id}) => _seedService.buySeed(id: id);

  @override
  AsyncResult<List<ReviewData>> seedPostComments(
          {required String id, required int page, required int limit}) =>
      _seedService
          .seedPostComments(id: id, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncResult seedTopicLike({required MyLikeType type, required String id}) =>
      _seedService.seedTopicLike(id: id, type: type.name).deserialize().guard;

  @override
  AsyncJson seedPostComment({
    required String postId,
    required String commentId,
    required String content,
  }) =>
      _seedService.seedPostComment(
          postId: postId, commentId: commentId, content: content);

  @override
  AsyncResult<List<ReviewData>> seedPostCommentsSecond({
    required String commentId,
    required int page,
    required int limit,
  }) =>
      _seedService
          .seedPostCommentsSecond(
              commentId: commentId, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(ReviewData.fromJson).toList())
          .guard;

  @override
  AsyncResult seedTopicFavorite({required String id}) =>
      _seedService.seedTopicFavorite(id: id).deserialize().guard;

  @override
  AsyncResult<List<PostModel>> searchSeed({
    required int page,
    required int limit,
    required String word,
  }) =>
      _seedService
          .searchSeed(page: page, limit: limit, word: word)
          .deserializeJsonListBy((e) => e.map(PostModel.fromJson).toList())
          .guard;
}
