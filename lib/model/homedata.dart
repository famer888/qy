// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

import 'dart:convert';

import 'package:qypj/model/appcenter.dart';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  HomeData({
    this.data,
    this.status,
    this.msg,
    this.crypt,
    this.isVip,
    this.line,
  });

  Data data;
  int status;
  String msg;
  bool crypt;
  bool isVip;
  String line;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        crypt: json["crypt"] == null ? null : json["crypt"],
        isVip: json["isVip"] == null ? null : json["isVip"],
        line: json["line"] == null ? null : json["line"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data.toJson(),
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "crypt": crypt == null ? null : crypt,
        "isVip": isVip == null ? null : isVip,
        "line": line == null ? null : line,
      };
}

class Data {
  Data({
    this.versionMsg,
    this.timestamp,
    this.config,
    this.notice,
    this.ads,
    this.pop_ads,
  });

  VersionMsg versionMsg;
  int timestamp;
  Notice notice;
  List<Notice> pop_ads;
  Config config;
  Ads ads;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        versionMsg: json["versionMsg"] == null
            ? null
            : VersionMsg.fromJson(json["versionMsg"]),
        notice: json["notice"] == null ? null : Notice.fromJson(json["notice"]),
        timestamp: json["timestamp"] == null ? null : json["timestamp"],
        config: json["config"] == null ? null : Config.fromJson(json["config"]),
        ads: json["ads"] == null ? null : Ads.fromJson(json["ads"]),
        pop_ads: json["pop_ads"] == null
            ? []
            : List.from(json["pop_ads"].map((x) => Notice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "versionMsg": versionMsg == null ? null : versionMsg.toJson(),
        "timestamp": timestamp == null ? null : timestamp,
        "notice": notice == null ? null : notice.toJson(),
        "config": config == null ? null : config.toJson(),
        "ads": ads == null ? null : ads.toJson(),
        "pop_ads": pop_ads.map((e) => e.toJson()),
      };
}

class Ads {
  Ads({
    this.id,
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
    this.report_id,
    this.report_type,
  });

  int id;
  String title;
  String description;
  String imgUrl;
  String url;
  int position;
  String androidDownUrl;
  String iosDownUrl;
  int type;
  int status;
  int oauthType;
  String mvM3U8;
  String channel;
  String createdAt;
  int report_id;
  int report_type;

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        imgUrl: json["img_url"],
        url: json["url"],
        position: json["position"],
        androidDownUrl: json["android_down_url"],
        iosDownUrl: json["ios_down_url"],
        type: json["type"],
        status: json["status"],
        oauthType: json["oauth_type"],
        mvM3U8: json["mv_m3u8"],
        channel: json["channel"],
        createdAt: json["created_at"].toString(),
        report_id: json['report_id'] ?? 0,
        report_type: json['report_type'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "img_url": imgUrl,
        "url": url,
        "position": position,
        "android_down_url": androidDownUrl,
        "ios_down_url": iosDownUrl,
        "type": type,
        "status": status,
        "oauth_type": oauthType,
        "mv_m3u8": mvM3U8,
        "channel": channel,
        "created_at": createdAt,
        "report_id": report_id,
        "report_type": report_type,
      };
}

class Config {
  Config({
    this.imgUploadUrl,
    this.mp4UploadUrl,
    this.mobileMp4UploadUrl,
    this.uploadImgKey,
    this.uploadMp4Key,
    this.uuid,
    this.github,
    this.officeSite,
    this.officialGroup,
    this.imgBase,
    this.line,
    this.m3u8_encrypt,
    this.video_encrypt_api,
    this.video_encrypt_referer,
    this.video_encrypt_m3u8,
    this.nav_id,
    this.dm_navid,
    this.mh_navid,
    this.github_url,
    this.lines_url,
    this.tips_share_text,
    this.girl_comment_option,
    this.short_site,
    this.proxy_join_num,
    this.solution,
    this.person_ads,
    this.day_price,
    this.buoy,
    this.show_app,
    this.tg_group,
    this.potato_group,
    this.sort_nav,
    this.forum_nav,
  });

