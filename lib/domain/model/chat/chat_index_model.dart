import 'chat_list_model.dart';
import '../banner_model.dart';

class ChatIndexModel {
  final List<BannerModel>? banner;

  final List<String>? notice;
  final List<ChatListModel>? chats;

  ChatIndexModel({required this.banner, this.notice, required this.chats});

  factory ChatIndexModel.fromJson(Map<String, dynamic> json) {
    return ChatIndexModel(
      banner: List.from(json['banner'].map((e) => BannerModel.fromJson)),
      notice: List.from(json['notice'] ?? []),
      chats: List.from(json['chats'])
          .map((x) => ChatListModel.fromJson(x))
          .toList(),
    );
  }
}
