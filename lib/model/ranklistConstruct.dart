import 'dart:convert';

RanklistConstructModel constructModelFromJson(String str) =>
    RanklistConstructModel.fromJson(json.decode(str));

String constructModelToJson(RanklistConstructModel data) =>
    json.encode(data.toJson());

class RanklistConstructModel {
  RanklistConstructModel(
      {this.banner, this.toplist, this.list, this.displayType});

  dynamic banner;
  Map toplist;
  List<dynamic> list;
  dynamic displayType;

  factory RanklistConstructModel.fromJson(Map<String, dynamic> json) =>
      RanklistConstructModel(
        banner: json["banner"] != null
            ? List<dynamic>.from(json["banner"].map((x) => x))
            : [],
        toplist: json["toplist"] != null
            ? (json['toplist'].runtimeType == List
                ? {}
                : Map.from(json["toplist"]))
            : {},
        list: json["list"] != null
            ? List<dynamic>.from(json["list"].map((x) => x))
            : [],
        displayType: json["display_type"] != null
            ? json['display_type'].toString()
            : 'vertical',
      );

  Map<String, dynamic> toJson() => {
        "banner": banner,
        "toplist": toplist,
        "list": List<dynamic>.from(list.map((x) => x)),
        "display_type": displayType,
      };
}
