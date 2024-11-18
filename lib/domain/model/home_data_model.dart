import 'ai/ai_nav_model.dart';
import 'novel/novel_nav_model.dart';
import 'novel/novel_sort_nav_model.dart';
import 'novel/novel_type_nav_model.dart';
import 'rank_nav_model.dart';
import 'seed/seed_sort_model.dart';
import 'comic/comic_nav_model.dart';
import 'comic/comic_sort_nav_model.dart';
import 'comic/comic_type_nav_model.dart';
import 'live/live_nav_model.dart';
import 'monitor/monitor_nav_model.dart';
import 'navigator_model.dart';

class HomeData {
  HomeData({
    required this.versionMsg,
    required this.config,
    this.notice,
    this.ads,
    required this.popAds,
    required this.help,
  });

  final VersionMsg? versionMsg;
  final Notice? notice;
  final List<Notice> popAds;
  final Config config;
  final AdModel? ads;
  final List<Help> help;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        versionMsg: json['versionMsg'] == null
            ? null
            : VersionMsg.fromJson(json['versionMsg']),
        notice: json['notice'] == null ? null : Notice.fromJson(json['notice']),
        config: Config.fromJson(json['config']),
        ads: json['ads'] == null ? null : AdModel.fromJson(json['ads']),
        popAds: List<Notice>.from(
            json['pop_ads']?.map((x) => Notice.fromJson(x)) ?? []),
        help: List<Help>.from(json['help']?.map((x) => Help.fromJson(x)) ?? []),
      );
}

class AdModel {
  AdModel(
      {this.id,
      this.title,
      this.description,
      this.imgUrl,
      this.url,
      this.position,
      this.androidDownUrl,
      this.iosDownUrl,
      this.type,
      this.status,
      this.oauthType,
      this.mvM3U8,
      this.channel,
      this.createdAt,
      this.subTitle});

  final int? id;
  final String? title;
  final String? description;
  final String? imgUrl;
  final String? url;
  final int? position;
  final String? androidDownUrl;
  final String? iosDownUrl;
  final int? type;
  final int? status;
  final int? oauthType;
  final String? mvM3U8;
  final String? channel;
  final String? createdAt;
  final String? subTitle;

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imgUrl: json['img_url'],
      url: json['url'],
      position: json['position'],
      androidDownUrl: json['android_down_url'],
      iosDownUrl: json['ios_down_url'],
      type: json['type'],
      status: json['status'],
      oauthType: json['oauth_type'],
      mvM3U8: json['mv_m3u8'],
      channel: json['channel'],
      createdAt: json['created_at'].toString(),
      subTitle: json['sub_title']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'img_url': imgUrl,
        'url': url,
        'position': position,
        'android_down_url': androidDownUrl,
        'ios_down_url': iosDownUrl,
        'type': type,
        'status': status,
        'oauth_type': oauthType,
        'mv_m3u8': mvM3U8,
        'channel': channel,
        'created_at': createdAt,
        'sub_title': subTitle
      };
}

class Config {
  Config({
    required this.imgBase,
    required this.imgUploadUrl,
    this.mp4UploadUrl,
    this.mobileMp4UploadUrl,
    required this.uploadImgKey,
    this.uploadMp4Key,
    this.uuid,
    this.officeSite,
    this.officialGroup,
    this.line,
    required this.vipLevelStr,
    required this.vipNameStr,
    required this.navId,
    this.awNavid,
    this.githubUrl,
    this.linesUrl,
    this.tipsShareText,
    this.proxyJoinNum,
    this.solution,
    this.sortNav,
    required this.forumNav,
    required this.seedNav,
    this.showApp,
    required this.potatoGroup,
    required this.tgGroup,
    required this.payAi,
    required this.seedVipTip,
    required this.seedCoinsTip,
    required this.wdaiStr,
    required this.vipLevelAwqStr,
    required this.vipNameAwqStr,
    required this.faceTopNav,
    required this.faceSortNav,
    required this.faceCoins,
    required this.stripCoins,
    required this.liveTopNav,
    required this.monitorTopNav,
    required this.comicTopNav,
    required this.comicSortNav,
    required this.comicTypeNav,
    required this.mvSecondSortNav,
    required this.mvDiscoverSortNav,
    required this.novelNav,
    required this.novelTypeNav,
    required this.novelSortNav,
    required this.rankTopNav,
    required this.rankCycleNav,
    required this.circleNav,
    required this.resourceNav,
    this.openLive,
    this.navPrepend,
  });

  final String imgUploadUrl;
  final String? solution;
  final String? mp4UploadUrl;
  final String? mobileMp4UploadUrl;
  final String uploadImgKey;
  final String? uploadMp4Key;
  final String? uuid;
  final String? tipsShareText;
  final String? officeSite;
  final String? officialGroup;
  final String imgBase;
  final List<String>? line;
  final List<String> vipLevelStr;
  final String vipNameStr;

