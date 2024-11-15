class WelfareTaskModel {
  final int? id;
  final String? title;
  final String? subTitle;
  final String? icon;
  final int? taskType;
  final int? rewardType;
  final int? rewardValue;
  final int? status;
  final int? sort;
  final String? appUrl;
  final int? progressStatus;
  final String? desc;

  WelfareTaskModel({
    this.id,
    this.title,
    this.subTitle,
    this.icon,
    this.taskType,
    this.rewardType,
    this.rewardValue,
    this.status,
    this.sort,
    this.appUrl,
    this.desc,
    this.progressStatus,
  });

  WelfareTaskModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        subTitle = json['sub_title'],
        icon = json['icon'],
        taskType = json['task_type'],
        rewardType = json['reward_type'],
        rewardValue = json['reward_value'],
        status = json['status'],
        sort = json['sort'],
        desc = json['desc'],
        appUrl = json['app_url'],
        progressStatus = json['progress_status'];
}
