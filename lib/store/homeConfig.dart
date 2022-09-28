import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qypj/model/homedata.dart';
import 'package:qypj/model/systemnotice.dart';

class GetConfig {
  static String imagePath;
}

class HomeConfig with ChangeNotifier, DiagnosticableTreeMixin {
  VersionMsg _versionMsg;
  Ads _ads;
  dynamic _pads;
  Notice _notice;
  Config _config;
  Member _member;
  SystemNotice _systemNotice;

  SystemNotice get systemnotice => _systemNotice;
  Member get member => _member;
  Notice get notice => _notice;
  Config get config => _config;
  Ads get ads => _ads;
  VersionMsg get versionMsg => _versionMsg;

  void setSystemNotice(dynamic data) {
    _systemNotice = data;
    notifyListeners();
  }

  void setExp(dynamic newExp) {
    _member.exp = newExp;
    notifyListeners();
  }

  void setIncome(dynamic newIncome) {
    _member.incomeMoney = newIncome;
    notifyListeners();
  }

  void setInviteBy(dynamic inviteBy) {
    _member.invitedBy = inviteBy;
    notifyListeners();
  }

  void setIsSetpassword(int status) {
    _member.isSetPassword = status;
    notifyListeners();
  }

  void setNickname(dynamic nickname) {
    _member.nickname = nickname;
    notifyListeners();
  }

  void setAvatar(dynamic url) {
    _member.thumb = url;
    notifyListeners();
  }

  void setNotice(dynamic newNotice) {
    _notice = newNotice;
    notifyListeners();
  }

  void setMember(Member newData) {
    _member = newData;
    notifyListeners();
  }

  void setVersionMsg(VersionMsg newVersionMsg) {
    _versionMsg = newVersionMsg;
    notifyListeners();
  }

  void setAbs(Ads newAbs) {
    _ads = newAbs;
    notifyListeners();
  }

  void setConfig(Config newConfig) {
    _config = newConfig;
    notifyListeners();
  }

  void setLevel(dynamic value) {
    _member.level = value;
    notifyListeners();
  }

  void setAgent(dynamic value) {
    _member.agent = value;
    notifyListeners();
  }

  void setInvitation(dynamic invitation) {
    _member.invitedBy = invitation;
    notifyListeners();
  }

  static setUserExp(BuildContext context, int exp) async {
    Provider.of<HomeConfig>(context, listen: false).setExp(exp);
  }

  static setUserIncome(BuildContext context, int income) async {
    Provider.of<HomeConfig>(context, listen: false).setIncome(income);
  }
}
