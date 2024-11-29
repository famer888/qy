// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'girl_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GirlListModel _$GirlListModelFromJson(Map<String, dynamic> json) {
  switch (json['__type']) {
    case 'girl':
      return GirlListGirlModel.fromJson(json);
    case 'ad':
      return GirlListAdModel.fromJson(json);

    default:
      throw CheckedFromJsonException(json, '__type', 'GirlListModel',
          'Invalid union type "${json['__type']}"!');
  }
}

/// @nodoc
mixin _$GirlListModel {
  int? get id => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  int? get type => throw _privateConstructorUsedError;

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GirlListGirlModel value) girl,
    required TResult Function(GirlListAdModel value) ad,
  }) =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$GirlListGirlModelImpl implements GirlListGirlModel {
  const _$GirlListGirlModelImpl(
      this.id,
      this.title,
      @JsonKey(name: 'class') this.class_,
      this.cup,
      this.age,
      this.height,
      this.type,
      this.price,
      this.coins,
      this.payCt,
      this.payFct,
      this.rid,
      final List<CommonMediaModel>? medias,
      {final String? $type})
      : _medias = medias,
        $type = $type ?? 'girl';

  factory _$GirlListGirlModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GirlListGirlModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? title;
  @override
  @JsonKey(name: 'class')
  final String class_;
  @override
  final String? cup;
  @override
  final int? age;
  @override
  final int? height;
  @override
  final int? type;
  @override
  final String? price;
  @override
  final int? coins;
  @override
  final int? payCt;
  @override
  final int? payFct;
  @override
  final int? rid;
  final List<CommonMediaModel>? _medias;
  @override
  List<CommonMediaModel>? get medias {
    final value = _medias;
    if (value == null) return null;
    if (_medias is EqualUnmodifiableListView) return _medias;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @JsonKey(name: '__type')
  final String $type;

  @override
  String toString() {
    return 'GirlListModel.girl(id: $id, title: $title, class_: $class_, cup: $cup, age: $age, height: $height, type: $type, price: $price, coins: $coins, payCt: $payCt, payFct: $payFct, rid: $rid, medias: $medias)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GirlListGirlModel value) girl,
    required TResult Function(GirlListAdModel value) ad,
  }) {
    return girl(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GirlListGirlModelImplToJson(
      this,
    );
  }
}

abstract class GirlListGirlModel implements GirlListModel {
  const factory GirlListGirlModel(
      final int? id,
      final String? title,
      @JsonKey(name: 'class') final String class_,
      final String? cup,
      final int? age,
      final int? height,
      final int? type,
      final String? price,
      final int? coins,
      final int? payCt,
      final int? payFct,
      final int? rid,
      final List<CommonMediaModel>? medias) = _$GirlListGirlModelImpl;

  factory GirlListGirlModel.fromJson(Map<String, dynamic> json) =
      _$GirlListGirlModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get title;
  @JsonKey(name: 'class')
  String get class_;
  String? get cup;
  int? get age;
  int? get height;
  @override
  int? get type;
  String? get price;
  int? get coins;
  int? get payCt;
  int? get payFct;
  int? get rid;
  List<CommonMediaModel>? get medias;
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$GirlListAdModelImpl implements GirlListAdModel {
  const _$GirlListAdModelImpl(
      this.id,
      this.title,
      this.description,
      this.imgUrl,
      this.urlConfig,
      this.position,
      this.androidDownUrl,
      this.iosDownUrl,
      this.type,
      this.status,
      this.oauthType,
      this.mvM3U8,
      this.channel,
      this.createdAt,
      this.router,
      this.startAt,
      this.endAt,
      this.clicked,
      this.sort,
      this.urlStr,
      this.linkUrl,
      this.url,
      this.resourceUrl,
      this.redirectType,
      this.reportId,
      this.reportType,
      this.subTitle,
      {final String? $type})
      : $type = $type ?? 'ad';

  factory _$GirlListAdModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GirlListAdModelImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? imgUrl;
  @override
  final String urlConfig;
  @override
  final int? position;
  @override
  final String? androidDownUrl;
  @override
  final String? iosDownUrl;
  @override
  final int? type;
  @override
  final int? status;
  @override
  final int? oauthType;
  @override
  final String? mvM3U8;
  @override
  final String? channel;
  @override
  final String? createdAt;
  @override
  final String router;
  @override
  final String? startAt;
  @override
  final String? endAt;
  @override
  final int clicked;
  @override
  final int sort;
  @override
  final String urlStr;
  @override
  final String linkUrl;
  @override
  final String? url;
  @override
  final String resourceUrl;
  @override
  final int redirectType;
  @override
  final int reportId;
  @override
  final int reportType;
  @override
  final String? subTitle;

  @JsonKey(name: '__type')
  final String $type;

  @override
  String toString() {
    return 'GirlListModel.ad(id: $id, title: $title, description: $description, imgUrl: $imgUrl, urlConfig: $urlConfig, position: $position, androidDownUrl: $androidDownUrl, iosDownUrl: $iosDownUrl, type: $type, status: $status, oauthType: $oauthType, mvM3U8: $mvM3U8, channel: $channel, createdAt: $createdAt, router: $router, startAt: $startAt, endAt: $endAt, clicked: $clicked, sort: $sort, urlStr: $urlStr, linkUrl: $linkUrl, url: $url, resourceUrl: $resourceUrl, redirectType: $redirectType, reportId: $reportId, reportType: $reportType, subTitle: $subTitle)';
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GirlListGirlModel value) girl,
    required TResult Function(GirlListAdModel value) ad,
  }) {
    return ad(this);
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GirlListAdModelImplToJson(
      this,
    );
  }
}

abstract class GirlListAdModel implements GirlListModel {
  const factory GirlListAdModel(
      final int id,
      final String title,
      final String? description,
      final String? imgUrl,
      final String urlConfig,
      final int? position,
      final String? androidDownUrl,
      final String? iosDownUrl,
      final int? type,
      final int? status,
      final int? oauthType,
      final String? mvM3U8,
      final String? channel,
      final String? createdAt,
      final String router,
      final String? startAt,
      final String? endAt,
      final int clicked,
      final int sort,
      final String urlStr,
      final String linkUrl,
      final String? url,
      final String resourceUrl,
      final int redirectType,
      final int reportId,
      final int reportType,
      final String? subTitle) = _$GirlListAdModelImpl;

  factory GirlListAdModel.fromJson(Map<String, dynamic> json) =
      _$GirlListAdModelImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  String? get description;
  String? get imgUrl;
  String get urlConfig;
  int? get position;
  String? get androidDownUrl;
  String? get iosDownUrl;
  @override
  int? get type;
  int? get status;
  int? get oauthType;
  String? get mvM3U8;
  String? get channel;
  String? get createdAt;
  String get router;
  String? get startAt;
  String? get endAt;
  int get clicked;
  int get sort;
  String get urlStr;
  String get linkUrl;
  String? get url;
  String get resourceUrl;
  int get redirectType;
  int get reportId;
  int get reportType;
  String? get subTitle;
}
