class FollowingUserModel {
  final int? uid;
  final int? aff;
  final String? nickname;
  final String? thumb;
  final int? exp;
  final int? pkId;
  final int? isFollow;
  final int? isSetPassword;
  final bool? newUser;
  final List<dynamic>? tagList;
  final String? vipStr;

  FollowingUserModel({
    this.uid,
    this.aff,
    this.nickname,
    this.thumb,
    this.exp,
    this.pkId,
    this.isFollow,
    this.isSetPassword,
    this.newUser,
    this.tagList,
    this.vipStr,
  });

  FollowingUserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as int?,
        aff = json['aff'] as int?,
        nickname = json['nickname'] as String?,
        thumb = json['thumb'] as String?,
        exp = json['exp'] as int?,
        pkId = json['pk_id'] as int?,
        isFollow = json['is_follow'] as int?,
        isSetPassword = json['is_set_password'] as int?,
        newUser = json['new_user'] as bool?,
        tagList = json['tag_list'] as List<dynamic>?,
        vipStr = json['vip_str'] as String?;


}
