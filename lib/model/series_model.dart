import 'package:qypj/model/appcenter.dart';
import 'package:qypj/model/videolist.dart';

class SeriesModel {
  SeriesModel({this.data, this.status, this.msg, this.crypt, this.isVip});
  SeriesALModel data;
  int status;
  String msg;
  bool crypt;
  bool isVip;

  factory SeriesModel.fromJson(Map<String, dynamic> json) => SeriesModel(
      data: SeriesALModel.fromJson(json["data"]),
      status: json["status"],
      msg: json["msg"],
      crypt: json["crypt"],
      isVip: json["isVip"]);

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "msg": msg,
        "crypt": crypt,
        "isVip": isVip
      };
}

class SeriesALModel {
  SeriesALModel({this.ads, this.list});
  List<Banner> ads;
  SeriesListModel list;

  factory SeriesALModel.fromJson(Map<String, dynamic> json) => SeriesALModel(
        ads: List<Banner>.from(json["ads"].map((x) => Banner.fromJson(x))),
        list: SeriesListModel.fromJson(json["list"]),
      );

  Map<String, dynamic> toJson() => {
        "ads": List<dynamic>.from(ads.map((e) => e.toJson())),
        "list": list.toJson()
      };
}

class SeriesListModel {
  SeriesListModel({this.title, this.value});
  String title;
  List<SeriesValueModel> value;

  factory SeriesListModel.fromJson(Map<String, dynamic> json) =>
      SeriesListModel(
        title: json["title"],
        value: List<SeriesValueModel>.from(
            json["value"].map((x) => SeriesValueModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": List<dynamic>.from(value.map((e) => e.toJson()))
      };
}

class SeriesValueModel {
  SeriesValueModel(
      {this.id,
      this.num,
      this.title,
      this.is_free,
      this.price,
      this.created_at,
      this.updated_at,
      this.thumb,
      this.is_hide,
      this.sort});
  int id;
  int num;
  String title;
  int is_free;
  int price;
  String created_at;
  String updated_at;
  String thumb;
  int is_hide;
  int sort;

  factory SeriesValueModel.fromJson(Map<String, dynamic> json) =>
      SeriesValueModel(
          id: json["id"],
          num: json["num"],
          title: json["title"],
          is_free: json["is_free"],
          price: json["price"],
          created_at: json["created_at"],
          updated_at: json["updated_at"],
          thumb: json["thumb"],
          is_hide: json["is_hide"],
          sort: json["sort"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "num": num,
        "title": title,
        "is_free": is_free,
        "price": price,
        "created_at": created_at,
        "updated_at": updated_at,
        "thumb": thumb,
        "is_hide": is_hide,
        "sort": sort
      };
}

class SeriesDetailDataModel {
  SeriesDetailDataModel(
      {this.data, this.status, this.msg, this.crypt, this.isVip});
  SeriesDetailModel data;
  int status;
  String msg;
  bool crypt;
  bool isVip;

  factory SeriesDetailDataModel.fromJson(Map<String, dynamic> json) =>
      SeriesDetailDataModel(
          data: SeriesDetailModel.fromJson(json["data"]),
          status: json["status"],
          msg: json["msg"],
          crypt: json["crypt"],
          isVip: json["isVip"]);

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "status": status,
        "msg": msg,
        "crypt": crypt,
        "isVip": isVip
      };
}

class SeriesDetailModel {
  SeriesDetailModel(
      {this.id,
      this.num,
      this.title,
      this.is_free,
      this.price,
      this.created_at,
      this.updated_at,
      this.thumb,
      this.is_hide,
      this.sort,
      this.new_num,
      this.max_num,
      this.content_type,
      this.value});
  int id;
  int num;
  String title;
  int is_free;
  int price;
  String created_at;
  String updated_at;
  String thumb;
  int is_hide;
  int sort;
  int new_num;
  int max_num;
  List<VideoItem> value;
  int content_type = 1;

  factory SeriesDetailModel.fromJson(Map<String, dynamic> json) =>
      SeriesDetailModel(
        id: json["id"],
        num: json["num"],
        title: json["title"],
        is_free: json["is_free"],
        price: json["price"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
        thumb: json["thumb"],
        is_hide: json["is_hide"],
        sort: json["sort"],
        new_num: json["new_num"],
        max_num: json["max_num"],
        content_type: json["content_type"],
        value: List<VideoItem>.from(
            json["value"].map((x) => VideoItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "num": num,
        "title": title,
        "is_free": is_free,
        "price": price,
        "created_at": created_at,
        "updated_at": updated_at,
        "thumb": thumb,
        "is_hide": is_hide,
        "sort": sort,
        "new_num": new_num,
        "max_num": max_num,
        "content_type": content_type,
        "value": List<dynamic>.from(value.map((e) => e.toJson()))
      };
}
