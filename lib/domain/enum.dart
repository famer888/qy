enum MyTokenStatus {
  /// Token失效
  invalid,

  /// 登录会员
  valid,
}

enum MyMediaType {
  /// 图片,
  image,

  /// 视频
  video,
}

enum MyLikeType {
  /// 帖子
  post,

  /// 评论
  comment,
}

enum MyProductType {
  /// 会员
  vip,

  /// 金币
  coin;

  int get id => switch (this) {
        MyProductType.vip => 1,
        MyProductType.coin => 2,
      };
}

enum MyCoinFilterType {
  /// 全部
  all,

  /// 收入
  income,

  /// 支出
  expenditure;

  String get stringType => switch (this) {
        MyCoinFilterType.all => '',
        MyCoinFilterType.income => '1',
        MyCoinFilterType.expenditure => '2',
      };
}

enum MyModuleType {
  _,

  /// 长视频
  video,

  /// 短视频
  shortVideo,

  /// 漫画
  comic,

  /// 帖子
  article,

  /// 种子
  bit,

  /// 语音
  voice,

  /// 直播
  live,

  /// 动漫
  cartoon,

  /// 黄游
  hGame,

  /// 小说
  novel,
}
