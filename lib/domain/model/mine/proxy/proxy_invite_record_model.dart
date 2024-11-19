class ProxyInviteRecordListModel {
  final List<ProxyInviteRecordModel> list;
  final String lastIx;
  ProxyInviteRecordListModel({required this.list, required this.lastIx});
  factory ProxyInviteRecordListModel.fromJson(Map<String, dynamic> json) {
    return ProxyInviteRecordListModel(
        list: json['list'] != null
            ? List.from(
                json['list'].map((e) => ProxyInviteRecordModel.fromJson(e)))
            : [],
        lastIx: json['last_ix'] ?? '');
  }
}

class ProxyInviteRecordModel {
  final String affCode;
  final String phone;
  final String regStatus;
  final String logDate;

  ProxyInviteRecordModel({
    required this.affCode,
    required this.phone,
    required this.regStatus,
    required this.logDate,
  });
  factory ProxyInviteRecordModel.fromJson(Map<String, dynamic> json) {
    return ProxyInviteRecordModel(
        affCode: json['aff_code'],
        phone: json['phone'],
        regStatus: json['reg_status'],
        logDate: json['log_date']);
  }
}
