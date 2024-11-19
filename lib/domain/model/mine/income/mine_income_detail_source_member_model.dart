class MineIncomeDetailSourceMemberModel {
  final int? uid;
  final int? aff;
  final String? nickname;
  final int? isSetPassword;
  final bool? newUser;
  final int? isFollow;
  final List<dynamic>? tagList;
  final String? vipStr;

  MineIncomeDetailSourceMemberModel({
    this.uid,
    this.aff,
    this.nickname,
    this.isSetPassword,
    this.newUser,
    this.isFollow,
    this.tagList,
    this.vipStr,
  });

  factory MineIncomeDetailSourceMemberModel.fromJson(
          Map<String, dynamic> json) =>
      MineIncomeDetailSourceMemberModel(
        uid: json['uid'],
        aff: json['aff'],
        nickname: json['nickname'],
        isSetPassword: json['is_set_password'],
        newUser: json['new_user'],
        isFollow: json['is_follow'],
        tagList: json['tag_list'],
        vipStr: json['vip_str'],
      );
}
