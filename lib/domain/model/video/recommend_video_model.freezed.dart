// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommend_video_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendVideoModel _$RecommendVideoModelFromJson(Map<String, dynamic> json) {
  switch (json['__type']) {
    case 'ad':
      return RecommendVideoAdModel.fromJson(json);
    case 'video':
      return RecommendVideoCardModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, '__type', 'RecommendVideoModel',
          'Invalid union type "${json['__type']}"!');
  }
}

/// @nodoc
mixin _$RecommendVideoModel {
  int? get id => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendVideoAdModel value) ad,
    required TResult Function(RecommendVideoCardModel value) video,
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RecommendVideoAdModelImpl implements RecommendVideoAdModel {
  _$RecommendVideoAdModelImpl(
      this.id,
      this.description,
      this.imgUrl,
      this.urlConfig,
      this.type,
      this.router,
      this.urlStr,
      this.linkUrl,
      this.url,
      this.resourceUrl,
      this.redirectType,
      this.reportId,
      this.reportType,
      {final String? $type})
      : $type = $type ?? 'ad';

  factory _$RecommendVideoAdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendVideoAdModelImplFromJson(json);

  @override
  int? id;
  @override
  String? description;
  @override
  String? imgUrl;
  @override
  String? urlConfig;
  @override
  int? type;
  @override
  String? router;
  @override
  String? urlStr;
  @override
  String? linkUrl;
  @override
  String? url;
  @override
  String? resourceUrl;
  @override
  int? redirectType;
  @override
  int? reportId;
  @override
  int? reportType;

  @JsonKey(name: '__type')
  final String $type;

  @override
  String toString() {
    return 'RecommendVideoModel.ad(id: $id, description: $description, imgUrl: $imgUrl, urlConfig: $urlConfig, type: $type, router: $router, urlStr: $urlStr, linkUrl: $linkUrl, url: $url, resourceUrl: $resourceUrl, redirectType: $redirectType, reportId: $reportId, reportType: $reportType)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendVideoAdModel value) ad,
    required TResult Function(RecommendVideoCardModel value) video,
  }) {
    return ad(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendVideoAdModelImplToJson(
      this,
    );
  }
}

abstract class RecommendVideoAdModel implements RecommendVideoModel {
  factory RecommendVideoAdModel(
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
      int? reportType) = _$RecommendVideoAdModelImpl;

  factory RecommendVideoAdModel.fromJson(Map<String, dynamic> json) =
      _$RecommendVideoAdModelImpl.fromJson;

  @override
  int? get id;
  set id(int? value);
  String? get description;
  set description(String? value);
  String? get imgUrl;
  set imgUrl(String? value);
  String? get urlConfig;
  set urlConfig(String? value);
  @override
  int? get type;
  set type(int? value);
  String? get router;
  set router(String? value);
  String? get urlStr;
  set urlStr(String? value);
  String? get linkUrl;
  set linkUrl(String? value);
  String? get url;
  set url(String? value);
  String? get resourceUrl;
  set resourceUrl(String? value);
  int? get redirectType;
  set redirectType(int? value);
  int? get reportId;
  set reportId(int? value);
  int? get reportType;
  set reportType(int? value);
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$RecommendVideoCardModelImpl implements RecommendVideoCardModel {
  _$RecommendVideoCardModelImpl(
      this.title, this.subTitle, this.type, this.id, this.items,
      {final String? $type})
      : $type = $type ?? 'video';

  factory _$RecommendVideoCardModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecommendVideoCardModelImplFromJson(json);

  @override
  String title;
  @override
  String? subTitle;
  @override
  int type;
  @override
  int id;
  @override
  List<VideoCardModel> items;

  @JsonKey(name: '__type')
  final String $type;

  @override
  String toString() {
    return 'RecommendVideoModel.video(title: $title, subTitle: $subTitle, type: $type, id: $id, items: $items)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(RecommendVideoAdModel value) ad,
    required TResult Function(RecommendVideoCardModel value) video,
  }) {
    return video(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendVideoCardModelImplToJson(
      this,
    );
  }
}

abstract class RecommendVideoCardModel implements RecommendVideoModel {
  factory RecommendVideoCardModel(String title, String? subTitle, int type,
      int id, List<VideoCardModel> items) = _$RecommendVideoCardModelImpl;

  factory RecommendVideoCardModel.fromJson(Map<String, dynamic> json) =
      _$RecommendVideoCardModelImpl.fromJson;

  String get title;
  set title(String value);
  String? get subTitle;
  set subTitle(String? value);
  @override
  int get type;
  set type(int value);
  @override
  int get id;
  set id(int value);
  List<VideoCardModel> get items;
  set items(List<VideoCardModel> value);
}
