import 'package:freezed_annotation/freezed_annotation.dart';

import 'video_model.dart';
part 'recommend_video_model.freezed.dart';
part 'recommend_video_model.g.dart';

@Freezed(
  unionKey: '__type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: false,
  addImplicitFinal: false,
)
class RecommendVideoModel with _$RecommendVideoModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendVideoModel.ad(
    int? id,
    String? description,
    String? imgUrl,
    String? urlConfig,
    int? type,
    String? router,
    String? urlStr,
    String? linkUrl,
    String? url,
    String? resourceUrl,
    int? redirectType,
    int? reportId,
    int? reportType,
  ) = RecommendVideoAdModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendVideoModel.video(
    String title,
    String? subTitle,
    int type,
    int id,
    List<VideoCardModel> items,
  ) = RecommendVideoCardModel;

  factory RecommendVideoModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['__type'] = 'ad';
    } else {
      json['__type'] = 'video';
    }
    return _$RecommendVideoModelFromJson(json);
  }
}
