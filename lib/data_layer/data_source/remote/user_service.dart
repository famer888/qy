import '../../../domain/type_def.dart';
import 'base_service.dart';

class UserService extends BaseService {
  UserService(super._dio);

  @override
  final service = 'user';

  /// 获取用户接口
  AsyncJson getUserInfo() => post('/userInfo');

  /// 填写邀请码
  AsyncJson toInvitation({required String affCode}) =>
      post('/invitation', data: {'aff_code': affCode});

  AsyncJson communityFollowUser({required String aff}) =>
      post('/toggle_follow', data: {
        'aff': aff,
      });

  /// 修改用户头像、昵称、签名
  AsyncJson updateUserInfo({
    String? nickName,
    String? thumb,
    String? intro,
  }) =>
      post('/updateUserInfo', data: {
        'nickname': nickName,
        'thumb': thumb,
        'intro': intro,
      });

  /// 扣币明细
  AsyncJson getListMoneyDetail({
    required int page,
    required int limit,
    required String type,
  }) =>
      post('/listMoneyDetail', data: {
        'limit': limit,
        'page': page,
        'type': type,
      });

  /// 清除缓存
  AsyncJson clearCached() => post('/clear_cached');

  /// 提现  银行卡列表
  AsyncJson cashBankCardList({
    required int page,
    required int limit,
  }) =>
      post('/list_bankcard', data: {
        'page': page,
        'limit': limit,
      });

  /// 提现  添加银行卡
  AsyncJson cashAddBankCard({
    required String card,
    required String name,
  }) =>
      post('/add_bankcard', data: {
        'card': card,
        'name': name,
      });

  /// 提现  删除银行卡
  AsyncJson cashDeleteBankCard({required int cardId}) =>
      post('/del_bankcard', data: {'id': cardId});

  /// 收益汇总
  AsyncJson earnTotalInfo({
    String source = '',
    required int page,
    required int limit,
    required String lastIx,
  }) =>
      post('/list_income_log', data: {
        'source': source,
        'page': page,
        'limit': limit,
        'last_ix': lastIx,
      });

  /// 我的帖子
  AsyncJson userMyPosts({
    String cate = 'release',
    required int page,
    required int limit,
  }) =>
      post('/my_posts', data: {
        'cate': cate,
        'page': page,
        'limit': limit,
      });

  /// 我收藏的
  AsyncJson getUserFavor({
    required int limit,
    required int page,
    required int type,
    required String lastIx,
  }) =>
      post('/getUserFavor', data: {
        'page': page,
        'limit': limit,
        'type': type,
        'last_ix': lastIx,
      });

  /// 用户收藏   type: 1 mv  2 book 3 story 4 link 5 soundBook 6pic
  AsyncJson userFavorites({
    required int type,
    required int id,
  }) =>
      post('/favorites', data: {
        'relatedId': id,
        'type': type,
      });

  /// 我购买的
  AsyncJson getUserBuy({
    required int limit,
    required int page,
    required int type,
  }) =>
      post('/getUserBuy', data: {
        'page': page,
        'limit': limit,
        'type': type,
      });

  /// 我的关注
  AsyncJson userListFollow({
    required int page,
    required int limit,
    required String lastIx,
  }) =>
      post('/list_follow', data: {
        'page': page,
        'limit': limit,
        'last_ix': lastIx,
      });

  /// 填写邀请码
  AsyncJson sendInvitation({
    required String affCode,
  }) =>
      post('/invitation', data: {'aff_code': affCode});
}
