part of '../repo.dart';

mixin _User on _BaseAppRepo implements UserDomain {
  @override
  AsyncResult<Member> getUserInfo() =>
      _userService.getUserInfo().deserializeJsonBy(Member.fromJson).guard;

  @override
  AsyncResult sendInvitation({required String affCode}) =>
      _userService.postInvitation(affCode: affCode).deserialize().guard;

  @override
  AsyncJson toggleCommunityFollowUser({
    required String aff,
  }) =>
      _userService.toggleFollow(aff: aff);

  @override
  AsyncResult updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  }) =>
      _userService
          .updateUserInfo(nickName: nickName, thumb: thumb, intro: intro)
          .deserialize()
          .guard;

  @override
  AsyncResult<List<CoinDetail>> getMoneyDetailList({
    required int page,
    required MyCoinFilterType type,
    required int limit,
  }) =>
      _userService
          .getMoneyDetailList(page: page, type: type.stringType, limit: limit)
          .deserializeJsonListBy((e) => e.map(CoinDetail.fromJson).toList())
          .guard;

  @override
  AsyncResult<BankList> getBankCardList({
    required int page,
    required int limit,
  }) =>
      _userService
          .getBankCardList(page: page, limit: limit)
          .deserializeJsonBy(BankList.fromJson)
          .guard;

  @override
  AsyncJson addBankCard({
    required String card,
    required String name,
  }) =>
      _userService.addBankCard(card: card, name: name);

  @override
  AsyncJson deleteBankCard({required int cardId}) =>
      _userService.deleteBankCard(cardId: cardId);

  @override
  AsyncResult<MineIncomeDetailData> getEarnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  }) =>
      _userService
          .getEarnTotalInfo(
              page: page, lastIx: lastIx, limit: limit, source: source)
          .deserializeJsonBy(MineIncomeDetailData.fromJson)
          .guard;

  @override
  AsyncResult<List<TieztModel>> getMyPostList({
    String cate = 'release',
    required int page,
    required int limit,
  }) =>
      _userService
          .getMyPostList(page: page, limit: limit, cate: cate)
          .deserializeJsonListBy((e) => e.map(TieztModel.fromJson).toList())
          .guard;

  @override
  AsyncResult getUserFavor({
    required int page,
    required int limit,
    required int type,
    required String lastIx,
  }) =>
      type == 1
          ? _userService
              .getUserFavor(
                  page: page, type: type, lastIx: lastIx, limit: limit)
              .deserializeJsonBy(MineVideoListModel.fromJson)
              .guard
          : _userService
              .getUserFavor(
                  page: page, type: type, lastIx: lastIx, limit: limit)
              .deserializeJsonBy(MineTieztListModel.fromJson)
              .guard;

  @override
  AsyncResult userFavorites({
    required int type,
    required int id,
  }) =>
      _userService.userFavorites(type: type, id: id).deserialize().guard;

  @override
  AsyncResult toggleUserFavorite({
    required MyModuleType type,
    required int id,
  }) =>
      _userService
          .toggleUserFavorite(type: type.index, id: id)
          .deserialize()
          .guard;

  @override
  AsyncResult toggleUserCommentLike(
          {required MyModuleType type, required int id}) =>
      _userService
          .toggleUserCommentLike(type: type.index, id: id)
          .deserialize()
          .guard;

  @override
  AsyncResult getPurchasedList({
    required int page,
    required int limit,
    required int type,
  }) =>
      type == 1
          ? _userService
              .getPurchasedList(page: page, type: type, limit: limit)
              .deserializeJsonBy(MineVideoListModel.fromJson)
              .guard
          : _userService
              .getPurchasedList(page: page, type: type, limit: limit)
              .deserializeJsonBy(MineTieztListModel.fromJson)
              .guard;

  @override
  AsyncResult<FollowingUser> getFollowList(
          {required int page, required int limit, required String lastIx}) =>
      _userService
          .getFollowList(page: page, lastIx: lastIx, limit: limit)
          .deserializeJsonBy(FollowingUser.fromJson)
          .guard;

  @override
  AsyncResult toggleUserLike({required MyModuleType type, required int id}) =>
      _userService.toggleUserLike(type: type.index, id: id).deserialize().guard;

  @override
  AsyncJson clearCached() => _userService.clearCached();
}
