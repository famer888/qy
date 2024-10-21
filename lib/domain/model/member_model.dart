import '../../ui_layer/notifiers/chat_notifier.dart';
import 'home_data_model.dart';

extension MemberHelper on Member {
  bool get isSelf => channel == 'self';
}

class Member {
  Member(
      {this.uid,
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
      required this.nickname,
      this.thumb,
      this.coins,
      required this.money,
      this.incomeMoney,
      this.roleType,
      this.tempVip,
      this.followedCount,
      this.videosCount,
      this.fabulousCount,
      this.likesCount,
      this.commentCount,
      required this.vipLevel,
      required this.vipStr,
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
      this.expCon,
      this.expDown,
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
      this.newUser,
      this.shortMvFreeTime,
      this.longMvFreeTime,
      this.videoDownloadValue,
      this.regTip,
      this.ads,
      this.isFollow,
      this.postCount,
      this.fansCount,
      this.chat});

  final int? isFollow;
  final int? postCount;
  final int? fansCount;
  final int? uid;
  final bool? newUser;
  final int? videoDownloadValue;
  final String? uuid;
  final String? regTip;
  final String? username;
  final String? createdAt;
  final String? updatedAt;
  final int? roleId;
  final int? gender;
  final String? regip;
  final String? regdate;
  final String? lastip;
  final String? lastvisit;
  final String? expiredAt;
  final int? lastpost;
  final int? oltime;
  final int? pageviews;
  final int? score;
  final int? aff;
  final String? channel;
  final dynamic invitedBy;
  final int? invitedNum;
  final int? banPost;
  final int? loginCount;
  final String? appVersion;
  final int? validate;
  final Share? share;
  final int? isLogin;
  final String nickname;
  final String? thumb;
  final int? coins;
  final int money;
  final int? incomeMoney;
  final List? roleType;
  final int? tempVip;
  final int? followedCount;
  final int? videosCount;
  final int? fabulousCount;
  final int? likesCount;
  final int? commentCount;
  final int vipLevel;
  final String vipStr;
  final String? personSignnatrue;
  final int? oldVip;
  final int? stature;
  final String? interest;
  final String? city;
  final int? usedMoneyFreeNum;
  final int? agentFee;
  final int? agent;
  final int? buildId;
  final int? authStatus;
  final int? exp;
  final int? expCon;
  final int? expDown;
  final String? isVirtual;
  final String? chatUid;
  final dynamic phone;
  final dynamic phonePrefix;
  final int? freeViewCnt;
  final String? lastactivity;
  final dynamic thumbStr;
  final String? oauthStr;
  final int? isSetPassword;
  final int? level;
  final AdModel? ads;
  final int? shortMvFreeTime;
  final int? longMvFreeTime;
  final IMChatModel? chat;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
      postCount: json['post_count'] ?? 0,
      fansCount: json['fans_count'] ?? 0,
      isFollow: json['is_follow'] ?? 0,
      uid: json['uid'],
      videoDownloadValue: json['video_download_value'] ?? 0,
      shortMvFreeTime: json['shortMvFreeTime'],
      longMvFreeTime: json['longMvFreeTime'],
      newUser: json['new_user'] ?? false,
      uuid: json['uuid'],
      regTip: json['reg_tip'] ?? '',
      username: json['username'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      roleId: json['role_id'],
      gender: json['gender'],
      regip: json['regip'],
      regdate: json['regdate'],
      lastip: json['lastip'],
      lastvisit: json['lastvisit'],
      expiredAt: json['expired_at'],
      lastpost: json['lastpost'],
      oltime: json['oltime'],
      pageviews: json['pageviews'],
      score: json['score'],
      aff: json['aff'],
      channel: json['channel'],
      invitedBy: json['invited_by'],
      invitedNum: json['invited_num'],
      banPost: json['ban_post'],
      loginCount: json['login_count'],
      appVersion: json['app_version'],
      validate: json['validate'],
      share: json['share'] == null ? null : Share.fromJson(json['share']),
      isLogin: json['is_login'],
      nickname: json['nickname'],
      thumb: json['thumb'] ?? '',
      coins: json['coins'],
      money: json['money'] ?? 0,
      incomeMoney: json['income_money'],
      roleType: json['role_type'],
      tempVip: json['temp_vip'],
      followedCount: json['followed_count'],
      videosCount: json['videos_count'],
      fabulousCount: json['fabulous_count'],
      likesCount: json['likes_count'],
      commentCount: json['comment_count'],
      vipLevel: json['vip_level'] ?? 0,
      vipStr: json['vip_str'] ?? '',
      personSignnatrue: json['person_signnatrue'] ?? '',
      oldVip: json['old_vip'],
      stature: json['stature'],
      interest: json['interest'],
      city: json['city'],
      usedMoneyFreeNum: json['used_money_free_num'],
      agentFee: json['agent_fee'],
      agent: json['agent'],
      buildId: json['build_id'],
      authStatus: json['auth_status'],
      exp: json['exp'] ?? 0,
      expCon: json['exp_con'] ?? 2,
      expDown: json['exp_down'] ?? 5,
      isVirtual: json['is_virtual'],
      chatUid: json['chat_uid'],
      phone: json['phone'],
      phonePrefix: json['phone_prefix'],
      freeViewCnt: json['free_view_cnt'] == null
          ? null
          : json['free_view_cnt'].runtimeType == int
              ? json['free_view_cnt']
              : int.parse(json['free_view_cnt']),
      lastactivity: json['lastactivity'],
      thumbStr: json['thumb_str'] == null || json['thumb_str'] == ''
          ? null
          : json['thumb_str'],
      oauthStr: json['oauth_str'],
      isSetPassword: json['is_set_password'],
      level: json['level'],
      ads: json['ads'] == null ? null : AdModel.fromJson(json['ads']),
      chat: json['chat'] == null ? null : IMChatModel.fromJson(json['chat']));

