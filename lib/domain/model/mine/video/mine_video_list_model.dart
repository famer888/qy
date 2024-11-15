import 'mine_video_model.dart';

class MineVideoListModel {
  final List<MineVideoModel>? list;
  final String? lastIx;

  MineVideoListModel({
    this.list,
    this.lastIx,
  });

  factory MineVideoListModel.fromJson(Map<String, dynamic> json) =>
      MineVideoListModel(
        list: List.from(json['list'].map((e) => MineVideoModel.fromJson(e))),
        lastIx: json['last_ix'] as String?,
      );
}
