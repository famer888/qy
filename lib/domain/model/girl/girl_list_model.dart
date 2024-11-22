import '../common_media_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'girl_list_model.freezed.dart';
part 'girl_list_model.g.dart';

@Freezed(
  unionKey: '__type',
  when: FreezedWhenOptions(when: false, whenOrNull: false, maybeWhen: false),
  map: FreezedMapOptions(maybeMap: false, mapOrNull: false, map: true),
  fromJson: true,
  toJson: true,
  copyWith: false,
  equal: false,
  makeCollectionsUnmodifiable: true,
)
class GirlListModel with _$GirlListModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GirlListModel.girl(
    int? id,
    String? title,
    String? class_,
    String? cup,
    int? age,
    int? height,
    int? type,
    String? price,
    int? coins,
    int? payCt,
    int? payFct,
    int? rid,
    List<CommonMediaModel>? medias,
  ) = GirlListGirlModel;

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GirlListModel.ad(
    int id,
    String title,
    String? description,
    String? imgUrl,
    String urlConfig,
    int? position,
    String? androidDownUrl,
    String? iosDownUrl,
    int? type,
    int? status,
    int? oauthType,
    String? mvM3U8,
    String? channel,
    String? createdAt,
    String router,
    String? startAt,
    String? endAt,
    int clicked,
    int sort,
    String urlStr,
    String linkUrl,
    String? url,
    String resourceUrl,
    int redirectType,
    int reportId,
    int reportType,
    String? subTitle,
  ) = GirlListAdModel;

  factory GirlListModel.fromJson(Map<String, dynamic> json) {
    if (json['url'] != null) {
      json['__type'] = 'ad';
    } else {
      json['__type'] = 'girl';
    }
    return _$GirlListModelFromJson(json);
  }
}


// class GirlListModel {
//   final int? id;
//   final String? title;
//   final String? class_;
//   final String? cup;
//   final int? age;
//   final int? height;
//   final int? type;
//   final String? price;
//   final int? coins;
//   final int? payCt;
//   final int? payFct;
//   final int? rid;
//   final List<CommonMediaModel>? medias;

//   GirlListModel({
//     this.id,
//     this.title,
//     this.class_,
//     this.cup,
//     this.age,
//     this.height,
//     this.type,
//     this.price,
//     this.coins,
//     this.payCt,
//     this.payFct,
//     this.rid,
//     this.medias,
//   });

//   factory GirlListModel.fromJson(Map<String, dynamic> json) {
//     return GirlListModel(
//       id: json['id'],
//       title: json['title'],
//       class_: json['class'],
//       cup: json['cup'],
//       age: json['age'],
//       height: json['height'],
//       type: json['type'],
//       price: json['price'],
//       coins: json['coins'],
//       payCt: json['pay_ct'],
//       payFct: json['pay_fct'],
//       rid: json['rid'],
//       medias: json['medias'].map((x) => CommonMediaModel.fromJson(x)) ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'class': class_,
//       'cup': cup,
//       'age': age,
//       'height': height,
//       'type': type,
//       'price': price,
//       'coins': coins,
//       'pay_ct': payCt,
//       'pay_fct': payFct,
//       'rid': rid,
//       'medias': (medias ?? []).map((x) => x.toJson()),
//     };
//   }
// }