  Map<String, dynamic> toJson() => {
        'post_count': postCount ?? 0,
        'fans_count': fansCount ?? 0,
        'is_follow': isFollow ?? 0,
        'uid': uid,
        'reg_tip': regTip ?? '',
        'video_download_value': videoDownloadValue ?? 0,
        'new_user': newUser ?? false,
        'shortMvFreeTime': shortMvFreeTime,
        'longMvFreeTime': longMvFreeTime,
        'uuid': uuid,
        'username': username,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'role_id': roleId,
        'gender': gender,
        'regip': regip,
        'regdate': regdate,
        'lastip': lastip,
        'lastvisit': lastvisit,
        'expired_at': expiredAt,
        'lastpost': lastpost,
        'oltime': oltime,
        'pageviews': pageviews,
        'score': score,
        'aff': aff,
        'channel': channel,
        'invited_by': invitedBy,
        'invited_num': invitedNum,
        'ban_post': banPost,
        'login_count': loginCount,
        'app_version': appVersion,
        'validate': validate,
        'share': share?.toJson(),
        'is_login': isLogin,
        'nickname': nickname,
        'thumb': thumb ?? '',
        'coins': coins,
        'money': money,
        'income_money': incomeMoney,
        'role_type': roleType,
        'temp_vip': tempVip,
        'followed_count': followedCount,
        'videos_count': videosCount,
        'fabulous_count': fabulousCount,
        'likes_count': likesCount,
        'comment_count': commentCount,
        'vip_level': vipLevel,
        'vip_str': vipStr,
        'person_signnatrue': personSignnatrue ?? '',
        'old_vip': oldVip,
        'stature': stature,
        'interest': interest,
        'city': city,
        'used_money_free_num': usedMoneyFreeNum,
        'agent_fee': agentFee,
        'agent': agent,
        'build_id': buildId,
        'auth_status': authStatus,
        'exp': exp ?? 0,
        'exp_con': expCon ?? 2,
        'exp_down': expDown ?? 5,
        'is_virtual': isVirtual,
        'chat_uid': chatUid,
        'phone': phone,
        'phone_prefix': phonePrefix,
        'free_view_cnt': freeViewCnt,
        'lastactivity': lastactivity,
        'thumb_str': thumbStr == null || thumbStr == '' ? null : thumbStr,
        'oauth_str': oauthStr,
        'is_set_password': isSetPassword,
        'level': level,
        'ads': ads?.toJson(),
        'chat': chat?.toJson()
      };

