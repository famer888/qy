part of '../repo.dart';

mixin _Rank on _BaseAppRepo implements RankDomain {
  @override
  AsyncResult<List<VideoCardModel>?> rankMVList({
    required String type,
    required String cycle,
  }) =>
      _rankService
          .rankMVList(type: type, cycle: cycle)
          .deserializeJsonListBy((e) => e.map(VideoCardModel.fromJson).toList())
          .guard;
}
