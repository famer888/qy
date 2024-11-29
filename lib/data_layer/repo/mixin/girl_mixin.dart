part of '../repo.dart';

mixin _Girl on _BaseAppRepo implements GirlDomain {
  @override
  AsyncResult<List<GirlOptionModel>> getOptions() => _girlService
      .getOptions()
      .deserializeJsonListBy((e) => e.map(GirlOptionModel.fromJson).toList())
      .guard;

  @override
  AsyncResult<GirlIndexModel> girlIndex({
    required Map<String, dynamic> girlOptions,
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlIndex(girlOptions: girlOptions, page: page, limit: limit)
          .deserializeJsonBy(GirlIndexModel.fromJson)
          .guard;

  @override
  AsyncResult<GirlDetailModel> girlDetail({
    required int id,
  }) =>
      _girlService
          .girlDetail(id: id)
          .deserializeJsonBy(GirlDetailModel.fromJson)
          .guard;

  @override
  AsyncJson girlCreate({
    required Map<String, dynamic> allInfo,
  }) =>
      _girlService.girlCreate(allInfo: allInfo);

  @override
  AsyncJson girlBuy({
    required int id,
  }) =>
      _girlService.girlBuy(id: id);

  @override
  AsyncJson girlFavorite({
    required int id,
  }) =>
      _girlService.girlFavorite(id: id);

  @override
  AsyncResult<List<GirlListModel>> girlBuyList({
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlBuyList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<GirlListModel>> girlPeerList({
    required int aff,
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlPeerList(aff: aff, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<GirlListModel>> girlMyList({
    required int status, // 状态 1-待审核 2-已拒绝 3-处理中 4-已通过
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlMyList(status: status, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<GirlListModel>> girlSearchList({
    required String word,
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlSearchList(word: word, page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<GirlListModel>> girlLikeList({
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlLikeList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;

  @override
  AsyncResult<List<GirlListModel>> girlFavoriteList({
    required int page,
    required int limit,
  }) =>
      _girlService
          .girlFavoriteList(page: page, limit: limit)
          .deserializeJsonListBy((e) => e.map(GirlListModel.fromJson).toList())
          .guard;
}