  final String? githubUrl;
  final List<String>? linesUrl;
  final String? proxyJoinNum;

  final List<PreTopNavModel>? navPrepend;

  final int? navId;
  final int? awNavid;

  final int? openLive;

  ///视频
  final List<NavigatorModel>? sortNav;
  final List<NavigatorModel> mvDiscoverSortNav;
  final List<NavigatorModel> mvSecondSortNav;
  final List<NavigatorModel> resourceNav;
  final List<RankNavModel> rankTopNav;
  final List<RankNavModel> rankCycleNav;

  ///社区
  final List<NavigatorModel> forumNav;

  ///圈子
  final List<NavigatorModel> circleNav;

  ///种子
  final List<SeedSortModel> seedNav;

  final List<AiFaceTopicModel> faceTopNav; //AI换脸分类
  final List<AiFaceSortModel> faceSortNav; //AI换脸排序
  ///直播
  final List<LiveNavModel> liveTopNav; //直播分类
  ///监控
  final List<MonitorNavModel> monitorTopNav; //监控分类

  ///漫画
  final List<ComicNavModel> comicTopNav; //漫画分类
  final List<ComicSortNavModel> comicSortNav; //漫画排序
  final List<ComicTypeNavListModel> comicTypeNav; //漫画排序条件

  ///小说
  final List<NovelNavModel> novelNav; //小说分类
  final List<NovelSortNavModel> novelSortNav; //小说排序
  final List<NovelTypeNavListModel> novelTypeNav; //小说排序条件

  final int payAi;
  final int? showApp;

  final String potatoGroup;
  final String tgGroup;

