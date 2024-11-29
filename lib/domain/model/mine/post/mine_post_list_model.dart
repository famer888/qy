import '../../post/post_model.dart';

class MinePostListModel {
  final List<PostModel>? list;
  final String? lastIx;

  MinePostListModel({
    this.list,
    this.lastIx,
  });

  factory MinePostListModel.fromJson(Map<String, dynamic> json) =>
      MinePostListModel(
        list: List.from(json['list'].map((e) => PostModel.fromJson(e))),
        lastIx: json['last_ix'] as String?,
      );
}
