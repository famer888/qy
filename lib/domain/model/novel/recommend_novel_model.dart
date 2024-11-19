import 'package:freezed_annotation/freezed_annotation.dart';
import 'novel_item_model.dart';
part 'recommend_novel_model.freezed.dart';
part 'recommend_novel_model.g.dart';

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
class RecommendNovelModel with _$RecommendNovelModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendNovelModel.ad(
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
  ) = RecommendNovelAdModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  factory RecommendNovelModel.novel(
    String? title,
    String? value,
    List<NovelItemModel>? items,
  ) = RecommendNovelCardModel;

  factory RecommendNovelModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['__type'] = 'ad';
    } else {
      json['__type'] = 'novel';
    }
    return _$RecommendNovelModelFromJson(json);
  }
}