  String day_price;
  dynamic person_ads;
  String imgUploadUrl;
  String solution;
  String mp4UploadUrl;
  String mobileMp4UploadUrl;
  String uploadImgKey;
  String uploadMp4Key;
  String uuid;
  String tips_share_text;
  String github;
  String officeSite;
  String officialGroup;
  String short_site;
  String imgBase;
  List<dynamic> line;
  String m3u8_encrypt;
  String video_encrypt_api;
  String video_encrypt_referer;
  String video_encrypt_m3u8;
  int nav_id = 7;
  int dm_navid = 0;
  int mh_navid = 0;
  String github_url;
  List<dynamic> lines_url;
  String girl_comment_option;
  String proxy_join_num;
  List<dynamic> buoy;
  int show_app;
  String tg_group;
  String potato_group;
  List<dynamic> sort_nav;
  List<dynamic> forum_nav;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        day_price: json["day_price"] == null ? null : json["day_price"],
        person_ads: json["person_ads"] == null ? null : json["person_ads"],
        imgUploadUrl:
            json["img_upload_url"] == null ? null : json["img_upload_url"],
        solution: json["solution"] == null ? "" : json["solution"],
        mp4UploadUrl:
            json["mp4_upload_url"] == null ? null : json["mp4_upload_url"],
        mobileMp4UploadUrl: json["mobile_mp4_upload_url"] == null
            ? null
            : json["mobile_mp4_upload_url"],
        uploadImgKey:
            json["upload_img_key"] == null ? null : json["upload_img_key"],
        uploadMp4Key:
            json["upload_mp4_key"] == null ? null : json["upload_mp4_key"],
        uuid: json["uuid"] == null ? null : json["uuid"],
        github: json["github"] == null ? null : json["github"],
        officeSite: json["office_site"] == null ? null : json["office_site"],
        officialGroup:
            json["official_group"] == null ? null : json["official_group"],
        imgBase: json["img_base"] == null ? null : json["img_base"],
        line: json["line"] == null
            ? null
            : List<dynamic>.from(json["line"].map((x) => x)),
        buoy: json["buoy"] == null
            ? null
            : List<dynamic>.from(json["buoy"].map((x) => x)),
        m3u8_encrypt: json['m3u8_encrypt'] == null
            ? null
            : json['m3u8_encrypt'].toString(),
        video_encrypt_api: json["video_encrypt_api"] == null
            ? null
            : json["video_encrypt_api"],
        video_encrypt_referer: json["video_encrypt_referer"] == null
            ? null
            : json["video_encrypt_referer"],
        video_encrypt_m3u8: json["video_encrypt_m3u8"] == null
            ? null
            : json["video_encrypt_m3u8"],
        nav_id: json["nav_id"],
        dm_navid: json["dm_navid"],
        mh_navid: json["mh_navid"],
        short_site: json["short_site"] == null ? null : json["short_site"],
        github_url: json["github_url"] == null ? null : json["github_url"],
        lines_url: json["lines_url"] == null
            ? null
            : List<dynamic>.from(
                json["lines_url"].map((x) => x),
              ),
        tips_share_text:
            json["tips_share_text"] == null ? null : json["tips_share_text"],
        girl_comment_option: json['girl_comment_option'] == null
            ? null
            : json['girl_comment_option'].toString(),
        proxy_join_num: json['proxy_join_num'] == null
            ? null
            : json['proxy_join_num'].toString(),
        show_app: json['show_app'],
        potato_group: json['potato_group'] ?? '',
        tg_group: json['tg_group'] ?? '',
        sort_nav: json["sort_nav"] == null
            ? []
            : List<dynamic>.from(
                json["sort_nav"].map((x) => x),
              ),
        forum_nav: json["forum_nav"] == null
            ? []
            : List<dynamic>.from(
                json["forum_nav"].map((x) => x),
              ),
      );

