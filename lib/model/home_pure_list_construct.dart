import 'dart:convert';

HomePureListConstructModel constructModelFromJson(String str) =>
    HomePureListConstructModel.fromJson(json.decode(str));

String constructModelToJson(HomePureListConstructModel data) =>
    json.encode(data.toJson());

class HomePureListConstructModel {
  HomePureListConstructModel({this.list, this.banner, this.type, this.nav});

  String api;
  List<dynamic> list;
  List<dynamic> banner;
  List<dynamic> nav;
  dynamic last_ix;
  int type = 0;

  factory HomePureListConstructModel.fromJson(
    Map<String, dynamic> json,
  ) {
    int type = 0;
    // if (api != null) {
    //   switch (api) {
    //     case "/api/mv/list_construct": // "视频列表-横屏"
    //       type = 14;
    //       break;
    //     case "/api/mv/list_construct": // "视频列表-竖屏"
    //       type = 17;
    //       break;
    //     case "/api/cartoon/list_construct": // "动漫列表-横屏"
    //       type = 14;
    //       break;
    //     case "/api/cartoon/list_construct": // "动漫列表-竖屏"
    //       type = 17;
    //       break;
    //     case "/api/book/list_construct": // "漫画列表"
    //       type = 4;
    //       break;
    //     case "/api/pic/list_construct": // 图片列表
    //       type = 11;
    //       break;
    //     case "/api/topic/list_construct": // 合集列表
    //       type = 15;
    //       break;
    //     default:
    //   }
    // }

    return HomePureListConstructModel(
        list: json["list"] != null
            ? List<dynamic>.from(json["list"].map((x) => x))
            : [],
        banner: json["banner"] != null
            ? List<dynamic>.from(json["banner"].map((x) => x))
            : [],
        nav: json["nav"] != null
            ? List<dynamic>.from(json["nav"].map((x) => x))
            : [],
        type: type);
  }

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x)),
        "banner": List<dynamic>.from(banner.map((x) => x)),
        "nav": List<dynamic>.from(nav.map((x) => x)),
      };
}
