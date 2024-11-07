// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommend_video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecommendVideoAdModelImpl _$$RecommendVideoAdModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendVideoAdModelImpl(
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

Map<String, dynamic> _$$RecommendVideoAdModelImplToJson(
        _$RecommendVideoAdModelImpl instance) =>
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

_$RecommendVideoCardModelImpl _$$RecommendVideoCardModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RecommendVideoCardModelImpl(
      json['title'] as String,
      json['sub_title'] as String?,
      (json['type'] as num).toInt(),
      (json['id'] as num).toInt(),
      (json['items'] as List<dynamic>)
          .map((e) => VideoCardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['__type'] as String?,
    );

Map<String, dynamic> _$$RecommendVideoCardModelImplToJson(
        _$RecommendVideoCardModelImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'sub_title': instance.subTitle,
      'type': instance.type,
      'id': instance.id,
      'items': instance.items,
      '__type': instance.$type,
    };
