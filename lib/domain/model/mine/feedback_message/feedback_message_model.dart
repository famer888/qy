import 'feedback_message_problem_model.dart';

class FeedBackMessageModel {
  final int? id;
  final String? nickname;
  final String? thumb;
  final dynamic message;
  final int messageType;
  final int status;
  final String? createdAt;
  final int? isLocal;
  final List<FeedBackMessageProblemModel>? problemList;

  FeedBackMessageModel({
    required this.id,
    required this.nickname,
    required this.thumb,
    this.message,
    required this.messageType,
    required this.status,
    this.createdAt,
    this.isLocal,
    this.problemList,
  });

  factory FeedBackMessageModel.fromJson(Map<String, dynamic> json) =>
      FeedBackMessageModel(
        id: json['id'],
        nickname: json['nickname'],
        thumb: json['thumb'],
        message: json['message'],
        messageType: json['messageType'],
        status: json['status'],
        createdAt: json['createdAt'],
        isLocal: json['isLocal'],
        problemList: json['problemList'] == null
            ? null
            : List<FeedBackMessageProblemModel>.from(json['problemList']
                .map((x) => FeedBackMessageProblemModel.fromJson(x))),
      );
}
