class ChatNavModel {
  ChatNavModel({
    this.sort,
    this.name,
    this.type,
  });

  final String? sort;
  final String? name;
  final int? type;

  factory ChatNavModel.fromJson(Map<String, dynamic> json) => ChatNavModel(
        sort: json['sort'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'sort': sort,
        'name': name,
        'type': type,
      };
}
