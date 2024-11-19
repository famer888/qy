class WithdrawalRecordModel {
  final String amount;
  final String statusStr;
  final String updatedAt;
  WithdrawalRecordModel({
    required this.amount,
    required this.statusStr,
    required this.updatedAt,
  });
  factory WithdrawalRecordModel.fromJson(Map<String, dynamic> json) =>
      WithdrawalRecordModel(
          amount: '${json['amount']}',
          statusStr: json['status_str'],
          updatedAt: json['updated_at']);
}
