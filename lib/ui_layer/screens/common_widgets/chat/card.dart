import 'package:flutter/widgets.dart';

import '../../../../domain/model/chat/chat_list_model.dart';
import '../../../../domain/model/girl/girl_list_model.dart';
import '../../../../domain/model/video/video_model.dart';
import '../video/card/widgets/ad_view.dart';
import 'list_card.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.data});
  static const aspectRatio = 163 / 128;
  final ChatListModel data;
  @override
  Widget build(BuildContext context) {
    return data.map(
      chat: (chat) => ChatListCard(data: chat),
      ad: (ad) => AdCardView(ad: VideoCardAdModel.fromJson(ad.toJson())),
    );
  }
}
