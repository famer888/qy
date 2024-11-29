class AiFaceMaterialModel {
  final int id;
  final int aff;
  final String title;
  final String thumb;
  final int thumbW;
  final int thumbH;
  final int usedCt;
  final String? usedFct;
  final int? isHot;

  AiFaceMaterialModel(
      {required this.id,
      required this.aff,
      required this.thumb,
      required this.title,
      required this.usedCt,
      this.usedFct,
      this.isHot,
      required this.thumbW,
      required this.thumbH});

  factory AiFaceMaterialModel.fromJson(Map<String, dynamic> json) =>
      AiFaceMaterialModel(
          id: json['id'],
          aff: json['aff'],
          thumb: json['thumb'],
          title: json['title'],
          usedCt: json['used_ct'],
          usedFct: json['used_fct'].toString(),
          isHot: json['is_hot'] ?? 0,
          thumbW: json['thumb_w'],
          thumbH: json['thumb_h']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'aff': aff,
        'thumb': thumb,
        'title': title,
        'used_ct': usedCt,
        'used_fct': usedFct,
        'is_hot': isHot,
        'thumb_w': thumbW,
        'thumb_h': thumbH,
      };
}
