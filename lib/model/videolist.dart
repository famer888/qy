// To parse this JSON data, do
//
//     final videoList = videoListFromJson(jsonString);

import 'dart:convert';

import 'package:qypj/model/homedata.dart';

VideoList videoListFromJson(String str) => VideoList.fromJson(json.decode(str));

String videoListToJson(VideoList data) => json.encode(data.toJson());

class VideoList {
  VideoList({
    this.data,
    this.status,
    this.msg,
    this.crypt,
    this.isVip,
  });

  List<VideoItem> data;
  int status;
  String msg;
  bool crypt;
  bool isVip;

  factory VideoList.fromJson(Map<String, dynamic> json) => VideoList(
        data: json["data"] == null
            ? null
            : List<VideoItem>.from(
                json["data"].map((x) => VideoItem.fromJson(x))),
        status: json["status"] == null ? null : json["status"],
        msg: json["msg"] == null ? null : json["msg"],
        crypt: json["crypt"] == null ? null : json["crypt"],
        isVip: json["isVip"] == null ? null : json["isVip"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status == null ? null : status,
        "msg": msg == null ? null : msg,
        "crypt": crypt == null ? null : crypt,
        "isVip": isVip == null ? null : isVip,
      };
}

class VideoItem {
  VideoItem({
    this.id,
    this.title,
    this.topic_id,
    this.aff,
    this.second_title,
    this.coins,
    this.duration,
    this.isfree,
    this.count_comment,
    this.count_reward,
    this.favorites,
    this.count_like,
    this.count_play,
    this.rating,
    this.tags,
    this.directors,
    this.cover_vertical,
    this.cover_horizontal,
    this.source_240,
    this.userFavorites,
    this.discount_coins,
    this.source_origin_str,
    this.tag_list,
    this.is_pay,
    this.discount,
    this.topic,
    this.member,
    this.preview_url,
  });

  int id;
  String title;
  int topic_id;
  dynamic aff;
  String second_title;
  int coins;
  int duration;
  int isfree;
  int count_comment;
  int count_reward;
  int favorites;
  int count_like;
  int count_play;
  int rating;
  String tags;
  String directors;
  String cover_vertical;
  String cover_horizontal;
  String source_240;
  int userFavorites;
  int discount_coins;
  String source_origin_str;
  dynamic tag_list;
  int is_pay;
  double discount;
  dynamic topic;
  Member member;
  String preview_url;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
        discount: json["discount"] == null
            ? 0
            : double.parse(json["discount"].toString()),
        aff: json["aff"],
        id: json["id"] == null ? 0 : json["id"],
        title: json["title"] == null ? null : json["title"],
        duration: json["duration"] == null ? null : json["duration"],
        directors: json["directors"] == null ? null : json["directors"],
        tags: json["tags"] == null ? null : json["tags"],
        rating: json["rating"] == null ? null : json["rating"],
        favorites: json["favorites"] == null ? null : json["favorites"],
        isfree: json["isfree"] == null ? null : json["isfree"],
        coins: json["coins"] == null ? null : json["coins"],
        second_title:
            json["second_title"] == null ? null : json["second_title"],
        member: json['member'] == null ? null : Member.fromJson(json['member']),
        userFavorites:
            json['userFavorites'] == null ? 0 : json['userFavorites'],
        topic_id: json['topic_id'] == null ? 0 : json['topic_id'],
        count_comment:
            json['count_comment'] == null ? 0 : json['count_comment'],
        count_reward: json['count_reward'] == null ? 0 : json['count_reward'],
        count_like: json['count_like'] == null ? 0 : json['count_like'],
        count_play: json['count_play'] == null ? 0 : json['count_play'],
        cover_vertical:
            json['cover_vertical'] == null ? "" : json['cover_vertical'],
        cover_horizontal:
            json['cover_horizontal'] == null ? "" : json['cover_horizontal'],
        source_240: json['source_240'] == null ? "" : json['source_240'],
        discount_coins:
            json['discount_coins'] == null ? "" : json['discount_coins'],
        source_origin_str:
            json['source_origin_str'] == null ? "" : json['source_origin_str'],
        tag_list: json['tag_list'] == null ? null : json['tag_list'],
        is_pay: json['is_pay'] == null ? 0 : json['is_pay'],
        topic: json['topic'] == null ? null : json['topic'],
        preview_url: json['preview_url'] == null ? "" : json['preview_url'],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? 0 : id,
        "title": title == null ? "" : title,
        "discount": discount == null ? 0 : discount,
        "aff": aff,
        "duration": duration == null ? 0 : duration,
        "directors": directors == null ? "" : directors,
        "tags": tags == null ? "" : tags,
        "rating": rating == null ? null : rating,
        "coins": coins == null ? null : coins,
        "favorites": favorites == null ? 0 : favorites,
        "isfree": isfree == null ? 0 : isfree,
        "second_title": second_title == null ? "" : second_title,
        "preview_url": preview_url == null ? "" : preview_url,
        "member": member == null ? null : member,
        "userFavorites": userFavorites == null ? 0 : userFavorites,
        "topic_id": topic_id == null ? 0 : topic_id,
        "count_comment": count_comment == null ? 0 : count_comment,
        "count_reward": count_reward == null ? 0 : count_reward,
        "count_like": count_like == null ? 0 : count_like,
        "count_play": count_play == null ? 0 : count_play,
        "cover_vertical": cover_vertical == null ? "" : cover_vertical,
        "cover_horizontal": cover_horizontal == null ? "" : cover_horizontal,
        "source_240": source_240 == null ? "" : source_240,
        "discount_coins": discount_coins == null ? 0 : discount_coins,
        "source_origin_str": source_origin_str == null ? "" : source_origin_str,
        "tag_list": tag_list == null ? null : tag_list,
        "is_pay": is_pay == null ? 0 : is_pay,
        "topic": topic == null ? null : topic,
      };
}
