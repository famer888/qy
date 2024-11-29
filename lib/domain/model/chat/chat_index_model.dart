import 'chat_list_model.dart';
import '../banner_model.dart';
import '../tip_model.dart';

class ChatIndexModel {
  final List<BannerModel>? banner;

  final List<TipModel>? tips;
  final List<ChatListModel>? chats;

  ChatIndexModel({required this.banner, this.tips, required this.chats});

  factory ChatIndexModel.fromJson(Map<String, dynamic> json) {
    return ChatIndexModel(
      banner: List.from(json['banner'].map((e) => BannerModel.fromJson(e))),
      tips: List<TipModel>.from(json['tips'].map((e) => TipModel.fromJson(e))),
      chats: List.from(json['chats'])
          .map((x) => ChatListModel.fromJson(x))
          .toList(),
    );
  }
}