  Member copyWith({
    int? isFollow,
    int? postCount,
    int? fansCount,
    int? uid,
    bool? newUser,
    int? videoDownloadValue,
    String? uuid,
    String? regTip,
    String? username,
    String? createdAt,
    String? updatedAt,
    int? roleId,
    int? gender,
    String? regip,
    String? regdate,
    String? lastip,
    String? lastvisit,
    String? expiredAt,
    int? lastpost,
    int? oltime,
    int? pageviews,
    int? score,
    int? aff,
    String? channel,
    dynamic invitedBy,
    int? invitedNum,
    int? banPost,
    int? loginCount,
    String? appVersion,
    int? validate,
    Share? share,
    int? isLogin,
    String? nickname,
    String? thumb,
    int? coins,
    int? money,
    int? incomeMoney,
    List? roleType,
    int? tempVip,
    int? followedCount,
    int? videosCount,
    int? fabulousCount,
    int? likesCount,
    int? commentCount,
    int? vipLevel,
    String? vipStr,
    String? personSignnatrue,
    int? oldVip,
    int? stature,
    String? interest,
    String? city,
    int? usedMoneyFreeNum,
    int? agentFee,
    int? agent,
    int? buildId,
    int? authStatus,
    int? exp,
    int? expCon,
    int? expDown,
    String? isVirtual,
    String? chatUid,
    dynamic phone,
    dynamic phonePrefix,
    int? freeViewCnt,
    String? lastactivity,
    dynamic thumbStr,
    String? oauthStr,
    int? isSetPassword,
    int? level,
    AdModel? ads,
    int? shortMvFreeTime,
    int? longMvFreeTime,
    IMChatModel? chat,
  }) =>
      Member(
        isFollow: isFollow ?? this.isFollow,
        postCount: postCount ?? this.postCount,
        fansCount: fansCount ?? this.fansCount,
        uid: uid ?? this.uid,
        newUser: newUser ?? this.newUser,
        videoDownloadValue: videoDownloadValue ?? this.videoDownloadValue,
        uuid: uuid ?? this.uuid,
        regTip: regTip ?? this.regTip,
        username: username ?? this.username,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        roleId: roleId ?? this.roleId,
        gender: gender ?? this.gender,
        regip: regip ?? this.regip,
        regdate: regdate ?? this.regdate,
        lastip: lastip ?? this.lastip,
        lastvisit: lastvisit ?? this.lastvisit,
        expiredAt: expiredAt ?? this.expiredAt,
        lastpost: lastpost ?? this.lastpost,
        oltime: oltime ?? this.oltime,
        pageviews: pageviews ?? this.pageviews,
        score: score ?? this.score,
        aff: aff ?? this.aff,
        channel: channel ?? this.channel,
        invitedBy: invitedBy ?? this.invitedBy,
        invitedNum: invitedNum ?? this.invitedNum,
        banPost: banPost ?? this.banPost,
        loginCount: loginCount ?? this.loginCount,
        appVersion: appVersion ?? this.appVersion,
        validate: validate ?? this.validate,
        share: share ?? this.share,
        isLogin: isLogin ?? this.isLogin,
        nickname: nickname ?? this.nickname,
        thumb: thumb ?? this.thumb,
        coins: coins ?? this.coins,
        money: money ?? this.money,
        incomeMoney: incomeMoney ?? this.incomeMoney,
        roleType: roleType ?? this.roleType,
        tempVip: tempVip ?? this.tempVip,
        followedCount: followedCount ?? this.followedCount,
        videosCount: videosCount ?? this.videosCount,
        fabulousCount: fabulousCount ?? this.fabulousCount,
        likesCount: likesCount ?? this.likesCount,
        commentCount: commentCount ?? this.commentCount,
        vipLevel: vipLevel ?? this.vipLevel,
        vipStr: vipStr ?? this.vipStr,
        personSignnatrue: personSignnatrue ?? this.personSignnatrue,
        oldVip: oldVip ?? this.oldVip,
        stature: stature ?? this.stature,
        interest: interest ?? this.interest,
        city: city ?? this.city,
        usedMoneyFreeNum: usedMoneyFreeNum ?? this.usedMoneyFreeNum,
        agentFee: agentFee ?? this.agentFee,
        agent: agent ?? this.agent,
        buildId: buildId ?? this.buildId,
        authStatus: authStatus ?? this.authStatus,
        exp: exp ?? this.exp,
        expCon: expCon ?? this.expCon,
        expDown: expDown ?? this.expDown,
        isVirtual: isVirtual ?? this.isVirtual,
        chatUid: chatUid ?? this.chatUid,
        phone: phone ?? this.phone,
        phonePrefix: phonePrefix ?? this.phonePrefix,
        freeViewCnt: freeViewCnt ?? this.freeViewCnt,
        lastactivity: lastactivity ?? this.lastactivity,
        thumbStr: thumbStr ?? this.thumbStr,
        oauthStr: oauthStr ?? this.oauthStr,
        isSetPassword: isSetPassword ?? this.isSetPassword,
        level: level ?? this.level,
        ads: ads ?? this.ads,
        shortMvFreeTime: shortMvFreeTime ?? this.shortMvFreeTime,
        longMvFreeTime: longMvFreeTime ?? this.longMvFreeTime,
        chat: chat ?? this.chat,
      );
}

class Share {
  Share({
    this.affUrlCopy,
    this.affCode,
    this.affUrl,
  });

  final AffUrlCopy? affUrlCopy;
  final String? affCode;
  final String? affUrl;

  factory Share.fromJson(Map<String, dynamic> json) => Share(
        affUrlCopy: json['aff_url_copy'] == null
            ? null
            : AffUrlCopy.fromJson(json['aff_url_copy']),
        affCode: json['aff_code'],
        affUrl: json['aff_url'],
      );

  Map<String, dynamic> toJson() => {
        'aff_url_copy': affUrlCopy?.toJson(),
        'aff_code': affCode,
        'aff_url': affUrl,
      };
}

class AffUrlCopy {
  AffUrlCopy({
    this.code,
    this.url,
  });

  final String? code;
  final String? url;

  factory AffUrlCopy.fromJson(Map<String, dynamic> json) => AffUrlCopy(
        code: json['code'],
        url: json['url'],
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'url': url,
      };
}
