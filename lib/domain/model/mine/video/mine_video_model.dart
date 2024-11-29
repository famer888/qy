class MineVideoModel {
  final int? mvType;
  final int? duration;
  final int? id;
  final int? playCt;
  final String? title;
  final String? coverVertical;
  final String? coverHorizontal;

  MineVideoModel({
    this.mvType,
    this.duration,
    this.id,
    this.playCt,
    this.title,
    this.coverVertical,
    this.coverHorizontal,
  });

  MineVideoModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        mvType = json['mv_type'],
        duration = json['duration'],
        playCt = json['play_ct'],
        title = json['title'],
        coverVertical = json['cover_vertical'],
        coverHorizontal = json['cover_horizontal'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'mv_type': mvType,
        'duration': duration,
        'play_ct': playCt,
        'title': title,
        'cover_vertical': coverVertical,
        'cover_horizontal': coverHorizontal,
      };
}