  Map<String, dynamic> toJson() => {
        "day_price": day_price == null ? null : day_price,
        "person_ads": person_ads == null ? null : person_ads,
        "img_upload_url": imgUploadUrl == null ? null : imgUploadUrl,
        "solution": solution == null ? "" : solution,
        "mp4_upload_url": mp4UploadUrl == null ? null : mp4UploadUrl,
        "mobile_mp4_upload_url":
            mobileMp4UploadUrl == null ? null : mobileMp4UploadUrl,
        "upload_img_key": uploadImgKey == null ? null : uploadImgKey,
        "upload_mp4_key": uploadMp4Key == null ? null : uploadMp4Key,
        "uuid": uuid == null ? null : uuid,
        "github": github == null ? null : github,
        "office_site": officeSite == null ? null : officeSite,
        "official_group": officialGroup == null ? null : officialGroup,
        "img_base": imgBase == null ? null : imgBase,
        "line": line == null ? null : List<dynamic>.from(line.map((x) => x)),
        "m3u8_encrypt": m3u8_encrypt == null ? null : m3u8_encrypt,
        "video_encrypt_api":
            video_encrypt_api == null ? null : video_encrypt_api,
        "video_encrypt_referer":
            video_encrypt_referer == null ? null : video_encrypt_referer,
        "video_encrypt_m3u8":
            video_encrypt_m3u8 == null ? null : video_encrypt_m3u8,
        "nav_id": nav_id,
        "dm_navid": dm_navid,
        "mh_navid": mh_navid,
        "short_site": short_site,
        "github_url": github_url,
        "tips_share_text": tips_share_text,
        "lines_url": lines_url == null
            ? null
            : List<dynamic>.from(lines_url.map((x) => x)),
        "girl_comment_option":
            girl_comment_option == null ? null : girl_comment_option,
        "proxy_join_num": proxy_join_num == null ? null : proxy_join_num,
        "buoy": buoy == null ? null : List<dynamic>.from(buoy.map((x) => x)),
        "sort_nav":
            sort_nav == null ? [] : List<dynamic>.from(sort_nav.map((x) => x)),
        "show_app": show_app,
        "potato_group": potato_group,
        "tg_group": tg_group,
        "forum_nav": forum_nav == null
            ? []
            : List<dynamic>.from(forum_nav.map((x) => x)),
      };
}

class Share {
  Share({
    this.affUrlCopy,
    this.affCode,
    this.affUrl,
  });

  AffUrlCopy affUrlCopy;
  String affCode;
  String affUrl;

  factory Share.fromJson(Map<String, dynamic> json) => Share(
        affUrlCopy: json["aff_url_copy"] == null
            ? null
            : AffUrlCopy.fromJson(json["aff_url_copy"]),
        affCode: json["aff_code"] == null ? null : json["aff_code"],
        affUrl: json["aff_url"] == null ? null : json["aff_url"],
      );

  Map<String, dynamic> toJson() => {
        "aff_url_copy": affUrlCopy == null ? null : affUrlCopy.toJson(),
        "aff_code": affCode == null ? null : affCode,
        "aff_url": affUrl == null ? null : affUrl,
      };
}

class AffUrlCopy {
  AffUrlCopy({
    this.code,
    this.url,
  });

  String code;
  String url;

  factory AffUrlCopy.fromJson(Map<String, dynamic> json) => AffUrlCopy(
        code: json["code"] == null ? null : json["code"],
        url: json["url"] == null ? null : json["url"],
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "url": url == null ? null : url,
      };
}

class Member {
  Member({
    this.uid,
    this.uuid,
    this.username,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.gender,
    this.regip,
    this.regdate,
    this.lastip,
    this.lastvisit,
    this.expiredAt,
    this.lastpost,
    this.oltime,
    this.pageviews,
    this.score,
    this.aff,
    this.channel,
    this.invitedBy,
    this.invitedNum,
    this.banPost,
    this.loginCount,
    this.appVersion,
    this.validate,
    this.share,
    this.isLogin,
    this.nickname,
    this.thumb,
    this.coins,
    this.money,
    this.incomeMoney,
    this.roleType,
    this.tempVip,
    this.followedCount,
    this.videosCount,
    this.fabulousCount,
    this.likesCount,
    this.commentCount,
    this.vipLevel,
    this.personSignnatrue,
    this.oldVip,
    this.stature,
    this.interest,
    this.city,
    this.usedMoneyFreeNum,
    this.agentFee,
    this.agent,
    this.buildId,
    this.authStatus,
    this.exp,
    this.exp_con,
    this.exp_down,
    this.isVirtual,
    this.chatUid,
    this.phone,
    this.phonePrefix,
    this.freeViewCnt,
    this.lastactivity,
    this.thumbStr,
    this.oauthStr,
    this.isSetPassword,
    this.level,
    this.new_user,
    this.shortMvFreeTime,
    this.longMvFreeTime,
    this.video_download_value,
    this.reg_tip,
    this.ads,
    this.is_follow,
    this.post_count,
    this.fans_count,
    this.vip_str,
  });

