import 'comic_item_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'recommend_comic_model.freezed.dart';
part 'recommend_comic_model.g.dart';

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
class RecommendComicModel with _$RecommendComicModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendComicModel.ad(
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
  ) = RecommendComicAdModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendComicModel.comic(
    String? title,
    String? value,
    List<ComicItemModel>? items,
  ) = RecommendComicCardModel;

  factory RecommendComicModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['__type'] = 'ad';
    } else {
      json['__type'] = 'comic';
    }
    return _$RecommendComicModelFromJson(json);
  }
}
