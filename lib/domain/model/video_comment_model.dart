import 'user_model.dart';

class CommentListModel {
  final List<CommentModel> list;
  String? lastIx;

  CommentListModel({
    required this.list,
    this.lastIx,
  });

  factory CommentListModel.fromJson(Map<String, dynamic> json) =>
      CommentListModel(
        list: List<CommentModel>.from(
            json['list']?.map((x) => CommentModel.fromJson(x)) ?? []),
        lastIx: json['last_ix']?.toString(),
      );
}

class CommentModel {
  CommentModel({
    this.id,
    required this.content,
    required this.likeCount,
    required this.replayCount,
    this.status,
    required this.createdAt,
    this.isLike,
    required this.member,
  });

  int? id;

  final String content;
  int likeCount;
  int replayCount;
  final int? status;
  final String createdAt;
  int? isLike;
  final UserModel? member;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id']?.toInt(),

        //接口返回不同字段兼容
        content: (json['content'] ?? json['text'])?.toString() ?? '',
        likeCount: (json['like_count'] ?? json['like_fct'])?.toInt() ?? 0,

        replayCount: json['replay_count']?.toInt() ?? 0,
        status: json['status']?.toInt(),
        createdAt: json['created_at']?.toString() ?? '',
        isLike: json['is_like']?.toInt(),
        member: (json['member'] != null)
            ? UserModel.fromJson(json['member'])
            : null,
      );
}
