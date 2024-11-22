import '../common_media_model.dart';

class ChatListModel {
  final int? id;
  final int? aff;
  final String? name;
  final int? age;
  final int? height;
  final int? weight;
  final String? cup;
  final int? payCt;
  final int? payFct;
  final int? rid;
  final List<CommonMediaModel>? medias;

  ChatListModel({
    this.id,
    this.aff,
    this.name,
    this.age,
    this.height,
    this.weight,
    this.cup,
    this.payCt,
    this.payFct,
    this.rid,
    this.medias,
  });

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      id: json['id'],
      aff: json['aff'],
      name: json['name'],
      age: json['age'],
      height: json['height'],
      weight: json['weight'],
      cup: json['cup'],
      payCt: json['pay_ct'],
      payFct: json['pay_fct'],
      rid: json['rid'],
      medias: List.from(
          json['medias'].map((x) => CommonMediaModel.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aff': aff,
      'name': name,
      'age': age,
      'height': height,
      'weight': weight,
      'cup': cup,
      'pay_ct': payCt,
      'pay_fct': payFct,
      'rid': rid,
      'medias': (medias ?? []).map((x) => x.toJson()),
    };
  }
}
