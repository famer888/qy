import 'welfare_task_model.dart';

class WelfareTaskListModel {
  final String? title;
  final int? freeViewCnt;
  final int? totalFreeViewCnt;
  final int? invitedNum;
  final int? exp;
  final List<WelfareTaskModel>? list;
  final List<WelfareTaskModel>? signRewardList;
  final int? incomeMoney;
  final bool? signStatus;
  final int? signNum;

  WelfareTaskListModel({
    this.title,
    this.freeViewCnt,
    this.totalFreeViewCnt,
    this.invitedNum,
    this.exp,
    this.list,
    this.signRewardList,
    this.signStatus,
    this.signNum,
    this.incomeMoney,
  });

  WelfareTaskListModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        freeViewCnt = json['free_view_cnt'],
        totalFreeViewCnt = json['total_free_view_cnt'],
        invitedNum = json['invited_num'],
        exp = json['exp'],
        list = List.from(
          json['list']?.map((e) => WelfareTaskModel.fromJson(e)),
        ),
        signRewardList = List.from(
          json['sign_reward_list']?.map((e) => WelfareTaskModel.fromJson(e)),
        ),
        incomeMoney = json['income_money'],
        signStatus = json['sign_status'],
        signNum = json['sign_num'];
}
