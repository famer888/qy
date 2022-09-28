import 'dart:convert';

HomePackageListConstructModel constructModelFromJson(String str) =>
    HomePackageListConstructModel.fromJson(json.decode(str));

String constructModelToJson(HomePackageListConstructModel data) =>
    json.encode(data.toJson());

class HomePackageListConstructModel {
  HomePackageListConstructModel(
      {this.list, this.package, this.banner, this.contentType});

  List<dynamic> list;
  dynamic package;

  List<dynamic> banner;
  dynamic last_ix;
  int contentType = 0;

  factory HomePackageListConstructModel.fromJson(
    Map<String, dynamic> json,
  ) {
    int contentType = 0;

// const TYPE_LONG = 1;
// const TYPE_SHORT = 2;
// const TYPE_DONGMAN = 3;
// const TYPE_PICTURE = 4;
// const TYPE_STORY = 5;
// const TYPE_BOOK = 6;
// const TYPE = [
//     self::TYPE_LONG => '长视频',
//     self::TYPE_SHORT => '短视频',
//     self::TYPE_DONGMAN => '动漫',
//     self::TYPE_PICTURE => '美图',
//     self::TYPE_STORY => '小说',
//     self::TYPE_BOOK => '漫画',
// ];

    // switch (json["contentType"]) {
    //   case 1: //
    //     contentType = 1;
    //     break;
    //   case 2:
    //     contentType = 111; // 自定义一个短视频的
    //     break;
    //   case 3:
    //     contentType = 16;
    //     break;
    //   case 4:
    //     contentType = 17;
    //     break;
    //   case 5:
    //     contentType = 6;
    //     break;
    //   case 6:
    //     contentType = 2;
    //     break;
    //   default:
    // }

    contentType = 1;

    return HomePackageListConstructModel(
        list: json["list"] != null
            ? List<dynamic>.from(json["list"].map((x) => x))
            : [],
        banner: json["banner"] != null
            ? List<dynamic>.from(json["banner"].map((x) => x))
            : [],
        package: json["package"] != null ? Map.from(json["package"]) : {},
        contentType: contentType);
  }

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x)),
        "banner": List<dynamic>.from(banner.map((x) => x)),
        "package": package,
      };
}
