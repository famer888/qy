import 'ai/ai_nav_model.dart';
import 'bit_seed_nav_model.dart';
import 'live/live_nav_model.dart';
import 'monitor/monitor_nav_model.dart';
import 'navigator_model.dart';

class HomeData {
  HomeData(
      {required this.versionMsg,
      this.timestamp,
      required this.config,
      this.notice,
      this.ads,
      this.popAds,
      this.help});

  final VersionMsg? versionMsg;
  final int? timestamp;
  final Notice? notice;
  final List<Notice>? popAds;
  final Config config;
  final AdModel? ads;
  final List<Help>? help;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
      versionMsg: json['versionMsg'] == null
          ? null
          : VersionMsg.fromJson(json['versionMsg']),
      notice: json['notice'] == null ? null : Notice.fromJson(json['notice']),
      timestamp: json['timestamp'],
      config: Config.fromJson(json['config']),
      ads: json['ads'] == null ? null : AdModel.fromJson(json['ads']),
      popAds: List<Notice>.from(
          json['pop_ads']?.map((x) => Notice.fromJson(x)) ?? []),
      help: List<Help>.from(json['help']?.map((e) => Help.fromJson(e))));
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
    this.github,
    this.officeSite,
    this.officialGroup,
    this.line,
    this.m3u8Encrypt,
    this.videoEncryptApi,
    this.videoEncryptReferer,
    this.videoEncryptM3u8,
    required this.vipLevelStr,
    required this.vipNameStr,
    required this.navId,
    this.lqNavid,
    this.dmNavid,
    this.mhNavid,
    this.awNavid,
    this.githubUrl,
    this.linesUrl,
    this.tipsShareText,
    this.girlCommentOption,
    this.shortSite,
    this.proxyJoinNum,
    this.solution,
    this.personAds,
    this.dayPrice,
    this.coverIds,
    this.coverVipStr,
    this.coverTips,
    this.sortNav,
    this.forumNav,
    this.seedSortNav,
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
    required this.faceCoins,
    required this.stripCoins,
    required this.liveTopNav,
    required this.monitorTopNav,
  });

  final String? dayPrice;
  final dynamic personAds;
  final String imgUploadUrl;
  final String? solution;
  final String? mp4UploadUrl;
  final String? mobileMp4UploadUrl;
  final String uploadImgKey;
  final String? uploadMp4Key;
  final String? uuid;
  final String? tipsShareText;
  final String? github;
  final String? officeSite;
  final String? officialGroup;
  final String? shortSite;
  final String imgBase;
  final List<String>? line;
  final int? m3u8Encrypt;
  final String? videoEncryptApi;
  final String? videoEncryptReferer;
  final String? videoEncryptM3u8;
  final List<String> vipLevelStr;
  final String vipNameStr;
  final int? navId;
  final int? lqNavid;
  final int? dmNavid;
  final int? mhNavid;
  final int? awNavid;
  final String? githubUrl;
  final List<String>? linesUrl;
  final String? girlCommentOption;
  final String? proxyJoinNum;
  final List<String>? coverIds;
  final List<String>? coverVipStr;
  final String? coverTips;
  final List<NavigatorModel>? sortNav;
  final List<NavigatorModel>? forumNav;
  final List<NavigatorModel>? seedSortNav;
  final List<BitSeedNavModel> seedNav;
  final List<AiNavModel> faceTopNav;
  final List<LiveNavModel> liveTopNav;
  final List<MonitorNavModel> monitorTopNav;

  final int payAi;
  final int? showApp;

  final String potatoGroup;
  final String tgGroup;

  final String seedVipTip;
  final String seedCoinsTip;
  final String wdaiStr;
  final List<String> vipLevelAwqStr;
  final String vipNameAwqStr;
  final int? faceCoins;
  final int? stripCoins;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        dayPrice: json['day_price'],
        personAds: json['person_ads'],
        imgUploadUrl: json['img_upload_url'],
        solution: json['solution'] ?? '',
        mp4UploadUrl: json['mp4_upload_url'],
        mobileMp4UploadUrl: json['mobile_mp4_upload_url'],
        uploadImgKey: json['upload_img_key'] ?? '',
        uploadMp4Key: json['upload_mp4_key'],
        uuid: json['uuid'],
        github: json['github'],
        officeSite: json['office_site'],
        officialGroup: json['official_group'],
        imgBase: json['img_base'],
        line: json['line']?.map((x) => x).toList(),
        m3u8Encrypt: json['m3u8_encrypt'],
        videoEncryptApi: json['video_encrypt_api'],
        videoEncryptReferer: json['video_encrypt_referer'],
        videoEncryptM3u8: json['video_encrypt_m3u8'],
        vipLevelStr:
            List<String>.from(json['vip_level_str']?.map((x) => x) ?? []),
        vipNameStr: json['vip_name_str'] ?? '',
        navId: json['nav_id'],
        lqNavid: json['lq_navid'],
        dmNavid: json['dm_navid'],
        mhNavid: json['mh_navid'],
        awNavid: json['aw_id'] ?? 0,
        shortSite: json['short_site'],
        githubUrl: json['github_url'],
        linesUrl: List<String>.from(json['lines_url']?.map((x) => x) ?? []),
        tipsShareText: json['tips_share_text'],
        girlCommentOption: json['girl_comment_option'] ??
            json['girl_comment_option'].toString(),
        proxyJoinNum: json['proxy_join_num']?.toString(),
        coverIds: List<String>.from(json['cover_ids']?.map((x) => x) ?? []),
        coverVipStr: json['cover_vip_str']?.map((x) => x).toList(),
        coverTips: json['cover_tips'],
        sortNav: List<NavigatorModel>.from(
            json['sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        forumNav: List<NavigatorModel>.from(
            json['forum_nav']?.map((x) => NavigatorModel.fromJson(x)) ?? []),
        seedSortNav: List<NavigatorModel>.from(
            json['seed_sort_nav']?.map((x) => NavigatorModel.fromJson(x)) ??
                []),
        seedNav: List<BitSeedNavModel>.from(
            json['seed_nav']?.map((x) => BitSeedNavModel.fromJson(x)) ?? []),
        payAi: json['pay_ai'] ?? 0,
        showApp: json['show_app'],
        potatoGroup: json['potato_group'] ?? '',
        tgGroup: json['tg_group'] ?? '',
        seedVipTip: json['seed_vip_tip'] ?? '',
        seedCoinsTip: json['seed_coins_tip'] ?? '',
        wdaiStr: json['wdai_str'] ?? '',
        faceCoins: json['face_coins'],
        vipLevelAwqStr:
            List<String>.from(json['vip_level_awq_str']?.map((x) => x) ?? []),
        vipNameAwqStr: json['vip_name_awq_str'] ?? '',
        faceTopNav: List<AiNavModel>.from(
            json['face_top_nav']?.map((x) => AiNavModel.fromJson(x)) ?? []),
        stripCoins: json['strip_coins'],
        liveTopNav: List<LiveNavModel>.from(
            json['live_top_nav']?.map((x) => LiveNavModel.fromJson(x)) ?? []),
        monitorTopNav: List<MonitorNavModel>.from(
            json['monitor_top_nav']?.map((x) => MonitorNavModel.fromJson(x)) ??
                []),
      );

  Map<String, dynamic> toJson() => {
        'day_price': dayPrice,
        'person_ads': personAds,
        'img_upload_url': imgUploadUrl,
        'solution': solution ?? '',
        'mp4_upload_url': mp4UploadUrl,
        'mobile_mp4_upload_url': mobileMp4UploadUrl,
        'upload_img_key': uploadImgKey,
        'upload_mp4_key': uploadMp4Key,
        'uuid': uuid,
        'github': github,
        'office_site': officeSite,
        'official_group': officialGroup,
        'img_base': imgBase,
        'line': line?.map((e) => e).toList(),
        'm3u8_encrypt': m3u8Encrypt,
        'video_encrypt_api': videoEncryptApi,
        'video_encrypt_referer': videoEncryptReferer,
        'video_encrypt_m3u8': videoEncryptM3u8,
        'vip_level_str': vipLevelStr.map((e) => e).toList(),
        'vip_name_str': vipNameStr,
        'nav_id': navId,
        'lq_navid': lqNavid,
        'dm_navid': dmNavid,
        'mh_navid': mhNavid,
        'aw_navid': awNavid,
        'short_site': shortSite,
        'github_url': githubUrl,
        'tips_share_text': tipsShareText,
        'lines_url': linesUrl?.map((e) => e).toList(),
        'girl_comment_option': girlCommentOption,
        'proxy_join_num': proxyJoinNum,
        'cover_ids': coverIds?.map((e) => e).toList(),
        'cover_vip_str': coverVipStr?.map((e) => e).toList(),
        'cover_tips': coverTips,
        'sort_nav': sortNav?.map((x) => x).toList() ?? [],
        'forum_nav': forumNav?.map((e) => e).toList() ?? [],
        'seed_nav': seedNav.map((e) => e).toList(),
        'seed_sort_nav': seedSortNav?.map((e) => e).toList() ?? [],
        'pay_ai': payAi,
        'show_app': showApp,
        'potato_group': potatoGroup,
        'tg_group': tgGroup,
        'seed_vip_tip': seedVipTip,
        'seed_coins_tip': seedCoinsTip,
        'face_coins': faceCoins,
        'face_top_nav': faceTopNav.map((e) => e).toList(),
        'strip_coins': stripCoins,
        'live_top_nav': liveTopNav.map((e) => e).toList(),
        'monitor_top_nav': monitorTopNav.map((e) => e).toList(),
      };
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