  int is_follow;
  int post_count;
  int fans_count;
  int uid;
  bool new_user;
  int video_download_value;
  String uuid;
  String reg_tip;
  String username;
  String createdAt;
  String updatedAt;
  int roleId;
  int gender;
  String regip;
  String regdate;
  String lastip;
  String lastvisit;
  dynamic expiredAt;
  int lastpost;
  int oltime;
  int pageviews;
  int score;
  int aff;
  String channel;
  dynamic invitedBy;
  int invitedNum;
  int banPost;
  int loginCount;
  String appVersion;
  int validate;
  Share share;
  int isLogin;
  String nickname;
  String thumb;
  int coins;
  int money;
  int incomeMoney;
  List roleType;
  int tempVip;
  int followedCount;
  int videosCount;
  int fabulousCount;
  int likesCount;
  int commentCount;
  int vipLevel;
  String vip_str;
  String personSignnatrue;
  int oldVip;
  int stature;
  String interest;
  String city;
  int usedMoneyFreeNum;
  int agentFee;
  int agent;
  int buildId;
  int authStatus;
  int exp;
  int exp_con;
  int exp_down;
  String isVirtual;
  String chatUid;
  dynamic phone;
  dynamic phonePrefix;
  int freeViewCnt;
  String lastactivity;
  dynamic thumbStr;
  String oauthStr;
  int isSetPassword;
  int level;
  Banner ads;
  int shortMvFreeTime;
  int longMvFreeTime;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
      post_count: json["post_count"] == null ? 0 : json["post_count"],
      fans_count: json["fans_count"] == null ? 0 : json["fans_count"],
      is_follow: json["is_follow"] == null ? 0 : json["is_follow"],
      uid: json["uid"] == null ? null : json["uid"],
      video_download_value: json["video_download_value"] == null
          ? 0
          : json["video_download_value"],
      shortMvFreeTime:
          json["shortMvFreeTime"] == null ? null : json["shortMvFreeTime"],
      longMvFreeTime:
          json["longMvFreeTime"] == null ? null : json["longMvFreeTime"],
      new_user: json["new_user"] == null ? false : json["new_user"],
      uuid: json["uuid"] == null ? null : json["uuid"],
      reg_tip: json["reg_tip"] == null ? "" : json["reg_tip"],
      username: json["username"] == null ? null : json["username"],
      createdAt: json["created_at"] == null ? null : json["created_at"],
      updatedAt: json["updated_at"] == null ? null : json["updated_at"],
      roleId: json["role_id"] == null ? null : json["role_id"],
      gender: json["gender"] == null ? null : json["gender"],
      regip: json["regip"] == null ? null : json["regip"],
      regdate: json["regdate"] == null ? null : json["regdate"],
      lastip: json["lastip"] == null ? null : json["lastip"],
      lastvisit: json["lastvisit"] == null ? null : json["lastvisit"],
      expiredAt: json["expired_at"] == null ? null : json["expired_at"],
      lastpost: json["lastpost"] == null ? null : json["lastpost"],
      oltime: json["oltime"] == null ? null : json["oltime"],
      pageviews: json["pageviews"] == null ? null : json["pageviews"],
      score: json["score"] == null ? null : json["score"],
      aff: json["aff"] == null ? null : json["aff"],
      channel: json["channel"] == null ? null : json["channel"],
      invitedBy: json["invited_by"] == null ? null : json["invited_by"],
      invitedNum: json["invited_num"] == null ? null : json["invited_num"],
      banPost: json["ban_post"] == null ? null : json["ban_post"],
      loginCount: json["login_count"] == null ? null : json["login_count"],
      appVersion: json["app_version"] == null ? null : json["app_version"],
      validate: json["validate"] == null ? null : json["validate"],
      share: json["share"] == null ? null : Share.fromJson(json["share"]),
      isLogin: json["is_login"] == null ? null : json["is_login"],
      nickname: json["nickname"] == null ? null : json["nickname"],
      thumb: json["thumb"] == null ? "" : json["thumb"],
      coins: json["coins"] == null ? null : json["coins"],
      money: json["money"] == null ? null : json["money"],
      incomeMoney: json["income_money"] == null ? null : json["income_money"],
      roleType: json["role_type"] == null ? null : json["role_type"],
      tempVip: json["temp_vip"] == null ? null : json["temp_vip"],
      followedCount:
          json["followed_count"] == null ? null : json["followed_count"],
      videosCount: json["videos_count"] == null ? null : json["videos_count"],
      fabulousCount:
          json["fabulous_count"] == null ? null : json["fabulous_count"],
      likesCount: json["likes_count"] == null ? null : json["likes_count"],
      commentCount:
          json["comment_count"] == null ? null : json["comment_count"],
      vipLevel: json["vip_level"] == null ? null : json["vip_level"],
      personSignnatrue:
          json["person_signnatrue"] == null ? "" : json["person_signnatrue"],
      oldVip: json["old_vip"] == null ? null : json["old_vip"],
      stature: json["stature"] == null ? null : json["stature"],
      interest: json["interest"] == null ? null : json["interest"],
      city: json["city"] == null ? null : json["city"],
      usedMoneyFreeNum: json["used_money_free_num"] == null
          ? null
          : json["used_money_free_num"],
      agentFee: json["agent_fee"] == null ? null : json["agent_fee"],
      agent: json["agent"] == null ? null : json["agent"],
      buildId: json["build_id"] == null ? null : json["build_id"],
      authStatus: json["auth_status"] == null ? null : json["auth_status"],
      exp: json["exp"] == null ? 0 : json["exp"],
      exp_con: json["exp_con"] == null ? 2 : json["exp_con"],
      exp_down: json["exp_down"] == null ? 5 : json["exp_down"],
      isVirtual: json["is_virtual"] == null ? null : json["is_virtual"],
      chatUid: json["chat_uid"] == null ? null : json["chat_uid"],
      phone: json["phone"] == null ? null : json["phone"],
      phonePrefix: json["phone_prefix"] == null ? null : json["phone_prefix"],
      freeViewCnt: json["free_view_cnt"] == null
          ? null
          : json["free_view_cnt"].runtimeType == int
              ? json["free_view_cnt"]
              : int.parse(json["free_view_cnt"]),
      lastactivity: json["lastactivity"] == null ? null : json["lastactivity"],
      thumbStr: json["thumb_str"] == null || json["thumb_str"] == ''
          ? null
          : json["thumb_str"],
      oauthStr: json["oauth_str"] == null ? null : json["oauth_str"],
      isSetPassword:
          json["is_set_password"] == null ? null : json["is_set_password"],
      level: json["level"] == null ? null : json["level"],
      vip_str: json["vip_str"] == null ? "" : json["vip_str"],
      ads: json["ads"] == null ? null : Banner.fromJson(json["ads"]));

  Map<String, dynamic> toJson() => {
        "post_count": post_count == null ? 0 : post_count,
        "fans_count": fans_count == null ? 0 : fans_count,
        "is_follow": is_follow == null ? 0 : is_follow,
        "uid": uid == null ? null : uid,
        "reg_tip": reg_tip == null ? "" : reg_tip,
        "video_download_value":
            video_download_value == null ? 0 : video_download_value,
        "new_user": new_user == null ? false : new_user,
        "shortMvFreeTime": shortMvFreeTime == null ? null : shortMvFreeTime,
        "longMvFreeTime": longMvFreeTime == null ? null : longMvFreeTime,
        "uuid": uuid == null ? null : uuid,
        "username": username == null ? null : username,
        "created_at": createdAt == null ? null : createdAt,
        "updated_at": updatedAt == null ? null : updatedAt,
        "role_id": roleId == null ? null : roleId,
        "gender": gender == null ? null : gender,
        "regip": regip == null ? null : regip,
        "regdate": regdate == null ? null : regdate,
        "lastip": lastip == null ? null : lastip,
        "lastvisit": lastvisit == null ? null : lastvisit,
        "expired_at": expiredAt == null ? null : expiredAt,
        "lastpost": lastpost == null ? null : lastpost,
        "oltime": oltime == null ? null : oltime,
        "pageviews": pageviews == null ? null : pageviews,
        "score": score == null ? null : score,
        "aff": aff == null ? null : aff,
        "channel": channel == null ? null : channel,
        "invited_by": invitedBy == null ? null : invitedBy,
        "invited_num": invitedNum == null ? null : invitedNum,
        "ban_post": banPost == null ? null : banPost,
        "login_count": loginCount == null ? null : loginCount,
        "app_version": appVersion == null ? null : appVersion,
        "validate": validate == null ? null : validate,
        "share": share == null ? null : share.toJson(),
        "is_login": isLogin == null ? null : isLogin,
        "nickname": nickname == null ? null : nickname,
        "thumb": thumb == null ? "" : thumb,
        "coins": coins == null ? null : coins,
        "money": money == null ? null : money,
        "income_money": incomeMoney == null ? null : incomeMoney,
        "role_type": roleType == null ? null : roleType,
        "temp_vip": tempVip == null ? null : tempVip,
        "followed_count": followedCount == null ? null : followedCount,
        "videos_count": videosCount == null ? null : videosCount,
        "fabulous_count": fabulousCount == null ? null : fabulousCount,
        "likes_count": likesCount == null ? null : likesCount,
        "comment_count": commentCount == null ? null : commentCount,
        "vip_level": vipLevel == null ? null : vipLevel,
        "person_signnatrue": personSignnatrue == null ? "" : personSignnatrue,
        "old_vip": oldVip == null ? null : oldVip,
        "stature": stature == null ? null : stature,
        "interest": interest == null ? null : interest,
        "city": city == null ? null : city,
        "used_money_free_num":
            usedMoneyFreeNum == null ? null : usedMoneyFreeNum,
        "agent_fee": agentFee == null ? null : agentFee,
        "agent": agent == null ? null : agent,
        "build_id": buildId == null ? null : buildId,
        "auth_status": authStatus == null ? null : authStatus,
        "exp": exp == null ? 0 : exp,
        "exp_con": exp_con == null ? 2 : exp_con,
        "exp_down": exp_down == null ? 5 : exp_down,
        "is_virtual": isVirtual == null ? null : isVirtual,
        "chat_uid": chatUid == null ? null : chatUid,
        "phone": phone == null ? null : phone,
        "phone_prefix": phonePrefix == null ? null : phonePrefix,
        "free_view_cnt": freeViewCnt == null ? null : freeViewCnt,
        "lastactivity": lastactivity == null ? null : lastactivity,
        "thumb_str": thumbStr == null || thumbStr == '' ? null : thumbStr,
        "oauth_str": oauthStr == null ? null : oauthStr,
        "is_set_password": isSetPassword == null ? null : isSetPassword,
        "level": level == null ? null : level,
        "ads": ads == null ? null : ads.toJson(),
        "vip_str": vip_str,
      };
}

