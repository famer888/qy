class WelfareModel {
  WelfareModel({this.data, this.status, this.msg, this.crypt, this.isVip});
  List<WelfareAppModel> data;
  int status;
  String msg;
  bool crypt;
  bool isVip;

  factory WelfareModel.fromJson(Map<String, dynamic> json) => WelfareModel(
      data: List<WelfareAppModel>.from(
          json["data"].map((x) => WelfareAppModel.fromJson(x))),
      status: json["status"],
      msg: json["msg"],
      crypt: json["crypt"],
      isVip: json["isVip"]);

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status,
        "msg": msg,
        "crypt": crypt,
        "isVip": isVip
      };
}

class WelfareAppModel {
  WelfareAppModel({this.id, this.name, this.down_url, this.cover});

  int id;
  String name;
  String down_url;
  String cover;

  factory WelfareAppModel.fromJson(Map<String, dynamic> json) =>
      WelfareAppModel(
          id: json["id"],
          name: json["name"],
          down_url: json["down_url"],
          cover: json["cover"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "down_url": down_url, "cover": cover};
}