  final String seedVipTip;
  final String seedCoinsTip;
  final String wdaiStr;
  final List<String> vipLevelAwqStr;
  final String vipNameAwqStr;
  final int faceCoins;
  final int stripCoins;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        imgUploadUrl: json['img_upload_url'],
        solution: json['solution'] ?? '',
        mp4UploadUrl: json['mp4_upload_url'],
        mobileMp4UploadUrl: json['mobile_mp4_upload_url'],
        uploadImgKey: json['upload_img_key'] ?? '',
        uploadMp4Key: json['upload_mp4_key'],
        uuid: json['uuid'],
        officeSite: json['office_site'],
        officialGroup: json['official_group'],
        imgBase: json['img_base'],
        line: json['line']?.map((x) => x).toList(),
        vipLevelStr:
            List<String>.from(json['vip_level_str']?.map((x) => x) ?? []),
        vipNameStr: json['vip_name_str'] ?? '',
        navId: json['nav_id'],
        awNavid: json['aw_id'] ?? 0,
        githubUrl: json['github_url'],
        linesUrl: List<String>.from(json['lines_url']?.map((x) => x) ?? []),
        tipsShareText: json['tips_share_text'],
        proxyJoinNum: json['proxy_join_num']?.toString(),
        sortNav: List<NavigatorModel>.from(
            json['sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        mvSecondSortNav: List<NavigatorModel>.from(json['mv_second_sort_nav']
                ?.map((x) => NavigatorModel.fromJson(x)) ??
            []),
        resourceNav: List<NavigatorModel>.from(
            json['resource_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        mvDiscoverSortNav: List<NavigatorModel>.from(
            json['mv_discover_sort_nav']
                    ?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        forumNav: List<NavigatorModel>.from(
            json['forum_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        circleNav: List<NavigatorModel>.from(
            json['circle_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        seedNav: List<SeedSortModel>.from(
            json['seed_nav']?.map((x) => SeedSortModel.fromJson(x)) ?? []),
        payAi: json['pay_ai'] ?? 0,
        showApp: json['show_app'],
        potatoGroup: json['potato_group'] ?? '',
        tgGroup: json['tg_group'] ?? '',
        seedVipTip: json['seed_vip_tip'] ?? '',
        seedCoinsTip: json['seed_coins_tip'] ?? '',
        wdaiStr: json['wdai_str'] ?? '',
        faceCoins: json['face_coins'] ?? 0,
        vipLevelAwqStr:
            List<String>.from(json['vip_level_awq_str']?.map((x) => x) ?? []),
        vipNameAwqStr: json['vip_name_awq_str'] ?? '',
        faceTopNav: List<AiFaceTopicModel>.from(
            json['face_top_nav']?.map((x) => AiFaceTopicModel.fromJson(x)) ??
                []),
        faceSortNav: List<AiFaceSortModel>.from(
            json['face_sort_nav']?.map((x) => AiFaceSortModel.fromJson(x)) ??
                []),
        stripCoins: json['strip_coins'] ?? 0,
        liveTopNav: List<LiveNavModel>.from(
            json['live_top_nav']?.map((x) => LiveNavModel.fromJson(x)) ?? []),
        monitorTopNav: List<MonitorNavModel>.from(
            json['monitor_top_nav']?.map((x) => MonitorNavModel.fromJson(x)) ??
                []),
        comicTopNav: List<ComicNavModel>.from(
            json['comic_top_nav']?.map((x) => ComicNavModel.fromJson(x)) ?? []),
        comicSortNav: List<ComicSortNavModel>.from(
            json['comic_sort_nav']?.map((x) => ComicSortNavModel.fromJson(x)) ??
                []),
        comicTypeNav: List<ComicTypeNavListModel>.from(json['comic_type_nav']
                ?.map((x) => ComicTypeNavListModel.fromJson(x)) ??
            []),
        navPrepend: List<PreTopNavModel>.from(
            json['nav_prepend']?.map((x) => PreTopNavModel.fromJson(x)) ?? []),
        novelNav: List<NovelNavModel>.from(
            json['novel_nav']?.map((x) => NovelNavModel.fromJson(x)) ?? []),
        novelTypeNav: List<NovelTypeNavListModel>.from(json['novel_type_nav']
                ?.map((x) => NovelTypeNavListModel.fromJson(x)) ??
            []),
        novelSortNav: List<NovelSortNavModel>.from(
            json['novel_sort']?.map((x) => NovelSortNavModel.fromJson(x)) ??
                []),
        rankTopNav: List<RankNavModel>.from(
            json['rank_top_nav']?.map((x) => RankNavModel.fromJson(x)) ?? []),
        rankCycleNav: List<RankNavModel>.from(
            json['rank_cycle_nav']?.map((x) => RankNavModel.fromJson(x)) ?? []),
        openLive: json['open_live'],
      );
}

class Notice {
  Notice({
    this.id,
    this.imgUrl,
    this.router,
    this.type,
    this.height,
    this.width,
    this.urlStr,
    this.reportId,
    this.reportType,
  });

  final int? id;
  final String? imgUrl;
  final String? router;
  final String? type;
  final int? height;
  final int? width;
  final String? urlStr;
  final int? reportId;
  final int? reportType;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json['id'] ?? 0,
        imgUrl: json['img_url'] ?? '',
        router: json['router'] ?? '',
        type: json['type'] ?? '',
        height: json['height'] ?? 100,
        width: json['width'] ?? 100,
        urlStr: json['url_str'] ?? '',
        reportId: json['report_id'] ?? 0,
        reportType: json['report_type'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'img_url': imgUrl,
        'router': router,
        'type': type,
        'height': height,
        'width': width,
        'url_str': urlStr,
        'report_id': reportId,
        'report_type': reportType,
      };
}

class VersionMsg {
  VersionMsg({
    this.version,
    this.type,
    this.apk,
    this.tips,
    this.must,
    this.status,
    this.message,
    this.mstatus,
    this.channel,
  });

  /// 版本号
  final String? version;
  final String? type;

  /// 更新app用下载网址
  final String? apk;

  /// 更新描述
  final String? tips;

  /// 更新开关 0 不更新  1 强制更新 2 非强制更新
  final int? must;
  final int? status;

  /// 公告描述
  final String? message;

  /// 系统公告状态 0 没有 1通知 2禁用
  final int? mstatus;
  final String? channel;

  factory VersionMsg.fromJson(Map<String, dynamic> json) => VersionMsg(
        version: json['version'],
        type: json['type'],
        apk: json['apk'],
        tips: json['tips'],
        must: json['must'],
        status: json['status'],
        message: json['message'],
        mstatus: json['mstatus'],
        channel: json['channel'],
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'type': type,
        'apk': apk,
        'tips': tips,
        'must': must,
        'status': status,
        'message': message,
        'mstatus': mstatus,
        'channel': channel,
      };
}

class Help {
  Help({
    required this.items,
    required this.type,
    required this.name,
  });
  final List<HelpItem> items;
  final int type;
  final String name;

  factory Help.fromJson(Map<String, dynamic> json) => Help(
        items: List.from(json['items'].map((x) => HelpItem.fromJson(x))),
        type: json['type'],
        name: json['name'],
      );
}

class HelpItem {
  HelpItem(
      {required this.id,
      required this.question,
      required this.answer,
      required this.status,
      required this.type,
      required this.views,
      required this.createdAt,
      required this.updatedAt});
  final int id;
  final String question;
  final String answer;
  final int status;
  final int type;
  final int? views;
  final String createdAt;
  final String updatedAt;

  factory HelpItem.fromJson(Map<String, dynamic> json) => HelpItem(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      status: json['status'],
      type: json['type'],
      views: json['views'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at']);
}

class PreTopNavModel {
  PreTopNavModel({
    required this.title,
    required this.id,
  });

  final String title;
  final int id;

  factory PreTopNavModel.fromJson(Map<String, dynamic> json) => PreTopNavModel(
        title: json['title'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'id': id,
      };
}
