// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_comic_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendComicAdModelImpl _$$RecommendComicAdModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendComicAdModelImpl(
      (json['id'] as num?)?.toInt(),
      json['description'] as String?,
      json['img_url'] as String?,
      json['url_config'] as String?,
      (json['type'] as num?)?.toInt(),
      json['router'] as String?,
      json['url_str'] as String?,
      json['link_url'] as String?,
      json['url'] as String?,
      json['resource_url'] as String?,
      (json['redirect_type'] as num?)?.toInt(),
      (json['report_id'] as num?)?.toInt(),
      (json['report_type'] as num?)?.toInt(),
      $type: json['__type'] as String?,
    );

Map<String, dynamic> _$$RecommendComicAdModelImplToJson(
        _$RecommendComicAdModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'img_url': instance.imgUrl,
      'url_config': instance.urlConfig,
      'type': instance.type,
      'router': instance.router,
      'url_str': instance.urlStr,
      'link_url': instance.linkUrl,
      'url': instance.url,
      'resource_url': instance.resourceUrl,
      'redirect_type': instance.redirectType,
      'report_id': instance.reportId,
      'report_type': instance.reportType,
      '__type': instance.$type,
    };

_$RecommendComicCardModelImpl _$$RecommendComicCardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendComicCardModelImpl(
      json['title'] as String?,
      json['value'] as String?,
      (json['items'] as List<dynamic>?)
          ?.map((e) => ComicItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['__type'] as String?,
    );

Map<String, dynamic> _$$RecommendComicCardModelImplToJson(
        _$RecommendComicCardModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'items': instance.items,
      '__type': instance.$type,
    };
