class NavigatorModel {
  NavigatorModel({
    required this.title,
    required this.type,
  });

  final String title;
  final String type;

  factory NavigatorModel.fromJson(Map<String, dynamic> json) => NavigatorModel(
        title: json['title'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
      };
}
