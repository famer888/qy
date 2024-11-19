import 'following_user_model.dart';

class FollowingUserListModel {
  final List<FollowingUserModel> list;
  final String? lastIx;

  FollowingUserListModel({
    required this.list,
    this.lastIx,
  });

  FollowingUserListModel.fromJson(Map<String, dynamic> json)
      : list = List.from(
          json['list']?.map((e) => FollowingUserModel.fromJson(e)) ?? [],
        ),
        lastIx = json['last_ix'] as String?;
}
