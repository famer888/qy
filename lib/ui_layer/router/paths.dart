import '../../app_config.dart';

class AppRouterPaths {
  static const root = '/';

  /// 登入
  static const login = '/login';

  /// 浅网
  static const home = '/home';

  /// 禁区
  static const jq = '/jq';

  /// 圈子
  static const qz = '/qz';

  /// 社区
  static const community = '/community';

  /// 下载
  static const xz = '/xz';

  /// 我的
  static const mine = '/mine';

  /// 标签视频列表
  static const moreVideo = '/moreVideo/:name/:id';

  /// 更多推荐视频列表
  static const moreRecommendVideo = '/moreRecommendVideo/:name/:id/:type';

  /// 搜索
  static const search = '/search';

  /// 搜索结果
  static const searchResult = '/searchResult/:title';

  /// 社区标签
  static const communityTagDetail = '/communityTagDetail';

  /// 社区帖子详情
  static const communityTieztDetail = '/communityTieztDetail/:id';

  /// 社区发布帖子
  static const communityIssue = '/communityIssue/:type/:circle';

  /// 社区选择版块
  static const communityModule = '/communityModule';

  /// 约炮发布
  static const girlIssue = '/girlIssue';

  /// 约炮 详情
  static const girlDetail = '/girlDetail';

  /// 裸聊发布
  static const chatIssue = '/chatIssue';

  /// 裸聊 详情
  static const chatDetail = '/chatDetail';

  /// 下载帖子详情
  static const bitPostDetail = '/bitPostDetail/:id';

  /// 我的 - VIP充值
  static const mineVipCenter = '/vip';

  /// 我的 - VIP升级
  static const vipUpgrade = '/vipUpgrade';

  /// 我的 - 金币充值
  static const mineCoinRecharge = '/coinRecharge';

  /// 我的 - 金币明细
  static const mineCoinDetail = '/mineCoinDetail';

  /// 我的 - 充值记录
  static const mineRechargeRecord = '/mineRechargeRecord/:type';

  /// 我的 - 帖子
  static const minePost = '/minePost';

  /// 我的 - 收藏
  static const mineCollection = '/mineCollection';

  /// 我的 - 关注
  static const mineFansFollow = '/mineFansFollow';

  /// 我的 - 原创入驻
  static const mineOriginalEnter = '/mineOriginalEnter';

  /// 我的 - 购买
  static const mineBuy = '/mineBuy';

  /// 我的 - 下载
  static const mineDownload = '/mineDownload';

  /// 我的 - 邀请码/兑换码/编辑用户名
  static const mineFillCode = '/mineFillCode/:title';

  /// 我的 - 帮助
  static const mineHelp = '/mineHelp';

  /// 我的 - 官方交流群
  static const mineOfficialGroup = '/mineOfficialGroup';

  /// 我的 - 客服消息
  static const customerService = '/customerService';

  /// 我的 - 系统消息
  static const mineSystemMessage = '/mineSystemMessage';

  /// 我的 - 消息中心
  static const mineMessageCenter = '/mineMessageCenter';

  /// 我的 - 设置
  static const mineSetup = '/mineSetup';

  /// 我的 - 去推广
  static const mineShareToUser = '/mineShareToUser';

  /// 我的 - 推广记录
  static const mineShareToUserRecord = '/mineShareToUserRecord';

  /// 我的 - 福利
  static const mineWelfare = '/mineWelfare/:index';

  /// 代理 - 赚钱
  static const mineAgent = '/mineAgent';

  /// 代理 - 明细
  static const mineAgentProfit = '/mineAgentProfit';

  /// 代理 - 推广数据
  static const mineAgentPromoteData = '/mineAgentPromoteData';

  /// 我的 - 提现
  static const mineWithdrawal = '/mineWithdrawal/:isAgent';

  /// 我的 - 提现 - 明细
  static const mineWithdrawalRecord = '/mineWithdrawalRecord';

  /// 我的 - 提现 - 银行卡列表
  static const mineWithdrawalBankList = '/mineWithdrawalBankList';

  /// 我的 - 收益明细
  static const mineIncomeDetail = '/mineIncomeDetail';

  /// 我的 - 关注
  static const mineFollowing = '/mineFollowing';

  /// 我的 - AI
  static const mineAIRecord = '/minAIRecord';

  /// 我的 - 申请入驻
  static const originalEnter = '/originalEnter';

  /// 用户中心
  static const userCenter = '/userCenter/:aff';

  /// IM聊天
  static const chatMessage = '/chatMessage/:toUuid/:nickName/:thumb';

  /// 长视频详情页
  static const videoDetail = '/videoDetail';

  static const mediaViewer = '/mediaViewer';

  static const localVideo = '/localVideo';

  static const webView = '/${BuildConfig.webViewPathName}/:url';

  /// 直播视频详情页
  static const liveVideoDetail = '/liveVideoDetail';

  /// 监控视频详情页
  static const monitorVideoDetail = '/monitorVideoDetail';

  /// 漫画
  // 更多漫画列表
  static const moreComic = '/moreComic/:title/:sort';

  // 分类漫画列表
  static const sortComic = '/sortComic';

  // 最新漫画列表
  static const newComic = '/newComic';

  // 完结漫画列表
  static const endComic = '/endComic';

  // 排行榜漫画列表
  static const rankComic = '/rankComic';

  // 漫画详情
  static const comicDetail = '/comicDetail';

  // 漫画阅读界面
  static const comicReader = '/comicReader';

  /// 小说
  // 小说详情
  static const novelDetail = '/novelDetail';

  // 小说全部章节
  static const novelChapters = '/novelChapters';

  // 小说阅读界面
  static const novelReader = '/novelReader';

  // 更多小说列表
  static const moreNovel = '/moreNovel/:title/:sort';

  // 小说分类列表
  static const novelSort = '/novelSort';

  // 小说最新列表
  static const novelNew = '/novelNew';

  // 小说连载列表
  static const noveUpdating = '/noveUpdating';

  // 小说完结列表
  static const novelEnd = '/novelEnd';

  /// ai科技
  static const aiService = '/aiService';

  /// ai科技
  static const aiMagicDetail = '/aiMagicDetail';

  /// 精采发现
  static const discovery = '/discovery';

  /// 榜单
  static const rankList = '/rankList';
}
