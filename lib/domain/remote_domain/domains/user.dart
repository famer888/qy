import '../../enum.dart';
import '../../model/bank_card_model.dart';
import '../../model/coin_detail_model.dart';
import '../../model/follow_user_model.dart';
import '../../model/income_detail_data_model.dart';
import '../../model/member_model.dart';
import '../../model/tiezt_model.dart';
import '../../type_def.dart';

abstract class UserDomain {
  /// 获取用户接口
  AsyncResult<Member> getUserInfo();

  /// 关注用户/取消关注
  AsyncJson communityFollowUser({required String aff});

  /// 修改用户头像、昵称、签名
  AsyncResult updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  });

  /// 填写邀请码
  AsyncResult toInvitation({required String affCode});

  /// 金币明细
  AsyncResult<List<CoinDetail>> getListMoneyDetail({
    required int page,
    required MyCoinFilterType type,
    required int limit,
  });

  /// 提现  银行卡列表
  AsyncResult<BankList> cashBankCardList({
    required int page,
    required int limit,
  });

  /// 提现  添加银行卡
  AsyncJson cashAddBankCard({
    required String card,
    required String name,
  });

  /// 提现  删除银行卡
  AsyncJson cashDeleteBankCard({required int cardId});

  /// 收益汇总
  AsyncResult<MineIncomeDetailData> earnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  });

  /// 我的帖子
  AsyncResult<List<TieztModel>> userMyPosts({
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

  /// 用户收藏   type: 1 mv  2 book 3 story 4 link 5 soundBook 6pic
  AsyncResult userFavorites({required int type, required int id});

  /// 我购买的
  AsyncResult getUserBuy({
    required int page,
    required int limit,
    required int type,
  });

  /// 我的关注
  AsyncResult<FollowingUser> userListFollow({
    required int page,
    required int limit,
    required String lastIx,
  });

  /// 填写邀请码
  AsyncResult sendInvitation({required String affCode});

  /// 清除缓存
  AsyncJson clearCached();
}
