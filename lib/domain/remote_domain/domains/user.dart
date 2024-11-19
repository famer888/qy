import '../../enum.dart';
import '../../model/mine/coin_recharge/coin_recharge_detail_model.dart';
import '../../model/mine/income/mine_income_detail_list_model.dart';
import '../../model/member_model.dart';
import '../../model/mine/following/following_user_list_model.dart';
import '../../model/mine/withdrawal/bank_card_list_model.dart';
import '../../model/tiezt_model.dart';
import '../../model/toggle_favorite_model.dart';
import '../../model/toggle_like_model.dart';
import '../../model/vip_upgrade_model.dart';
import '../../type_def.dart';

abstract class UserDomain {
  /// 获取用户接口
  AsyncResult<Member> getUserInfo();

  /// 关注用户/取消关注
  AsyncJson toggleCommunityFollowUser({required String aff});

  /// 修改用户头像、昵称、签名
  AsyncResult updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  });

  /// 填写邀请码
  AsyncResult sendInvitation({required String affCode});

  /// 金币明细
  AsyncResult<List<CoinRechargeDetailModel>> getMoneyDetailList({
    required int page,
    required MyCoinFilterType type,
    required int limit,
  });

  /// 提现  银行卡列表
  AsyncResult<BankCardListModel> getBankCardList({
    required int page,
    required int limit,
  });

  /// 提现  添加银行卡
  AsyncJson addBankCard({
    required String card,
    required String name,
  });

  /// 提现  删除银行卡
  AsyncJson deleteBankCard({required int cardId});

  /// 收益汇总
  AsyncResult<MineIncomeDetailListModel> getEarnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  });

  /// 我的帖子
  AsyncResult<List<TieztModel>> getMyPostList({
    String cate = 'release',
    required int page,
    required int limit,
  });

  /// 我收藏的
  AsyncResult getUserFavor({
    required int page,
    required int limit,
    required int type,
    required String lastIx,
  });

  /// 收藏/取消收藏,
  AsyncResult<ToggleFavoriteModel> toggleUserFavorite(
      {required ModuleType type, required int id});

  /// 评论点赞/取消点赞
  AsyncResult toggleUserCommentLike(
      {required ModuleType type, required int id});

  /// 点赞/取消点赞
  AsyncResult<ToggleLikeModel> toggleUserLike(
      {required ModuleType type, required int id});

  /// 我购买的
  AsyncResult getPurchasedList({
    required int page,
    required int limit,
    required int type,
  });

  /// 我的关注
  AsyncResult<FollowingUserListModel> getFollowList({
    required int page,
    required int limit,
    required String lastIx,
  });

  ///VIP可升级列表
  AsyncResult<VipUpgradeModel> userUpgradeGoods();

  ///金币升级VIP
  AsyncResult userUpgrade({required int id});

  /// 清除缓存
  AsyncJson clearCached();
}