class Notice {
  Notice({
    this.id,
    this.img_url,
    this.router,
    this.type,
    this.height,
    this.width,
    this.url_str,
    this.report_id,
    this.report_type,
  });

  int id;
  String img_url;
  String router;
  String type;
  int height;
  int width;
  String url_str;
  int report_id;
  int report_type;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
        id: json["id"] == null ? 0 : json["id"],
        img_url: json["img_url"] == null ? "" : json["img_url"],
        router: json["router"] == null ? "" : json["router"],
        type: json["type"] == null ? "" : json["type"],
        height: json["height"] == null ? 100 : json["height"],
        width: json["width"] == null ? 100 : json["width"],
        url_str: json["url_str"] == null ? "" : json["url_str"],
        report_id: json["report_id"] ?? 0,
        report_type: json['report_type'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "img_url": img_url,
        "router": router,
        "type": type,
        "height": height,
        "width": width,
        "url_str": url_str,
        "report_id": report_id,
        "report_type": report_type,
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

  String version;
  String type;
  String apk;
  String tips;

  int must;
  int status;
  String message;
  int mstatus;
  String channel;

  factory VersionMsg.fromJson(Map<String, dynamic> json) => VersionMsg(
        version: json["version"] == null ? null : json["version"],
        type: json["type"] == null ? null : json["type"],
        apk: json["apk"] == null ? null : json["apk"],
        tips: json["tips"] == null ? null : json["tips"],
        must: json["must"] == null ? null : json["must"],
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        mstatus: json["mstatus"] == null ? null : json["mstatus"],
        channel: json["channel"] == null ? null : json["channel"],
      );

  Map<String, dynamic> toJson() => {
        "version": version == null ? null : version,
        "type": type == null ? null : type,
        "apk": apk == null ? null : apk,
        "tips": tips == null ? null : tips,
        "must": must == null ? null : must,
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "mstatus": mstatus == null ? null : mstatus,
        "channel": channel == null ? null : channel,
      };
}
