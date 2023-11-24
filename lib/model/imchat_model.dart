class ImChatModel {
  ImChatModel({
    this.token,
    this.via,
    this.key,
    this.iv,
    this.img_base,
    this.line,
  });

  String token;
  String via;
  String key;
  String iv;
  String img_base;
  String line;

  factory ImChatModel.fromJson(Map<String, dynamic> json) => ImChatModel(
        token: json["token"] ?? "",
        via: json["via"] ?? "",
        key: json["key"] ?? "",
        iv: json["iv"] ?? "",
        img_base: json["img_base"] ?? "",
        line: json["line"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "via": via,
        "key": key,
        "iv": iv,
        "img_base": img_base,
        "line": line,
      };
}

class ChatMessage {
  ChatMessage({
    this.nickname,
    this.content,
    this.type,
    this.avatar,
    this.time,
    this.content_type,
    this.touser,
  });
  String nickname;
  String avatar;
  String content;
  int type;
  int content_type; // 0 是文本 1 是图片
  String time;

  ChatUser touser;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        nickname: json["nickname"] ?? "",
        content: json["content"] ?? "",
        avatar: json["avatar"] ?? "",
        type: json["type"] ?? 0,
        content_type: json["content_type"] ?? 0,
        time: json["time"] ?? "",
        touser:
            json["touser"] == null ? null : ChatUser.fromJson(json["touser"]),
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "content": content,
        "avatar": avatar,
        "content_type": content_type,
        "type": type,
        "time": time,
        "touser": touser?.toJson(),
      };
}

class ChatList {
  ChatList({this.id, this.count, this.list, this.touser});
  String id = ""; //uuid + other uuid
  int count = 0;
  List<ChatMessage> list = [];
  ChatUser touser;

  factory ChatList.fromJson(Map<String, dynamic> json) => ChatList(
        id: json["id"] ?? "",
        count: json["count"] ?? 0,
        list: json["list"] == null
            ? []
            : List<ChatMessage>.from(
                json["list"].map((x) => ChatMessage.fromJson(x))),
        touser:
            json["touser"] == null ? null : ChatUser.fromJson(json["touser"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "list":
            list == null ? [] : List<dynamic>.from(list.map((x) => x.toJson())),
        "touser": touser?.toJson(),
      };
}

class ChatUser {
  ChatUser({this.nickname, this.avatar, this.uuid});
  String nickname;
  String avatar;
  String uuid;

  factory ChatUser.fromJson(Map<String, dynamic> json) => ChatUser(
        nickname: json["nickname"] ?? "",
        avatar: json["avatar"] ?? "",
        uuid: json["uuid"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "nickname": nickname,
        "avatar": avatar,
        "uuid": uuid,
      };
}
